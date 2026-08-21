package com.ticketbooking.event.web.dto;

import com.ticketbooking.event.domain.SeatStatus;
import com.ticketbooking.event.domain.SeatType;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record SeatResponse(
        UUID id,
        String rowLabel,
        int seatNumber,
        SeatType seatType,
        BigDecimal price,
        SeatStatus status,
        // Null unless LOCKED — an approximate marker of when the hold started,
        // for the frontend to show "unlocks in ~Xm" on seats held by someone
        // else. The real TTL enforcement lives in booking-service's Redis
        // lock; this is a display-only mirror of that moment.
        Instant lockedAt
) {
}
