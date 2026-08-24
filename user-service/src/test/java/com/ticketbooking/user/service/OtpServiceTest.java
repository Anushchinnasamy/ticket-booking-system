package com.ticketbooking.user.service;

import com.ticketbooking.common.event.OtpRequestedEvent;
import com.ticketbooking.common.exception.UnauthorizedException;
import com.ticketbooking.user.cache.InMemoryExpiringStore;
import com.ticketbooking.user.domain.User;
import com.ticketbooking.user.domain.UserRole;
import com.ticketbooking.user.repository.UserRepository;
import com.ticketbooking.user.util.TokenGenerator;
import com.ticketbooking.user.web.dto.AuthResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.core.KafkaTemplate;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OtpServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private AuthService authService;

    @Mock
    private KafkaTemplate<String, Object> kafkaTemplate;

    private final InMemoryExpiringStore store = new InMemoryExpiringStore();

    private OtpService newService() {
        return newService(3);
    }

    private OtpService newService(int rateLimitMaxRequests) {
        return new OtpService(userRepository, authService, store, kafkaTemplate, 5, rateLimitMaxRequests, 10);
    }

    @Test
    void requestOtp_whenUserExists_storesHashAndPublishesEvent() {
        OtpService service = newService();
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(new User("a@b.com", "hash", UserRole.CUSTOMER)));

        service.requestOtp("a@b.com");

        assertThat(store.get("otp:a@b.com")).isNotNull();
        verify(kafkaTemplate).send(eq("otp-requested"), eq("a@b.com"), any(OtpRequestedEvent.class));
    }

    @Test
    void requestOtp_whenUserDoesNotExist_completesWithoutStoringOrPublishing() {
        OtpService service = newService();
        when(userRepository.findByEmail("nobody@example.com")).thenReturn(Optional.empty());

        service.requestOtp("nobody@example.com");

        verifyNoInteractions(kafkaTemplate);
    }

    @Test
    void requestOtp_whenRateLimited_doesNotLookUpUser() {
        OtpService service = newService(3);
        store.set("otp-rate:a@b.com", "3", java.time.Duration.ofMinutes(10));

        service.requestOtp("a@b.com");

        verifyNoInteractions(userRepository);
        verifyNoInteractions(kafkaTemplate);
    }

    @Test
    void verifyOtp_whenCorrect_deletesKeyAndIssuesTokens() {
        OtpService service = newService();
        String otp = "123456";
        store.set("otp:a@b.com", TokenGenerator.sha256Hex(otp), java.time.Duration.ofMinutes(5));
        User user = new User("a@b.com", "hash", UserRole.CUSTOMER);
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(user));
        AuthResponse expected = new AuthResponse("access", "refresh", "Bearer", 900);
        when(authService.issueTokens(user)).thenReturn(expected);

        AuthResponse result = service.verifyOtp("a@b.com", otp);

        assertThat(result).isEqualTo(expected);
        assertThat(store.get("otp:a@b.com")).isNull();
    }

    @Test
    void verifyOtp_whenIncorrect_deletesKeyAnywayAndThrowsUnauthorized() {
        OtpService service = newService();
        store.set("otp:a@b.com", TokenGenerator.sha256Hex("123456"), java.time.Duration.ofMinutes(5));

        assertThatThrownBy(() -> service.verifyOtp("a@b.com", "999999"))
                .isInstanceOf(UnauthorizedException.class);

        assertThat(store.get("otp:a@b.com")).isNull();
        verifyNoInteractions(authService);
    }

    @Test
    void verifyOtp_whenNoStoredOtp_throwsUnauthorized() {
        OtpService service = newService();

        assertThatThrownBy(() -> service.verifyOtp("a@b.com", "123456"))
                .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void verifyOtp_calledTwiceWithSameOtp_secondCallFailsBecauseKeyWasDeleted() {
        OtpService service = newService();
        String otp = "123456";
        store.set("otp:a@b.com", TokenGenerator.sha256Hex(otp), java.time.Duration.ofMinutes(5));
        User user = new User("a@b.com", "hash", UserRole.CUSTOMER);
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(user));
        when(authService.issueTokens(user)).thenReturn(new AuthResponse("a", "r", "Bearer", 900));

        service.verifyOtp("a@b.com", otp);

        assertThatThrownBy(() -> service.verifyOtp("a@b.com", otp))
                .isInstanceOf(UnauthorizedException.class);
    }
}
