package com.ticketbooking.event.repository;

import com.ticketbooking.event.domain.Event;
import com.ticketbooking.event.domain.EventCategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EventRepository extends JpaRepository<Event, UUID> {

    List<Event> findByCategory(EventCategory category);
}
