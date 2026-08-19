package com.ticketbooking.apigateway.config;

import com.ticketbooking.common.security.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.cloud.gateway.filter.ratelimit.KeyResolver;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;

import java.time.Duration;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class RateLimiterConfigTest {

    private final JwtService jwtService = new JwtService("test-jwt-secret-at-least-32-bytes-long");
    private final KeyResolver resolver = new RateLimiterConfig().userKeyResolver(jwtService);

    @Test
    void resolve_whenValidBearerToken_returnsUserPrefixedSubject() {
        String token = jwtService.generateToken("user-123", Map.of(), Duration.ofMinutes(5));
        MockServerWebExchange exchange = MockServerWebExchange.from(
                MockServerHttpRequest.get("/bookings").header("Authorization", "Bearer " + token));

        String key = resolver.resolve(exchange).block();

        assertThat(key).isEqualTo("user:user-123");
    }

    @Test
    void resolve_whenNoAuthorizationHeader_fallsBackToAnonIpKey() {
        MockServerWebExchange exchange = MockServerWebExchange.from(MockServerHttpRequest.get("/bookings"));

        String key = resolver.resolve(exchange).block();

        assertThat(key).startsWith("anon:");
    }

    @Test
    void resolve_whenTokenMalformed_fallsBackToAnonIpKey() {
        MockServerWebExchange exchange = MockServerWebExchange.from(
                MockServerHttpRequest.get("/bookings").header("Authorization", "Bearer not-a-real-jwt"));

        String key = resolver.resolve(exchange).block();

        assertThat(key).startsWith("anon:");
    }

    @Test
    void resolve_whenTokenSignedWithDifferentSecret_fallsBackToAnonIpKey() {
        JwtService otherSigner = new JwtService("a-completely-different-32-byte-secret");
        String token = otherSigner.generateToken("user-999", Map.of(), Duration.ofMinutes(5));
        MockServerWebExchange exchange = MockServerWebExchange.from(
                MockServerHttpRequest.get("/bookings").header("Authorization", "Bearer " + token));

        String key = resolver.resolve(exchange).block();

        assertThat(key).startsWith("anon:");
    }
}
