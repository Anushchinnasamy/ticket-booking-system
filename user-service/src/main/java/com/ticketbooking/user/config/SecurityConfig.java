package com.ticketbooking.user.config;

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
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

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
                        // /error must be permitAll or a real 401/etc gets silently
                        // overwritten with 401-from-anonymous on Spring Boot's internal
                        // error forward (harmless when the original was already 401,
                        // but genuinely wrong for any other status).
                        .requestMatchers("/error").permitAll()
                        .requestMatchers("/actuator/**", "/auth/register", "/auth/login", "/auth/refresh",
                                "/auth/forgot-password", "/auth/reset-password", "/auth/otp/**").permitAll()
                        // Internal, service-to-service only (called by
                        // notification-service to resolve an email from a
                        // userId). Hardening this is Phase 8 territory, same
                        // as every other internal endpoint in this system.
                        .requestMatchers(HttpMethod.GET, "/users/*").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
