package com.ticketbooking.common.logging;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.MDC;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.UUID;

/**
 * Reads the {@code X-Correlation-Id} header set by api-gateway (see its own
 * CorrelationIdFilter), or generates one if the request arrived without it
 * (e.g. a direct service-to-service call that bypasses the gateway), and
 * puts it in MDC so every log line for this request — across every
 * service it touches — carries the same id. Cleared in a finally block so
 * it never leaks onto a pooled request-handling thread's next request.
 */
public class CorrelationIdFilter extends OncePerRequestFilter {

    public static final String HEADER = "X-Correlation-Id";
    public static final String MDC_KEY = "correlationId";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String correlationId = request.getHeader(HEADER);
        if (correlationId == null || correlationId.isBlank()) {
            correlationId = UUID.randomUUID().toString();
        }
        MDC.put(MDC_KEY, correlationId);
        response.setHeader(HEADER, correlationId);
        try {
            chain.doFilter(request, response);
        } finally {
            MDC.remove(MDC_KEY);
        }
    }

    /** Same gotcha documented elsewhere in this codebase: without this, the /error re-dispatch loses the id. */
    @Override
    protected boolean shouldNotFilterErrorDispatch() {
        return false;
    }
}
