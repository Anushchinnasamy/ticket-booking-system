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
                        // Public — this is the URL opened from a shared ticket
                        // link (e.g. WhatsApp); the recipient has no account.
                        .requestMatchers(HttpMethod.GET, "/t/*").permitAll()
                        // Gate/staff app only — scans a QR and posts it here.
                        // The endpoint's real security is the HMAC signature
                        // check inside TicketService, but role-gating it too
                        // keeps random authenticated customers from hitting it.
                        .requestMatchers(HttpMethod.POST, "/tickets/redeem").hasAnyRole("COUNTER_STAFF", "ADMIN")
                        // Counter/gate staff booking a walk-up customer directly,
                        // skipping payment — same role gate as ticket redemption.
                        .requestMatchers(HttpMethod.POST, "/bookings/counter-sale").hasAnyRole("COUNTER_STAFF", "ADMIN")
                        .anyRequest().authenticated())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
