package com.ticketbooking.booking.web.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.util.List;
import java.util.UUID;

public record CombinedTicketRequest(@NotEmpty List<@NotNull UUID> bookingIds) {
}
