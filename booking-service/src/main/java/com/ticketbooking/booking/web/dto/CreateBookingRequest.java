package com.ticketbooking.booking.web.dto;

import jakarta.validation.constraints.NotNull;

import java.util.UUID;

public record CreateBookingRequest(
        @NotNull UUID showId,
        @NotNull UUID seatId,
        @NotNull UUID userId
) {
}
