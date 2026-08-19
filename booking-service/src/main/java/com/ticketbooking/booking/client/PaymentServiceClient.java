package com.ticketbooking.booking.client;

import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;

import java.util.UUID;

/**
 * The one synchronous dependency booking-service has on payment-service —
 * used only by customer-initiated cancellation of an already-paid booking,
 * where the refund must succeed before the booking is actually cancelled
 * (see BookingService.cancelConfirmedBooking).
 */
@Component
public class PaymentServiceClient {

    private final RestClient restClient;

    public PaymentServiceClient(RestClient paymentServiceRestClient) {
        this.restClient = paymentServiceRestClient;
    }

    /** Refunds the most recent payment for a booking. Idempotent on payment-service's side — safe to call more than once. */
    public void refundBooking(UUID bookingId) {
        try {
            restClient.post()
                    .uri("/payments/booking/{bookingId}/refund", bookingId)
                    .retrieve()
                    .toBodilessEntity();
        } catch (HttpClientErrorException.NotFound ex) {
            throw new ResourceNotFoundException("No payment found for booking: " + bookingId);
        } catch (HttpClientErrorException.Conflict ex) {
            throw new ConflictException("Refund not possible for booking: " + bookingId);
        }
    }
}
