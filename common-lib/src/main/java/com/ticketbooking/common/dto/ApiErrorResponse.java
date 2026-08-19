package com.ticketbooking.common.dto;

import java.time.Instant;

public record ApiErrorResponse(
        String errorCode,
        String message,
        Instant timestamp
) {
    public static ApiErrorResponse of(String errorCode, String message) {
        return new ApiErrorResponse(errorCode, message, Instant.now());
    }
}
