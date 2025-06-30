package com.roomreserve.model;


public class UserNotificationPref {
    private int prefId;
    private int userId;
    private boolean emailEnabled;
    private boolean inAppEnabled;

    // Constructors, getters, and setters
    public UserNotificationPref() {}
    
    public UserNotificationPref(int userId, boolean emailEnabled, boolean inAppEnabled) {
        this.userId = userId;
        this.emailEnabled = emailEnabled;
        this.inAppEnabled = inAppEnabled;
    }


    // Getters and setters for all fields
    public int getPrefId() {
        return prefId;
    }

    public void setPrefId(int prefId) {
        this.prefId = prefId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public boolean isEmailEnabled() {
        return emailEnabled;
    }

    public void setEmailEnabled(boolean emailEnabled) {
        this.emailEnabled = emailEnabled;
    }

    public boolean isInAppEnabled() {
        return inAppEnabled;
    }

    public void setInAppEnabled(boolean inAppEnabled) {
        this.inAppEnabled = inAppEnabled;
    }
}