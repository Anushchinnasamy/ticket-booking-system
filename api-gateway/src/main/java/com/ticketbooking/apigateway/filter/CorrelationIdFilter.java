package com.ticketbooking.apigateway.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.UUID;

/**
 * Generates a correlation id for any request that doesn't already carry
 * one, forwards it to the downstream service as a request header, and
 * echoes it back to the caller in the response — the single thread that
 * ties one request's logs together across every service it touches.
 * Downstream services don't yet read this header into their own log
 * context (that's Phase 11's job); for now the gateway is the one place
 * this id is actually logged.
 */
@Component
public class CorrelationIdFilter implements GlobalFilter, Ordered {

    public static final String HEADER = "X-Correlation-Id";

    private static final Logger log = LoggerFactory.getLogger(CorrelationIdFilter.class);

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String correlationId = exchange.getRequest().getHeaders().getFirst(HEADER);
        if (correlationId == null || correlationId.isBlank()) {
            correlationId = UUID.randomUUID().toString();
        }
        String finalCorrelationId = correlationId;

        ServerHttpRequest mutatedRequest = exchange.getRequest().mutate()
                .header(HEADER, finalCorrelationId)
                .build();
        ServerWebExchange mutatedExchange = exchange.mutate().request(mutatedRequest).build();
        mutatedExchange.getResponse().getHeaders().add(HEADER, finalCorrelationId);

        long start = System.currentTimeMillis();
        return chain.filter(mutatedExchange).then(Mono.fromRunnable(() -> {
            long durationMs = System.currentTimeMillis() - start;
            log.info("[{}] {} {} -> {} ({} ms)",
                    finalCorrelationId,
                    mutatedExchange.getRequest().getMethod(),
                    mutatedExchange.getRequest().getURI().getPath(),
                    mutatedExchange.getResponse().getStatusCode(),
                    durationMs);
        }));
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE;
    }
}
