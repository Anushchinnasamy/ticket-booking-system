package com.ticketbooking.payment.gateway;

/** Thrown when a call to Razorpay itself fails (network, 5xx, malformed response). */
public class PaymentGatewayException extends RuntimeException {

    public PaymentGatewayException(String message, Throwable cause) {
        super(message, cause);
    }
}
