package com.ticketbooking.common.resilience;

import io.github.resilience4j.retry.Retry;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionStage;
import java.util.concurrent.ScheduledExecutorService;
import java.util.function.Supplier;

/**
 * Kafka-agnostic retry-with-backoff wrapper for any operation that returns
 * a {@link CompletableFuture} — built for {@code KafkaTemplate.send(...)},
 * but not specific to it, so common-lib doesn't need a spring-kafka
 * dependency just to offer this. Retry delays are scheduled on the given
 * executor, never by blocking the caller's thread — the caller gets its
 * future back immediately, same as the underlying fire-and-forget publish.
 */
public final class RetryingPublisher {

    private RetryingPublisher() {
    }

    public static <T> CompletableFuture<T> withRetry(Supplier<CompletableFuture<T>> operation, Retry retry,
                                                       ScheduledExecutorService scheduler) {
        Supplier<CompletionStage<T>> decorated =
                Retry.decorateCompletionStage(retry, scheduler, operation::get);
        return decorated.get().toCompletableFuture();
    }
}
