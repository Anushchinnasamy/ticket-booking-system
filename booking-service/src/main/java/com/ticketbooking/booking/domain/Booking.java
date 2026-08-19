package com.ticketbooking.booking.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;

import java.time.Instant;
import java.util.UUID;

/**
 * show_id and seat_id reference Event Service's own data (a different
 * database) — there is no JPA relation or FK here, only IDs.
 */
@Entity
@Table(name = "bookings")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "show_id", nullable = false)
    private UUID showId;

    @Column(name = "seat_id", nullable = false)
    private UUID seatId;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private BookingStatus status;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected Booking() {
    }

    public Booking(UUID showId, UUID seatId, UUID userId) {
        this.showId = showId;
        this.seatId = seatId;
        this.userId = userId;
        this.status = BookingStatus.PENDING;
    }

    @PrePersist
    void onCreate() {
        Instant now = Instant.now();
        if (createdAt == null) {
            createdAt = now;
        }
        updatedAt = now;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = Instant.now();
    }

    public UUID getId() {
        return id;
    }

    public UUID getShowId() {
        return showId;
    }

    public UUID getSeatId() {
        return seatId;
    }

    public UUID getUserId() {
        return userId;
    }

    public BookingStatus getStatus() {
        return status;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    /**
     * Tolerant transition used by the stale-booking sweep: only cancels a
     * still-PENDING hold, otherwise a no-op (a booking already CONFIRMED by
     * the time the sweep runs should not be cancelled out from under it).
     */
    public void cancel() {
        if (status == BookingStatus.PENDING) {
            status = BookingStatus.CANCELLED;
        }
    }

    /**
     * Tolerant transition on successful payment: only confirms a still-PENDING
     * booking, otherwise a no-op — keeps the endpoint safely callable more
     * than once (e.g. a retried payment-verification request).
     */
    public void confirm() {
        if (status == BookingStatus.PENDING) {
            status = BookingStatus.CONFIRMED;
        }
    }
}
