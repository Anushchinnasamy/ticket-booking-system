package com.ticketbooking.booking.lock;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * In-process replacement for the earlier Redis/Redisson-backed lock —
 * correct as long as booking-service runs as a single instance, which is
 * the only way it's deployed (no horizontal scaling on the free-tier Render
 * plan this project targets; see docs/adr/001-locking-strategy.md for the
 * original Postgres-vs-Redis tradeoff this superseded). The lock is held
 * for the full hold TTL, not just the duration of the request — it
 * represents the seat reservation itself (a PENDING booking), not a brief
 * mutex around one write. {@link #tryLock} is non-blocking: if the key is
 * already held and not yet expired, it fails immediately, matching the
 * "on failure return 409" flow, rather than queueing.
 */
@Component
public class SeatLockService {

    private record Held(long ownerThreadId, Instant expiresAt) {
        boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }

    private final Map<String, Held> locks = new ConcurrentHashMap<>();
    private final long holdTtlMinutes;
    private final Counter lockContentionCounter;

    public SeatLockService(@Value("${booking.hold-ttl-minutes}") long holdTtlMinutes,
                            MeterRegistry meterRegistry) {
        this.holdTtlMinutes = holdTtlMinutes;
        this.lockContentionCounter = Counter.builder("seat_lock_contention")
                .description("Number of tryLock calls that failed because another holder already had the seat locked")
                .register(meterRegistry);
    }

    /** False means someone else already holds this seat's lock — real contention, not an error. */
    public boolean tryLock(UUID showId, UUID seatId) {
        String key = lockKey(showId, seatId);
        long threadId = Thread.currentThread().getId();
        Instant expiresAt = Instant.now().plusSeconds(holdTtlMinutes * 60);
        AtomicBoolean acquired = new AtomicBoolean(false);

        locks.compute(key, (k, existing) -> {
            if (existing != null && !existing.isExpired()) {
                return existing;
            }
            acquired.set(true);
            return new Held(threadId, expiresAt);
        });

        if (!acquired.get()) {
            lockContentionCounter.increment();
        }
        return acquired.get();
    }

    public void unlock(UUID showId, UUID seatId) {
        String key = lockKey(showId, seatId);
        long threadId = Thread.currentThread().getId();
        locks.computeIfPresent(key, (k, held) -> held.ownerThreadId() == threadId ? null : held);
    }

    /**
     * Releases the lock regardless of which thread/process acquired it —
     * used by the stale-booking sweep, which runs on a scheduler thread that
     * never held the lock itself.
     */
    public void forceUnlock(UUID showId, UUID seatId) {
        locks.remove(lockKey(showId, seatId));
    }

    private String lockKey(UUID showId, UUID seatId) {
        return "seat:%s:%s".formatted(showId, seatId);
    }
}
