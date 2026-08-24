package com.ticketbooking.user.service;

import com.ticketbooking.common.event.PasswordResetRequestedEvent;
import com.ticketbooking.common.exception.UnauthorizedException;
import com.ticketbooking.user.cache.InMemoryExpiringStore;
import com.ticketbooking.user.domain.PasswordResetToken;
import com.ticketbooking.user.domain.User;
import com.ticketbooking.user.repository.PasswordResetTokenRepository;
import com.ticketbooking.user.repository.UserRepository;
import com.ticketbooking.user.util.TokenGenerator;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.Instant;

@Service
public class PasswordResetService {

    private static final String KAFKA_TOPIC = "password-reset-requested";
    private static final String RATE_LIMIT_KEY_PREFIX = "password-reset-rate:";

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final KafkaTemplate<String, Object> kafkaTemplate;
    private final InMemoryExpiringStore store;
    private final Duration tokenTtl;
    private final int rateLimitMaxRequests;
    private final Duration rateLimitWindow;

    public PasswordResetService(UserRepository userRepository,
                                 PasswordResetTokenRepository tokenRepository,
                                 PasswordEncoder passwordEncoder,
                                 KafkaTemplate<String, Object> kafkaTemplate,
                                 InMemoryExpiringStore store,
                                 @Value("${password-reset.ttl-minutes}") long tokenTtlMinutes,
                                 @Value("${password-reset.rate-limit.max-requests}") int rateLimitMaxRequests,
                                 @Value("${password-reset.rate-limit.window-minutes}") long rateLimitWindowMinutes) {
        this.userRepository = userRepository;
        this.tokenRepository = tokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.kafkaTemplate = kafkaTemplate;
        this.store = store;
        this.tokenTtl = Duration.ofMinutes(tokenTtlMinutes);
        this.rateLimitMaxRequests = rateLimitMaxRequests;
        this.rateLimitWindow = Duration.ofMinutes(rateLimitWindowMinutes);
    }

    /**
     * Always completes without signaling whether the email exists or was
     * rate-limited — both the controller's generic 200 and this method's
     * void return are part of the same anti-enumeration guarantee, applied
     * consistently rather than just at the HTTP layer.
     */
    @Transactional
    public void forgotPassword(String email) {
        if (!withinRateLimit(RATE_LIMIT_KEY_PREFIX + email)) {
            return;
        }
        userRepository.findByEmail(email).ifPresent(user -> {
            String rawToken = TokenGenerator.randomToken();
            String tokenHash = TokenGenerator.sha256Hex(rawToken);
            Instant expiresAt = Instant.now().plus(tokenTtl);

            tokenRepository.save(new PasswordResetToken(user, tokenHash, expiresAt));
            kafkaTemplate.send(KAFKA_TOPIC, email, new PasswordResetRequestedEvent(email, rawToken, expiresAt));
        });
    }

    @Transactional
    public void resetPassword(String rawToken, String newPassword) {
        String tokenHash = TokenGenerator.sha256Hex(rawToken);
        PasswordResetToken token = tokenRepository.findByTokenHash(tokenHash)
                .filter(PasswordResetToken::isValid)
                .orElseThrow(() -> new UnauthorizedException("Invalid or expired reset token"));

        User user = token.getUser();
        user.changePasswordHash(passwordEncoder.encode(newPassword));
        token.markUsed();

        tokenRepository.findByUserAndUsedFalse(user).forEach(PasswordResetToken::markUsed);
    }

    private boolean withinRateLimit(String key) {
        long count = store.increment(key);
        if (count == 1L) {
            store.expire(key, rateLimitWindow);
        }
        return count <= rateLimitMaxRequests;
    }
}
