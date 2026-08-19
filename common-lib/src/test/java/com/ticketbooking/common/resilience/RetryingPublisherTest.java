package com.ticketbooking.common.resilience;

import io.github.resilience4j.core.IntervalFunction;
import io.github.resilience4j.retry.Retry;
import io.github.resilience4j.retry.RetryConfig;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.time.Duration;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertTimeoutPreemptively;

class RetryingPublisherTest {

    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

    @AfterEach
    void tearDown() {
        scheduler.shutdown();
    }

    private Retry retryWithBackoff(int maxAttempts) {
        RetryConfig config = RetryConfig.custom()
                .maxAttempts(maxAttempts)
                .intervalFunction(IntervalFunction.ofExponentialBackoff(Duration.ofMillis(10), 2.0))
                .retryExceptions(RuntimeException.class)
                .build();
        return Retry.of("test", config);
    }

    @Test
    void withRetry_whenOperationFailsThenSucceeds_retriesAndEventuallyCompletes() {
        AtomicInteger attempts = new AtomicInteger();
        Retry retry = retryWithBackoff(3);

        CompletableFuture<String> result = RetryingPublisher.withRetry(() -> {
            if (attempts.incrementAndGet() < 3) {
                CompletableFuture<String> failed = new CompletableFuture<>();
                failed.completeExceptionally(new RuntimeException("transient failure"));
                return failed;
            }
            return CompletableFuture.completedFuture("success");
        }, retry, scheduler);

        assertTimeoutPreemptively(Duration.ofSeconds(2), () -> {
            assertThat(result.get()).isEqualTo("success");
        });
        assertThat(attempts.get()).isEqualTo(3);
    }

    @Test
    void withRetry_whenAlwaysFails_exhaustsAttemptsAndCompletesExceptionally() {
        AtomicInteger attempts = new AtomicInteger();
        Retry retry = retryWithBackoff(3);

        CompletableFuture<String> result = RetryingPublisher.withRetry(() -> {
            attempts.incrementAndGet();
            CompletableFuture<String> failed = new CompletableFuture<>();
            failed.completeExceptionally(new RuntimeException("permanent failure"));
            return failed;
        }, retry, scheduler);

        assertTimeoutPreemptively(Duration.ofSeconds(2), () ->
                assertThatThrownBy(result::get).hasMessageContaining("permanent failure"));
        assertThat(attempts.get()).isEqualTo(3);
    }

    @Test
    void withRetry_whenOperationSucceedsImmediately_doesNotRetry() {
        AtomicInteger attempts = new AtomicInteger();
        Retry retry = retryWithBackoff(3);

        CompletableFuture<String> result = RetryingPublisher.withRetry(() -> {
            attempts.incrementAndGet();
            return CompletableFuture.completedFuture("ok");
        }, retry, scheduler);

        assertTimeoutPreemptively(Duration.ofSeconds(1), () -> assertThat(result.get()).isEqualTo("ok"));
        assertThat(attempts.get()).isEqualTo(1);
    }

    @Test
    void withRetry_doesNotBlockTheCallingThread() {
        Retry retry = retryWithBackoff(3);
        CompletableFuture<String> neverCompletes = new CompletableFuture<>();

        assertTimeoutPreemptively(Duration.ofMillis(200), () ->
                RetryingPublisher.withRetry(() -> neverCompletes, retry, scheduler));
    }
}
