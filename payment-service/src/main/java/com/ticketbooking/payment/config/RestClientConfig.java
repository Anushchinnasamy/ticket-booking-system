package com.ticketbooking.payment.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.ClientHttpRequestFactories;
import org.springframework.boot.web.client.ClientHttpRequestFactorySettings;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

import java.time.Duration;

@Configuration
public class RestClientConfig {

    /**
     * A circuit breaker alone doesn't make a hung (not merely unreachable)
     * booking-service fail fast — without a bounded read timeout, a call
     * that never gets a response would hang indefinitely regardless of
     * breaker state. Both together are what "fail fast" actually requires.
     */
    @Bean
    public RestClient bookingServiceRestClient(RestClient.Builder builder,
                                                @Value("${booking-service.base-url}") String baseUrl) {
        ClientHttpRequestFactorySettings settings = ClientHttpRequestFactorySettings.DEFAULTS
                .withConnectTimeout(Duration.ofSeconds(2))
                .withReadTimeout(Duration.ofSeconds(3));
        return builder.baseUrl(baseUrl)
                .requestFactory(ClientHttpRequestFactories.get(settings))
                .build();
    }
}
