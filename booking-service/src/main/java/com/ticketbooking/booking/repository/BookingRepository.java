package com.ticketbooking.booking.repository;

import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public interface BookingRepository extends JpaRepository<Booking, UUID> {

    List<Booking> findByStatusAndCreatedAtBefore(BookingStatus status, Instant cutoff);

    /**
     * Single atomic UPDATE ... WHERE, same principle as Phase 2's SELECT FOR
     * UPDATE: the database's own row-level locking is what makes two
     * concurrent redemptions of the same ticket resolve to exactly one
     * success, with no separate read-then-write window for a race to land
     * in. Returns the number of rows affected — 0 means the booking wasn't
     * CONFIRMED at the moment of the update (already checked in, cancelled,
     * or never existed).
     */
    @Modifying
    @Query("UPDATE Booking b SET b.status = com.ticketbooking.booking.domain.BookingStatus.CHECKED_IN, " +
            "b.updatedAt = :now WHERE b.id = :id AND b.status = com.ticketbooking.booking.domain.BookingStatus.CONFIRMED")
    int checkInIfConfirmed(@Param("id") UUID id, @Param("now") Instant now);
}
