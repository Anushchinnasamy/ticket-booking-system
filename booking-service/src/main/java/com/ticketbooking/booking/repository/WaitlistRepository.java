package com.ticketbooking.booking.repository;

import com.ticketbooking.booking.domain.Waitlist;
import com.ticketbooking.booking.domain.WaitlistStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface WaitlistRepository extends JpaRepository<Waitlist, UUID> {

    boolean existsByShowIdAndUserIdAndStatus(UUID showId, UUID userId, WaitlistStatus status);

    long countByShowIdAndStatus(UUID showId, WaitlistStatus status);

    /** FIFO promotion order — oldest join wins, regardless of the informational position column. */
    Optional<Waitlist> findFirstByShowIdAndStatusOrderByCreatedAtAsc(UUID showId, WaitlistStatus status);
}
