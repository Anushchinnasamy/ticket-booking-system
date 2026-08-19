package com.ticketbooking.apigateway.config;

import com.ticketbooking.common.security.JwtService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.ratelimit.KeyResolver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import reactor.core.publisher.Mono;

@Configuration
public class RateLimiterConfig {

    @Bean
    public JwtService jwtService(@Value("${jwt.secret}") String secret) {
        return new JwtService(secret);
    }

    /**
     * Resolves the rate-limit bucket key to the authenticated user's id
     * (JWT subject) — this is what makes the limit "per user" instead of
     * per IP, so one legitimate customer's normal traffic never eats into
     * another's budget. Parsing here is advisory only: an invalid or
     * missing token falls back to an IP-based key rather than rejecting the
     * request outright — downstream services remain the real authority on
     * auth, this bean only needs *a* stable identity to bucket on.
     */
    @Bean
    public KeyResolver userKeyResolver(JwtService jwtService) {
        return exchange -> {
            String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
            if (authHeader != null && authHeader.regionMatches(true, 0, "Bearer ", 0, 7)) {
                String token = authHeader.substring(7);
                try {
                    Claims claims = jwtService.parseClaims(token);
                    return Mono.just("user:" + claims.getSubject());
                } catch (JwtException | IllegalArgumentException ex) {
                    // fall through to IP-based key below
                }
            }
            String ip = exchange.getRequest().getRemoteAddress() != null
                    ? exchange.getRequest().getRemoteAddress().getAddress().getHostAddress()
                    : "unknown";
            return Mono.just("anon:" + ip);
        };
    }
}
