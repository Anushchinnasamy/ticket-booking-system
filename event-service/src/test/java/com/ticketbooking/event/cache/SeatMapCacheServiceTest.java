package com.ticketbooking.event.cache;

import com.ticketbooking.event.domain.SeatStatus;
import com.ticketbooking.event.domain.SeatType;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import com.ticketbooking.event.web.dto.SeatResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

class SeatMapCacheServiceTest {

    private SeatMapCacheService cacheService;

    @BeforeEach
    void setUp() {
        cacheService = new SeatMapCacheService(45);
    }

    private static SeatResponse sampleSeat(UUID id) {
        return new SeatResponse(id, "A", 12, SeatType.PREMIUM, new BigDecimal("500.00"), SeatStatus.AVAILABLE, null);
    }

    @Test
    void get_whenNotCached_returnsEmpty() {
        Optional<SeatMapResponse> result = cacheService.get(UUID.randomUUID());

        assertThat(result).isEmpty();
    }

    @Test
    void put_thenGet_roundTripsTheFullSeatMap() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        SeatResponse seat = sampleSeat(seatId);
        SeatMapResponse response = new SeatMapResponse(showId, "Test Concert", "Test Arena",
                Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("450.00"), List.of(seat));

        cacheService.put(showId, response);
        Optional<SeatMapResponse> result = cacheService.get(showId);

        assertThat(result).isPresent();
        assertThat(result.get().eventTitle()).isEqualTo("Test Concert");
        assertThat(result.get().venueName()).isEqualTo("Test Arena");
        assertThat(result.get().seats()).hasSize(1);
        assertThat(result.get().seats().get(0).id()).isEqualTo(seatId);
        assertThat(result.get().seats().get(0).status()).isEqualTo(SeatStatus.AVAILABLE);
    }

    @Test
    void get_afterTtlExpires_returnsEmpty() throws InterruptedException {
        SeatMapCacheService shortTtlCache = new SeatMapCacheService(0);
        UUID showId = UUID.randomUUID();
        SeatMapResponse response = new SeatMapResponse(showId, "T", "V", Instant.now(),
                new BigDecimal("1.00"), List.of(sampleSeat(UUID.randomUUID())));
        shortTtlCache.put(showId, response);
        Thread.sleep(20);

        Optional<SeatMapResponse> result = shortTtlCache.get(showId);

        assertThat(result).isEmpty();
    }

    @Test
    void updateSeat_whenShowIsCached_patchesOnlyThatSeatField() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        SeatMapResponse response = new SeatMapResponse(showId, "T", "V", Instant.now(),
                new BigDecimal("1.00"), List.of(sampleSeat(seatId)));
        cacheService.put(showId, response);

        SeatResponse updated = new SeatResponse(seatId, "A", 12, SeatType.PREMIUM, new BigDecimal("500.00"), SeatStatus.LOCKED, null);
        cacheService.updateSeat(showId, updated);

        Optional<SeatMapResponse> result = cacheService.get(showId);
        assertThat(result).isPresent();
        assertThat(result.get().seats().get(0).status()).isEqualTo(SeatStatus.LOCKED);
    }

    @Test
    void updateSeat_whenShowIsNotCached_isANoOp() {
        UUID showId = UUID.randomUUID();

        cacheService.updateSeat(showId, sampleSeat(UUID.randomUUID()));

        assertThat(cacheService.get(showId)).isEmpty();
    }
}
