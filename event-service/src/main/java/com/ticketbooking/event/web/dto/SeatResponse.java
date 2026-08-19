package com.ticketbooking.event.web.dto;

import com.ticketbooking.event.domain.SeatStatus;
import com.ticketbooking.event.domain.SeatType;

import java.math.BigDecimal;
import java.util.UUID;

public record SeatResponse(
        UUID id,
        String rowLabel,
        int seatNumber,
        SeatType seatType,
        BigDecimal price,
        SeatStatus status
) {
}
