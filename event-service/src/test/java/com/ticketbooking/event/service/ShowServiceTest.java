package com.ticketbooking.event.service;

import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.event.cache.SeatMapCacheService;
import com.ticketbooking.event.domain.Event;
import com.ticketbooking.event.domain.EventCategory;
import com.ticketbooking.event.domain.Seat;
import com.ticketbooking.event.domain.SeatMap;
import com.ticketbooking.event.domain.SeatStatus;
import com.ticketbooking.event.domain.SeatType;
import com.ticketbooking.event.domain.Show;
import com.ticketbooking.event.domain.Venue;
import com.ticketbooking.event.repository.SeatRepository;
import com.ticketbooking.event.repository.ShowRepository;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import com.ticketbooking.event.web.dto.SeatResponse;
import io.github.resilience4j.retry.Retry;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.core.KafkaTemplate;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertTimeoutPreemptively;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ShowServiceTest {

    @Mock
    private ShowRepository showRepository;

    @Mock
    private SeatRepository seatRepository;

    @Mock
    private KafkaTemplate<String, Object> kafkaTemplate;

    @Mock
    private SeatMapCacheService seatMapCacheService;

    private final Retry kafkaPublishRetry = Retry.ofDefaults("test");
    private final ScheduledExecutorService kafkaRetryScheduler = Executors.newSingleThreadScheduledExecutor(r -> {
        Thread t = new Thread(r);
        t.setDaemon(true);
        return t;
    });

    private ShowService newService() {
        return new ShowService(showRepository, seatRepository, kafkaTemplate, kafkaPublishRetry, kafkaRetryScheduler,
                seatMapCacheService);
    }

    /**
     * RetryingPublisher calls .whenComplete() on whatever KafkaTemplate.send
     * returns — real KafkaTemplate never returns null, but an unstubbed
     * Mockito mock does, which NPEs. Tests that care about a specific future
     * (e.g. a never-completing one, to prove non-blocking) override this.
     */
    @BeforeEach
    void stubKafkaSendDefault() {
        lenient().when(kafkaTemplate.send(anyString(), anyString(), any()))
                .thenReturn(CompletableFuture.completedFuture(null));
    }

    /** Default: cache miss, so existing tests exercise the DB fallback path unless they override this. */
    @BeforeEach
    void stubCacheMissByDefault() {
        lenient().when(seatMapCacheService.get(any())).thenReturn(Optional.empty());
    }

    @Test
    void getSeatMap_whenShowExists_returnsSeatsWithStatuses() {
        Event event = new Event("The Great Adventure", EventCategory.MOVIE, "An action-packed journey.");
        Venue venue = new Venue("PVR Forum Mall", "Bengaluru", "Koramangala");
        Show show = new Show(event, venue, Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("250.00"));
        SeatMap seatMap = new SeatMap(show);
        Seat seat = new Seat(seatMap, "1", 1, SeatType.PREMIUM, new BigDecimal("375.00"), SeatStatus.AVAILABLE);
        UUID showId = UUID.randomUUID();

        when(showRepository.findById(showId)).thenReturn(Optional.of(show));
        when(seatRepository.findByShowIdOrderByPosition(showId)).thenReturn(List.of(seat));

        SeatMapResponse result = newService().getSeatMap(showId);

        assertThat(result.eventTitle()).isEqualTo("The Great Adventure");
        assertThat(result.venueName()).isEqualTo("PVR Forum Mall");
        assertThat(result.seats()).hasSize(1);
        assertThat(result.seats().get(0).status()).isEqualTo(SeatStatus.AVAILABLE);
        assertThat(result.seats().get(0).seatType()).isEqualTo(SeatType.PREMIUM);
        verify(seatMapCacheService).put(eq(showId), any());
    }

    @Test
    void getSeatMap_whenCacheHit_returnsCachedResponseWithoutQueryingDatabase() {
        UUID showId = UUID.randomUUID();
        SeatMapResponse cached = new SeatMapResponse(showId, "Cached Title", "Cached Venue",
                Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("100.00"),
                List.of(new SeatResponse(UUID.randomUUID(), "A", 1, SeatType.REGULAR,
                        new BigDecimal("100.00"), SeatStatus.AVAILABLE, null)));
        when(seatMapCacheService.get(showId)).thenReturn(Optional.of(cached));

        SeatMapResponse result = newService().getSeatMap(showId);

        assertThat(result).isSameAs(cached);
        verifyNoInteractions(showRepository, seatRepository);
        verify(seatMapCacheService, never()).put(any(), any());
    }

    @Test
    void getSeatMap_whenShowNotFound_throwsResourceNotFoundException() {
        UUID showId = UUID.randomUUID();
        when(showRepository.findById(showId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().getSeatMap(showId))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void lockSeat_whenAvailable_transitionsToLocked() {
        Event event = new Event("The Great Adventure", EventCategory.MOVIE, "An action-packed journey.");
        Venue venue = new Venue("PVR Forum Mall", "Bengaluru", "Koramangala");
        Show show = new Show(event, venue, Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("250.00"));
        SeatMap seatMap = new SeatMap(show);
        Seat seat = new Seat(seatMap, "1", 1, SeatType.REGULAR, new BigDecimal("250.00"), SeatStatus.AVAILABLE);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowIdForUpdate(seatId, showId)).thenReturn(Optional.of(seat));

        newService().lockSeat(showId, seatId);

        assertThat(seat.getStatus()).isEqualTo(SeatStatus.LOCKED);
    }

    @Test
    void lockSeat_whenAlreadyLocked_throwsConflictException() {
        Event event = new Event("The Great Adventure", EventCategory.MOVIE, "An action-packed journey.");
        Venue venue = new Venue("PVR Forum Mall", "Bengaluru", "Koramangala");
        Show show = new Show(event, venue, Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("250.00"));
        SeatMap seatMap = new SeatMap(show);
        Seat seat = new Seat(seatMap, "1", 1, SeatType.REGULAR, new BigDecimal("250.00"), SeatStatus.LOCKED);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowIdForUpdate(seatId, showId)).thenReturn(Optional.of(seat));

        assertThatThrownBy(() -> newService().lockSeat(showId, seatId))
                .isInstanceOf(ConflictException.class);
    }

    @Test
    void lockSeat_whenSeatNotFound_throwsResourceNotFoundException() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        when(seatRepository.findByIdAndShowIdForUpdate(seatId, showId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().lockSeat(showId, seatId))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void claimSeat_whenAvailable_transitionsToLocked() {
        Seat seat = newSeat(SeatStatus.AVAILABLE);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowId(seatId, showId)).thenReturn(Optional.of(seat));

        newService().claimSeat(showId, seatId);

        assertThat(seat.getStatus()).isEqualTo(SeatStatus.LOCKED);
        verify(kafkaTemplate).send(eq("seat-status-changed"), anyString(), any());
        verify(seatMapCacheService).updateSeat(eq(showId), any());
    }

    /**
     * Same non-blocking guarantee as booking-service's Kafka publishing (see
     * BookingServiceTest): if this ever started blocking on the send, the
     * test would hang until JUnit's timeout kills it.
     */
    @Test
    void claimSeat_doesNotBlockOnKafkaPublish() {
        Seat seat = newSeat(SeatStatus.AVAILABLE);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        when(seatRepository.findByIdAndShowId(seatId, showId)).thenReturn(Optional.of(seat));
        CompletableFuture<Object> neverCompletes = new CompletableFuture<>();
        when(kafkaTemplate.send(anyString(), anyString(), any())).thenReturn((CompletableFuture) neverCompletes);

        assertTimeoutPreemptively(Duration.ofMillis(500), () -> newService().claimSeat(showId, seatId));
    }

    @Test
    void claimSeat_whenAlreadyLocked_throwsConflictException() {
        Seat seat = newSeat(SeatStatus.LOCKED);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowId(seatId, showId)).thenReturn(Optional.of(seat));

        assertThatThrownBy(() -> newService().claimSeat(showId, seatId))
                .isInstanceOf(ConflictException.class);
    }

    @Test
    void releaseSeat_whenLocked_transitionsToAvailable() {
        Seat seat = newSeat(SeatStatus.LOCKED);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowId(seatId, showId)).thenReturn(Optional.of(seat));

        newService().releaseSeat(showId, seatId);

        assertThat(seat.getStatus()).isEqualTo(SeatStatus.AVAILABLE);
        verify(kafkaTemplate).send(eq("seat-status-changed"), anyString(), any());
        verify(seatMapCacheService).updateSeat(eq(showId), any());
    }

    @Test
    void releaseSeat_whenBooked_transitionsToAvailable() {
        Seat seat = newSeat(SeatStatus.BOOKED);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowId(seatId, showId)).thenReturn(Optional.of(seat));

        newService().releaseSeat(showId, seatId);

        assertThat(seat.getStatus()).isEqualTo(SeatStatus.AVAILABLE);
        verify(kafkaTemplate).send(eq("seat-status-changed"), anyString(), any());
        verify(seatMapCacheService).updateSeat(eq(showId), any());
    }

    @Test
    void releaseSeat_whenAlreadyAvailable_isNoOp() {
        Seat seat = newSeat(SeatStatus.AVAILABLE);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowId(seatId, showId)).thenReturn(Optional.of(seat));

        newService().releaseSeat(showId, seatId);

        assertThat(seat.getStatus()).isEqualTo(SeatStatus.AVAILABLE);
    }

    @Test
    void bookSeat_whenLocked_transitionsToBooked() {
        Seat seat = newSeat(SeatStatus.LOCKED);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowId(seatId, showId)).thenReturn(Optional.of(seat));

        newService().bookSeat(showId, seatId);

        assertThat(seat.getStatus()).isEqualTo(SeatStatus.BOOKED);
        verify(kafkaTemplate).send(eq("seat-status-changed"), anyString(), any());
        verify(seatMapCacheService).updateSeat(eq(showId), any());
    }

    @Test
    void bookSeat_whenNotLocked_throwsConflictException() {
        Seat seat = newSeat(SeatStatus.AVAILABLE);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowId(seatId, showId)).thenReturn(Optional.of(seat));

        assertThatThrownBy(() -> newService().bookSeat(showId, seatId))
                .isInstanceOf(ConflictException.class);
    }

    private static Seat newSeat(SeatStatus status) {
        Event event = new Event("The Great Adventure", EventCategory.MOVIE, "An action-packed journey.");
        Venue venue = new Venue("PVR Forum Mall", "Bengaluru", "Koramangala");
        Show show = new Show(event, venue, Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("250.00"));
        SeatMap seatMap = new SeatMap(show);
        return new Seat(seatMap, "1", 1, SeatType.REGULAR, new BigDecimal("250.00"), status);
    }
}
