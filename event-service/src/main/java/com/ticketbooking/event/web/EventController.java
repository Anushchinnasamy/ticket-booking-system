package com.ticketbooking.event.web;

import com.ticketbooking.event.domain.EventCategory;
import com.ticketbooking.event.service.EventService;
import com.ticketbooking.event.web.dto.CreateEventRequest;
import com.ticketbooking.event.web.dto.EventDetailResponse;
import com.ticketbooking.event.web.dto.EventSummaryResponse;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/events")
public class EventController {

    private final EventService eventService;

    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    @GetMapping
    public List<EventSummaryResponse> listEvents(@RequestParam(required = false) EventCategory category) {
        return eventService.listEvents(category);
    }

    @GetMapping("/{id}")
    public EventDetailResponse getEvent(@PathVariable UUID id) {
        return eventService.getEvent(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public EventSummaryResponse createEvent(@Valid @RequestBody CreateEventRequest request) {
        return eventService.createEvent(request);
    }
}
