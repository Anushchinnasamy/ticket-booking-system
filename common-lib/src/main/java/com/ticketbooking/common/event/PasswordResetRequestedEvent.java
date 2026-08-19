package com.ticketbooking.common.event;

import java.time.Instant;

/**
 * Published to the {@code password-reset-requested} topic. Carries the raw
 * (unhashed) token so Notification service can put it in the reset link —
 * User service only ever persists the token's hash.
 */
public record PasswordResetRequestedEvent(
        String email,
        String rawToken,
        Instant expiresAt
) {
}
