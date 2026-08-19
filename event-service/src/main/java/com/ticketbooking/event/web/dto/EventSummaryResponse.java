package com.ticketbooking.event.web.dto;

import com.ticketbooking.event.domain.EventCategory;

import java.util.UUID;

public record EventSummaryResponse(
        UUID id,
        String title,
        EventCategory category,
        String description
) {
}
