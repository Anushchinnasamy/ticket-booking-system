package com.ticketbooking.booking.ticketing;

import java.math.BigDecimal;
import java.time.Instant;

public record SeatDetails(
        String eventTitle,
        String venueName,
        Instant startTime,
        String rowLabel,
        int seatNumber,
        String seatType,
        BigDecimal price
) {
}
