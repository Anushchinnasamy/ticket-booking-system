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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class NotificationEventListener {

    private static final Logger log = LoggerFactory.getLogger(NotificationEventListener.class);

    private final EmailService emailService;
    private final UserServiceClient userServiceClient;
    private final EventServiceClient eventServiceClient;
    private final PaymentServiceClient paymentServiceClient;

    public NotificationEventListener(EmailService emailService, UserServiceClient userServiceClient,
                                      EventServiceClient eventServiceClient, PaymentServiceClient paymentServiceClient) {
        this.emailService = emailService;
        this.userServiceClient = userServiceClient;
        this.eventServiceClient = eventServiceClient;
        this.paymentServiceClient = paymentServiceClient;
    }

    @KafkaListener(topics = "booking-confirmed", groupId = "${spring.kafka.consumer.group-id}")
    public void onBookingConfirmed(BookingConfirmedEvent event) {
        String email = userServiceClient.getEmail(event.userId());
        SeatDetails seat = eventServiceClient.getSeatDetails(event.showId(), event.seatId());
        Optional<PaymentDetails> payment = paymentServiceClient.getPaymentForBooking(event.bookingId());
        String body = """
                Hi,

                Your booking is confirmed!

                Booking ID: %s
                Event:      %s
                Venue:      %s
                Show time:  %s
                Seat:       %s%d (%s)
                Amount paid: %s
                Confirmed:  %s

                Thanks for booking with us.
                """.formatted(event.bookingId(), seat.eventTitle(), seat.venueName(), seat.startTime(),
                seat.rowLabel(), seat.seatNumber(), seat.seatType(), formatPayment(payment), event.confirmedAt());
        emailService.send(email, "Your booking is confirmed", body);
    }

    @KafkaListener(topics = "booking-cancelled", groupId = "${spring.kafka.consumer.group-id}")
    public void onBookingCancelled(BookingCancelledEvent event) {
        String email = userServiceClient.getEmail(event.userId());
        SeatDetails seat = eventServiceClient.getSeatDetails(event.showId(), event.seatId());
        Optional<PaymentDetails> payment = paymentServiceClient.getPaymentForBooking(event.bookingId());
        String body = """
                Hi,

                Your booking has been cancelled.

                Booking ID: %s
                Event:      %s
                Venue:      %s
                Show time:  %s
                Seat:       %s%d (%s)
                Payment:    %s

                If you didn't request this, please contact support.
                """.formatted(event.bookingId(), seat.eventTitle(), seat.venueName(), seat.startTime(),
                seat.rowLabel(), seat.seatNumber(), seat.seatType(), formatCancelledPayment(payment),
                event.cancelledAt());
        emailService.send(email, "Your booking has been cancelled", body);
    }

    private String formatPayment(Optional<PaymentDetails> payment) {
        return payment.map(p -> "%s %s (%s)".formatted(p.currency(), p.amount(), p.status()))
                .orElse("No payment on record");
    }

    private String formatCancelledPayment(Optional<PaymentDetails> payment) {
        return payment.map(p -> "%s %s was charged (status: %s). Refunds are handled separately by our support team."
                        .formatted(p.currency(), p.amount(), p.status()))
                .orElse("No payment was charged for this booking.");
    }

    @KafkaListener(topics = "password-reset-requested", groupId = "${spring.kafka.consumer.group-id}")
    public void onPasswordResetRequested(PasswordResetRequestedEvent event) {
        String body = """
                Hi,

                We received a request to reset your password. Use the token below \
                with POST /auth/reset-password before it expires:

                %s

                Expires at: %s

                If you didn't request this, you can safely ignore this email.
                """.formatted(event.rawToken(), event.expiresAt());
        emailService.send(event.email(), "Reset your password", body);
    }

    @KafkaListener(topics = "otp-requested", groupId = "${spring.kafka.consumer.group-id}")
    public void onOtpRequested(OtpRequestedEvent event) {
        String body = """
                Hi,

                Your one-time login code is:

                %s

                Expires at: %s. It can only be used once.
                """.formatted(event.otp(), event.expiresAt());
        emailService.send(event.email(), "Your one-time login code", body);
    }

    /**
     * No email — this event carries no recipient (a catalog-wide seat
     * change, not tied to one user's inbox). Consumed anyway so consumer
     * lag on this topic stays visible, and as a hook for a future
     * real-time seat-map feature.
     */
    @KafkaListener(topics = "seat-status-changed", groupId = "${spring.kafka.consumer.group-id}")
    public void onSeatStatusChanged(SeatStatusChangedEvent event) {
        log.info("Seat {} for show {} is now {}", event.seatId(), event.showId(), event.status());
    }
}
