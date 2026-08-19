package com.ticketbooking.common.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import java.io.IOException;
import java.time.Instant;

/** Sibling to {@link RestAuthenticationEntryPoint} — same JSON error shape used everywhere else, for a 403 instead of a 401. */
public class RestAccessDeniedHandler implements AccessDeniedHandler {

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException)
            throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("application/json");
        response.getWriter().write("""
                {"errorCode":"FORBIDDEN","message":"You do not have permission to perform this action","timestamp":"%s"}""".formatted(Instant.now()));
    }
}
