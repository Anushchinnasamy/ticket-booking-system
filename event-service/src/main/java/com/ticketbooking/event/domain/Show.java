package com.ticketbooking.event.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "shows")
public class Show {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "event_id", nullable = false)
    private Event event;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "venue_id", nullable = false)
    private Venue venue;

    @Column(name = "start_time", nullable = false)
    private Instant startTime;

    @Column(name = "base_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal basePrice;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    protected Show() {
    }

    public Show(Event event, Venue venue, Instant startTime, BigDecimal basePrice) {
        this.event = event;
        this.venue = venue;
        this.startTime = startTime;
        this.basePrice = basePrice;
    }

    @PrePersist
    void onCreate() {
        if (createdAt == null) {
            createdAt = Instant.now();
        }
    }

    public UUID getId() {
        return id;
    }

    public Event getEvent() {
        return event;
    }

    public Venue getVenue() {
        return venue;
    }

    public Instant getStartTime() {
        return startTime;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
