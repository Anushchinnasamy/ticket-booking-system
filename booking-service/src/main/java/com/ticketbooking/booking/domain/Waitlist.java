package com.ticketbooking.booking.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

import java.time.Instant;
import java.util.UUID;

/** show_id references Event Service's own data — no JPA relation or FK here, only the ID. */
@Entity
@Table(name = "waitlist")
public class Waitlist {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "show_id", nullable = false)
    private UUID showId;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    /**
     * Informational display order only — computed once at join time from the
     * current WAITING count. Promotion order is actually determined by
     * {@code createdAt} (see WaitlistRepository), not this column, so a rare
     * concurrent-join race that assigns two entries the same position never
     * affects correctness, only what number is shown to the user.
     */
    @Column(nullable = false)
    private long position;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private WaitlistStatus status;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "notified_at")
    private Instant notifiedAt;

    protected Waitlist() {
    }

    public Waitlist(UUID showId, UUID userId, long position) {
        this.showId = showId;
        this.userId = userId;
        this.position = position;
        this.status = WaitlistStatus.WAITING;
    }

    @PrePersist
    void onCreate() {
        if (createdAt == null) {
            createdAt = Instant.now();
        }
    }

    public void markNotified() {
        this.status = WaitlistStatus.NOTIFIED;
        this.notifiedAt = Instant.now();
    }

    public UUID getId() {
        return id;
    }

    public UUID getShowId() {
        return showId;
    }

    public UUID getUserId() {
        return userId;
    }

    public long getPosition() {
        return position;
    }

    public WaitlistStatus getStatus() {
        return status;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getNotifiedAt() {
        return notifiedAt;
    }
}
