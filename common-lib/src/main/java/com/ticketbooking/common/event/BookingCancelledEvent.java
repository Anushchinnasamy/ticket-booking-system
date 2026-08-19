package com.ticketbooking.common.event;

import java.time.Instant;
import java.util.UUID;

/** Published to the {@code booking-cancelled} topic. */
public record BookingCancelledEvent(
        UUID bookingId,
        UUID showId,
        UUID seatId,
        UUID userId,
        Instant cancelledAt
) {
}
