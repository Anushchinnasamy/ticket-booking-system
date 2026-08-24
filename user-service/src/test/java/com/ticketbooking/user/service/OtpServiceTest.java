package com.ticketbooking.user.service;

import com.ticketbooking.common.event.OtpRequestedEvent;
import com.ticketbooking.common.exception.UnauthorizedException;
import com.ticketbooking.user.domain.User;
import com.ticketbooking.user.domain.UserRole;
import com.ticketbooking.user.repository.UserRepository;
import com.ticketbooking.user.util.TokenGenerator;
import com.ticketbooking.user.web.dto.AuthResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.kafka.core.KafkaTemplate;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
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
    private StringRedisTemplate redisTemplate;

    @Mock
    private ValueOperations<String, String> valueOperations;

    @Mock
    private KafkaTemplate<String, Object> kafkaTemplate;

    private OtpService newService() {
        return new OtpService(userRepository, authService, redisTemplate, kafkaTemplate, 5, 3, 10);
    }

    private void stubRateLimit(long countAfterIncrement) {
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.increment(anyString())).thenReturn(countAfterIncrement);
    }

    @Test
    void requestOtp_whenUserExists_storesHashAndPublishesEvent() {
        OtpService service = newService();
        stubRateLimit(1L);
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(new User("a@b.com", "hash", UserRole.CUSTOMER)));

        service.requestOtp("a@b.com");

        verify(valueOperations).set(eq("otp:a@b.com"), anyString(), any());
        verify(kafkaTemplate).send(eq("otp-requested"), eq("a@b.com"), any(OtpRequestedEvent.class));
    }

    @Test
    void requestOtp_whenUserDoesNotExist_completesWithoutStoringOrPublishing() {
        OtpService service = newService();
        stubRateLimit(1L);
        when(userRepository.findByEmail("nobody@example.com")).thenReturn(Optional.empty());

        service.requestOtp("nobody@example.com");

        verifyNoInteractions(kafkaTemplate);
    }

    @Test
    void requestOtp_whenRateLimited_doesNotLookUpUser() {
        OtpService service = newService();
        stubRateLimit(4L);

        service.requestOtp("a@b.com");

        verifyNoInteractions(userRepository);
        verifyNoInteractions(kafkaTemplate);
    }

    @Test
    void verifyOtp_whenCorrect_deletesKeyAndIssuesTokens() {
        OtpService service = newService();
        String otp = "123456";
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("otp:a@b.com")).thenReturn(TokenGenerator.sha256Hex(otp));
        User user = new User("a@b.com", "hash", UserRole.CUSTOMER);
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(user));
        AuthResponse expected = new AuthResponse("access", "refresh", "Bearer", 900);
        when(authService.issueTokens(user)).thenReturn(expected);

        AuthResponse result = service.verifyOtp("a@b.com", otp);

        assertThat(result).isEqualTo(expected);
        verify(redisTemplate).delete("otp:a@b.com");
    }

    @Test
    void verifyOtp_whenIncorrect_deletesKeyAnywayAndThrowsUnauthorized() {
        OtpService service = newService();
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("otp:a@b.com")).thenReturn(TokenGenerator.sha256Hex("123456"));

        assertThatThrownBy(() -> service.verifyOtp("a@b.com", "999999"))
                .isInstanceOf(UnauthorizedException.class);

        verify(redisTemplate).delete("otp:a@b.com");
        verifyNoInteractions(authService);
    }

    @Test
    void verifyOtp_whenNoStoredOtp_throwsUnauthorized() {
        OtpService service = newService();
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("otp:a@b.com")).thenReturn(null);

        assertThatThrownBy(() -> service.verifyOtp("a@b.com", "123456"))
                .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void verifyOtp_calledTwiceWithSameOtp_secondCallFailsBecauseKeyWasDeleted() {
        OtpService service = newService();
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        String otp = "123456";
        when(valueOperations.get("otp:a@b.com"))
                .thenReturn(TokenGenerator.sha256Hex(otp))
                .thenReturn(null); // simulates the real Redis delete having taken effect
        User user = new User("a@b.com", "hash", UserRole.CUSTOMER);
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(user));
        when(authService.issueTokens(user)).thenReturn(new AuthResponse("a", "r", "Bearer", 900));

        service.verifyOtp("a@b.com", otp);

        assertThatThrownBy(() -> service.verifyOtp("a@b.com", otp))
                .isInstanceOf(UnauthorizedException.class);
    }
}
