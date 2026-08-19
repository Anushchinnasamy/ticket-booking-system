package com.ticketbooking.booking.lock;

import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SeatLockServiceTest {

    @Mock
    private RedissonClient redissonClient;

    @Mock
    private RLock rLock;

    private final SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();

    private SeatLockService newService() {
        return new SeatLockService(redissonClient, 5, meterRegistry);
    }

    @Test
    void tryLock_whenAcquired_doesNotIncrementContentionCounter() throws InterruptedException {
        when(redissonClient.getLock(anyString())).thenReturn(rLock);
        when(rLock.tryLock(0, 5, TimeUnit.MINUTES)).thenReturn(true);

        boolean result = newService().tryLock(UUID.randomUUID(), UUID.randomUUID());

        assertThat(result).isTrue();
        assertThat(meterRegistry.get("seat_lock_contention").counter().count()).isEqualTo(0.0);
    }

    @Test
    void tryLock_whenAlreadyHeld_incrementsContentionCounter() throws InterruptedException {
        when(redissonClient.getLock(anyString())).thenReturn(rLock);
        when(rLock.tryLock(0, 5, TimeUnit.MINUTES)).thenReturn(false);

        boolean result = newService().tryLock(UUID.randomUUID(), UUID.randomUUID());

        assertThat(result).isFalse();
        assertThat(meterRegistry.get("seat_lock_contention").counter().count()).isEqualTo(1.0);
    }

    @Test
    void tryLock_whenInterrupted_incrementsContentionCounterAndRestoresInterruptFlag() throws InterruptedException {
        when(redissonClient.getLock(anyString())).thenReturn(rLock);
        when(rLock.tryLock(0, 5, TimeUnit.MINUTES)).thenThrow(new InterruptedException());

        boolean result = newService().tryLock(UUID.randomUUID(), UUID.randomUUID());

        assertThat(result).isFalse();
        assertThat(meterRegistry.get("seat_lock_contention").counter().count()).isEqualTo(1.0);
        assertThat(Thread.interrupted()).isTrue();
    }
}
