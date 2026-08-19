package com.ticketbooking.payment.client;

import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;

import java.util.UUID;

@Component
public class BookingServiceClient {

    private final RestClient restClient;

    public BookingServiceClient(RestClient bookingServiceRestClient) {
        this.restClient = bookingServiceRestClient;
    }

    /**
     * Forwards the caller's own bearer token rather than calling as an
     * unauthenticated "internal" request — booking-service's normal
     * ownership check (does this booking belong to the token's subject)
     * then applies unchanged, so payment-service never needs to see or
     * bypass that check itself.
     */
    public BookingInfo getBooking(UUID bookingId, String authorizationHeader) {
        try {
            return restClient.get()
                    .uri("/bookings/{id}", bookingId)
                    .header(HttpHeaders.AUTHORIZATION, authorizationHeader)
                    .retrieve()
                    .body(BookingInfo.class);
        } catch (HttpClientErrorException.NotFound ex) {
            throw new ResourceNotFoundException("Booking not found: " + bookingId);
        }
    }

    /** Called on successful payment: booking-service moves PENDING -> CONFIRMED and books the seat. */
    public void confirmBooking(UUID bookingId) {
        try {
            restClient.post()
                    .uri("/bookings/{id}/confirm", bookingId)
                    .retrieve()
                    .toBodilessEntity();
        } catch (HttpClientErrorException.NotFound ex) {
            throw new ResourceNotFoundException("Booking not found: " + bookingId);
        }
    }

    /** Compensating step on failed payment: releases the seat lock and cancels the booking. */
    public void cancelBooking(UUID bookingId) {
        try {
            restClient.post()
                    .uri("/bookings/{id}/cancel", bookingId)
                    .retrieve()
                    .toBodilessEntity();
        } catch (HttpClientErrorException.NotFound ex) {
            throw new ResourceNotFoundException("Booking not found: " + bookingId);
        }
    }
}
