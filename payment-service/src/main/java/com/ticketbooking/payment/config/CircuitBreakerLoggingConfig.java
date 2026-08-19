package com.ticketbooking.payment.config;

import io.github.resilience4j.circuitbreaker.CircuitBreakerRegistry;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/** Logs circuit breaker state transitions — the evidence trail for the Phase 9 chaos test. */
@Component
public class CircuitBreakerLoggingConfig {

    private static final Logger log = LoggerFactory.getLogger(CircuitBreakerLoggingConfig.class);

    private final CircuitBreakerRegistry registry;

    public CircuitBreakerLoggingConfig(CircuitBreakerRegistry registry) {
        this.registry = registry;
    }

    @PostConstruct
    void logStateTransitions() {
        registry.circuitBreaker("booking-service").getEventPublisher()
                .onStateTransition(event -> log.warn("Circuit breaker [{}] {} -> {}",
                        event.getCircuitBreakerName(),
                        event.getStateTransition().getFromState(),
                        event.getStateTransition().getToState()));
    }
}
