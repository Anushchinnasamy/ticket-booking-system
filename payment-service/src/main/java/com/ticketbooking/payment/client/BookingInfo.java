package com.ticketbooking.payment.client;

import java.time.Instant;
import java.util.UUID;

/** Mirrors booking-service's BookingResponse — only the fields payment-service needs. */
public record BookingInfo(
        UUID id,
        UUID showId,
        UUID seatId,
        UUID userId,
        String status,
        Instant createdAt
) {
}
