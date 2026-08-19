package com.ticketbooking.booking.waitlist;

import com.ticketbooking.booking.domain.Waitlist;
import com.ticketbooking.booking.domain.WaitlistStatus;
import com.ticketbooking.booking.repository.WaitlistRepository;
import com.ticketbooking.booking.web.dto.WaitlistResponse;
import com.ticketbooking.common.exception.ConflictException;
import io.github.resilience4j.retry.Retry;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class WaitlistServiceTest {

    @Mock
    private WaitlistRepository waitlistRepository;

    @Mock
    private KafkaTemplate<String, Object> kafkaTemplate;

    private final Retry kafkaPublishRetry = Retry.ofDefaults("test");
    private final ScheduledExecutorService kafkaRetryScheduler = Executors.newSingleThreadScheduledExecutor(r -> {
        Thread t = new Thread(r);
        t.setDaemon(true);
        return t;
    });

    private WaitlistService newService() {
        return new WaitlistService(waitlistRepository, kafkaTemplate, kafkaPublishRetry, kafkaRetryScheduler);
    }

    @BeforeEach
    void stubKafkaSendDefault() {
        lenient().when(kafkaTemplate.send(anyString(), anyString(), any()))
                .thenReturn(CompletableFuture.completedFuture(null));
    }

    @Test
    void join_whenNotAlreadyWaiting_savesWithComputedPosition() {
        UUID showId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        when(waitlistRepository.existsByShowIdAndUserIdAndStatus(showId, userId, WaitlistStatus.WAITING)).thenReturn(false);
        when(waitlistRepository.countByShowIdAndStatus(showId, WaitlistStatus.WAITING)).thenReturn(2L);
        when(waitlistRepository.save(any(Waitlist.class))).thenAnswer(inv -> inv.getArgument(0));

        WaitlistResponse result = newService().join(showId, userId);

        assertThat(result.showId()).isEqualTo(showId);
        assertThat(result.userId()).isEqualTo(userId);
        assertThat(result.position()).isEqualTo(3L);
        assertThat(result.status()).isEqualTo(WaitlistStatus.WAITING);
    }

    @Test
    void join_whenAlreadyWaiting_throwsConflictWithoutSaving() {
        UUID showId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        when(waitlistRepository.existsByShowIdAndUserIdAndStatus(showId, userId, WaitlistStatus.WAITING)).thenReturn(true);

        assertThatThrownBy(() -> newService().join(showId, userId))
                .isInstanceOf(ConflictException.class);

        verify(waitlistRepository, never()).save(any(Waitlist.class));
    }

    @Test
    void promoteNext_whenSomeoneWaiting_marksNotifiedAndPublishesEvent() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        Waitlist entry = new Waitlist(showId, userId, 1);
        ReflectionTestUtils.setField(entry, "id", UUID.randomUUID());
        when(waitlistRepository.findFirstByShowIdAndStatusOrderByCreatedAtAsc(showId, WaitlistStatus.WAITING))
                .thenReturn(Optional.of(entry));
        when(waitlistRepository.save(entry)).thenReturn(entry);

        newService().promoteNext(showId, seatId);

        assertThat(entry.getStatus()).isEqualTo(WaitlistStatus.NOTIFIED);
        verify(waitlistRepository).save(entry);
        verify(kafkaTemplate).send(eq("waitlist-seat-available"), anyString(), any());
    }

    @Test
    void promoteNext_whenNobodyWaiting_isNoOp() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        when(waitlistRepository.findFirstByShowIdAndStatusOrderByCreatedAtAsc(showId, WaitlistStatus.WAITING))
                .thenReturn(Optional.empty());

        newService().promoteNext(showId, seatId);

        verify(waitlistRepository, never()).save(any(Waitlist.class));
        verifyNoInteractions(kafkaTemplate);
    }
}
