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
     * Marks a seat LOCKED. Safe to call only once the caller already holds
     * the Redis distributed lock for this seat (see SeatLockService) — this
     * endpoint does no DB-level locking of its own. Throws
     * {@link ConflictException} if the seat is not AVAILABLE,
     * {@link ResourceNotFoundException} if the show/seat doesn't exist.
     */
    public void claimSeat(UUID showId, UUID seatId) {
        try {
            restClient.post()
                    .uri("/shows/{showId}/seats/{seatId}/claim", showId, seatId)
                    .retrieve()
                    .toBodilessEntity();
        } catch (HttpClientErrorException.Conflict ex) {
            throw new ConflictException("Seat is not available: " + seatId);
        } catch (HttpClientErrorException.NotFound ex) {
            throw new ResourceNotFoundException("Show or seat not found: " + showId + "/" + seatId);
        }
    }

    /**
     * Releases a seat back to AVAILABLE. Used by the stale-booking sweep to
     * free seats whose reservation hold expired without confirmation.
     */
    public void releaseSeat(UUID showId, UUID seatId) {
        try {
            restClient.post()
                    .uri("/shows/{showId}/seats/{seatId}/release", showId, seatId)
                    .retrieve()
                    .toBodilessEntity();
        } catch (HttpClientErrorException.NotFound ex) {
            throw new ResourceNotFoundException("Show or seat not found: " + showId + "/" + seatId);
        }
    }

    /** Finalizes a seat as BOOKED. Called once payment-service confirms a successful charge. */
    public void bookSeat(UUID showId, UUID seatId) {
        try {
            restClient.post()
                    .uri("/shows/{showId}/seats/{seatId}/book", showId, seatId)
                    .retrieve()
                    .toBodilessEntity();
        } catch (HttpClientErrorException.Conflict ex) {
            throw new ConflictException("Seat is not locked, cannot book: " + seatId);
        } catch (HttpClientErrorException.NotFound ex) {
            throw new ResourceNotFoundException("Show or seat not found: " + showId + "/" + seatId);
        }
    }
}
