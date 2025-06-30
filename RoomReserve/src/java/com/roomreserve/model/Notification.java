package com.roomreserve.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class Notification {
    private int notificationId;
    private int userId;
    private int templateId;
    private String title;
    private String message;
    private boolean read;
//    private boolean isEmailSent;
    private LocalDateTime createdAt;
    private Timestamp createdAtTimestamp;

    public Notification() {
    }

    public Notification(int userId, int templateId, String title, String message) {
        this.userId = userId;
        this.templateId = templateId;
        this.title = title;
        this.message = message;
    }
    
    public Notification(int notificationId, int userId, String title, String message, boolean read, LocalDateTime createdAt) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.read = read;
        this.createdAt = createdAt;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public Date getDateCreated() {
        return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Timestamp getCreatedAtTimestamp() {
        return createdAtTimestamp;
    }

    public void setCreatedAtTimestamp(Timestamp createdAtTimestamp) {
        this.createdAtTimestamp = createdAtTimestamp;
    }
}
