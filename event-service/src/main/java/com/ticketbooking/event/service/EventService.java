package com.ticketbooking.event.service;

import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.event.domain.Event;
import com.ticketbooking.event.domain.EventCategory;
import com.ticketbooking.event.repository.EventRepository;
import com.ticketbooking.event.repository.ShowRepository;
import com.ticketbooking.event.web.dto.CreateEventRequest;
import com.ticketbooking.event.web.dto.EventDetailResponse;
import com.ticketbooking.event.web.dto.EventSummaryResponse;
import com.ticketbooking.event.web.dto.ShowSummaryResponse;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class EventService {

    private final EventRepository eventRepository;
    private final ShowRepository showRepository;

    public EventService(EventRepository eventRepository, ShowRepository showRepository) {
        this.eventRepository = eventRepository;
        this.showRepository = showRepository;
    }

    public List<EventSummaryResponse> listEvents(EventCategory category, String city) {
        List<Event> events;
        if (city != null && !city.isBlank()) {
            events = eventRepository.findByCity(city, category);
        } else if (category != null) {
            events = eventRepository.findByCategory(category);
        } else {
            events = eventRepository.findAll();
        }
        return events.stream().map(this::toSummary).toList();
    }

    public List<String> listCities() {
        return eventRepository.findDistinctCities();
    }

    public EventDetailResponse getEvent(UUID eventId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found: " + eventId));

        List<ShowSummaryResponse> shows = showRepository.findByEventId(eventId).stream()
                .map(show -> new ShowSummaryResponse(
                        show.getId(),
                        show.getVenue().getName(),
                        show.getVenue().getCity(),
                        show.getStartTime(),
                        show.getBasePrice()))
                .toList();

        return new EventDetailResponse(event.getId(), event.getTitle(), event.getCategory(), event.getDescription(), shows);
    }

    @Transactional
    public EventSummaryResponse createEvent(CreateEventRequest request) {
        Event event = new Event(request.title(), request.category(), request.description());
        Event saved = eventRepository.save(event);
        return toSummary(saved);
    }

    private EventSummaryResponse toSummary(Event event) {
        return new EventSummaryResponse(event.getId(), event.getTitle(), event.getCategory(), event.getDescription());
    }
}
