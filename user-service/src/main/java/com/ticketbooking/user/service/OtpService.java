package com.ticketbooking.user.service;

import com.ticketbooking.common.event.OtpRequestedEvent;
import com.ticketbooking.common.exception.UnauthorizedException;
import com.ticketbooking.user.cache.InMemoryExpiringStore;
import com.ticketbooking.user.domain.User;
import com.ticketbooking.user.repository.UserRepository;
import com.ticketbooking.user.util.TokenGenerator;
import com.ticketbooking.user.web.dto.AuthResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.Instant;

/**
 * Passwordless login: runs alongside password login, not instead of it.
 * The OTP store here is deliberately not the primary Postgres database —
 * an OTP is inherently ephemeral, it either gets used within its TTL or it
 * doesn't matter anymore.
 */
@Service
public class OtpService {

    private static final String KAFKA_TOPIC = "otp-requested";
    private static final String OTP_KEY_PREFIX = "otp:";
    private static final String RATE_LIMIT_KEY_PREFIX = "otp-rate:";
    private static final int OTP_DIGITS = 6;

    private final UserRepository userRepository;
    private final AuthService authService;
    private final InMemoryExpiringStore store;
    private final KafkaTemplate<String, Object> kafkaTemplate;
    private final Duration otpTtl;
    private final int rateLimitMaxRequests;
    private final Duration rateLimitWindow;

    public OtpService(UserRepository userRepository,
                       AuthService authService,
                       InMemoryExpiringStore store,
                       KafkaTemplate<String, Object> kafkaTemplate,
                       @Value("${otp.ttl-minutes}") long otpTtlMinutes,
                       @Value("${otp.rate-limit.max-requests}") int rateLimitMaxRequests,
                       @Value("${otp.rate-limit.window-minutes}") long rateLimitWindowMinutes) {
        this.userRepository = userRepository;
        this.authService = authService;
        this.store = store;
        this.kafkaTemplate = kafkaTemplate;
        this.otpTtl = Duration.ofMinutes(otpTtlMinutes);
        this.rateLimitMaxRequests = rateLimitMaxRequests;
        this.rateLimitWindow = Duration.ofMinutes(rateLimitWindowMinutes);
    }

    /** Same anti-enumeration guarantee as forgot-password: always completes without revealing whether the email exists. */
    public void requestOtp(String email) {
        if (!withinRateLimit(RATE_LIMIT_KEY_PREFIX + email)) {
            return;
        }
        userRepository.findByEmail(email).ifPresent(user -> {
            String otp = TokenGenerator.randomNumericOtp(OTP_DIGITS);
            store.set(OTP_KEY_PREFIX + email, TokenGenerator.sha256Hex(otp), otpTtl);
            kafkaTemplate.send(KAFKA_TOPIC, email, new OtpRequestedEvent(email, otp, Instant.now().plus(otpTtl)));
        });
    }

    /**
     * Single-use regardless of outcome: the stored OTP is deleted whether the
     * guess was right or wrong, so a second attempt with the same code always
     * fails — no retries against a captured/guessed OTP.
     */
    @Transactional(readOnly = true)
    public AuthResponse verifyOtp(String email, String otp) {
        String key = OTP_KEY_PREFIX + email;
        String storedHash = store.get(key);
        store.delete(key);

        if (storedHash == null || !storedHash.equals(TokenGenerator.sha256Hex(otp))) {
            throw new UnauthorizedException("Invalid or expired OTP");
        }

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UnauthorizedException("Invalid or expired OTP"));
        return authService.issueTokens(user);
    }

    private boolean withinRateLimit(String key) {
        long count = store.increment(key);
        if (count == 1L) {
            store.expire(key, rateLimitWindow);
        }
        return count <= rateLimitMaxRequests;
    }
}
