package com.ticketbooking.event.domain;

import com.ticketbooking.common.exception.ConflictException;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "seats")
public class Seat {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "seat_map_id", nullable = false)
    private SeatMap seatMap;

    @Column(name = "row_label", nullable = false, length = 5)
    private String rowLabel;

    @Column(name = "seat_number", nullable = false)
    private int seatNumber;

    @Enumerated(EnumType.STRING)
    @Column(name = "seat_type", nullable = false, length = 20)
    private SeatType seatType;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private SeatStatus status;

    protected Seat() {
    }

    public Seat(SeatMap seatMap, String rowLabel, int seatNumber, SeatType seatType, BigDecimal price, SeatStatus status) {
        this.seatMap = seatMap;
        this.rowLabel = rowLabel;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.price = price;
        this.status = status;
    }

    public UUID getId() {
        return id;
    }

    public SeatMap getSeatMap() {
        return seatMap;
    }

    public String getRowLabel() {
        return rowLabel;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public SeatType getSeatType() {
        return seatType;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public SeatStatus getStatus() {
        return status;
    }

    public void lock() {
        if (status != SeatStatus.AVAILABLE) {
            throw new ConflictException("Seat is not available: " + id);
        }
        status = SeatStatus.LOCKED;
    }

    /**
     * Tolerant release used by cleanup paths (the stale-booking sweep): only
     * transitions LOCKED -> AVAILABLE, otherwise a no-op, since the goal is
     * "make sure it's free," not asserting a specific prior state.
     */
    public void release() {
        if (status == SeatStatus.LOCKED) {
            status = SeatStatus.AVAILABLE;
        }
    }

    /** Final transition on successful payment: LOCKED -> BOOKED. */
    public void book() {
        if (status != SeatStatus.LOCKED) {
            throw new ConflictException("Seat is not locked, cannot book: " + id);
        }
        status = SeatStatus.BOOKED;
    }
}
