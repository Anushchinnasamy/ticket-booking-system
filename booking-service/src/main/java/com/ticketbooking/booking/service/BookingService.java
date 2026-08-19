package com.ticketbooking.booking.service;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.domain.Booking;
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
     * around this one write. It's released by the stale-booking sweep if the
     * hold expires, or (in a future phase) on payment confirm/cancel.
     */
    public BookingResponse createBooking(CreateBookingRequest request) {
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

        Booking booking = new Booking(showId, seatId, request.userId());
        Booking saved = bookingRepository.save(booking);
        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public BookingResponse getBooking(UUID id) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found: " + id));
        return toResponse(booking);
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
