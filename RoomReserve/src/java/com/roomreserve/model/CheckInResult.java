package com.roomreserve.model;

import java.time.LocalDateTime;

public class CheckInResult {
    private boolean success;
    private String message;
    private LocalDateTime checkInTime;

    public CheckInResult() {
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(LocalDateTime checkInTime) {
        this.checkInTime = checkInTime;
    }
    
    // Constructor, getters, and setters
    public CheckInResult(boolean success, String message) {
        this.success = success;
        this.message = message;
        this.checkInTime = LocalDateTime.now();
    }
}