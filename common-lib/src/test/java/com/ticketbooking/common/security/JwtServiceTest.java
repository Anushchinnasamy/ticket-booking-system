package com.ticketbooking.common.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.security.SignatureException;
import org.junit.jupiter.api.Test;

import java.time.Duration;
import java.util.Map;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class JwtServiceTest {

    private final JwtService jwtService = new JwtService("test-secret-at-least-32-bytes-long-for-hs256");

    @Test
    void generateAndParse_roundTripsSubjectAndClaims() {
        String userId = UUID.randomUUID().toString();

        String token = jwtService.generateToken(userId, Map.of("role", "CUSTOMER", "email", "a@b.com"), Duration.ofMinutes(15));
        Claims claims = jwtService.parseClaims(token);

        assertThat(claims.getSubject()).isEqualTo(userId);
        assertThat(claims.get("role", String.class)).isEqualTo("CUSTOMER");
        assertThat(claims.get("email", String.class)).isEqualTo("a@b.com");
        assertThat(claims.getExpiration()).isAfter(claims.getIssuedAt());
    }

    @Test
    void parseClaims_whenExpired_throwsExpiredJwtException() {
        String token = jwtService.generateToken(UUID.randomUUID().toString(), Map.of(), Duration.ofMillis(1));

        await10Ms();

        assertThatThrownBy(() -> jwtService.parseClaims(token))
                .isInstanceOf(ExpiredJwtException.class);
    }

    @Test
    void parseClaims_whenSignedWithDifferentSecret_throwsSignatureException() {
        // Same byte length as the primary test secret (44 bytes / 352 bits) so
        // both land in jjwt's HS256 key-size bucket — a mismatched length would
        // make jjwt pick a different HMAC algorithm (HS384/HS512) and fail with
        // WeakKeyException instead of the SignatureException this test wants.
        JwtService otherService = new JwtService("a-completely-different-secret-of-the-same-len");
        String token = otherService.generateToken(UUID.randomUUID().toString(), Map.of(), Duration.ofMinutes(15));

        assertThatThrownBy(() -> jwtService.parseClaims(token))
                .isInstanceOf(SignatureException.class);
    }

    @Test
    void parseClaims_whenMalformed_throwsException() {
        assertThatThrownBy(() -> jwtService.parseClaims("not-a-valid-jwt"))
                .isInstanceOf(io.jsonwebtoken.JwtException.class);
    }

    private static void await10Ms() {
        try {
            Thread.sleep(10);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
