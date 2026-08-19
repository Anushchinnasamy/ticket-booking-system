package com.ticketbooking.booking.web.dto;

import jakarta.validation.constraints.NotNull;

import java.util.UUID;

/** customerId is the walk-up customer the counter staff is booking for — distinct from the authenticated staff member. */
public record CounterSaleRequest(
        @NotNull UUID showId,
        @NotNull UUID seatId,
        @NotNull UUID customerId
) {
}
