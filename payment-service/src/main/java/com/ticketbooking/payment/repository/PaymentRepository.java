package com.ticketbooking.payment.repository;

import com.ticketbooking.payment.domain.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface PaymentRepository extends JpaRepository<Payment, UUID> {

    Optional<Payment> findByIdempotencyKey(String idempotencyKey);

    @Query(value = "SELECT * FROM payments WHERE :bookingId = ANY(booking_ids) ORDER BY created_at DESC LIMIT 1", nativeQuery = true)
    Optional<Payment> findFirstByBookingIdOrderByCreatedAtDesc(@Param("bookingId") UUID bookingId);
}
