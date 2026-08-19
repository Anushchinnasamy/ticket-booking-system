package com.ticketbooking.common.exception;

/** Thrown for authentication failures: wrong credentials, invalid/expired token. */
public class UnauthorizedException extends ApplicationException {

    public UnauthorizedException(String message) {
        super("UNAUTHORIZED", message);
    }
}
