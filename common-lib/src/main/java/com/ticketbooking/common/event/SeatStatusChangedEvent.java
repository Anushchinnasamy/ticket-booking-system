package com.ticketbooking.common.event;

import java.time.Instant;
import java.util.UUID;

/** Published to the {@code seat-status-changed} topic. */
public record SeatStatusChangedEvent(
        UUID showId,
        UUID seatId,
        String status,
        Instant changedAt
) {
}
