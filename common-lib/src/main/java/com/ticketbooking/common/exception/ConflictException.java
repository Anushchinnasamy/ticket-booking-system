package com.ticketbooking.common.exception;

/**
 * Thrown for state-conflict failures such as a seat lock that is already held
 * or a booking transition attempted from an invalid state.
 */
public class ConflictException extends ApplicationException {

    public ConflictException(String message) {
        super("CONFLICT", message);
    }
}
