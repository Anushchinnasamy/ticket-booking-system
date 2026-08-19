package com.ticketbooking.common.event;

import java.time.Instant;
import java.util.UUID;

/** Published to the {@code waitlist-seat-available} topic when a cancellation frees a seat on a show with a waiting list. */
public record WaitlistSeatAvailableEvent(
        UUID waitlistId,
        UUID showId,
        UUID userId,
        UUID seatId,
        Instant notifiedAt
) {
}
