package com.ticketbooking.event.config;

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
                        // OncePerRequestFilter (which JwtAuthenticationFilter extends)
                        // skips ERROR dispatches by default, so when a 403/other error
                        // triggers Spring Boot's internal forward to /error, our filter
                        // doesn't re-authenticate that second pass. Without this
                        // permitAll, an unauthenticated-looking /error dispatch would
                        // itself get rejected and silently overwrite the real status
                        // code with 401.
                        .requestMatchers("/error").permitAll()
                        .requestMatchers("/actuator/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/events", "/events/**", "/shows/**").permitAll()
                        // Internal, service-to-service only (called by booking-service).
                        // Not hardened with its own auth yet — see Phase 8 API Gateway,
                        // which is where edge/network hardening for internal endpoints
                        // like these belongs.
                        .requestMatchers(HttpMethod.POST, "/shows/*/seats/*/lock", "/shows/*/seats/*/claim",
                                "/shows/*/seats/*/release", "/shows/*/seats/*/book").permitAll()
                        .requestMatchers(HttpMethod.POST, "/events").hasRole("ADMIN")
                        .anyRequest().authenticated())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
