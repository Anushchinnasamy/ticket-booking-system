package com.ticketbooking.payment.web;

import com.ticketbooking.payment.service.PaymentService;
import com.ticketbooking.payment.web.dto.ChargeRequest;
import com.ticketbooking.payment.web.dto.ChargeResponse;
import com.ticketbooking.payment.web.dto.FailRequest;
import com.ticketbooking.payment.web.dto.PaymentResponse;
import com.ticketbooking.payment.web.dto.VerifyRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/payments")
public class PaymentController {

    private final PaymentService paymentService;

    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @PostMapping("/charge")
    @ResponseStatus(HttpStatus.CREATED)
    public ChargeResponse charge(@RequestHeader("Idempotency-Key") String idempotencyKey,
                                  @RequestHeader("Authorization") String authorization,
                                  @Valid @RequestBody ChargeRequest request,
                                  Authentication authentication) {
        UUID callerUserId = UUID.fromString(authentication.getName());
        return paymentService.charge(idempotencyKey, request, callerUserId, authorization);
    }

    @GetMapping("/{id}")
    public PaymentResponse getPayment(@PathVariable UUID id) {
        return paymentService.getPayment(id);
    }

    /** Internal, service-to-service only — called by notification-service to enrich booking emails. */
    @GetMapping("/booking/{bookingId}")
    public PaymentResponse getPaymentForBooking(@PathVariable UUID bookingId) {
        return paymentService.getPaymentForBooking(bookingId);
    }

    @PostMapping("/{id}/verify")
    public PaymentResponse verify(@PathVariable UUID id, @Valid @RequestBody VerifyRequest request) {
        return paymentService.verify(id, request);
    }

    @PostMapping("/{id}/fail")
    public PaymentResponse fail(@PathVariable UUID id, @RequestBody(required = false) FailRequest request) {
        return paymentService.fail(id, request != null ? request : new FailRequest(null));
    }
}
