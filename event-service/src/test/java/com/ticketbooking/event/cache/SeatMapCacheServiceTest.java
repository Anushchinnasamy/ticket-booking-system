package com.ticketbooking.event.cache;

import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ticketbooking.event.domain.SeatStatus;
import com.ticketbooking.event.domain.SeatType;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import com.ticketbooking.event.web.dto.SeatResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.StringRedisTemplate;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SeatMapCacheServiceTest {

    @Mock
    private StringRedisTemplate redisTemplate;

    @Mock
    private HashOperations<String, Object, Object> hashOperations;

    private ObjectMapper objectMapper;
    private SeatMapCacheService cacheService;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper()
                .registerModule(new JavaTimeModule())
                .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        when(redisTemplate.opsForHash()).thenReturn(hashOperations);
        cacheService = new SeatMapCacheService(redisTemplate, objectMapper, 45);
    }

    private static SeatResponse sampleSeat(UUID id) {
        return new SeatResponse(id, "A", 12, SeatType.PREMIUM, new BigDecimal("500.00"), SeatStatus.AVAILABLE);
    }

    @Test
    void get_whenNotCached_returnsEmpty() {
        UUID showId = UUID.randomUUID();
        when(hashOperations.entries("seatmap:" + showId)).thenReturn(Map.of());

        Optional<SeatMapResponse> result = cacheService.get(showId);

        assertThat(result).isEmpty();
    }

    @Test
    void put_thenGet_roundTripsTheFullSeatMap() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        SeatResponse seat = sampleSeat(seatId);
        SeatMapResponse response = new SeatMapResponse(showId, "Test Concert", "Test Arena",
                Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("450.00"), java.util.List.of(seat));

        seedCacheViaPut(showId, response);

        Optional<SeatMapResponse> result = cacheService.get(showId);

        assertThat(result).isPresent();
        assertThat(result.get().eventTitle()).isEqualTo("Test Concert");
        assertThat(result.get().venueName()).isEqualTo("Test Arena");
        assertThat(result.get().seats()).hasSize(1);
        assertThat(result.get().seats().get(0).id()).isEqualTo(seatId);
        assertThat(result.get().seats().get(0).status()).isEqualTo(SeatStatus.AVAILABLE);
    }

    @Test
    void get_refreshesTtlOnHit() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        SeatMapResponse response = new SeatMapResponse(showId, "T", "V", Instant.now(),
                new BigDecimal("1.00"), java.util.List.of(sampleSeat(seatId)));
        seedCacheViaPut(showId, response);

        cacheService.get(showId);

        // Once from put(), once from get() — both refresh the TTL.
        verify(redisTemplate, org.mockito.Mockito.times(2)).expire("seatmap:" + showId, Duration.ofSeconds(45));
    }

    /** Calls the real put() and wires its captured output back out as what entries() would return. */
    private void seedCacheViaPut(UUID showId, SeatMapResponse response) {
        cacheService.put(showId, response);
        org.mockito.ArgumentCaptor<Map> captor = org.mockito.ArgumentCaptor.forClass(Map.class);
        verify(hashOperations).putAll(eq("seatmap:" + showId), captor.capture());
        Map<Object, Object> stored = new LinkedHashMap<>(captor.getValue());
        when(hashOperations.entries("seatmap:" + showId)).thenReturn(stored);
    }

    @Test
    void updateSeat_whenShowIsCached_patchesOnlyThatSeatField() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        when(hashOperations.hasKey("seatmap:" + showId, "__meta__")).thenReturn(true);

        cacheService.updateSeat(showId, sampleSeat(seatId));

        verify(hashOperations).put(eq("seatmap:" + showId), eq(seatId.toString()), any());
        verify(redisTemplate).expire("seatmap:" + showId, Duration.ofSeconds(45));
    }

    @Test
    void updateSeat_whenShowIsNotCached_isANoOp() {
        UUID showId = UUID.randomUUID();
        when(hashOperations.hasKey("seatmap:" + showId, "__meta__")).thenReturn(false);

        cacheService.updateSeat(showId, sampleSeat(UUID.randomUUID()));

        verify(hashOperations, never()).put(any(), any(), any());
        verify(redisTemplate, never()).expire(any(), any(Duration.class));
    }
}
