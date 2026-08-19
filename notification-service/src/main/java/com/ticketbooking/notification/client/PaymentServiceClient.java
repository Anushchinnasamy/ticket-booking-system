package com.ticketbooking.notification.client;

import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;

import java.math.BigDecimal;
import java.util.Optional;
import java.util.UUID;

@Component
public class PaymentServiceClient {

    private record PaymentResponse(UUID id, UUID bookingId, BigDecimal amount, String currency, String status) {
    }

    private final RestClient paymentServiceRestClient;

    public PaymentServiceClient(RestClient paymentServiceRestClient) {
        this.paymentServiceRestClient = paymentServiceRestClient;
    }

    /** Empty when no payment was ever initiated for this booking (e.g. an expired hold, swept before checkout). */
    public Optional<PaymentDetails> getPaymentForBooking(UUID bookingId) {
        try {
            PaymentResponse response = paymentServiceRestClient.get()
                    .uri("/payments/booking/{bookingId}", bookingId)
                    .retrieve()
                    .body(PaymentResponse.class);
            return Optional.ofNullable(response)
                    .map(r -> new PaymentDetails(r.amount(), r.currency(), r.status()));
        } catch (HttpClientErrorException.NotFound ex) {
            return Optional.empty();
        }
    }
}
