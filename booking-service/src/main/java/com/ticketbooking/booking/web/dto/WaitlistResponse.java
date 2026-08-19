package com.ticketbooking.booking.web.dto;

import com.ticketbooking.booking.domain.WaitlistStatus;

import java.time.Instant;
import java.util.UUID;

public record WaitlistResponse(
        UUID id,
        UUID showId,
        UUID userId,
        long position,
        WaitlistStatus status,
        Instant createdAt
) {
}
