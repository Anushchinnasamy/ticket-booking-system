package com.ticketbooking.booking.service;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import com.ticketbooking.booking.lock.SeatLockService;
import com.ticketbooking.booking.repository.BookingRepository;
import com.ticketbooking.booking.web.dto.BookingResponse;
import com.ticketbooking.booking.web.dto.CreateBookingRequest;
import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final EventServiceClient eventServiceClient;
    private final SeatLockService seatLockService;

    public BookingService(BookingRepository bookingRepository, EventServiceClient eventServiceClient,
                           SeatLockService seatLockService) {
        this.bookingRepository = bookingRepository;
        this.eventServiceClient = eventServiceClient;
        this.seatLockService = seatLockService;
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

        if (!seatLockService.tryLock(showId, seatId)) {
            throw new ConflictException("Seat is not available: " + seatId);
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
     */
    public BookingResponse confirmBooking(UUID id) {
        Booking booking = findOrThrow(id);
        if (booking.getStatus() == BookingStatus.PENDING) {
            eventServiceClient.bookSeat(booking.getShowId(), booking.getSeatId());
            seatLockService.unlock(booking.getShowId(), booking.getSeatId());
            booking.confirm();
            booking = bookingRepository.save(booking);
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
        }
        return toResponse(booking);
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
