package com.ticketbooking.event.web.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record ShowSummaryResponse(
        UUID id,
        String venueName,
        String venueCity,
        Instant startTime,
        BigDecimal basePrice
) {
}
