package com.ticketbooking.booking.config;

import com.ticketbooking.common.security.JwtAuthenticationFilter;
import com.ticketbooking.common.security.JwtService;
import com.ticketbooking.common.security.RestAccessDeniedHandler;
import com.ticketbooking.common.security.RestAuthenticationEntryPoint;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public JwtService jwtService(@Value("${jwt.secret}") String secret) {
        return new JwtService(secret);
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter(JwtService jwtService) {
        return new JwtAuthenticationFilter(jwtService);
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationFilter jwtAuthenticationFilter) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint(new RestAuthenticationEntryPoint())
                        .accessDeniedHandler(new RestAccessDeniedHandler()))
                .authorizeHttpRequests(auth -> auth
                        // See the identical note in event-service's SecurityConfig:
                        // OncePerRequestFilter skips ERROR dispatches by default, so
                        // /error must be permitAll or a real 403/etc gets silently
                        // overwritten with 401 on Spring Boot's internal error forward.
                        .requestMatchers("/error").permitAll()
                        .requestMatchers("/actuator/**").permitAll()
                        // Internal, service-to-service only (called by payment-service).
                        // See the equivalent note in event-service's SecurityConfig —
                        // hardening these is Phase 8 API Gateway territory.
                        .requestMatchers(HttpMethod.POST, "/bookings/*/confirm", "/bookings/*/cancel").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
