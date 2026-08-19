package com.ticketbooking.booking.ticketing;

import com.ticketbooking.common.event.BookingConfirmedEvent;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class TicketEventListener {

    private final TicketService ticketService;

    public TicketEventListener(TicketService ticketService) {
        this.ticketService = ticketService;
    }

    /**
     * Independent consumer of the same booking-confirmed event Notification
     * service consumes in Phase 6 — a separate consumer group so this never
     * competes with or blocks on notification-service's own processing.
     */
    @KafkaListener(topics = "booking-confirmed", groupId = "${spring.kafka.consumer.group-id}")
    public void onBookingConfirmed(BookingConfirmedEvent event) {
        ticketService.generateTicket(event);
    }
}
