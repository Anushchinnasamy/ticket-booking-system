package com.ticketbooking.booking.ticketing;

import com.ticketbooking.booking.domain.BookingStatus;

import java.util.UUID;

/** What the public, unauthenticated {@code GET /t/{shareToken}} page renders. */
public record SharedTicketView(UUID bookingId, BookingStatus status, SeatDetails seat, String qrPngBase64) {
}
