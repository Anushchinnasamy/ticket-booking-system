package com.ticketbooking.user.service;

import com.ticketbooking.common.event.PasswordResetRequestedEvent;
import com.ticketbooking.common.exception.UnauthorizedException;
import com.ticketbooking.user.cache.InMemoryExpiringStore;
import com.ticketbooking.user.domain.PasswordResetToken;
import com.ticketbooking.user.domain.User;
import com.ticketbooking.user.domain.UserRole;
import com.ticketbooking.user.repository.PasswordResetTokenRepository;
import com.ticketbooking.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PasswordResetServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordResetTokenRepository tokenRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private KafkaTemplate<String, Object> kafkaTemplate;

    private final InMemoryExpiringStore store = new InMemoryExpiringStore();

    private PasswordResetService newService() {
        return new PasswordResetService(userRepository, tokenRepository, passwordEncoder, kafkaTemplate,
                store, 15, 3, 60);
    }

    @Test
    void forgotPassword_whenUserExists_savesTokenAndPublishesEvent() {
        PasswordResetService service = newService();
        User user = userWithId("a@b.com", "hashed", UserRole.CUSTOMER);
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(user));

        service.forgotPassword("a@b.com");

        verify(tokenRepository).save(any(PasswordResetToken.class));
        verify(kafkaTemplate).send(eq("password-reset-requested"), eq("a@b.com"), any(PasswordResetRequestedEvent.class));
    }

    @Test
    void forgotPassword_whenUserDoesNotExist_completesWithoutSavingOrPublishing() {
        PasswordResetService service = newService();
        when(userRepository.findByEmail("nobody@example.com")).thenReturn(Optional.empty());

        service.forgotPassword("nobody@example.com");

        verifyNoInteractions(tokenRepository);
        verifyNoInteractions(kafkaTemplate);
    }

    @Test
    void forgotPassword_whenRateLimited_doesNotLookUpUserAtAll() {
        PasswordResetService service = newService();
        store.set("password-reset-rate:a@b.com", "3", Duration.ofMinutes(60)); // already at the max of 3

        service.forgotPassword("a@b.com");

        verifyNoInteractions(userRepository);
        verifyNoInteractions(tokenRepository);
        verifyNoInteractions(kafkaTemplate);
    }

    @Test
    void resetPassword_whenTokenValid_updatesPasswordMarksUsedAndInvalidatesOtherTokens() {
        PasswordResetService service = newService();
        User user = userWithId("a@b.com", "old-hash", UserRole.CUSTOMER);
        String rawToken = "raw-token-value";
        String tokenHash = sha256Hex(rawToken);
        PasswordResetToken token = new PasswordResetToken(user, tokenHash, Instant.now().plusSeconds(600));
        PasswordResetToken otherOutstanding = new PasswordResetToken(user, "other-hash", Instant.now().plusSeconds(600));

        when(tokenRepository.findByTokenHash(tokenHash)).thenReturn(Optional.of(token));
        when(passwordEncoder.encode("newPassword123")).thenReturn("new-hash");
        when(tokenRepository.findByUserAndUsedFalse(user)).thenReturn(List.of(otherOutstanding));

        service.resetPassword(rawToken, "newPassword123");

        assertThat(user.getPasswordHash()).isEqualTo("new-hash");
        assertThat(token.isUsed()).isTrue();
        assertThat(otherOutstanding.isUsed()).isTrue();
    }

    @Test
    void resetPassword_whenTokenNotFound_throwsUnauthorizedException() {
        PasswordResetService service = newService();
        when(tokenRepository.findByTokenHash(anyString())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.resetPassword("bogus", "newPassword123"))
                .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void resetPassword_whenTokenExpired_throwsUnauthorizedException() {
        PasswordResetService service = newService();
        User user = userWithId("a@b.com", "old-hash", UserRole.CUSTOMER);
        String rawToken = "raw-token";
        String tokenHash = sha256Hex(rawToken);
        PasswordResetToken expired = new PasswordResetToken(user, tokenHash, Instant.now().minusSeconds(1));
        when(tokenRepository.findByTokenHash(tokenHash)).thenReturn(Optional.of(expired));

        assertThatThrownBy(() -> service.resetPassword(rawToken, "newPassword123"))
                .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void resetPassword_whenTokenAlreadyUsed_throwsUnauthorizedException() {
        PasswordResetService service = newService();
        User user = userWithId("a@b.com", "old-hash", UserRole.CUSTOMER);
        String rawToken = "raw-token";
        String tokenHash = sha256Hex(rawToken);
        PasswordResetToken used = new PasswordResetToken(user, tokenHash, Instant.now().plusSeconds(600));
        used.markUsed();
        when(tokenRepository.findByTokenHash(tokenHash)).thenReturn(Optional.of(used));

        assertThatThrownBy(() -> service.resetPassword(rawToken, "newPassword123"))
                .isInstanceOf(UnauthorizedException.class);
    }

    private static User userWithId(String email, String passwordHash, UserRole role) {
        User user = new User(email, passwordHash, role);
        ReflectionTestUtils.setField(user, "id", UUID.randomUUID());
        return user;
    }

    private static String sha256Hex(String raw) {
        return com.ticketbooking.user.util.TokenGenerator.sha256Hex(raw);
    }
}
