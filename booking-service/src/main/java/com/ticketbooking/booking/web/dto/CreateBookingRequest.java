package com.ticketbooking.booking.web.dto;

import jakarta.validation.constraints.NotNull;

import java.util.UUID;

/** userId is no longer client-supplied — it's derived from the authenticated JWT (see BookingController). */
public record CreateBookingRequest(
        @NotNull UUID showId,
        @NotNull UUID seatId
) {
}
