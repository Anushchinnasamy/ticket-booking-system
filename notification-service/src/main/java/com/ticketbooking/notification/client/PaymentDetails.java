package com.ticketbooking.notification.client;

import java.math.BigDecimal;

public record PaymentDetails(BigDecimal amount, String currency, String status) {
}
