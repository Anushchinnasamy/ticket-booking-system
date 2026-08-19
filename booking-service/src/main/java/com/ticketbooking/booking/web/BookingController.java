package com.ticketbooking.booking.web;

import com.ticketbooking.booking.service.BookingService;
import com.ticketbooking.booking.web.dto.BookingResponse;
import com.ticketbooking.booking.web.dto.CreateBookingRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/bookings")
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public BookingResponse createBooking(@Valid @RequestBody CreateBookingRequest request, Authentication authentication) {
        return bookingService.createBooking(request, UUID.fromString(authentication.getName()));
    }

    @GetMapping("/{id}")
    public BookingResponse getBooking(@PathVariable UUID id, Authentication authentication) {
        UUID requestingUserId = UUID.fromString(authentication.getName());
        boolean isAdmin = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch("ROLE_ADMIN"::equals);
        return bookingService.getBooking(id, requestingUserId, isAdmin);
    }

    /** Called by payment-service once a charge succeeds. */
    @PostMapping("/{id}/confirm")
    public BookingResponse confirmBooking(@PathVariable UUID id) {
        return bookingService.confirmBooking(id);
    }

    /** Called by payment-service on a failed charge (the compensating step). */
    @PostMapping("/{id}/cancel")
    public BookingResponse cancelBooking(@PathVariable UUID id) {
        return bookingService.cancelBooking(id);
    }
}
