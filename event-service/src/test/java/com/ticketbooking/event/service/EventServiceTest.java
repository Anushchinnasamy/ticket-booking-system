package com.ticketbooking.event.service;

import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.event.domain.Event;
import com.ticketbooking.event.domain.EventCategory;
import com.ticketbooking.event.domain.Show;
import com.ticketbooking.event.domain.Venue;
import com.ticketbooking.event.repository.EventRepository;
import com.ticketbooking.event.repository.ShowRepository;
import com.ticketbooking.event.web.dto.CreateEventRequest;
import com.ticketbooking.event.web.dto.EventDetailResponse;
import com.ticketbooking.event.web.dto.EventSummaryResponse;
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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class EventServiceTest {

    @Mock
    private EventRepository eventRepository;

    @Mock
    private ShowRepository showRepository;

    @InjectMocks
    private EventService eventService;

    @Test
    void listEvents_withoutCategory_returnsAllEvents() {
        Event movie = new Event("The Great Adventure", EventCategory.MOVIE, "An action-packed journey.");
        when(eventRepository.findAll()).thenReturn(List.of(movie));

        List<EventSummaryResponse> result = eventService.listEvents(null);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).title()).isEqualTo("The Great Adventure");
        assertThat(result.get(0).category()).isEqualTo(EventCategory.MOVIE);
    }

    @Test
    void listEvents_withCategory_filtersByCategory() {
        Event concert = new Event("Coldplay Live", EventCategory.CONCERT, "World tour stop.");
        when(eventRepository.findByCategory(EventCategory.CONCERT)).thenReturn(List.of(concert));

        List<EventSummaryResponse> result = eventService.listEvents(EventCategory.CONCERT);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).category()).isEqualTo(EventCategory.CONCERT);
    }

    @Test
    void getEvent_whenFound_returnsDetailWithShows() {
        Event event = new Event("Neon Skyline", EventCategory.MOVIE, "A neo-noir thriller.");
        Venue venue = new Venue("INOX Garuda Mall", "Bengaluru", "Magrath Road");
        Show show = new Show(event, venue, Instant.parse("2026-09-02T19:00:00Z"), new BigDecimal("220.00"));
        UUID eventId = UUID.randomUUID();

        when(eventRepository.findById(eventId)).thenReturn(Optional.of(event));
        when(showRepository.findByEventId(eventId)).thenReturn(List.of(show));

        EventDetailResponse result = eventService.getEvent(eventId);

        assertThat(result.title()).isEqualTo("Neon Skyline");
        assertThat(result.shows()).hasSize(1);
        assertThat(result.shows().get(0).venueName()).isEqualTo("INOX Garuda Mall");
        assertThat(result.shows().get(0).basePrice()).isEqualByComparingTo("220.00");
    }

    @Test
    void getEvent_whenNotFound_throwsResourceNotFoundException() {
        UUID eventId = UUID.randomUUID();
        when(eventRepository.findById(eventId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> eventService.getEvent(eventId))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createEvent_savesAndReturnsSummary() {
        CreateEventRequest request = new CreateEventRequest("Live Laugh Roast", EventCategory.COMEDY, "Stand-up night.");
        Event saved = new Event(request.title(), request.category(), request.description());
        when(eventRepository.save(any(Event.class))).thenReturn(saved);

        EventSummaryResponse result = eventService.createEvent(request);

        assertThat(result.title()).isEqualTo("Live Laugh Roast");
        assertThat(result.category()).isEqualTo(EventCategory.COMEDY);
        verify(eventRepository).save(any(Event.class));
    }
}
