package com.ticketbooking.common.exception;

public class ResourceNotFoundException extends ApplicationException {

    public ResourceNotFoundException(String message) {
        super("RESOURCE_NOT_FOUND", message);
    }
}
