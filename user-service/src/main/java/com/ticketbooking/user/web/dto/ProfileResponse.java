package com.ticketbooking.user.web.dto;

import com.ticketbooking.user.domain.UserRole;

import java.time.Instant;
import java.util.UUID;

public record ProfileResponse(
        UUID id,
        String email,
        UserRole role,
        Instant createdAt
) {
}
