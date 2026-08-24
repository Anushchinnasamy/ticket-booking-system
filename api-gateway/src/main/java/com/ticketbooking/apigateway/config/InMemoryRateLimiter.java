package com.ticketbooking.apigateway.config;

import org.springframework.cloud.gateway.filter.ratelimit.RateLimiter;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-process token-bucket replacement for Spring Cloud Gateway's built-in
 * RedisRateLimiter — correct as long as api-gateway runs as a single
 * instance, which is the only way it's deployed (no horizontal scaling on
 * the free-tier Render plan this project targets). One bucket per
 * routeId+key, refilled continuously at replenishRate tokens/second up to
 * burstCapacity — same shape as the token-bucket the Redis Lua script it
 * replaces implemented, just without Redis.
 *
 * <p>The "in-memory-rate-limiter.*" shortcut prefix used in application.yml
 * route filter args is Spring Cloud Gateway's shortcut-binding convention:
 * it kebab-cases this class's simple name to derive the prefix, the same
 * way "redis-rate-limiter.*" was derived from RedisRateLimiter.
 */
@Component
public class InMemoryRateLimiter implements RateLimiter<InMemoryRateLimiter.Config> {

    public static class Config {
        private int replenishRate;
        private int burstCapacity = 1;
        private int requestedTokens = 1;

        public int getReplenishRate() {
            return replenishRate;
        }

        public void setReplenishRate(int replenishRate) {
            this.replenishRate = replenishRate;
        }

        public int getBurstCapacity() {
            return burstCapacity;
        }

        public void setBurstCapacity(int burstCapacity) {
            this.burstCapacity = burstCapacity;
        }

        public int getRequestedTokens() {
            return requestedTokens;
        }

        public void setRequestedTokens(int requestedTokens) {
            this.requestedTokens = requestedTokens;
        }
    }

    private record Bucket(double tokens, Instant lastRefill) {
    }

    private final Map<String, Config> routeConfigs = new ConcurrentHashMap<>();
    private final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    @Override
    public Mono<Response> isAllowed(String routeId, String id) {
        Config config = routeConfigs.getOrDefault(routeId, new Config());
        if (config.getReplenishRate() <= 0) {
            return Mono.just(new Response(true, Map.of()));
        }
        String bucketKey = routeId + ":" + id;

        boolean[] allowedHolder = new boolean[1];
        long[] remainingHolder = new long[1];

        buckets.compute(bucketKey, (k, existing) -> {
            Instant now = Instant.now();
            double tokens = config.getBurstCapacity();
            if (existing != null) {
                double elapsedSeconds = Duration.between(existing.lastRefill(), now).toMillis() / 1000.0;
                tokens = Math.min(config.getBurstCapacity(), existing.tokens() + elapsedSeconds * config.getReplenishRate());
            }
            boolean allowed = tokens >= config.getRequestedTokens();
            if (allowed) {
                tokens -= config.getRequestedTokens();
            }
            allowedHolder[0] = allowed;
            remainingHolder[0] = (long) tokens;
            return new Bucket(tokens, now);
        });

        Response response = new Response(allowedHolder[0], Map.of(
                "X-RateLimit-Remaining", String.valueOf(remainingHolder[0]),
                "X-RateLimit-Burst-Capacity", String.valueOf(config.getBurstCapacity()),
                "X-RateLimit-Replenish-Rate", String.valueOf(config.getReplenishRate())));
        return Mono.just(response);
    }

    @Override
    public Map<String, Config> getConfig() {
        return routeConfigs;
    }

    @Override
    public Class<Config> getConfigClass() {
        return Config.class;
    }

    @Override
    public Config newConfig() {
        return new Config();
    }
}
