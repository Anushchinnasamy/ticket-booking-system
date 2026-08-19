package com.ticketbooking.event.service;

import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.event.domain.Seat;
import com.ticketbooking.event.domain.Show;
import com.ticketbooking.event.repository.SeatRepository;
import com.ticketbooking.event.repository.ShowRepository;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import com.ticketbooking.event.web.dto.SeatResponse;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class ShowService {

    private final ShowRepository showRepository;
    private final SeatRepository seatRepository;

    public ShowService(ShowRepository showRepository, SeatRepository seatRepository) {
        this.showRepository = showRepository;
        this.seatRepository = seatRepository;
    }

    public SeatMapResponse getSeatMap(UUID showId) {
        Show show = showRepository.findById(showId)
                .orElseThrow(() -> new ResourceNotFoundException("Show not found: " + showId));

        List<SeatResponse> seats = seatRepository.findByShowIdOrderByPosition(showId).stream()
                .map(seat -> new SeatResponse(
                        seat.getId(),
                        seat.getRowLabel(),
                        seat.getSeatNumber(),
                        seat.getSeatType(),
                        seat.getPrice(),
                        seat.getStatus()))
                .toList();

        return new SeatMapResponse(
                show.getId(),
                show.getEvent().getTitle(),
                show.getVenue().getName(),
                show.getStartTime(),
                show.getBasePrice(),
                seats);
    }

    /**
     * Phase 2 baseline (see docs/adr/001-locking-strategy.md): kept as a
     * working reference implementation. No longer called by booking-service.
     */
    @Transactional
    public void lockSeat(UUID showId, UUID seatId) {
        Seat seat = seatRepository.findByIdAndShowIdForUpdate(seatId, showId)
                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));
        seat.lock();
    }

    /**
     * Phase 3: plain update, no DB-level lock — safe only because the caller
     * (booking-service) already holds an external Redis lock for this seat.
     */
    @Transactional
    public void claimSeat(UUID showId, UUID seatId) {
        Seat seat = seatRepository.findByIdAndShowId(seatId, showId)
                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));
        seat.lock();
    }

    @Transactional
    public void releaseSeat(UUID showId, UUID seatId) {
        Seat seat = seatRepository.findByIdAndShowId(seatId, showId)
                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));
        seat.release();
    }
}
