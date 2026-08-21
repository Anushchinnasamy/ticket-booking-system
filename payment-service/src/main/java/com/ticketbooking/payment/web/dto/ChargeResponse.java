package com.ticketbooking.payment.web.dto;

import com.ticketbooking.payment.domain.PaymentStatus;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public record ChargeResponse(
        UUID paymentId,
        List<UUID> bookingIds,
        BigDecimal amount,
        String currency,
        PaymentStatus status,
        String razorpayOrderId,
        String razorpayKeyId
) {
}
