package com.ticketbooking.user.service;

import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.common.exception.UnauthorizedException;
import com.ticketbooking.common.security.JwtService;
import com.ticketbooking.user.domain.User;
import com.ticketbooking.user.domain.UserRole;
import com.ticketbooking.user.repository.UserRepository;
import com.ticketbooking.user.web.dto.AuthResponse;
import com.ticketbooking.user.web.dto.LoginRequest;
import com.ticketbooking.user.web.dto.ProfileResponse;
import com.ticketbooking.user.web.dto.RefreshRequest;
import com.ticketbooking.user.web.dto.RegisterRequest;
import com.ticketbooking.user.web.dto.UserSummaryResponse;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Map;
import java.util.UUID;

@Service
public class AuthService {

    private static final String CLAIM_TYPE = "type";
    private static final String TOKEN_TYPE_ACCESS = "access";
    private static final String TOKEN_TYPE_REFRESH = "refresh";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final Duration accessTokenTtl;
    private final Duration refreshTokenTtl;

    public AuthService(UserRepository userRepository,
                        PasswordEncoder passwordEncoder,
                        JwtService jwtService,
                        @Value("${jwt.access-token-ttl-minutes}") long accessTokenTtlMinutes,
                        @Value("${jwt.refresh-token-ttl-days}") long refreshTokenTtlDays) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.accessTokenTtl = Duration.ofMinutes(accessTokenTtlMinutes);
        this.refreshTokenTtl = Duration.ofDays(refreshTokenTtlDays);
    }

    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new ConflictException("Email already registered: " + request.email());
        }
        User user = new User(request.email(), passwordEncoder.encode(request.password()), UserRole.CUSTOMER);
        User saved = userRepository.save(user);
        return issueTokens(saved);
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new UnauthorizedException("Invalid email or password"));
        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new UnauthorizedException("Invalid email or password");
        }
        return issueTokens(user);
    }

    @Transactional(readOnly = true)
    public AuthResponse refresh(RefreshRequest request) {
        Claims claims;
        try {
            claims = jwtService.parseClaims(request.refreshToken());
        } catch (JwtException | IllegalArgumentException e) {
            throw new UnauthorizedException("Invalid or expired refresh token");
        }
        if (!TOKEN_TYPE_REFRESH.equals(claims.get(CLAIM_TYPE, String.class))) {
            throw new UnauthorizedException("Not a refresh token");
        }
        User user = userRepository.findById(UUID.fromString(claims.getSubject()))
                .orElseThrow(() -> new UnauthorizedException("User no longer exists"));
        return issueTokens(user);
    }

    @Transactional(readOnly = true)
    public ProfileResponse getProfile(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + userId));
        return new ProfileResponse(user.getId(), user.getEmail(), user.getRole(), user.getCreatedAt());
    }

    /**
     * Internal, service-to-service lookup (e.g. Notification Service
     * resolving an email from the userId in a booking-confirmed event).
     */
    @Transactional(readOnly = true)
    public UserSummaryResponse getUserSummary(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + userId));
        return new UserSummaryResponse(user.getId(), user.getEmail());
    }

    /** Public so OtpService can issue the same token pair after a successful OTP verification. */
    public AuthResponse issueTokens(User user) {
        String accessToken = jwtService.generateToken(
                user.getId().toString(),
                Map.of("email", user.getEmail(), "role", user.getRole().name(), CLAIM_TYPE, TOKEN_TYPE_ACCESS),
                accessTokenTtl);
        String refreshToken = jwtService.generateToken(
                user.getId().toString(),
                Map.of(CLAIM_TYPE, TOKEN_TYPE_REFRESH),
                refreshTokenTtl);
        return new AuthResponse(accessToken, refreshToken, "Bearer", accessTokenTtl.toSeconds());
    }
}
