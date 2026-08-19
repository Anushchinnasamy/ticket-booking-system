package com.ticketbooking.booking.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

import java.time.Instant;
import java.util.UUID;

/**
 * One row per CONFIRMED booking, created asynchronously off the
 * booking-confirmed Kafka event (see TicketEventListener). qrPayload is the
 * exact signed string that was encoded into the QR image — stored so the
 * PDF can be regenerated deterministically without re-signing.
 */
@Entity
@Table(name = "tickets")
public class Ticket {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "booking_id", nullable = false, unique = true)
    private UUID bookingId;

    @Column(name = "qr_payload", nullable = false, columnDefinition = "TEXT")
    private String qrPayload;

    @Column(name = "pdf_object_key", nullable = false)
    private String pdfObjectKey;

    @Column(name = "share_token", unique = true)
    private String shareToken;

    @Column(name = "share_token_expires_at")
    private Instant shareTokenExpiresAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    protected Ticket() {
    }

    public Ticket(UUID bookingId, String qrPayload, String pdfObjectKey) {
        this.bookingId = bookingId;
        this.qrPayload = qrPayload;
        this.pdfObjectKey = pdfObjectKey;
    }

    @PrePersist
    void onCreate() {
        if (createdAt == null) {
            createdAt = Instant.now();
        }
    }

    public void issueShareToken(String token, Instant expiresAt) {
        this.shareToken = token;
        this.shareTokenExpiresAt = expiresAt;
    }

    public boolean isShareTokenValid() {
        return shareToken != null && shareTokenExpiresAt != null && shareTokenExpiresAt.isAfter(Instant.now());
    }

    public UUID getId() {
        return id;
    }

    public UUID getBookingId() {
        return bookingId;
    }

    public String getQrPayload() {
        return qrPayload;
    }

    public String getPdfObjectKey() {
        return pdfObjectKey;
    }

    public String getShareToken() {
        return shareToken;
    }

    public Instant getShareTokenExpiresAt() {
        return shareTokenExpiresAt;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
