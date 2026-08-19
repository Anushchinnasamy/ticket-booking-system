package com.ticketbooking.payment.domain;

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

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

/**
 * booking_id references Booking Service's own data (a different database) —
 * there is no JPA relation or FK here, only the ID.
 */
@Entity
@Table(name = "payments")
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "idempotency_key", nullable = false, unique = true)
    private String idempotencyKey;

    @Column(name = "booking_id", nullable = false)
    private UUID bookingId;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false, length = 3)
    private String currency;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private PaymentStatus status;

    @Column(name = "razorpay_order_id", length = 64)
    private String razorpayOrderId;

    @Column(name = "razorpay_payment_id", length = 64)
    private String razorpayPaymentId;

    @Column(name = "razorpay_refund_id", length = 64)
    private String razorpayRefundId;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected Payment() {
    }

    public Payment(String idempotencyKey, UUID bookingId, BigDecimal amount, String currency, String razorpayOrderId) {
        this.idempotencyKey = idempotencyKey;
        this.bookingId = bookingId;
        this.amount = amount;
        this.currency = currency;
        this.razorpayOrderId = razorpayOrderId;
        this.status = PaymentStatus.INITIATED;
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

    public void markSuccess(String razorpayPaymentId) {
        this.razorpayPaymentId = razorpayPaymentId;
        this.status = PaymentStatus.SUCCESS;
    }

    public void markFailed() {
        this.status = PaymentStatus.FAILED;
    }

    /** Only a SUCCESS payment can be refunded — enforced by the caller (PaymentService), not here, so the conflict message can name the actual booking. */
    public void markRefunded(String razorpayRefundId) {
        this.razorpayRefundId = razorpayRefundId;
        this.status = PaymentStatus.REFUNDED;
    }

    public UUID getId() {
        return id;
    }

    public String getIdempotencyKey() {
        return idempotencyKey;
    }

    public UUID getBookingId() {
        return bookingId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public String getCurrency() {
        return currency;
    }

    public PaymentStatus getStatus() {
        return status;
    }

    public String getRazorpayOrderId() {
        return razorpayOrderId;
    }

    public String getRazorpayPaymentId() {
        return razorpayPaymentId;
    }

    public String getRazorpayRefundId() {
        return razorpayRefundId;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
