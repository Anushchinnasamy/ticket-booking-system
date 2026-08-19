package com.ticketbooking.notification.listener;

import com.ticketbooking.common.event.BookingCancelledEvent;
import com.ticketbooking.common.event.BookingConfirmedEvent;
import com.ticketbooking.common.event.OtpRequestedEvent;
import com.ticketbooking.common.event.PasswordResetRequestedEvent;
import com.ticketbooking.common.event.SeatStatusChangedEvent;
import com.ticketbooking.notification.client.EventServiceClient;
import com.ticketbooking.notification.client.PaymentDetails;
import com.ticketbooking.notification.client.PaymentServiceClient;
import com.ticketbooking.notification.client.SeatDetails;
import com.ticketbooking.notification.client.UserServiceClient;
import com.ticketbooking.notification.service.EmailService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class NotificationEventListenerTest {

    @Mock
    private EmailService emailService;

    @Mock
    private UserServiceClient userServiceClient;

    @Mock
    private EventServiceClient eventServiceClient;

    @Mock
    private PaymentServiceClient paymentServiceClient;

    private NotificationEventListener listener() {
        return new NotificationEventListener(emailService, userServiceClient, eventServiceClient, paymentServiceClient);
    }

    private static SeatDetails sampleSeat() {
        return new SeatDetails("Test Concert", "Test Arena", Instant.now(), "A", 12, "PREMIUM", new BigDecimal("500.00"));
    }

    @Test
    void onBookingConfirmed_resolvesEmailSeatAndPaymentThenSends() {
        UUID userId = UUID.randomUUID();
        BookingConfirmedEvent event = new BookingConfirmedEvent(
                UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(), userId, Instant.now());
        when(userServiceClient.getEmail(userId)).thenReturn("a@b.com");
        when(eventServiceClient.getSeatDetails(event.showId(), event.seatId())).thenReturn(sampleSeat());
        when(paymentServiceClient.getPaymentForBooking(event.bookingId()))
                .thenReturn(Optional.of(new PaymentDetails(new BigDecimal("500.00"), "INR", "SUCCESS")));

        listener().onBookingConfirmed(event);

        ArgumentCaptor<String> bodyCaptor = ArgumentCaptor.forClass(String.class);
        verify(emailService).send(eq("a@b.com"), eq("Your booking is confirmed"), bodyCaptor.capture());
        String body = bodyCaptor.getValue();
        assertThat(body).contains(event.bookingId().toString());
        assertThat(body).contains("Test Concert");
        assertThat(body).contains("Test Arena");
        assertThat(body).contains("A12");
        assertThat(body).contains("INR 500.00 (SUCCESS)");
    }

    @Test
    void onBookingCancelled_whenNoPaymentOnRecord_saysSoInsteadOfAmount() {
        UUID userId = UUID.randomUUID();
        BookingCancelledEvent event = new BookingCancelledEvent(
                UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(), userId, Instant.now());
        when(userServiceClient.getEmail(userId)).thenReturn("a@b.com");
        when(eventServiceClient.getSeatDetails(event.showId(), event.seatId())).thenReturn(sampleSeat());
        when(paymentServiceClient.getPaymentForBooking(event.bookingId())).thenReturn(Optional.empty());

        listener().onBookingCancelled(event);

        ArgumentCaptor<String> bodyCaptor = ArgumentCaptor.forClass(String.class);
        verify(emailService).send(eq("a@b.com"), eq("Your booking has been cancelled"), bodyCaptor.capture());
        assertThat(bodyCaptor.getValue()).contains("No payment was charged for this booking.");
    }

    @Test
    void onPasswordResetRequested_sendsToEventEmailWithoutUserLookup() {
        PasswordResetRequestedEvent event = new PasswordResetRequestedEvent(
                "reset@example.com", "raw-token-123", Instant.now().plusSeconds(900));

        listener().onPasswordResetRequested(event);

        ArgumentCaptor<String> bodyCaptor = ArgumentCaptor.forClass(String.class);
        verify(emailService).send(eq("reset@example.com"), eq("Reset your password"), bodyCaptor.capture());
        assertThat(bodyCaptor.getValue()).contains("raw-token-123");
        verifyNoInteractions(userServiceClient, eventServiceClient, paymentServiceClient);
    }

    @Test
    void onOtpRequested_sendsToEventEmailWithoutUserLookup() {
        OtpRequestedEvent event = new OtpRequestedEvent("otp@example.com", "482913", Instant.now().plusSeconds(300));

        listener().onOtpRequested(event);

        ArgumentCaptor<String> bodyCaptor = ArgumentCaptor.forClass(String.class);
        verify(emailService).send(eq("otp@example.com"), eq("Your one-time login code"), bodyCaptor.capture());
        assertThat(bodyCaptor.getValue()).contains("482913");
        verifyNoInteractions(userServiceClient, eventServiceClient, paymentServiceClient);
    }

    @Test
    void onSeatStatusChanged_doesNotSendEmail() {
        SeatStatusChangedEvent event = new SeatStatusChangedEvent(
                UUID.randomUUID(), UUID.randomUUID(), "LOCKED", Instant.now());

        listener().onSeatStatusChanged(event);

        verifyNoInteractions(emailService, userServiceClient, eventServiceClient, paymentServiceClient);
    }
}
