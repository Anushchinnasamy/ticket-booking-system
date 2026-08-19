package com.ticketbooking.event.web.dto;

import com.ticketbooking.event.domain.EventCategory;

import java.util.List;
import java.util.UUID;

public record EventDetailResponse(
        UUID id,
        String title,
        EventCategory category,
        String description,
        List<ShowSummaryResponse> shows
) {
}
