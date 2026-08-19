package com.ticketbooking.user.web;

import com.ticketbooking.user.service.AuthService;
import com.ticketbooking.user.service.OtpService;
import com.ticketbooking.user.service.PasswordResetService;
import com.ticketbooking.user.web.dto.AuthResponse;
import com.ticketbooking.user.web.dto.ForgotPasswordRequest;
import com.ticketbooking.user.web.dto.LoginRequest;
import com.ticketbooking.user.web.dto.OtpRequestRequest;
import com.ticketbooking.user.web.dto.OtpVerifyRequest;
import com.ticketbooking.user.web.dto.ProfileResponse;
import com.ticketbooking.user.web.dto.RefreshRequest;
import com.ticketbooking.user.web.dto.RegisterRequest;
import com.ticketbooking.user.web.dto.ResetPasswordRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;
    private final PasswordResetService passwordResetService;
    private final OtpService otpService;

    public AuthController(AuthService authService, PasswordResetService passwordResetService, OtpService otpService) {
        this.authService = authService;
        this.passwordResetService = passwordResetService;
        this.otpService = otpService;
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public AuthResponse register(@Valid @RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @PostMapping("/refresh")
    public AuthResponse refresh(@Valid @RequestBody RefreshRequest request) {
        return authService.refresh(request);
    }

    @GetMapping("/profile")
    public ProfileResponse profile(Authentication authentication) {
        UUID userId = UUID.fromString(authentication.getName());
        return authService.getProfile(userId);
    }

    /** Always 200 regardless of whether the email exists or was rate-limited — see PasswordResetService. */
    @PostMapping("/forgot-password")
    public void forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        passwordResetService.forgotPassword(request.email());
    }

    @PostMapping("/reset-password")
    public void resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        passwordResetService.resetPassword(request.token(), request.newPassword());
    }

    /** Always 200 — same anti-enumeration reasoning as forgot-password. */
    @PostMapping("/otp/request")
    public void requestOtp(@Valid @RequestBody OtpRequestRequest request) {
        otpService.requestOtp(request.email());
    }

    @PostMapping("/otp/verify")
    public AuthResponse verifyOtp(@Valid @RequestBody OtpVerifyRequest request) {
        return otpService.verifyOtp(request.email(), request.otp());
    }
}
