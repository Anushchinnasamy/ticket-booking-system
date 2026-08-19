package com.ticketbooking.payment.web.dto;

import jakarta.validation.constraints.NotBlank;

public record VerifyRequest(
        @NotBlank String razorpayOrderId,
        @NotBlank String razorpayPaymentId,
        @NotBlank String razorpaySignature
) {
}
