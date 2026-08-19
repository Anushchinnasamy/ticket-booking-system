package com.ticketbooking.booking.service;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import com.ticketbooking.booking.lock.SeatLockService;
import com.ticketbooking.booking.repository.BookingRepository;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Releases seat holds that expired without confirmation — the "background
 * job auto-releases seats whose lock expired without confirmation"
 * requirement from Phase 3. The Redis lock itself already auto-expires via
 * its TTL (Redisson leaseTime); this sweep is what makes the seat show as
 * AVAILABLE again in Event Service's Postgres and cancels the stale booking.
 */
@Component
public class StaleBookingSweeper {

    private static final Logger log = LoggerFactory.getLogger(StaleBookingSweeper.class);

    private final BookingRepository bookingRepository;
    private final EventServiceClient eventServiceClient;
    private final SeatLockService seatLockService;
    private final long holdTtlMinutes;

    public StaleBookingSweeper(BookingRepository bookingRepository,
                                EventServiceClient eventServiceClient,
                                SeatLockService seatLockService,
                                @Value("${booking.hold-ttl-minutes}") long holdTtlMinutes) {
        this.bookingRepository = bookingRepository;
        this.eventServiceClient = eventServiceClient;
        this.seatLockService = seatLockService;
        this.holdTtlMinutes = holdTtlMinutes;
    }

    @Scheduled(fixedDelay = 60_000)
    public void releaseExpiredHolds() {
        Instant cutoff = Instant.now().minus(holdTtlMinutes, ChronoUnit.MINUTES);
        List<Booking> stale = bookingRepository.findByStatusAndCreatedAtBefore(BookingStatus.PENDING, cutoff);

        for (Booking booking : stale) {
            try {
                eventServiceClient.releaseSeat(booking.getShowId(), booking.getSeatId());
            } catch (ResourceNotFoundException ex) {
                log.warn("Seat {} for show {} no longer exists; cancelling booking {} anyway",
                        booking.getSeatId(), booking.getShowId(), booking.getId());
            } catch (RuntimeException ex) {
                log.warn("Failed to release seat {} for show {}, will retry next sweep",
                        booking.getSeatId(), booking.getShowId(), ex);
                continue;
            }

            seatLockService.forceUnlock(booking.getShowId(), booking.getSeatId());
            booking.cancel();
        }

        if (!stale.isEmpty()) {
            bookingRepository.saveAll(stale);
            log.info("Released {} expired seat hold(s)", stale.size());
        }
    }
}
