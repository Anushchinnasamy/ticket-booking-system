package com.ticketbooking.event.config;

import io.github.resilience4j.core.IntervalFunction;
import io.github.resilience4j.retry.Retry;
import io.github.resilience4j.retry.RetryConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;

@Configuration
public class KafkaResilienceConfig {

    private static final Logger log = LoggerFactory.getLogger(KafkaResilienceConfig.class);

    @Bean(destroyMethod = "shutdown")
    public ScheduledExecutorService kafkaRetryScheduler() {
        return Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "kafka-publish-retry");
            t.setDaemon(true);
            return t;
        });
    }

    /**
     * Retries a transient Kafka publish failure up to 3 times with
     * exponential backoff (200ms, 400ms, 800ms) before giving up — never
     * blocks the caller, the delay is scheduled on kafkaRetryScheduler.
     */
    @Bean
    public Retry kafkaPublishRetry() {
        RetryConfig config = RetryConfig.custom()
                .maxAttempts(3)
                .intervalFunction(IntervalFunction.ofExponentialBackoff(Duration.ofMillis(200), 2.0))
                .retryExceptions(Exception.class)
                .build();
        Retry retry = Retry.of("kafka-publish", config);
        retry.getEventPublisher().onRetry(event ->
                log.warn("Retrying Kafka publish (attempt {}): {}", event.getNumberOfRetryAttempts(),
                        event.getLastThrowable().getMessage()));
        return retry;
    }
}
