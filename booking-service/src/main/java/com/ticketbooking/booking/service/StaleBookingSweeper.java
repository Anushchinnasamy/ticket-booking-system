package com.ticketbooking.booking.service;

import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import com.ticketbooking.booking.repository.BookingRepository;
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
 *
 * <p>Delegates to {@link BookingService#cancelBooking} — the same method
 * payment-service triggers on a failed charge — rather than duplicating the
 * release logic here.
 */
@Component
public class StaleBookingSweeper {

    private static final Logger log = LoggerFactory.getLogger(StaleBookingSweeper.class);

    private final BookingRepository bookingRepository;
    private final BookingService bookingService;
    private final long holdTtlMinutes;

    public StaleBookingSweeper(BookingRepository bookingRepository,
                                BookingService bookingService,
                                @Value("${booking.hold-ttl-minutes}") long holdTtlMinutes) {
        this.bookingRepository = bookingRepository;
        this.bookingService = bookingService;
        this.holdTtlMinutes = holdTtlMinutes;
    }

    @Scheduled(fixedDelay = 60_000)
    public void releaseExpiredHolds() {
        Instant cutoff = Instant.now().minus(holdTtlMinutes, ChronoUnit.MINUTES);
        List<Booking> stale = bookingRepository.findByStatusAndCreatedAtBefore(BookingStatus.PENDING, cutoff);

        int released = 0;
        for (Booking booking : stale) {
            try {
                bookingService.cancelBooking(booking.getId());
                released++;
            } catch (RuntimeException ex) {
                log.warn("Failed to release expired hold for booking {}, will retry next sweep",
                        booking.getId(), ex);
            }
        }

        if (released > 0) {
            log.info("Released {} expired seat hold(s)", released);
        }
    }
}
