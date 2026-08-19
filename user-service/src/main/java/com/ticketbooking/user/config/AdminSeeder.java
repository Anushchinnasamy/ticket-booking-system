package com.ticketbooking.user.config;

import com.ticketbooking.user.domain.User;
import com.ticketbooking.user.domain.UserRole;
import com.ticketbooking.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/** Seeds one ADMIN account on startup so admin-gated endpoints are testable without a manual promotion step. */
@Component
public class AdminSeeder implements ApplicationRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final String adminEmail;
    private final String adminPassword;

    public AdminSeeder(UserRepository userRepository,
                        PasswordEncoder passwordEncoder,
                        @Value("${admin.seed.email}") String adminEmail,
                        @Value("${admin.seed.password}") String adminPassword) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.adminEmail = adminEmail;
        this.adminPassword = adminPassword;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (!userRepository.existsByEmail(adminEmail)) {
            userRepository.save(new User(adminEmail, passwordEncoder.encode(adminPassword), UserRole.ADMIN));
        }
    }
}
