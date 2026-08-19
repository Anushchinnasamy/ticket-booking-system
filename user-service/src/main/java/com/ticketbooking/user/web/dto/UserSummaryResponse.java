package com.ticketbooking.user.web.dto;

import java.util.UUID;

/** Minimal internal lookup shape — e.g. Notification Service resolving an email from a userId. */
public record UserSummaryResponse(
        UUID id,
        String email
) {
}
