package com.ticketbooking.event.cache;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import com.ticketbooking.event.web.dto.SeatResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Comparator;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Cache-aside layer for {@code GET /shows/{id}/seats}, backed by one Redis
 * Hash per show: {@code seatmap:{showId}}, field {@code __meta__} holding
 * show-level data, one field per seat keyed by seatId holding that seat's
 * full response fields.
 *
 * <p>The hash shape (not a single JSON blob) is what makes per-seat
 * invalidation possible: {@link #updateSeat} does a single atomic HSET on
 * exactly one field, never touching the other seats or forcing a whole-show
 * cache-storm on every lock/claim/release during a flash sale.
 */
@Service
public class SeatMapCacheService {

    private static final Logger log = LoggerFactory.getLogger(SeatMapCacheService.class);
    private static final String META_FIELD = "__meta__";
    private static final String KEY_PREFIX = "seatmap:";

    private record CachedMeta(String eventTitle, String venueName, java.time.Instant startTime,
                               java.math.BigDecimal basePrice) {
    }

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;
    private final Duration ttl;

    private final AtomicLong hits = new AtomicLong();
    private final AtomicLong misses = new AtomicLong();

    public SeatMapCacheService(StringRedisTemplate redisTemplate, ObjectMapper objectMapper,
                                @Value("${seatmap.cache.ttl-seconds}") long ttlSeconds) {
        this.redisTemplate = redisTemplate;
        this.objectMapper = objectMapper;
        this.ttl = Duration.ofSeconds(ttlSeconds);
    }

    /** Empty on a cache miss (absent or TTL-expired) — caller falls back to the database. */
    public Optional<SeatMapResponse> get(UUID showId) {
        String key = key(showId);
        Map<Object, Object> raw = redisTemplate.opsForHash().entries(key);
        Object metaJson = raw.get(META_FIELD);
        if (metaJson == null) {
            misses.incrementAndGet();
            log.debug("Seat map cache MISS for show {} (hit rate so far: {})", showId, hitRateSummary());
            return Optional.empty();
        }

        try {
            CachedMeta meta = objectMapper.readValue((String) metaJson, CachedMeta.class);
            var seats = raw.entrySet().stream()
                    .filter(e -> !META_FIELD.equals(e.getKey()))
                    .map(e -> readSeat((String) e.getValue()))
                    .sorted(Comparator.comparing(SeatResponse::rowLabel).thenComparing(SeatResponse::seatNumber))
                    .toList();

            redisTemplate.expire(key, ttl);
            hits.incrementAndGet();
            log.debug("Seat map cache HIT for show {} (hit rate so far: {})", showId, hitRateSummary());
            return Optional.of(new SeatMapResponse(showId, meta.eventTitle(), meta.venueName(),
                    meta.startTime(), meta.basePrice(), seats));
        } catch (JsonProcessingException ex) {
            log.warn("Corrupted seat map cache entry for show {}, treating as a miss", showId);
            misses.incrementAndGet();
            return Optional.empty();
        }
    }

    /** Writes the full seat map through to the cache after a DB-backed read (cache-aside write-through on miss). */
    public void put(UUID showId, SeatMapResponse response) {
        String key = key(showId);
        try {
            Map<String, String> fields = new java.util.HashMap<>();
            fields.put(META_FIELD, objectMapper.writeValueAsString(
                    new CachedMeta(response.eventTitle(), response.venueName(), response.startTime(), response.basePrice())));
            for (SeatResponse seat : response.seats()) {
                fields.put(seat.id().toString(), objectMapper.writeValueAsString(seat));
            }
            redisTemplate.opsForHash().putAll(key, fields);
            redisTemplate.expire(key, ttl);
        } catch (JsonProcessingException ex) {
            log.warn("Failed to write seat map cache entry for show {}", showId, ex);
        }
    }

    /**
     * Patches exactly one seat's field via a single atomic HSET — no
     * read-modify-write race with concurrent updates to other seats in the
     * same show. A no-op if the show isn't currently cached: writing a
     * lone field into an absent hash would create a partial entry (missing
     * __meta__ and every other seat) that a later HGETALL would
     * misinterpret as a valid, fully-populated cache hit.
     */
    public void updateSeat(UUID showId, SeatResponse seat) {
        String key = key(showId);
        Boolean cached = redisTemplate.opsForHash().hasKey(key, META_FIELD);
        if (!Boolean.TRUE.equals(cached)) {
            return;
        }
        try {
            redisTemplate.opsForHash().put(key, seat.id().toString(), objectMapper.writeValueAsString(seat));
            redisTemplate.expire(key, ttl);
        } catch (JsonProcessingException ex) {
            log.warn("Failed to patch seat {} in cache for show {}", seat.id(), showId, ex);
        }
    }

    public String hitRateSummary() {
        long h = hits.get();
        long m = misses.get();
        long total = h + m;
        double rate = total == 0 ? 0.0 : (100.0 * h / total);
        return "%d/%d hits (%.1f%%)".formatted(h, total, rate);
    }

    private SeatResponse readSeat(String json) {
        try {
            return objectMapper.readValue(json, SeatResponse.class);
        } catch (JsonProcessingException ex) {
            throw new IllegalStateException("Corrupted cached seat entry", ex);
        }
    }

    private String key(UUID showId) {
        return KEY_PREFIX + showId;
    }
}
