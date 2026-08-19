package com.ticketbooking.event.web;

import com.ticketbooking.event.service.ShowService;
import com.ticketbooking.event.web.dto.SeatMapResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
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
}
