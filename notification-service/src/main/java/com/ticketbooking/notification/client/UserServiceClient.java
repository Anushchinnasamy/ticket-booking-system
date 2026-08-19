package com.ticketbooking.notification.client;

import com.ticketbooking.common.exception.ResourceNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.UUID;

@Component
public class UserServiceClient {

    private record UserSummaryResponse(UUID id, String email) {
    }

    private final RestClient userServiceRestClient;

    public UserServiceClient(RestClient userServiceRestClient) {
        this.userServiceRestClient = userServiceRestClient;
    }

    public String getEmail(UUID userId) {
        UserSummaryResponse response = userServiceRestClient.get()
                .uri("/users/{id}", userId)
                .retrieve()
                .body(UserSummaryResponse.class);
        if (response == null) {
            throw new ResourceNotFoundException("User not found: " + userId);
        }
        return response.email();
    }
}
