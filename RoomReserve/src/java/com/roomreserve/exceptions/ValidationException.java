package com.roomreserve.exceptions;

public class ValidationException extends RuntimeException {
    private String fieldName;
    private String errorCode;

    public ValidationException(String message) {
        super(message);
    }

    public ValidationException(String fieldName, String message) {
        super(message);
        this.fieldName = fieldName;
    }

    public ValidationException(String fieldName, String errorCode, String message) {
        super(message);
        this.fieldName = fieldName;
        this.errorCode = errorCode;
    }

    public String getFieldName() {
        return fieldName;
    }

    public String getErrorCode() {
        return errorCode;
    }

    @Override
    public String toString() {
        if (fieldName != null && errorCode != null) {
            return String.format("Validation error on %s [%s]: %s", fieldName, errorCode, getMessage());
        } else if (fieldName != null) {
            return String.format("Validation error on %s: %s", fieldName, getMessage());
        }
        return String.format("Validation error: %s", getMessage());
    }
}