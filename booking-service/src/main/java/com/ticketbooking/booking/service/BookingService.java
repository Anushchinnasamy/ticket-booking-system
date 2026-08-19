package com.ticketbooking.booking.service;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.repository.BookingRepository;
import com.ticketbooking.booking.web.dto.BookingResponse;
import com.ticketbooking.booking.web.dto.CreateBookingRequest;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final EventServiceClient eventServiceClient;

    public BookingService(BookingRepository bookingRepository, EventServiceClient eventServiceClient) {
        this.bookingRepository = bookingRepository;
        this.eventServiceClient = eventServiceClient;
    }

    /**
     * Not wrapped in a local transaction: the seat lock call to Event
     * Service is a network round trip, and it must complete (or fail)
     * before any local row is written — holding a DB transaction open across
     * that call would tie up a connection for no reason.
     */
    public BookingResponse createBooking(CreateBookingRequest request) {
        eventServiceClient.lockSeat(request.showId(), request.seatId());

        Booking booking = new Booking(request.showId(), request.seatId(), request.userId());
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
