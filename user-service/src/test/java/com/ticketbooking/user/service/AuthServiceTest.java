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
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    private AuthService newService() {
        return new AuthService(userRepository, passwordEncoder, jwtService, 15, 7);
    }

    @Test
    void register_whenNewEmail_savesUserAndIssuesTokens() {
        AuthService authService = newService();
        RegisterRequest request = new RegisterRequest("new@example.com", "password123");
        when(userRepository.existsByEmail("new@example.com")).thenReturn(false);
        when(passwordEncoder.encode("password123")).thenReturn("hashed");
        User saved = userWithId("new@example.com", "hashed", UserRole.CUSTOMER);
        when(userRepository.save(any(User.class))).thenReturn(saved);
        when(jwtService.generateToken(anyString(), any(), any())).thenReturn("token");

        AuthResponse result = authService.register(request);

        assertThat(result.accessToken()).isEqualTo("token");
        assertThat(result.tokenType()).isEqualTo("Bearer");
        verify(userRepository).save(any(User.class));
    }

    @Test
    void register_whenEmailAlreadyExists_throwsConflictException() {
        AuthService authService = newService();
        when(userRepository.existsByEmail("taken@example.com")).thenReturn(true);

        assertThatThrownBy(() -> authService.register(new RegisterRequest("taken@example.com", "password123")))
                .isInstanceOf(ConflictException.class);
    }

    @Test
    void login_whenValidCredentials_issuesTokens() {
        AuthService authService = newService();
        User user = userWithId("a@b.com", "hashed", UserRole.CUSTOMER);
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("password123", "hashed")).thenReturn(true);
        when(jwtService.generateToken(anyString(), any(), any())).thenReturn("token");

        AuthResponse result = authService.login(new LoginRequest("a@b.com", "password123"));

        assertThat(result.accessToken()).isEqualTo("token");
    }

    @Test
    void login_whenUserNotFound_throwsUnauthorizedException() {
        AuthService authService = newService();
        when(userRepository.findByEmail("nobody@example.com")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> authService.login(new LoginRequest("nobody@example.com", "password123")))
                .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void login_whenWrongPassword_throwsUnauthorizedException() {
        AuthService authService = newService();
        User user = new User("a@b.com", "hashed", UserRole.CUSTOMER);
        when(userRepository.findByEmail("a@b.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrong", "hashed")).thenReturn(false);

        assertThatThrownBy(() -> authService.login(new LoginRequest("a@b.com", "wrong")))
                .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void refresh_whenValidRefreshToken_issuesNewTokenPair() {
        AuthService authService = newService();
        User user = userWithId("a@b.com", "hashed", UserRole.CUSTOMER);
        UUID userId = user.getId();
        Claims claims = mock(Claims.class);
        when(claims.get("type", String.class)).thenReturn("refresh");
        when(claims.getSubject()).thenReturn(userId.toString());
        when(jwtService.parseClaims("valid-refresh")).thenReturn(claims);
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(jwtService.generateToken(anyString(), any(), any())).thenReturn("new-token");

        AuthResponse result = authService.refresh(new RefreshRequest("valid-refresh"));

        assertThat(result.accessToken()).isEqualTo("new-token");
    }

    @Test
    void refresh_whenAccessTokenUsedInstead_throwsUnauthorizedException() {
        AuthService authService = newService();
        Claims claims = mock(Claims.class);
        when(claims.get("type", String.class)).thenReturn("access");
        when(jwtService.parseClaims("access-token")).thenReturn(claims);

        assertThatThrownBy(() -> authService.refresh(new RefreshRequest("access-token")))
                .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void refresh_whenTokenExpired_throwsUnauthorizedException() {
        AuthService authService = newService();
        when(jwtService.parseClaims("expired")).thenThrow(mock(ExpiredJwtException.class));

        assertThatThrownBy(() -> authService.refresh(new RefreshRequest("expired")))
                .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void getProfile_whenFound_returnsProfile() {
        AuthService authService = newService();
        User user = new User("a@b.com", "hashed", UserRole.ADMIN);
        UUID userId = UUID.randomUUID();
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));

        ProfileResponse result = authService.getProfile(userId);

        assertThat(result.email()).isEqualTo("a@b.com");
        assertThat(result.role()).isEqualTo(UserRole.ADMIN);
    }

    @Test
    void getProfile_whenNotFound_throwsResourceNotFoundException() {
        AuthService authService = newService();
        UUID userId = UUID.randomUUID();
        when(userRepository.findById(userId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> authService.getProfile(userId))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getUserSummary_whenFound_returnsIdAndEmail() {
        AuthService authService = newService();
        User user = userWithId("a@b.com", "hashed", UserRole.CUSTOMER);
        when(userRepository.findById(user.getId())).thenReturn(Optional.of(user));

        var result = authService.getUserSummary(user.getId());

        assertThat(result.id()).isEqualTo(user.getId());
        assertThat(result.email()).isEqualTo("a@b.com");
    }

    @Test
    void getUserSummary_whenNotFound_throwsResourceNotFoundException() {
        AuthService authService = newService();
        UUID userId = UUID.randomUUID();
        when(userRepository.findById(userId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> authService.getUserSummary(userId))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    /**
     * User.id is @GeneratedValue, only populated by JPA at persist time — a
     * plain `new User(...)` in a unit test leaves it null. AuthService needs
     * a real id to mint a JWT subject, so tests that issue tokens use this
     * instead of the constructor directly.
     */
    private static User userWithId(String email, String passwordHash, UserRole role) {
        User user = new User(email, passwordHash, role);
        ReflectionTestUtils.setField(user, "id", UUID.randomUUID());
        return user;
    }
}
