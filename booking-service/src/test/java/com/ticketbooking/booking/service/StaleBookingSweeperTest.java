package com.ticketbooking.booking.service;

import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import com.ticketbooking.booking.repository.BookingRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentMatchers;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.UUID;

import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class StaleBookingSweeperTest {

    @Mock
    private BookingRepository bookingRepository;

    @Mock
    private BookingService bookingService;

    @Test
    void releaseExpiredHolds_delegatesCancellationToBookingService() {
        StaleBookingSweeper sweeper = new StaleBookingSweeper(bookingRepository, bookingService, 5);

        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        Booking stale = new Booking(showId, seatId, userId);
        when(bookingRepository.findByStatusAndCreatedAtBefore(
                ArgumentMatchers.eq(BookingStatus.PENDING), ArgumentMatchers.any()))
                .thenReturn(List.of(stale));

        sweeper.releaseExpiredHolds();

        verify(bookingService).cancelBooking(stale.getId());
    }

    @Test
    void releaseExpiredHolds_whenNoneStale_doesNothing() {
        StaleBookingSweeper sweeper = new StaleBookingSweeper(bookingRepository, bookingService, 5);
        when(bookingRepository.findByStatusAndCreatedAtBefore(
                ArgumentMatchers.eq(BookingStatus.PENDING), ArgumentMatchers.any()))
                .thenReturn(List.of());

        sweeper.releaseExpiredHolds();

        verify(bookingService, never()).cancelBooking(ArgumentMatchers.any());
    }

    @Test
    void releaseExpiredHolds_whenOneFails_stillProcessesTheRest() {
        StaleBookingSweeper sweeper = new StaleBookingSweeper(bookingRepository, bookingService, 5);

        Booking failing = new Booking(UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID());
        Booking succeeding = new Booking(UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID());
        when(bookingRepository.findByStatusAndCreatedAtBefore(
                ArgumentMatchers.eq(BookingStatus.PENDING), ArgumentMatchers.any()))
                .thenReturn(List.of(failing, succeeding));
        doThrow(new RuntimeException("event-service unreachable"))
                .doReturn(null)
                .when(bookingService).cancelBooking(ArgumentMatchers.any());

        sweeper.releaseExpiredHolds();

        verify(bookingService, times(2)).cancelBooking(ArgumentMatchers.any());
    }
}
