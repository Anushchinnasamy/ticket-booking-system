package com.ticketbooking.booking.ticketing;

import java.time.Instant;
import java.util.UUID;

public record SignedTicketPayload(UUID bookingId, UUID showId, UUID seatId, Instant issuedAt) {
}
