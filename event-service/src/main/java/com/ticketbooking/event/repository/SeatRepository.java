package com.ticketbooking.event.repository;

import com.ticketbooking.event.domain.Seat;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SeatRepository extends JpaRepository<Seat, UUID> {

    @Query("SELECT s FROM Seat s WHERE s.seatMap.show.id = :showId ORDER BY s.rowLabel ASC, s.seatNumber ASC")
    List<Seat> findByShowIdOrderByPosition(@Param("showId") UUID showId);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT s FROM Seat s WHERE s.id = :seatId AND s.seatMap.show.id = :showId")
    Optional<Seat> findByIdAndShowIdForUpdate(@Param("seatId") UUID seatId, @Param("showId") UUID showId);
}
