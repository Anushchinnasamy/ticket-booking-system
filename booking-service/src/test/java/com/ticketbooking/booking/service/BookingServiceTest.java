package com.ticketbooking.booking.service;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import com.ticketbooking.booking.lock.SeatLockService;
import com.ticketbooking.booking.repository.BookingRepository;
import com.ticketbooking.booking.web.dto.BookingResponse;
import com.ticketbooking.booking.web.dto.CreateBookingRequest;
import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BookingServiceTest {

    @Mock
    private BookingRepository bookingRepository;

    @Mock
    private EventServiceClient eventServiceClient;

    @Mock
    private SeatLockService seatLockService;

    @InjectMocks
    private BookingService bookingService;

    @Test
    void createBooking_whenLockAcquiredAndSeatClaimed_savesPendingBooking() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        CreateBookingRequest request = new CreateBookingRequest(showId, seatId, userId);
        Booking saved = new Booking(showId, seatId, userId);
        when(seatLockService.tryLock(showId, seatId)).thenReturn(true);
        when(bookingRepository.save(any(Booking.class))).thenReturn(saved);

        BookingResponse result = bookingService.createBooking(request);

        assertThat(result.showId()).isEqualTo(showId);
        assertThat(result.seatId()).isEqualTo(seatId);
        assertThat(result.status()).isEqualTo(BookingStatus.PENDING);
        verify(seatLockService).tryLock(showId, seatId);
        verify(eventServiceClient).claimSeat(showId, seatId);
        verify(bookingRepository).save(any(Booking.class));
        verify(seatLockService, never()).unlock(showId, seatId);
    }

    @Test
    void createBooking_whenRedisLockNotAcquired_throwsConflictWithoutCallingEventService() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        CreateBookingRequest request = new CreateBookingRequest(showId, seatId, userId);
        when(seatLockService.tryLock(showId, seatId)).thenReturn(false);

        assertThatThrownBy(() -> bookingService.createBooking(request))
                .isInstanceOf(ConflictException.class);

        verifyNoInteractions(eventServiceClient);
        verifyNoInteractions(bookingRepository);
    }

    @Test
    void createBooking_whenSeatClaimFails_releasesLockAndNeverSaves() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        CreateBookingRequest request = new CreateBookingRequest(showId, seatId, userId);
        when(seatLockService.tryLock(showId, seatId)).thenReturn(true);
        doThrow(new ConflictException("Seat is not available: " + seatId))
                .when(eventServiceClient).claimSeat(showId, seatId);

        assertThatThrownBy(() -> bookingService.createBooking(request))
                .isInstanceOf(ConflictException.class);

        verify(seatLockService).unlock(showId, seatId);
        verifyNoInteractions(bookingRepository);
    }

    @Test
    void getBooking_whenFound_returnsResponse() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        Booking booking = new Booking(showId, seatId, userId);
        UUID bookingId = UUID.randomUUID();
        when(bookingRepository.findById(bookingId)).thenReturn(Optional.of(booking));

        BookingResponse result = bookingService.getBooking(bookingId);

        assertThat(result.showId()).isEqualTo(showId);
        assertThat(result.status()).isEqualTo(BookingStatus.PENDING);
    }

    @Test
    void getBooking_whenNotFound_throwsResourceNotFoundException() {
        UUID bookingId = UUID.randomUUID();
        when(bookingRepository.findById(bookingId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> bookingService.getBooking(bookingId))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
