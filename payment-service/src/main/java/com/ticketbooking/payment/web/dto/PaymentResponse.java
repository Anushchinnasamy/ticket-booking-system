package com.ticketbooking.payment.web.dto;

import com.ticketbooking.payment.domain.PaymentStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record PaymentResponse(
        UUID id,
        UUID bookingId,
        BigDecimal amount,
        String currency,
        PaymentStatus status,
        String razorpayOrderId,
        String razorpayPaymentId,
        Instant createdAt
) {
}
