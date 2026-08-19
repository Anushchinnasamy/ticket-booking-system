package com.ticketbooking.common.event;

import java.time.Instant;

/**
 * Published to the {@code otp-requested} topic. Carries the raw OTP so
 * Notification service can email it — User service only ever persists the
 * OTP's hash in Redis.
 */
public record OtpRequestedEvent(
        String email,
        String otp,
        Instant expiresAt
) {
}
