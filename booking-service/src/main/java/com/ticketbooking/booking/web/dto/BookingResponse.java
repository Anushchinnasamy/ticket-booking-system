package com.ticketbooking.booking.web.dto;

import com.ticketbooking.booking.domain.BookingStatus;

import java.time.Instant;
import java.util.UUID;

public record BookingResponse(
        UUID id,
        UUID showId,
        UUID seatId,
        UUID userId,
        BookingStatus status,
        Instant createdAt
) {
}
