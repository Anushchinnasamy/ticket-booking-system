package com.ticketbooking.event.cache;

import com.ticketbooking.event.web.dto.SeatMapResponse;
import com.ticketbooking.event.web.dto.SeatResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * In-process replacement for the earlier Redis-backed cache-aside layer for
 * {@code GET /shows/{id}/seats} — correct (and sufficient) as long as
 * event-service runs as a single instance, which is the only way it's
 * deployed (no horizontal scaling on the free-tier Render plan this project
 * targets). One entry per show; {@link #updateSeat} patches just that
 * seat's map entry rather than the whole cached response, preserving the
 * earlier no-cache-storm-on-every-lock behavior without needing Redis's
 * per-field hash atomicity — a single JVM's ConcurrentHashMap already gives
 * that.
 */
@Service
public class SeatMapCacheService {

    private static final Logger log = LoggerFactory.getLogger(SeatMapCacheService.class);

    private record CachedShow(String eventTitle, String venueName, Instant startTime,
                               java.math.BigDecimal basePrice,
                               Map<UUID, SeatResponse> seats, Instant expiresAt) {
        boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }

    private final Map<UUID, CachedShow> cache = new ConcurrentHashMap<>();
    private final Duration ttl;

    private final AtomicLong hits = new AtomicLong();
    private final AtomicLong misses = new AtomicLong();

    public SeatMapCacheService(@Value("${seatmap.cache.ttl-seconds}") long ttlSeconds) {
        this.ttl = Duration.ofSeconds(ttlSeconds);
    }

    /** Empty on a cache miss (absent or TTL-expired) — caller falls back to the database. */
    public Optional<SeatMapResponse> get(UUID showId) {
        CachedShow cached = cache.get(showId);
        if (cached == null || cached.isExpired()) {
            if (cached != null) {
                cache.remove(showId, cached);
            }
            misses.incrementAndGet();
            log.debug("Seat map cache MISS for show {} (hit rate so far: {})", showId, hitRateSummary());
            return Optional.empty();
        }

        cache.computeIfPresent(showId, (id, c) -> c.isExpired() ? c
                : new CachedShow(c.eventTitle(), c.venueName(), c.startTime(), c.basePrice(), c.seats(), Instant.now().plus(ttl)));
        hits.incrementAndGet();
        log.debug("Seat map cache HIT for show {} (hit rate so far: {})", showId, hitRateSummary());

        List<SeatResponse> seats = cached.seats().values().stream()
                .sorted(Comparator.comparing(SeatResponse::rowLabel).thenComparing(SeatResponse::seatNumber))
                .toList();
        return Optional.of(new SeatMapResponse(showId, cached.eventTitle(), cached.venueName(),
                cached.startTime(), cached.basePrice(), seats));
    }

    /** Writes the full seat map through to the cache after a DB-backed read (cache-aside write-through on miss). */
    public void put(UUID showId, SeatMapResponse response) {
        Map<UUID, SeatResponse> seats = new ConcurrentHashMap<>();
        for (SeatResponse seat : response.seats()) {
            seats.put(seat.id(), seat);
        }
        cache.put(showId, new CachedShow(response.eventTitle(), response.venueName(), response.startTime(),
                response.basePrice(), seats, Instant.now().plus(ttl)));
    }

    /**
     * Patches exactly one seat — a no-op if the show isn't currently cached
     * (or has expired), matching the earlier Redis version's behavior:
     * writing a lone seat into an absent entry would create a partial cache
     * entry that a later read would misinterpret as fully populated.
     */
    public void updateSeat(UUID showId, SeatResponse seat) {
        cache.computeIfPresent(showId, (id, c) -> {
            if (c.isExpired()) {
                return c;
            }
            c.seats().put(seat.id(), seat);
            return new CachedShow(c.eventTitle(), c.venueName(), c.startTime(), c.basePrice(), c.seats(), Instant.now().plus(ttl));
        });
    }

    public String hitRateSummary() {
        long h = hits.get();
        long m = misses.get();
        long total = h + m;
        double rate = total == 0 ? 0.0 : (100.0 * h / total);
        return "%d/%d hits (%.1f%%)".formatted(h, total, rate);
    }
}
