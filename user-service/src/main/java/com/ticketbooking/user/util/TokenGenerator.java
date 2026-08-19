package com.ticketbooking.user.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HexFormat;

/**
 * Shared by password-reset tokens and OTPs: generates high-entropy random
 * secrets and hashes them with plain SHA-256 rather than BCrypt.
 *
 * <p>This is deliberate, not a shortcut: passwords need a slow, salted hash
 * (BCrypt) because humans pick low-entropy passwords an attacker can guess
 * offline. A 32-byte random token already has 256 bits of entropy — brute-forcing
 * it is infeasible regardless of hash speed — so a fast hash is both correct
 * and appropriate here.
 */
public final class TokenGenerator {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private TokenGenerator() {
    }

    public static String randomToken() {
        byte[] bytes = new byte[32];
        SECURE_RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    public static String randomNumericOtp(int digits) {
        int bound = (int) Math.pow(10, digits);
        int value = SECURE_RANDOM.nextInt(bound);
        return String.format("%0" + digits + "d", value);
    }

    public static String sha256Hex(String raw) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(raw.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 not available", e);
        }
    }
}
