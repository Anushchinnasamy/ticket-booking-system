package com.ticketbooking.common.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;

import java.io.IOException;
import java.time.Instant;

/**
 * Returns a genuine 401 for missing/invalid credentials. Without this,
 * Spring Security's default behavior for a request rejected by
 * {@code .anyRequest().authenticated()} is 403 — an anonymous principal is
 * treated as "authenticated but lacking authority," not "unauthenticated."
 * That doesn't match how a stateless JWT API should behave: 401 means
 * "you're not logged in," 403 means "you're logged in but not allowed."
 */
public class RestAuthenticationEntryPoint implements AuthenticationEntryPoint {

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException)
            throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.getWriter().write("""
                {"errorCode":"UNAUTHORIZED","message":"Authentication required","timestamp":"%s"}""".formatted(Instant.now()));
    }
}
