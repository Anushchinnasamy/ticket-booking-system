package com.ticketbooking.booking.waitlist;

import com.ticketbooking.common.event.BookingCancelledEvent;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class WaitlistEventListener {

    private final WaitlistService waitlistService;

    public WaitlistEventListener(WaitlistService waitlistService) {
        this.waitlistService = waitlistService;
    }

    /**
     * Independent consumer of the same booking-cancelled event Notification
     * service consumes — a separate listener within the same consumer group
     * as TicketEventListener, since it's a different topic and never
     * competes for the same partitions.
     */
    @KafkaListener(topics = "booking-cancelled", groupId = "${spring.kafka.consumer.group-id}")
    public void onBookingCancelled(BookingCancelledEvent event) {
        waitlistService.promoteNext(event.showId(), event.seatId());
    }
}
