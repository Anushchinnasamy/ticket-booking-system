package com.ticketbooking.event.repository;

import com.ticketbooking.event.domain.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface SeatRepository extends JpaRepository<Seat, UUID> {

    @Query("SELECT s FROM Seat s WHERE s.seatMap.show.id = :showId ORDER BY s.rowLabel ASC, s.seatNumber ASC")
    List<Seat> findByShowIdOrderByPosition(@Param("showId") UUID showId);
}
