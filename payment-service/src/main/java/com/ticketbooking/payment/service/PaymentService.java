package com.ticketbooking.payment.service;

import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.payment.client.BookingInfo;
import com.ticketbooking.payment.client.BookingServiceClient;
import com.ticketbooking.payment.domain.Payment;
import com.ticketbooking.payment.domain.PaymentStatus;
import com.ticketbooking.payment.gateway.RazorpayGatewayClient;
import com.ticketbooking.payment.repository.PaymentRepository;
import com.ticketbooking.payment.web.dto.ChargeRequest;
import com.ticketbooking.payment.web.dto.ChargeResponse;
import com.ticketbooking.payment.web.dto.FailRequest;
import com.ticketbooking.payment.web.dto.PaymentResponse;
import com.ticketbooking.payment.web.dto.VerifyRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.UUID;

@Service
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final RazorpayGatewayClient gatewayClient;
    private final BookingServiceClient bookingServiceClient;
    private final String razorpayKeyId;

    public PaymentService(PaymentRepository paymentRepository,
                           RazorpayGatewayClient gatewayClient,
                           BookingServiceClient bookingServiceClient,
                           @Value("${razorpay.key-id}") String razorpayKeyId) {
        this.paymentRepository = paymentRepository;
        this.gatewayClient = gatewayClient;
        this.bookingServiceClient = bookingServiceClient;
        this.razorpayKeyId = razorpayKeyId;
    }

    /**
     * Idempotency key is checked first — a retried request with the same key
     * returns the stored result instead of creating a second Razorpay order.
     * Not wrapped in a transaction: the booking lookup and the Razorpay order
     * creation are both network round trips that must resolve before any
     * local row is written.
     *
     * <p>{@code authorizationHeader} is the caller's own bearer token,
     * forwarded to booking-service so its normal ownership check applies —
     * see {@link BookingServiceClient#getBooking}. A caller who doesn't own
     * the booking gets the same 404 booking-service itself would give a
     * non-owner, not a 403 — consistent with the anti-enumeration approach
     * used throughout this system.
     */
    public ChargeResponse charge(String idempotencyKey, ChargeRequest request, UUID callerUserId, String authorizationHeader) {
        Optional<Payment> existing = paymentRepository.findByIdempotencyKey(idempotencyKey);
        if (existing.isPresent()) {
            return toChargeResponse(existing.get());
        }

        BookingInfo booking = bookingServiceClient.getBooking(request.bookingId(), authorizationHeader);
        if (!booking.userId().equals(callerUserId)) {
            throw new ResourceNotFoundException("Booking not found: " + request.bookingId());
        }
        if (!"PENDING".equals(booking.status())) {
            throw new ConflictException("Booking is not PENDING: " + request.bookingId());
        }

        String razorpayOrderId = gatewayClient.createOrder(request.amount(), "INR", idempotencyKey);

        Payment payment = new Payment(idempotencyKey, request.bookingId(), request.amount(), "INR", razorpayOrderId);
        Payment saved;
        try {
            saved = paymentRepository.save(payment);
        } catch (DataIntegrityViolationException e) {
            // Lost a race against a concurrent retry with the same key — the
            // unique constraint on idempotency_key caught what our check above
            // couldn't. Return whichever row actually won instead of erroring.
            saved = paymentRepository.findByIdempotencyKey(idempotencyKey).orElseThrow(() -> e);
        }
        return toChargeResponse(saved);
    }

    @Transactional(readOnly = true)
    public PaymentResponse getPayment(UUID id) {
        Payment payment = findOrThrow(id);
        return toResponse(payment);
    }

    /** Internal, service-to-service only — see the equivalent note in event-service's SecurityConfig. */
    @Transactional(readOnly = true)
    public PaymentResponse getPaymentForBooking(UUID bookingId) {
        Payment payment = paymentRepository.findFirstByBookingIdOrderByCreatedAtDesc(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("No payment found for booking: " + bookingId));
        return toResponse(payment);
    }

    /** Called by the checkout flow once Razorpay returns a signed success callback. */
    public PaymentResponse verify(UUID id, VerifyRequest request) {
        Payment payment = findOrThrow(id);

        if (payment.getStatus() != PaymentStatus.INITIATED) {
            return toResponse(payment);
        }

        boolean valid = payment.getRazorpayOrderId().equals(request.razorpayOrderId())
                && gatewayClient.verifySignature(request.razorpayOrderId(), request.razorpayPaymentId(), request.razorpaySignature());

        if (valid) {
            payment.markSuccess(request.razorpayPaymentId());
            paymentRepository.save(payment);
            bookingServiceClient.confirmBooking(payment.getBookingId());
        } else {
            payment.markFailed();
            paymentRepository.save(payment);
            bookingServiceClient.cancelBooking(payment.getBookingId());
        }
        return toResponse(payment);
    }

    /**
     * Called by booking-service when a customer cancels an already-paid
     * booking. Idempotent — a payment that's already REFUNDED returns the
     * stored result instead of calling Razorpay's refund API a second time,
     * same "check first" principle as {@link #charge}. Only a SUCCESS
     * payment can be refunded; anything else is a genuine conflict (nothing
     * was actually charged, or it already failed) rather than something to
     * silently tolerate.
     */
    public PaymentResponse refundForBooking(UUID bookingId) {
        Payment payment = paymentRepository.findFirstByBookingIdOrderByCreatedAtDesc(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("No payment found for booking: " + bookingId));

        if (payment.getStatus() == PaymentStatus.REFUNDED) {
            return toResponse(payment);
        }
        if (payment.getStatus() != PaymentStatus.SUCCESS) {
            throw new ConflictException("Cannot refund a payment that was not successful: " + payment.getStatus());
        }

        String refundId = gatewayClient.refund(payment.getRazorpayPaymentId(), payment.getAmount());
        payment.markRefunded(refundId);
        paymentRepository.save(payment);
        return toResponse(payment);
    }

    /** Called by the checkout flow's failure handler (declined card, cancelled payment, etc). */
    public PaymentResponse fail(UUID id, FailRequest request) {
        Payment payment = findOrThrow(id);

        if (payment.getStatus() != PaymentStatus.INITIATED) {
            return toResponse(payment);
        }

        payment.markFailed();
        paymentRepository.save(payment);
        bookingServiceClient.cancelBooking(payment.getBookingId());
        return toResponse(payment);
    }

    private Payment findOrThrow(UUID id) {
        return paymentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found: " + id));
    }

    private ChargeResponse toChargeResponse(Payment payment) {
        return new ChargeResponse(
                payment.getId(),
                payment.getBookingId(),
                payment.getAmount(),
                payment.getCurrency(),
                payment.getStatus(),
                payment.getRazorpayOrderId(),
                razorpayKeyId);
    }

    private PaymentResponse toResponse(Payment payment) {
        return new PaymentResponse(
                payment.getId(),
                payment.getBookingId(),
                payment.getAmount(),
                payment.getCurrency(),
                payment.getStatus(),
                payment.getRazorpayOrderId(),
                payment.getRazorpayPaymentId(),
                payment.getCreatedAt());
    }
}
