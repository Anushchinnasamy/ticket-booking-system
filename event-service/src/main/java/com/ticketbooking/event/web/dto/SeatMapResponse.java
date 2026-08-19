package com.ticketbooking.event.web.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record SeatMapResponse(
        UUID showId,
        String eventTitle,
        String venueName,
        Instant startTime,
        BigDecimal basePrice,
        List<SeatResponse> seats
) {
}
