package com.ticketbooking.booking.client;

import com.ticketbooking.booking.ticketing.SeatDetails;
import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
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

    private final RestClient restClient;

    public EventServiceClient(RestClient eventServiceRestClient) {
        this.restClient = eventServiceRestClient;
    }

    /** Used to populate the ticket PDF with human-readable show/seat details. */
    public SeatDetails getSeatDetails(UUID showId, UUID seatId) {
        SeatMapResponse response = restClient.get()
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
