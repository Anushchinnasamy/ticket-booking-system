package com.ticketbooking.event.service;

import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.event.domain.Event;
import com.ticketbooking.event.domain.EventCategory;
import com.ticketbooking.event.domain.Seat;
import com.ticketbooking.event.domain.SeatMap;
import com.ticketbooking.event.domain.SeatStatus;
import com.ticketbooking.event.domain.SeatType;
import com.ticketbooking.event.domain.Show;
import com.ticketbooking.event.domain.Venue;
import com.ticketbooking.event.repository.SeatRepository;
import com.ticketbooking.event.repository.ShowRepository;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ShowServiceTest {

    @Mock
    private ShowRepository showRepository;

    @Mock
    private SeatRepository seatRepository;

    @InjectMocks
    private ShowService showService;

    @Test
    void getSeatMap_whenShowExists_returnsSeatsWithStatuses() {
        Event event = new Event("The Great Adventure", EventCategory.MOVIE, "An action-packed journey.");
        Venue venue = new Venue("PVR Forum Mall", "Bengaluru", "Koramangala");
        Show show = new Show(event, venue, Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("250.00"));
        SeatMap seatMap = new SeatMap(show);
        Seat seat = new Seat(seatMap, "1", 1, SeatType.PREMIUM, new BigDecimal("375.00"), SeatStatus.AVAILABLE);
        UUID showId = UUID.randomUUID();

        when(showRepository.findById(showId)).thenReturn(Optional.of(show));
        when(seatRepository.findByShowIdOrderByPosition(showId)).thenReturn(List.of(seat));

        SeatMapResponse result = showService.getSeatMap(showId);

        assertThat(result.eventTitle()).isEqualTo("The Great Adventure");
        assertThat(result.venueName()).isEqualTo("PVR Forum Mall");
        assertThat(result.seats()).hasSize(1);
        assertThat(result.seats().get(0).status()).isEqualTo(SeatStatus.AVAILABLE);
        assertThat(result.seats().get(0).seatType()).isEqualTo(SeatType.PREMIUM);
    }

    @Test
    void getSeatMap_whenShowNotFound_throwsResourceNotFoundException() {
        UUID showId = UUID.randomUUID();
        when(showRepository.findById(showId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> showService.getSeatMap(showId))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void lockSeat_whenAvailable_transitionsToLocked() {
        Event event = new Event("The Great Adventure", EventCategory.MOVIE, "An action-packed journey.");
        Venue venue = new Venue("PVR Forum Mall", "Bengaluru", "Koramangala");
        Show show = new Show(event, venue, Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("250.00"));
        SeatMap seatMap = new SeatMap(show);
        Seat seat = new Seat(seatMap, "1", 1, SeatType.REGULAR, new BigDecimal("250.00"), SeatStatus.AVAILABLE);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowIdForUpdate(seatId, showId)).thenReturn(Optional.of(seat));

        showService.lockSeat(showId, seatId);

        assertThat(seat.getStatus()).isEqualTo(SeatStatus.LOCKED);
    }

    @Test
    void lockSeat_whenAlreadyLocked_throwsConflictException() {
        Event event = new Event("The Great Adventure", EventCategory.MOVIE, "An action-packed journey.");
        Venue venue = new Venue("PVR Forum Mall", "Bengaluru", "Koramangala");
        Show show = new Show(event, venue, Instant.parse("2026-09-01T10:00:00Z"), new BigDecimal("250.00"));
        SeatMap seatMap = new SeatMap(show);
        Seat seat = new Seat(seatMap, "1", 1, SeatType.REGULAR, new BigDecimal("250.00"), SeatStatus.LOCKED);
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();

        when(seatRepository.findByIdAndShowIdForUpdate(seatId, showId)).thenReturn(Optional.of(seat));

        assertThatThrownBy(() -> showService.lockSeat(showId, seatId))
                .isInstanceOf(ConflictException.class);
    }

    @Test
    void lockSeat_whenSeatNotFound_throwsResourceNotFoundException() {
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        when(seatRepository.findByIdAndShowIdForUpdate(seatId, showId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> showService.lockSeat(showId, seatId))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
