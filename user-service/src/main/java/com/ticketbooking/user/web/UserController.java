package com.ticketbooking.user.web;

import com.ticketbooking.user.service.AuthService;
import com.ticketbooking.user.web.dto.UserSummaryResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/users")
public class UserController {

    private final AuthService authService;

    public UserController(AuthService authService) {
        this.authService = authService;
    }

    /** Internal, service-to-service only — see the equivalent note in event-service's SecurityConfig. */
    @GetMapping("/{id}")
    public UserSummaryResponse getUser(@PathVariable UUID id) {
        return authService.getUserSummary(id);
    }
}
