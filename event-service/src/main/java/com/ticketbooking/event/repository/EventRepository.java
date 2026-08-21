package com.ticketbooking.event.repository;

import com.ticketbooking.event.domain.Event;
import com.ticketbooking.event.domain.EventCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface EventRepository extends JpaRepository<Event, UUID> {

    List<Event> findByCategory(EventCategory category);

    @Query("SELECT DISTINCT s.event FROM Show s WHERE LOWER(s.venue.city) = LOWER(:city) "
            + "AND (:category IS NULL OR s.event.category = :category)")
    List<Event> findByCity(@Param("city") String city, @Param("category") EventCategory category);

    @Query("SELECT DISTINCT s.venue.city FROM Show s ORDER BY s.venue.city")
    List<String> findDistinctCities();
}
