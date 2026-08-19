package com.ticketbooking.booking.client;

import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;

import java.util.UUID;

@Component
public class EventServiceClient {

    private final RestClient restClient;

    public EventServiceClient(RestClient eventServiceRestClient) {
        this.restClient = eventServiceRestClient;
    }

    /**
     * Calls Event Service's {@code SELECT ... FOR UPDATE}-backed lock
     * endpoint. Throws {@link ConflictException} if the seat is not
     * AVAILABLE, {@link ResourceNotFoundException} if the show/seat doesn't
     * exist.
     */
    public void lockSeat(UUID showId, UUID seatId) {
        try {
            restClient.post()
                    .uri("/shows/{showId}/seats/{seatId}/lock", showId, seatId)
                    .retrieve()
                    .toBodilessEntity();
        } catch (HttpClientErrorException.Conflict ex) {
            throw new ConflictException("Seat is not available: " + seatId);
        } catch (HttpClientErrorException.NotFound ex) {
            throw new ResourceNotFoundException("Show or seat not found: " + showId + "/" + seatId);
        }
    }
}
