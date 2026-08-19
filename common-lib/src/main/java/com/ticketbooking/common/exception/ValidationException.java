package com.ticketbooking.common.exception;

public class ValidationException extends ApplicationException {

    public ValidationException(String message) {
        super("VALIDATION_ERROR", message);
    }
}
