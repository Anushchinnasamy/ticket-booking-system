package com.ticketbooking.event.web;

import com.ticketbooking.event.service.ShowService;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/shows")
public class ShowController {

    private final ShowService showService;

    public ShowController(ShowService showService) {
        this.showService = showService;
    }

    @GetMapping("/{id}/seats")
    public SeatMapResponse getSeats(@PathVariable UUID id) {
        return showService.getSeatMap(id);
    }

    /**
     * Phase 2 baseline (see docs/adr/001-locking-strategy.md), kept as a
     * working reference implementation. No longer called by booking-service.
     */
    @PostMapping("/{showId}/seats/{seatId}/lock")
    @ResponseStatus(HttpStatus.OK)
    public void lockSeat(@PathVariable UUID showId, @PathVariable UUID seatId) {
        showService.lockSeat(showId, seatId);
    }

    /**
     * Internal endpoint called by booking-service once it already holds the
     * Redis distributed lock for this seat — see SeatLockService in
     * booking-service. No DB-level locking here; the caller's Redis lock is
     * what guarantees exclusivity.
     */
    @PostMapping("/{showId}/seats/{seatId}/claim")
    @ResponseStatus(HttpStatus.OK)
    public void claimSeat(@PathVariable UUID showId, @PathVariable UUID seatId) {
        showService.claimSeat(showId, seatId);
    }

    /**
     * Internal endpoint called by booking-service's stale-booking sweep to
     * release a seat whose reservation hold expired without confirmation.
     */
    @PostMapping("/{showId}/seats/{seatId}/release")
    @ResponseStatus(HttpStatus.OK)
    public void releaseSeat(@PathVariable UUID showId, @PathVariable UUID seatId) {
        showService.releaseSeat(showId, seatId);
    }

    /**
     * Internal endpoint called by booking-service once payment-service
     * confirms a successful charge.
     */
    @PostMapping("/{showId}/seats/{seatId}/book")
    @ResponseStatus(HttpStatus.OK)
    public void bookSeat(@PathVariable UUID showId, @PathVariable UUID seatId) {
        showService.bookSeat(showId, seatId);
    }
}
