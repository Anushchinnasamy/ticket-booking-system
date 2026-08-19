package com.ticketbooking.booking.web.dto;

import jakarta.validation.constraints.NotBlank;

public record RedeemRequest(@NotBlank String qrPayload) {
}
