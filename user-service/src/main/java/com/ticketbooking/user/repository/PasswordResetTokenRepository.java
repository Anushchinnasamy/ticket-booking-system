package com.ticketbooking.user.repository;

import com.ticketbooking.user.domain.PasswordResetToken;
import com.ticketbooking.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, UUID> {

    Optional<PasswordResetToken> findByTokenHash(String tokenHash);

    List<PasswordResetToken> findByUserAndUsedFalse(User user);
}
