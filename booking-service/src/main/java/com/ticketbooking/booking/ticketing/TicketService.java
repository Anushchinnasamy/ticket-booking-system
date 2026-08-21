package com.ticketbooking.booking.ticketing;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import com.ticketbooking.booking.domain.Ticket;
import com.ticketbooking.booking.repository.BookingRepository;
import com.ticketbooking.booking.repository.TicketRepository;
import com.ticketbooking.common.event.BookingConfirmedEvent;
import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.common.exception.ValidationException;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.UUID;

@Service
public class TicketService {

    private static final Logger log = LoggerFactory.getLogger(TicketService.class);
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private final TicketRepository ticketRepository;
    private final BookingRepository bookingRepository;
    private final EventServiceClient eventServiceClient;
    private final TicketSigningService signingService;
    private final QrCodeGenerator qrCodeGenerator;
    private final TicketPdfGenerator pdfGenerator;
    private final TicketStorageService storageService;
    private final int shareTokenTtlHours;
    private final MeterRegistry meterRegistry;

    public TicketService(TicketRepository ticketRepository, BookingRepository bookingRepository,
                          EventServiceClient eventServiceClient, TicketSigningService signingService,
                          QrCodeGenerator qrCodeGenerator, TicketPdfGenerator pdfGenerator,
                          TicketStorageService storageService,
                          @Value("${ticket.share-token-ttl-hours}") int shareTokenTtlHours,
                          MeterRegistry meterRegistry) {
        this.ticketRepository = ticketRepository;
        this.bookingRepository = bookingRepository;
        this.eventServiceClient = eventServiceClient;
        this.signingService = signingService;
        this.qrCodeGenerator = qrCodeGenerator;
        this.pdfGenerator = pdfGenerator;
        this.storageService = storageService;
        this.shareTokenTtlHours = shareTokenTtlHours;
        this.meterRegistry = meterRegistry;
    }

    /**
     * Triggered by TicketEventListener consuming booking-confirmed
     * independently of Notification service — never called synchronously
     * from the booking confirm path, so QR/PDF generation can never add
     * latency to that response. Idempotent: a redelivered event is a no-op
     * if a ticket already exists for this booking.
     */
    @Transactional
    public void generateTicket(BookingConfirmedEvent event) {
        if (ticketRepository.findByBookingId(event.bookingId()).isPresent()) {
            log.info("Ticket already exists for booking {}, skipping regeneration", event.bookingId());
            return;
        }

        SeatDetails seat = eventServiceClient.getSeatDetails(event.showId(), event.seatId());
        String qrPayload = signingService.sign(event.bookingId(), event.showId(), event.seatId(), event.confirmedAt());
        byte[] qrPng = qrCodeGenerator.generatePng(qrPayload);
        byte[] pdf = pdfGenerator.generate(event.bookingId(), seat, qrPng);

        String objectKey = "tickets/%s.pdf".formatted(event.bookingId());
        storageService.upload(objectKey, pdf, "application/pdf");

        ticketRepository.save(new Ticket(event.bookingId(), qrPayload, objectKey));
        log.info("Generated ticket for booking {}", event.bookingId());
    }

    @Transactional(readOnly = true)
    public byte[] getTicketPdf(UUID bookingId, UUID requestingUserId, boolean isAdmin) {
        Booking booking = findBookingOrThrow(bookingId);
        if (!isAdmin && !booking.getUserId().equals(requestingUserId)) {
            throw new ResourceNotFoundException("Booking not found: " + bookingId);
        }
        Ticket ticket = findTicketOrThrow(bookingId);
        return storageService.download(ticket.getPdfObjectKey());
    }

    /**
     * Renders a single PDF spanning every seat in one booking group (one
     * checkout's worth of bookings) — one page per seat, each with its own
     * QR, but one file/download/view instead of a separate ticket per seat.
     * Built on demand from the already-generated per-seat Ticket rows rather
     * than stored, since it's just a different presentation of existing data.
     */
    @Transactional(readOnly = true)
    public byte[] getCombinedTicketPdf(List<UUID> bookingIds, UUID requestingUserId, boolean isAdmin) {
        List<TicketPdfGenerator.TicketLine> lines = new ArrayList<>();
        for (UUID bookingId : bookingIds) {
            Booking booking = findBookingOrThrow(bookingId);
            if (!isAdmin && !booking.getUserId().equals(requestingUserId)) {
                throw new ResourceNotFoundException("Booking not found: " + bookingId);
            }
            Ticket ticket = findTicketOrThrow(bookingId);
            SeatDetails seat = eventServiceClient.getSeatDetails(booking.getShowId(), booking.getSeatId());
            byte[] qrPng = qrCodeGenerator.generatePng(ticket.getQrPayload());
            lines.add(new TicketPdfGenerator.TicketLine(bookingId, seat, qrPng));
        }
        return pdfGenerator.generateCombined(lines);
    }

    /**
     * Issues a share token per booking (reusing {@link #createShareLink}) and
     * hands back all of them joined by comma — the public {@code /t/group/...}
     * route splits on that to render every seat on one shared page.
     */
    @Transactional
    public String createCombinedShareLink(List<UUID> bookingIds, UUID requestingUserId, boolean isAdmin) {
        List<String> tokens = new ArrayList<>();
        for (UUID bookingId : bookingIds) {
            tokens.add(createShareLink(bookingId, requestingUserId, isAdmin));
        }
        return String.join(",", tokens);
    }

    @Transactional
    public String createShareLink(UUID bookingId, UUID requestingUserId, boolean isAdmin) {
        Booking booking = findBookingOrThrow(bookingId);
        if (!isAdmin && !booking.getUserId().equals(requestingUserId)) {
            throw new ResourceNotFoundException("Booking not found: " + bookingId);
        }
        Ticket ticket = findTicketOrThrow(bookingId);

        String token = generateShareToken();
        ticket.issueShareToken(token, Instant.now().plus(Duration.ofHours(shareTokenTtlHours)));
        return token;
    }

    @Transactional(readOnly = true)
    public SharedTicketView getSharedTicketView(String shareToken) {
        Ticket ticket = ticketRepository.findByShareToken(shareToken)
                .orElseThrow(() -> new ResourceNotFoundException("Share link not found or expired"));
        if (!ticket.isShareTokenValid()) {
            throw new ResourceNotFoundException("Share link not found or expired");
        }
        Booking booking = findBookingOrThrow(ticket.getBookingId());
        SeatDetails seat = eventServiceClient.getSeatDetails(booking.getShowId(), booking.getSeatId());
        byte[] qrPng = qrCodeGenerator.generatePng(ticket.getQrPayload());
        String qrPngBase64 = Base64.getEncoder().encodeToString(qrPng);
        return new SharedTicketView(booking.getId(), booking.getStatus(), seat, qrPngBase64);
    }

    /**
     * Verifies the QR signature first (rejects a forged/tampered payload
     * outright, no DB access needed), then performs a single atomic
     * conditional UPDATE for the actual check-in — same principle as
     * Phase 2/3's seat-locking: the database's row-level locking on that one
     * UPDATE is what guarantees exactly one of two concurrent redemption
     * attempts on the same ticket succeeds.
     */
    @Transactional
    public void redeem(String qrPayload) {
        SignedTicketPayload payload;
        try {
            payload = signingService.verify(qrPayload);
        } catch (ValidationException ex) {
            rejectionCounter("invalid_signature").increment();
            throw ex;
        }

        Booking booking = findBookingOrThrow(payload.bookingId());
        if (!booking.getShowId().equals(payload.showId()) || !booking.getSeatId().equals(payload.seatId())) {
            rejectionCounter("mismatch").increment();
            throw new ValidationException("Ticket QR does not match the booking it claims");
        }

        int updated = bookingRepository.checkInIfConfirmed(payload.bookingId(), Instant.now());
        if (updated == 0) {
            Booking current = findBookingOrThrow(payload.bookingId());
            if (current.getStatus() == BookingStatus.CHECKED_IN) {
                rejectionCounter("already_redeemed").increment();
                throw new ConflictException("Ticket already redeemed: " + payload.bookingId());
            }
            rejectionCounter("not_eligible").increment();
            throw new ConflictException("Booking is not eligible for check-in (status: " + current.getStatus() + ")");
        }
    }

    private Counter rejectionCounter(String reason) {
        return Counter.builder("ticket_redemption_rejected")
                .description("Ticket redemption attempts rejected, broken down by reason")
                .tag("reason", reason)
                .register(meterRegistry);
    }

    private String generateShareToken() {
        byte[] bytes = new byte[24];
        SECURE_RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private Booking findBookingOrThrow(UUID bookingId) {
        return bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found: " + bookingId));
    }

    private Ticket findTicketOrThrow(UUID bookingId) {
        return ticketRepository.findByBookingId(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not yet generated for booking: " + bookingId));
    }
}
