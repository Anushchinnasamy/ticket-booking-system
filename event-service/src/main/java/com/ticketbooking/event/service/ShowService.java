package com.ticketbooking.event.service;

import com.ticketbooking.common.event.SeatStatusChangedEvent;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.common.resilience.RetryingPublisher;
import com.ticketbooking.event.cache.SeatMapCacheService;
import com.ticketbooking.event.domain.Seat;
import com.ticketbooking.event.domain.Show;
import com.ticketbooking.event.repository.SeatRepository;
import com.ticketbooking.event.repository.ShowRepository;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import com.ticketbooking.event.web.dto.SeatResponse;
import io.github.resilience4j.retry.Retry;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ScheduledExecutorService;

@Service
@Transactional(readOnly = true)
public class ShowService {

    private static final String TOPIC_SEAT_STATUS_CHANGED = "seat-status-changed";

    private final ShowRepository showRepository;
    private final SeatRepository seatRepository;
    private final KafkaTemplate<String, Object> kafkaTemplate;
    private final Retry kafkaPublishRetry;
    private final ScheduledExecutorService kafkaRetryScheduler;
    private final SeatMapCacheService seatMapCacheService;

    public ShowService(ShowRepository showRepository, SeatRepository seatRepository,
                        KafkaTemplate<String, Object> kafkaTemplate, Retry kafkaPublishRetry,
                        ScheduledExecutorService kafkaRetryScheduler, SeatMapCacheService seatMapCacheService) {
        this.showRepository = showRepository;
        this.seatRepository = seatRepository;
        this.kafkaTemplate = kafkaTemplate;
        this.kafkaPublishRetry = kafkaPublishRetry;
        this.kafkaRetryScheduler = kafkaRetryScheduler;
        this.seatMapCacheService = seatMapCacheService;
    }

    /**
     * Cache-aside: try Redis first (see SeatMapCacheService — a hash per
     * show, so a write to one seat never invalidates the others), fall back
     * to Postgres on a miss and write the result through to the cache.
     */
    public SeatMapResponse getSeatMap(UUID showId) {
        Optional<SeatMapResponse> cached = seatMapCacheService.get(showId);
        if (cached.isPresent()) {
            return cached.get();
        }

        Show show = showRepository.findById(showId)
                .orElseThrow(() -> new ResourceNotFoundException("Show not found: " + showId));

        List<SeatResponse> seats = seatRepository.findByShowIdOrderByPosition(showId).stream()
                .map(this::toSeatResponse)
                .toList();

        SeatMapResponse response = new SeatMapResponse(
                show.getId(),
                show.getEvent().getTitle(),
                show.getVenue().getName(),
                show.getStartTime(),
                show.getBasePrice(),
                seats);

        seatMapCacheService.put(showId, response);
        return response;
    }

    /**
     * Phase 2 baseline (see docs/adr/001-locking-strategy.md): kept as a
     * working reference implementation. No longer called by booking-service.
     */
    @Transactional
    public void lockSeat(UUID showId, UUID seatId) {
        Seat seat = seatRepository.findByIdAndShowIdForUpdate(seatId, showId)
                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));
        seat.lock();
    }

    /**
     * Phase 3: plain update, no DB-level lock — safe only because the caller
     * (booking-service) already holds an external Redis lock for this seat.
     */
    @Transactional
    public void claimSeat(UUID showId, UUID seatId) {
        Seat seat = seatRepository.findByIdAndShowId(seatId, showId)
                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));
        seat.lock();
        onSeatMutated(showId, seatId, seat);
    }

    @Transactional
    public void releaseSeat(UUID showId, UUID seatId) {
        Seat seat = seatRepository.findByIdAndShowId(seatId, showId)
                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));
        seat.release();
        onSeatMutated(showId, seatId, seat);
    }

    /** Called by booking-service once payment succeeds: finalizes LOCKED -> BOOKED. */
    @Transactional
    public void bookSeat(UUID showId, UUID seatId) {
        Seat seat = seatRepository.findByIdAndShowId(seatId, showId)
                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));
        seat.book();
        onSeatMutated(showId, seatId, seat);
    }

    /**
     * Publishes the domain event and patches just this one seat's cache
     * entry — never the whole show's cache, which is exactly the
     * "needless cache-storm during a flash sale" the caching strategy is
     * built to avoid (other seats in the same show stay cached and warm).
     * Takes seatId explicitly rather than reading seat.getId() — in
     * production they're always the same row, but seat.getId() is only
     * populated once JPA has actually persisted the entity, so relying on
     * it here would be a landmine for any future caller working with a
     * not-yet-persisted Seat.
     */
    private void onSeatMutated(UUID showId, UUID seatId, Seat seat) {
        publishSeatStatusChanged(showId, seatId, seat.getStatus().name());
        seatMapCacheService.updateSeat(showId, toSeatResponse(seatId, seat));
    }

    /**
     * Fire-and-forget, same as booking-service's event publishing — never
     * blocks the caller on the broker or on any downstream consumer.
     */
    private void publishSeatStatusChanged(UUID showId, UUID seatId, String status) {
        RetryingPublisher.withRetry(() -> kafkaTemplate.send(TOPIC_SEAT_STATUS_CHANGED, seatId.toString(),
                        new SeatStatusChangedEvent(showId, seatId, status, Instant.now())),
                kafkaPublishRetry, kafkaRetryScheduler);
    }

    private SeatResponse toSeatResponse(Seat seat) {
        return toSeatResponse(seat.getId(), seat);
    }

    private SeatResponse toSeatResponse(UUID seatId, Seat seat) {
        return new SeatResponse(seatId, seat.getRowLabel(), seat.getSeatNumber(),
                seat.getSeatType(), seat.getPrice(), seat.getStatus());
    }
}
