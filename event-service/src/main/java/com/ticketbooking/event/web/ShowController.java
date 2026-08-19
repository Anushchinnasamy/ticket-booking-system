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
     * Internal endpoint called by booking-service to atomically claim a seat
     * before creating a booking. The actual correctness guarantee comes from
     * the {@code SELECT ... FOR UPDATE} in {@link ShowService#lockSeat}.
     */
    @PostMapping("/{showId}/seats/{seatId}/lock")
    @ResponseStatus(HttpStatus.OK)
    public void lockSeat(@PathVariable UUID showId, @PathVariable UUID seatId) {
        showService.lockSeat(showId, seatId);
    }
}
