package com.ticketbooking.payment.client;

import com.ticketbooking.common.exception.ResourceNotFoundException;
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

    public BookingInfo getBooking(UUID bookingId) {
        try {
            return restClient.get()
                    .uri("/bookings/{id}", bookingId)
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
