package com.ticketbooking.booking.service;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import com.ticketbooking.booking.lock.SeatLockService;
import com.ticketbooking.booking.repository.BookingRepository;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentMatchers;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class StaleBookingSweeperTest {

    @Mock
    private BookingRepository bookingRepository;

    @Mock
    private EventServiceClient eventServiceClient;

    @Mock
    private SeatLockService seatLockService;

    @Test
    void releaseExpiredHolds_cancelsStaleBookingsAndReleasesSeats() {
        StaleBookingSweeper sweeper = new StaleBookingSweeper(
                bookingRepository, eventServiceClient, seatLockService, 5);

        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        Booking stale = new Booking(showId, seatId, userId);
        when(bookingRepository.findByStatusAndCreatedAtBefore(
                ArgumentMatchers.eq(BookingStatus.PENDING), ArgumentMatchers.any()))
                .thenReturn(List.of(stale));

        sweeper.releaseExpiredHolds();

        assertThat(stale.getStatus()).isEqualTo(BookingStatus.CANCELLED);
        verify(eventServiceClient).releaseSeat(showId, seatId);
        verify(seatLockService).forceUnlock(showId, seatId);
        verify(bookingRepository).saveAll(List.of(stale));
    }

    @Test
    void releaseExpiredHolds_whenNoneStale_doesNothing() {
        StaleBookingSweeper sweeper = new StaleBookingSweeper(
                bookingRepository, eventServiceClient, seatLockService, 5);
        when(bookingRepository.findByStatusAndCreatedAtBefore(
                ArgumentMatchers.eq(BookingStatus.PENDING), ArgumentMatchers.any()))
                .thenReturn(List.of());

        sweeper.releaseExpiredHolds();

        verify(bookingRepository, never()).saveAll(ArgumentMatchers.anyList());
    }

    @Test
    void releaseExpiredHolds_whenSeatAlreadyGone_stillCancelsBooking() {
        StaleBookingSweeper sweeper = new StaleBookingSweeper(
                bookingRepository, eventServiceClient, seatLockService, 5);

        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        Booking stale = new Booking(showId, seatId, userId);
        when(bookingRepository.findByStatusAndCreatedAtBefore(
                ArgumentMatchers.eq(BookingStatus.PENDING), ArgumentMatchers.any()))
                .thenReturn(List.of(stale));
        doThrow(new ResourceNotFoundException("gone")).when(eventServiceClient).releaseSeat(showId, seatId);

        sweeper.releaseExpiredHolds();

        assertThat(stale.getStatus()).isEqualTo(BookingStatus.CANCELLED);
        verify(seatLockService).forceUnlock(showId, seatId);
    }
}
