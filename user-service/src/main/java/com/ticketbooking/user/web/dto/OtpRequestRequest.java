package com.ticketbooking.user.web.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record OtpRequestRequest(
        @NotBlank @Email String email
) {
}
