package com.roomreserve.model;

import java.time.LocalDateTime;

public class ApprovalLog {
    private int id;
    private int reservationId;
    private int managerId;
    private String action; // "approve", "reject", "modify"
    private String comments;
    private LocalDateTime actionTime;
    private User manager;

    public ApprovalLog() {
    }

    public ApprovalLog(int id, int reservationId, int managerId, String action, String comments, LocalDateTime actionTime, User manager) {
        this.id = id;
        this.reservationId = reservationId;
        this.managerId = managerId;
        this.action = action;
        this.comments = comments;
        this.actionTime = actionTime;
        this.manager = manager;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public LocalDateTime getActionTime() {
        return actionTime;
    }

    public void setActionTime(LocalDateTime actionTime) {
        this.actionTime = actionTime;
    }

    public User getManager() {
        return manager;
    }

    public void setManager(User manager) {
        this.manager = manager;
    }
    
    
}
