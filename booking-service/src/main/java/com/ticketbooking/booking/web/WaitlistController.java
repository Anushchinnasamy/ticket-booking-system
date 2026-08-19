package com.ticketbooking.booking.web;

import com.ticketbooking.booking.waitlist.WaitlistService;
import com.ticketbooking.booking.web.dto.WaitlistResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/shows/{showId}/waitlist")
public class WaitlistController {

    private final WaitlistService waitlistService;

    public WaitlistController(WaitlistService waitlistService) {
        this.waitlistService = waitlistService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public WaitlistResponse join(@PathVariable UUID showId, Authentication authentication) {
        return waitlistService.join(showId, UUID.fromString(authentication.getName()));
    }
}
