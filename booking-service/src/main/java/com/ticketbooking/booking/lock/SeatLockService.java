package com.ticketbooking.booking.lock;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * Redis-backed replacement for the Phase 2 {@code SELECT ... FOR UPDATE}
 * baseline (see docs/adr/001-locking-strategy.md). The lock is held for the
 * full hold TTL, not just the duration of the request — it represents the
 * seat reservation itself (a PENDING booking), not a brief mutex around one
 * write. {@link #tryLock} is non-blocking (waitTime = 0): if the key is
 * already held, it fails immediately, matching the "on failure return 409"
 * flow, rather than queueing.
 */
@Component
public class SeatLockService {

    private final RedissonClient redissonClient;
    private final long holdTtlMinutes;
    private final Counter lockContentionCounter;

    public SeatLockService(RedissonClient redissonClient,
                            @Value("${booking.hold-ttl-minutes}") long holdTtlMinutes,
                            MeterRegistry meterRegistry) {
        this.redissonClient = redissonClient;
        this.holdTtlMinutes = holdTtlMinutes;
        this.lockContentionCounter = Counter.builder("seat_lock_contention")
                .description("Number of tryLock calls that failed because another holder already had the seat locked")
                .register(meterRegistry);
    }

    /** False means someone else already holds this seat's lock — real contention, not an error. */
    public boolean tryLock(UUID showId, UUID seatId) {
        RLock lock = redissonClient.getLock(lockKey(showId, seatId));
        boolean acquired;
        try {
            acquired = lock.tryLock(0, holdTtlMinutes, TimeUnit.MINUTES);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            acquired = false;
        }
        if (!acquired) {
            lockContentionCounter.increment();
        }
        return acquired;
    }

    public void unlock(UUID showId, UUID seatId) {
        RLock lock = redissonClient.getLock(lockKey(showId, seatId));
        if (lock.isHeldByCurrentThread()) {
            lock.unlock();
        }
    }

    /**
     * Releases the lock regardless of which thread/process acquired it —
     * used by the stale-booking sweep, which runs on a scheduler thread that
     * never held the lock itself.
     */
    public void forceUnlock(UUID showId, UUID seatId) {
        redissonClient.getLock(lockKey(showId, seatId)).forceUnlock();
    }

    private String lockKey(UUID showId, UUID seatId) {
        return "seat:%s:%s".formatted(showId, seatId);
    }
}
