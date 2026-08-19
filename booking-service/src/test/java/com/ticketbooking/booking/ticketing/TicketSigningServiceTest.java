package com.ticketbooking.booking.ticketing;

import com.ticketbooking.common.exception.ValidationException;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class TicketSigningServiceTest {

    private final TicketSigningService signingService = new TicketSigningService("test-qr-secret-1234567890");

    @Test
    void signThenVerify_roundTripsToTheSameValues() {
        UUID bookingId = UUID.randomUUID();
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        Instant issuedAt = Instant.now().truncatedTo(ChronoUnit.MILLIS);

        String qrPayload = signingService.sign(bookingId, showId, seatId, issuedAt);
        SignedTicketPayload verified = signingService.verify(qrPayload);

        assertThat(verified.bookingId()).isEqualTo(bookingId);
        assertThat(verified.showId()).isEqualTo(showId);
        assertThat(verified.seatId()).isEqualTo(seatId);
        assertThat(verified.issuedAt()).isEqualTo(issuedAt);
    }

    @Test
    void verify_whenSignatureTampered_throwsValidationException() {
        String qrPayload = signingService.sign(UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(), Instant.now());
        String decoded = new String(Base64.getUrlDecoder().decode(qrPayload));
        String tampered = decoded.substring(0, decoded.length() - 1) + (decoded.endsWith("0") ? "1" : "0");
        String tamperedPayload = Base64.getUrlEncoder().withoutPadding().encodeToString(tampered.getBytes());

        assertThatThrownBy(() -> signingService.verify(tamperedPayload))
                .isInstanceOf(ValidationException.class);
    }

    @Test
    void verify_whenSignedWithADifferentSecret_throwsValidationException() {
        TicketSigningService otherSigner = new TicketSigningService("a-completely-different-secret");
        String qrPayload = otherSigner.sign(UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(), Instant.now());

        assertThatThrownBy(() -> signingService.verify(qrPayload))
                .isInstanceOf(ValidationException.class);
    }

    @Test
    void verify_whenNotValidBase64_throwsValidationException() {
        assertThatThrownBy(() -> signingService.verify("not valid base64!!"))
                .isInstanceOf(ValidationException.class);
    }

    @Test
    void verify_whenMalformedStructure_throwsValidationException() {
        String malformed = Base64.getUrlEncoder().withoutPadding().encodeToString("only|three|parts".getBytes());

        assertThatThrownBy(() -> signingService.verify(malformed))
                .isInstanceOf(ValidationException.class);
    }
}
