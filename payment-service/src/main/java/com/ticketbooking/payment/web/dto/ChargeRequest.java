package com.ticketbooking.payment.web.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public record ChargeRequest(
        @NotEmpty List<@NotNull UUID> bookingIds,
        @NotNull @DecimalMin(value = "0.01") BigDecimal amount
) {
}
