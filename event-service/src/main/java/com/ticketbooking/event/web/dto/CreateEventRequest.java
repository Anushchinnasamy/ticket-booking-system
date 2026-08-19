package com.ticketbooking.event.web.dto;

import com.ticketbooking.event.domain.EventCategory;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateEventRequest(
        @NotBlank String title,
        @NotNull EventCategory category,
        String description
) {
}
