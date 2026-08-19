package com.ticketbooking.notification.client;

import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Component
public class EventServiceClient {

    private record SeatMapResponse(UUID showId, String eventTitle, String venueName, Instant startTime,
                                    BigDecimal basePrice, List<SeatEntry> seats) {
    }

    private record SeatEntry(UUID id, String rowLabel, int seatNumber, String seatType, BigDecimal price,
                              String status) {
    }

    private final RestClient eventServiceRestClient;

    public EventServiceClient(RestClient eventServiceRestClient) {
        this.eventServiceRestClient = eventServiceRestClient;
    }

    public SeatDetails getSeatDetails(UUID showId, UUID seatId) {
        SeatMapResponse response = eventServiceRestClient.get()
                .uri("/shows/{showId}/seats", showId)
                .retrieve()
                .body(SeatMapResponse.class);
        if (response == null) {
            throw new ResourceNotFoundException("Show not found: " + showId);
        }
        SeatEntry seat = response.seats().stream()
                .filter(s -> s.id().equals(seatId))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));
        return new SeatDetails(response.eventTitle(), response.venueName(), response.startTime(),
                seat.rowLabel(), seat.seatNumber(), seat.seatType(), seat.price());
    }
}
