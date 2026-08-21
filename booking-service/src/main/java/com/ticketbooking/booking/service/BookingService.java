package com.ticketbooking.booking.service;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.client.PaymentServiceClient;
import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import com.ticketbooking.booking.lock.SeatLockService;
import com.ticketbooking.booking.repository.BookingRepository;
import com.ticketbooking.booking.ticketing.SeatDetails;
import com.ticketbooking.booking.web.dto.BookingResponse;
import com.ticketbooking.booking.web.dto.CreateBookingRequest;
import com.ticketbooking.common.event.BookingCancelledEvent;
import com.ticketbooking.common.event.BookingConfirmedEvent;
import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.common.resilience.RetryingPublisher;
import io.github.resilience4j.retry.Retry;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ScheduledExecutorService;

@Service
public class BookingService {

    private static final String TOPIC_BOOKING_CONFIRMED = "booking-confirmed";
    private static final String TOPIC_BOOKING_CANCELLED = "booking-cancelled";

    private final BookingRepository bookingRepository;
    private final EventServiceClient eventServiceClient;
    private final PaymentServiceClient paymentServiceClient;
    private final SeatLockService seatLockService;
    private final KafkaTemplate<String, Object> kafkaTemplate;
    private final Retry kafkaPublishRetry;
    private final ScheduledExecutorService kafkaRetryScheduler;

    public BookingService(BookingRepository bookingRepository, EventServiceClient eventServiceClient,
                           PaymentServiceClient paymentServiceClient, SeatLockService seatLockService,
                           KafkaTemplate<String, Object> kafkaTemplate,
                           Retry kafkaPublishRetry, ScheduledExecutorService kafkaRetryScheduler) {
        this.bookingRepository = bookingRepository;
        this.eventServiceClient = eventServiceClient;
        this.paymentServiceClient = paymentServiceClient;
        this.seatLockService = seatLockService;
        this.kafkaTemplate = kafkaTemplate;
        this.kafkaPublishRetry = kafkaPublishRetry;
        this.kafkaRetryScheduler = kafkaRetryScheduler;
    }

    /**
     * Not wrapped in a local transaction: both the Redis lock and the claim
     * call to Event Service are network round trips that must complete (or
     * fail) before any local row is written — holding a DB transaction open
     * across them would tie up a connection for no reason.
     *
     * <p>The Redis lock is deliberately NOT released on success — it is held
     * for its full TTL as the seat reservation itself, not just a mutex
     * around this one write. It's released by {@link #confirmBooking} /
     * {@link #cancelBooking} once payment-service resolves the charge, or by
     * the stale-booking sweep if the hold expires unconfirmed.
     */
    public BookingResponse createBooking(CreateBookingRequest request, UUID userId) {
        UUID showId = request.showId();
        UUID seatId = request.seatId();

        SeatDetails seatDetails = eventServiceClient.getSeatDetails(showId, seatId);
        if (!seatDetails.startTime().isAfter(Instant.now())) {
            throw new ConflictException("This show has already started — please choose another showtime.");
        }

        if (!seatLockService.tryLock(showId, seatId)) {
            throw new ConflictException("Seat %s%d was just taken by someone else.".formatted(seatDetails.rowLabel(), seatDetails.seatNumber()));
        }

        try {
            eventServiceClient.claimSeat(showId, seatId);
        } catch (RuntimeException ex) {
            seatLockService.unlock(showId, seatId);
            throw ex;
        }

        Booking booking = new Booking(showId, seatId, userId);
        Booking saved = bookingRepository.save(booking);
        return toResponse(saved);
    }

    /**
     * Non-owners get a 404, not a 403 — same anti-enumeration reasoning used
     * throughout user-service: don't confirm a booking ID exists to someone
     * who isn't allowed to see it. ADMIN bypasses the ownership check.
     */
    @Transactional(readOnly = true)
    public BookingResponse getBooking(UUID id, UUID requestingUserId, boolean isAdmin) {
        Booking booking = findOrThrow(id);
        if (!isAdmin && !booking.getUserId().equals(requestingUserId)) {
            throw new ResourceNotFoundException("Booking not found: " + id);
        }
        return toResponse(booking);
    }

    /**
     * Called by payment-service once a charge succeeds. Only acts on a
     * still-PENDING booking — guarding the status check before touching the
     * seat is what stops a retried confirm call from re-running side effects
     * against a booking that's already CONFIRMED.
     *
     * <p>{@code kafkaTemplate.send} is fire-and-forget (returns a
     * {@code CompletableFuture} we never block on) — this method, and by
     * extension payment-service's response to the original caller, returns
     * without waiting on the broker or on Notification Service's downstream
     * email send. See {@code BookingServiceTest} for a test that would hang
     * if that stopped being true.
     */
    public BookingResponse confirmBooking(UUID id) {
        Booking booking = findOrThrow(id);
        if (booking.getStatus() == BookingStatus.PENDING) {
            eventServiceClient.bookSeat(booking.getShowId(), booking.getSeatId());
            seatLockService.unlock(booking.getShowId(), booking.getSeatId());
            booking.confirm();
            booking = bookingRepository.save(booking);
            Booking finalBooking = booking;
            RetryingPublisher.withRetry(() -> kafkaTemplate.send(TOPIC_BOOKING_CONFIRMED, finalBooking.getId().toString(),
                    new BookingConfirmedEvent(finalBooking.getId(), finalBooking.getShowId(), finalBooking.getSeatId(),
                            finalBooking.getUserId(), Instant.now())), kafkaPublishRetry, kafkaRetryScheduler);
        }
        return toResponse(booking);
    }

    /**
     * Compensating step called by payment-service on a failed charge, and by
     * the stale-booking sweep on an expired hold. Only acts on a still-PENDING
     * booking — releasing the seat for a booking that's already CONFIRMED
     * would incorrectly free a genuinely booked seat.
     */
    public BookingResponse cancelBooking(UUID id) {
        Booking booking = findOrThrow(id);
        if (booking.getStatus() == BookingStatus.PENDING) {
            eventServiceClient.releaseSeat(booking.getShowId(), booking.getSeatId());
            seatLockService.forceUnlock(booking.getShowId(), booking.getSeatId());
            booking.cancel();
            booking = bookingRepository.save(booking);
            Booking finalBooking = booking;
            RetryingPublisher.withRetry(() -> kafkaTemplate.send(TOPIC_BOOKING_CANCELLED, finalBooking.getId().toString(),
                    new BookingCancelledEvent(finalBooking.getId(), finalBooking.getShowId(), finalBooking.getSeatId(),
                            finalBooking.getUserId(), Instant.now())), kafkaPublishRetry, kafkaRetryScheduler);
        }
        return toResponse(booking);
    }

    /**
     * Customer-initiated cancellation of an already-CONFIRMED (paid) booking.
     * Refund is called first — payment-service is the source of truth for
     * money movement, so it must succeed before anything else changes, same
     * "external call before local commit" ordering used by createBooking.
     * Publishing booking-cancelled after the local save is what drives both
     * the cancellation email and waitlist promotion (see WaitlistEventListener),
     * both async, off this response — and it's also what makes the ticket's
     * QR naturally rejected at redemption from this point on, since
     * checkInIfConfirmed only ever succeeds while status is CONFIRMED.
     */
    public BookingResponse cancelConfirmedBooking(UUID id, UUID requestingUserId, boolean isAdmin) {
        Booking booking = findOrThrow(id);
        if (!isAdmin && !booking.getUserId().equals(requestingUserId)) {
            throw new ResourceNotFoundException("Booking not found: " + id);
        }
        if (booking.getStatus() != BookingStatus.CONFIRMED) {
            throw new ConflictException("Only a CONFIRMED booking can be cancelled: current status " + booking.getStatus());
        }

        paymentServiceClient.refundBooking(id);
        eventServiceClient.releaseSeat(booking.getShowId(), booking.getSeatId());
        booking.cancelConfirmed();
        booking = bookingRepository.save(booking);

        Booking finalBooking = booking;
        RetryingPublisher.withRetry(() -> kafkaTemplate.send(TOPIC_BOOKING_CANCELLED, finalBooking.getId().toString(),
                new BookingCancelledEvent(finalBooking.getId(), finalBooking.getShowId(), finalBooking.getSeatId(),
                        finalBooking.getUserId(), Instant.now())), kafkaPublishRetry, kafkaRetryScheduler);
        return toResponse(booking);
    }

    /**
     * Counter-staff sale: skips payment entirely and jumps straight to
     * CONFIRMED on behalf of a walk-up customer. Reuses createBooking (Redis
     * lock + seat claim + PENDING row) followed immediately by confirmBooking
     * (seat book + booking-confirmed publish, which triggers Phase 7's usual
     * async ticket generation) — no new booking/payment logic needed, just a
     * different caller skipping the payment step in between.
     */
    public BookingResponse createCounterSaleBooking(CreateBookingRequest request, UUID customerUserId) {
        BookingResponse pending = createBooking(request, customerUserId);
        return confirmBooking(pending.id());
    }

    private Booking findOrThrow(UUID id) {
        return bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found: " + id));
    }

    private BookingResponse toResponse(Booking booking) {
        return new BookingResponse(
                booking.getId(),
                booking.getShowId(),
                booking.getSeatId(),
                booking.getUserId(),
                booking.getStatus(),
                booking.getCreatedAt());
    }
}
