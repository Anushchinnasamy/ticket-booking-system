package com.ticketbooking.event.repository;

import com.ticketbooking.event.domain.Show;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ShowRepository extends JpaRepository<Show, UUID> {

    @EntityGraph(attributePaths = {"venue"})
    List<Show> findByEventId(UUID eventId);

    @Override
    @EntityGraph(attributePaths = {"event", "venue"})
    Optional<Show> findById(UUID id);
}
