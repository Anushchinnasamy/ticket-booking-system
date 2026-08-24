package com.ticketbooking.user.cache;

import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-process replacement for the earlier Redis-backed OTP / rate-limit /
 * password-reset-rate-limit store — correct as long as user-service runs as
 * a single instance, which is the only way it's deployed (no horizontal
 * scaling on the free-tier Render plan this project targets). Mirrors the
 * handful of Redis string operations {@code OtpService}/{@code
 * PasswordResetService} relied on (SET+TTL, GET, DEL, INCR+TTL).
 */
@Component
public class InMemoryExpiringStore {

    private record Entry(String value, Instant expiresAt) {
        boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }

    private final Map<String, Entry> entries = new ConcurrentHashMap<>();

    public String get(String key) {
        Entry e = entries.get(key);
        if (e == null || e.isExpired()) {
            if (e != null) {
                entries.remove(key, e);
            }
            return null;
        }
        return e.value();
    }

    public void set(String key, String value, Duration ttl) {
        entries.put(key, new Entry(value, Instant.now().plus(ttl)));
    }

    public void delete(String key) {
        entries.remove(key);
    }

    public void expire(String key, Duration ttl) {
        entries.computeIfPresent(key, (k, e) -> new Entry(e.value(), Instant.now().plus(ttl)));
    }

    /**
     * Atomically increments the integer stored at key, creating it at 1 if
     * absent or expired — mirrors Redis INCR. The entry starts with a
     * 1-day safety-net TTL; callers needing a shorter window call
     * {@link #expire} right after the first increment, same as they did
     * against StringRedisTemplate.
     */
    public long increment(String key) {
        Entry updated = entries.compute(key, (k, e) -> {
            long current = (e == null || e.isExpired()) ? 0 : Long.parseLong(e.value());
            Instant expiresAt = (e != null && !e.isExpired()) ? e.expiresAt() : Instant.now().plus(Duration.ofDays(1));
            return new Entry(String.valueOf(current + 1), expiresAt);
        });
        return Long.parseLong(updated.value());
    }
}
