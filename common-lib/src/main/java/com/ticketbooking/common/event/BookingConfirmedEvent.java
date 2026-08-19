package com.ticketbooking.common.event;

import java.time.Instant;
import java.util.UUID;

/** Published to the {@code booking-confirmed} topic. */
public record BookingConfirmedEvent(
        UUID bookingId,
        UUID showId,
        UUID seatId,
        UUID userId,
        Instant confirmedAt
) {
}
