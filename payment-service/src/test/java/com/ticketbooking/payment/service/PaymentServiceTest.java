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
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.DataIntegrityViolationException;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.anyString;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PaymentServiceTest {

    private static final String AUTH_HEADER = "Bearer test-token";

    @Mock
    private PaymentRepository paymentRepository;

    @Mock
    private RazorpayGatewayClient gatewayClient;

    @Mock
    private BookingServiceClient bookingServiceClient;

    private PaymentService paymentService;

    private PaymentService newService() {
        return new PaymentService(paymentRepository, gatewayClient, bookingServiceClient, "rzp_test_fake_key_id");
    }

    @Test
    void charge_whenNewIdempotencyKey_createsRazorpayOrderAndSavesPayment() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID callerUserId = UUID.randomUUID();
        ChargeRequest request = new ChargeRequest(bookingId, new BigDecimal("250.00"));
        String idempotencyKey = "idem-key-1";

        when(paymentRepository.findByIdempotencyKey(idempotencyKey)).thenReturn(Optional.empty());
        when(bookingServiceClient.getBooking(bookingId, AUTH_HEADER))
                .thenReturn(new BookingInfo(bookingId, UUID.randomUUID(), UUID.randomUUID(), callerUserId, "PENDING", Instant.now()));
        when(gatewayClient.createOrder(any(BigDecimal.class), anyString(), anyString())).thenReturn("order_test123");
        when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

        ChargeResponse result = paymentService.charge(idempotencyKey, request, callerUserId, AUTH_HEADER);

        assertThat(result.razorpayOrderId()).isEqualTo("order_test123");
        assertThat(result.status()).isEqualTo(PaymentStatus.INITIATED);
        verify(gatewayClient, times(1)).createOrder(any(BigDecimal.class), anyString(), anyString());
        verify(paymentRepository, times(1)).save(any(Payment.class));
    }

    @Test
    void charge_whenRetriedWithSameIdempotencyKey_neverCallsGatewayAgain_onlyOnePaymentRow() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID callerUserId = UUID.randomUUID();
        ChargeRequest request = new ChargeRequest(bookingId, new BigDecimal("250.00"));
        String idempotencyKey = "idem-key-retry";

        // First call: no existing row.
        when(paymentRepository.findByIdempotencyKey(idempotencyKey))
                .thenReturn(Optional.empty())
                .thenReturn(Optional.empty());
        when(bookingServiceClient.getBooking(bookingId, AUTH_HEADER))
                .thenReturn(new BookingInfo(bookingId, UUID.randomUUID(), UUID.randomUUID(), callerUserId, "PENDING", Instant.now()));
        when(gatewayClient.createOrder(any(BigDecimal.class), anyString(), anyString())).thenReturn("order_test123");
        Payment saved = new Payment(idempotencyKey, bookingId, request.amount(), "INR", "order_test123");
        when(paymentRepository.save(any(Payment.class))).thenReturn(saved);

        ChargeResponse first = paymentService.charge(idempotencyKey, request, callerUserId, AUTH_HEADER);

        // Second call (the retry): the row now exists.
        when(paymentRepository.findByIdempotencyKey(idempotencyKey)).thenReturn(Optional.of(saved));
        ChargeResponse second = paymentService.charge(idempotencyKey, request, callerUserId, AUTH_HEADER);

        assertThat(first.razorpayOrderId()).isEqualTo(second.razorpayOrderId());
        verify(gatewayClient, times(1)).createOrder(any(BigDecimal.class), anyString(), anyString());
        verify(paymentRepository, times(1)).save(any(Payment.class));
    }

    @Test
    void charge_whenBookingNotPending_throwsConflictWithoutCallingGateway() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID callerUserId = UUID.randomUUID();
        ChargeRequest request = new ChargeRequest(bookingId, new BigDecimal("250.00"));
        when(paymentRepository.findByIdempotencyKey(anyString())).thenReturn(Optional.empty());
        when(bookingServiceClient.getBooking(bookingId, AUTH_HEADER))
                .thenReturn(new BookingInfo(bookingId, UUID.randomUUID(), UUID.randomUUID(), callerUserId, "CONFIRMED", Instant.now()));

        assertThatThrownBy(() -> paymentService.charge("idem-key-2", request, callerUserId, AUTH_HEADER))
                .isInstanceOf(ConflictException.class);

        verifyNoInteractions(gatewayClient);
        verify(paymentRepository, never()).save(any(Payment.class));
    }

    @Test
    void charge_whenCallerDoesNotOwnBooking_throwsResourceNotFound() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        UUID callerUserId = UUID.randomUUID();
        ChargeRequest request = new ChargeRequest(bookingId, new BigDecimal("250.00"));
        when(paymentRepository.findByIdempotencyKey(anyString())).thenReturn(Optional.empty());
        when(bookingServiceClient.getBooking(bookingId, AUTH_HEADER))
                .thenReturn(new BookingInfo(bookingId, UUID.randomUUID(), UUID.randomUUID(), ownerId, "PENDING", Instant.now()));

        assertThatThrownBy(() -> paymentService.charge("idem-key-owner", request, callerUserId, AUTH_HEADER))
                .isInstanceOf(ResourceNotFoundException.class);

        verifyNoInteractions(gatewayClient);
        verify(paymentRepository, never()).save(any(Payment.class));
    }

    @Test
    void charge_whenConcurrentRaceOnSameKey_returnsTheWinningRowInsteadOfErroring() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID callerUserId = UUID.randomUUID();
        ChargeRequest request = new ChargeRequest(bookingId, new BigDecimal("250.00"));
        String idempotencyKey = "idem-key-race";

        when(paymentRepository.findByIdempotencyKey(idempotencyKey))
                .thenReturn(Optional.empty());
        when(bookingServiceClient.getBooking(bookingId, AUTH_HEADER))
                .thenReturn(new BookingInfo(bookingId, UUID.randomUUID(), UUID.randomUUID(), callerUserId, "PENDING", Instant.now()));
        when(gatewayClient.createOrder(any(BigDecimal.class), anyString(), anyString())).thenReturn("order_raced");
        when(paymentRepository.save(any(Payment.class))).thenThrow(new DataIntegrityViolationException("duplicate key"));
        Payment winner = new Payment(idempotencyKey, bookingId, request.amount(), "INR", "order_raced");
        when(paymentRepository.findByIdempotencyKey(idempotencyKey))
                .thenReturn(Optional.empty())
                .thenReturn(Optional.of(winner));

        ChargeResponse result = paymentService.charge(idempotencyKey, request, callerUserId, AUTH_HEADER);

        assertThat(result.razorpayOrderId()).isEqualTo("order_raced");
    }

    @Test
    void verify_whenSignatureValid_marksSuccessAndConfirmsBooking() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID paymentId = UUID.randomUUID();
        Payment payment = new Payment("idem-key-3", bookingId, new BigDecimal("250.00"), "INR", "order_abc");
        when(paymentRepository.findById(paymentId)).thenReturn(Optional.of(payment));
        when(gatewayClient.verifySignature("order_abc", "pay_xyz", "sig_valid")).thenReturn(true);
        when(paymentRepository.save(payment)).thenReturn(payment);

        PaymentResponse result = paymentService.verify(paymentId, new VerifyRequest("order_abc", "pay_xyz", "sig_valid"));

        assertThat(result.status()).isEqualTo(PaymentStatus.SUCCESS);
        assertThat(result.razorpayPaymentId()).isEqualTo("pay_xyz");
        verify(bookingServiceClient).confirmBooking(bookingId);
        verify(bookingServiceClient, never()).cancelBooking(any());
    }

    @Test
    void verify_whenSignatureInvalid_marksFailedAndCancelsBooking() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID paymentId = UUID.randomUUID();
        Payment payment = new Payment("idem-key-4", bookingId, new BigDecimal("250.00"), "INR", "order_abc");
        when(paymentRepository.findById(paymentId)).thenReturn(Optional.of(payment));
        when(gatewayClient.verifySignature("order_abc", "pay_xyz", "sig_bad")).thenReturn(false);
        when(paymentRepository.save(payment)).thenReturn(payment);

        PaymentResponse result = paymentService.verify(paymentId, new VerifyRequest("order_abc", "pay_xyz", "sig_bad"));

        assertThat(result.status()).isEqualTo(PaymentStatus.FAILED);
        verify(bookingServiceClient).cancelBooking(bookingId);
        verify(bookingServiceClient, never()).confirmBooking(any());
    }

    @Test
    void verify_whenAlreadyResolved_isIdempotentAndSkipsSideEffects() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID paymentId = UUID.randomUUID();
        Payment payment = new Payment("idem-key-5", bookingId, new BigDecimal("250.00"), "INR", "order_abc");
        payment.markSuccess("pay_already");
        when(paymentRepository.findById(paymentId)).thenReturn(Optional.of(payment));

        PaymentResponse result = paymentService.verify(paymentId, new VerifyRequest("order_abc", "pay_new", "sig_new"));

        assertThat(result.razorpayPaymentId()).isEqualTo("pay_already");
        verifyNoInteractions(gatewayClient);
        verifyNoInteractions(bookingServiceClient);
    }

    @Test
    void fail_whenInitiated_marksFailedAndCancelsBooking() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        UUID paymentId = UUID.randomUUID();
        Payment payment = new Payment("idem-key-6", bookingId, new BigDecimal("250.00"), "INR", "order_abc");
        when(paymentRepository.findById(paymentId)).thenReturn(Optional.of(payment));
        when(paymentRepository.save(payment)).thenReturn(payment);

        PaymentResponse result = paymentService.fail(paymentId, new FailRequest("card_declined"));

        assertThat(result.status()).isEqualTo(PaymentStatus.FAILED);
        verify(bookingServiceClient).cancelBooking(bookingId);
    }

    @Test
    void getPayment_whenNotFound_throwsResourceNotFoundException() {
        paymentService = newService();
        UUID paymentId = UUID.randomUUID();
        when(paymentRepository.findById(paymentId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> paymentService.getPayment(paymentId))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getPaymentForBooking_whenFound_returnsMostRecentPayment() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        Payment payment = new Payment("idem-key-7", bookingId, new BigDecimal("250.00"), "INR", "order_abc");
        when(paymentRepository.findFirstByBookingIdOrderByCreatedAtDesc(bookingId)).thenReturn(Optional.of(payment));

        PaymentResponse result = paymentService.getPaymentForBooking(bookingId);

        assertThat(result.bookingId()).isEqualTo(bookingId);
        assertThat(result.amount()).isEqualByComparingTo("250.00");
    }

    @Test
    void getPaymentForBooking_whenNotFound_throwsResourceNotFoundException() {
        paymentService = newService();
        UUID bookingId = UUID.randomUUID();
        when(paymentRepository.findFirstByBookingIdOrderByCreatedAtDesc(bookingId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> paymentService.getPaymentForBooking(bookingId))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
