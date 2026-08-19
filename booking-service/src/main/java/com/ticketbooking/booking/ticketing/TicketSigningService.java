package com.ticketbooking.booking.ticketing;

import com.ticketbooking.common.exception.ValidationException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;
import java.util.UUID;

/**
 * Signs and verifies the QR payload printed on a ticket: HMAC-SHA256 over
 * {@code bookingId|showId|seatId|issuedAtMillis} using a server-side secret
 * never exposed in the QR itself. A raw booking ID in the QR would let
 * anyone forge a ticket by guessing IDs; the signature is what makes a scan
 * at the gate trustworthy without a network round trip to look anything up
 * first.
 */
@Service
public class TicketSigningService {

    private static final String HMAC_ALGORITHM = "HmacSHA256";
    private static final String DELIMITER = "|";

    private final SecretKeySpec key;

    public TicketSigningService(@Value("${ticket.qr-secret}") String secret) {
        this.key = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM);
    }

    public String sign(UUID bookingId, UUID showId, UUID seatId, Instant issuedAt) {
        String raw = String.join(DELIMITER, bookingId.toString(), showId.toString(), seatId.toString(),
                String.valueOf(issuedAt.toEpochMilli()));
        String signature = hmac(raw);
        String signed = raw + DELIMITER + signature;
        return Base64.getUrlEncoder().withoutPadding().encodeToString(signed.getBytes(StandardCharsets.UTF_8));
    }

    /** Throws {@link ValidationException} for a malformed payload or a signature that doesn't match. */
    public SignedTicketPayload verify(String qrPayload) {
        String decoded;
        try {
            decoded = new String(Base64.getUrlDecoder().decode(qrPayload), StandardCharsets.UTF_8);
        } catch (IllegalArgumentException ex) {
            throw new ValidationException("Malformed ticket QR payload");
        }

        String[] parts = decoded.split("\\|");
        if (parts.length != 5) {
            throw new ValidationException("Malformed ticket QR payload");
        }

        String raw = String.join(DELIMITER, parts[0], parts[1], parts[2], parts[3]);
        String claimedSignature = parts[4];
        String expectedSignature = hmac(raw);
        if (!MessageDigest.isEqual(
                expectedSignature.getBytes(StandardCharsets.UTF_8),
                claimedSignature.getBytes(StandardCharsets.UTF_8))) {
            throw new ValidationException("Ticket QR signature is invalid");
        }

        try {
            return new SignedTicketPayload(
                    UUID.fromString(parts[0]),
                    UUID.fromString(parts[1]),
                    UUID.fromString(parts[2]),
                    Instant.ofEpochMilli(Long.parseLong(parts[3])));
        } catch (IllegalArgumentException ex) {
            throw new ValidationException("Malformed ticket QR payload");
        }
    }

    private String hmac(String raw) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            mac.init(key);
            byte[] digest = mac.doFinal(raw.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (NoSuchAlgorithmException | java.security.InvalidKeyException ex) {
            throw new IllegalStateException("HMAC signing failed", ex);
        }
    }
}
