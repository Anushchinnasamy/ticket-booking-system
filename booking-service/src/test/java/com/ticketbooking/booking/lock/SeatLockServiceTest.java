package com.ticketbooking.booking.lock;

import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

class SeatLockServiceTest {

    private final SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();

    private SeatLockService newService(long holdTtlMinutes) {
        return new SeatLockService(holdTtlMinutes, meterRegistry);
    }

    @Test
    void tryLock_whenNotHeld_acquiresAndDoesNotIncrementContentionCounter() {
        SeatLockService service = newService(5);

        boolean result = service.tryLock(UUID.randomUUID(), UUID.randomUUID());

        assertThat(result).isTrue();
        assertThat(meterRegistry.get("seat_lock_contention").counter().count()).isEqualTo(0.0);
    }

    @Test
    void tryLock_whenAlreadyHeld_incrementsContentionCounter() {
        SeatLockService service = newService(5);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        service.tryLock(showId, seatId);

        boolean result = service.tryLock(showId, seatId);

        assertThat(result).isFalse();
        assertThat(meterRegistry.get("seat_lock_contention").counter().count()).isEqualTo(1.0);
    }

    @Test
    void tryLock_afterUnlock_canBeReacquired() {
        SeatLockService service = newService(5);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        service.tryLock(showId, seatId);

        service.unlock(showId, seatId);
        boolean result = service.tryLock(showId, seatId);

        assertThat(result).isTrue();
    }

    @Test
    void tryLock_afterExpiry_canBeReacquiredEvenWithoutUnlock() throws InterruptedException {
        SeatLockService service = newService(0); // expires practically immediately
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        service.tryLock(showId, seatId);
        Thread.sleep(50);

        boolean result = service.tryLock(showId, seatId);

        assertThat(result).isTrue();
    }

    @Test
    void forceUnlock_releasesLockRegardlessOfOwner() {
        SeatLockService service = newService(5);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        service.tryLock(showId, seatId);

        service.forceUnlock(showId, seatId);
        boolean result = service.tryLock(showId, seatId);

        assertThat(result).isTrue();
    }

    @Test
    void locksOnDifferentSeats_doNotContendWithEachOther() {
        SeatLockService service = newService(5);
        UUID showId = UUID.randomUUID();

        boolean first = service.tryLock(showId, UUID.randomUUID());
        boolean second = service.tryLock(showId, UUID.randomUUID());

        assertThat(first).isTrue();
        assertThat(second).isTrue();
        assertThat(meterRegistry.get("seat_lock_contention").counter().count()).isEqualTo(0.0);
    }
}
