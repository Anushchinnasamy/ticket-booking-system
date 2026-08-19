package com.ticketbooking.booking.waitlist;

import com.ticketbooking.booking.domain.Waitlist;
import com.ticketbooking.booking.domain.WaitlistStatus;
import com.ticketbooking.booking.repository.WaitlistRepository;
import com.ticketbooking.booking.web.dto.WaitlistResponse;
import com.ticketbooking.common.event.WaitlistSeatAvailableEvent;
import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.resilience.RetryingPublisher;
import io.github.resilience4j.retry.Retry;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;
import java.util.concurrent.ScheduledExecutorService;

@Service
public class WaitlistService {

    private static final String TOPIC_WAITLIST_SEAT_AVAILABLE = "waitlist-seat-available";

    private final WaitlistRepository waitlistRepository;
    private final KafkaTemplate<String, Object> kafkaTemplate;
    private final Retry kafkaPublishRetry;
    private final ScheduledExecutorService kafkaRetryScheduler;

    public WaitlistService(WaitlistRepository waitlistRepository, KafkaTemplate<String, Object> kafkaTemplate,
                            Retry kafkaPublishRetry, ScheduledExecutorService kafkaRetryScheduler) {
        this.waitlistRepository = waitlistRepository;
        this.kafkaTemplate = kafkaTemplate;
        this.kafkaPublishRetry = kafkaPublishRetry;
        this.kafkaRetryScheduler = kafkaRetryScheduler;
    }

    /** A user can only be WAITING once per show — rejoining after being NOTIFIED (a past promotion) is allowed. */
    @Transactional
    public WaitlistResponse join(UUID showId, UUID userId) {
        if (waitlistRepository.existsByShowIdAndUserIdAndStatus(showId, userId, WaitlistStatus.WAITING)) {
            throw new ConflictException("Already on the waitlist for show: " + showId);
        }
        long position = waitlistRepository.countByShowIdAndStatus(showId, WaitlistStatus.WAITING) + 1;
        Waitlist saved = waitlistRepository.save(new Waitlist(showId, userId, position));
        return toResponse(saved);
    }

    /**
     * Consumed off every booking-cancelled event (see WaitlistEventListener) —
     * a seat is freed the same way whether the cancelled booking was a
     * confirmed/refunded one or a PENDING hold that simply expired, so both
     * paths are equally valid triggers here. No-op if nobody is waiting,
     * which is the common case on a show that isn't sold out.
     */
    public void promoteNext(UUID showId, UUID seatId) {
        waitlistRepository.findFirstByShowIdAndStatusOrderByCreatedAtAsc(showId, WaitlistStatus.WAITING)
                .ifPresent(entry -> {
                    entry.markNotified();
                    Waitlist saved = waitlistRepository.save(entry);
                    RetryingPublisher.withRetry(() -> kafkaTemplate.send(TOPIC_WAITLIST_SEAT_AVAILABLE, saved.getId().toString(),
                            new WaitlistSeatAvailableEvent(saved.getId(), showId, saved.getUserId(), seatId, Instant.now())),
                            kafkaPublishRetry, kafkaRetryScheduler);
                });
    }

    private WaitlistResponse toResponse(Waitlist waitlist) {
        return new WaitlistResponse(waitlist.getId(), waitlist.getShowId(), waitlist.getUserId(),
                waitlist.getPosition(), waitlist.getStatus(), waitlist.getCreatedAt());
    }
}
