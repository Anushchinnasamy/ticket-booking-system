package com.ticketbooking.booking.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class RestClientConfig {

    @Bean
    public RestClient eventServiceRestClient(RestClient.Builder builder,
                                              @Value("${event-service.base-url}") String baseUrl) {
        return builder.baseUrl(baseUrl).build();
    }

    @Bean
    public RestClient paymentServiceRestClient(RestClient.Builder builder,
                                                @Value("${payment-service.base-url}") String baseUrl) {
        return builder.baseUrl(baseUrl).build();
    }
}
