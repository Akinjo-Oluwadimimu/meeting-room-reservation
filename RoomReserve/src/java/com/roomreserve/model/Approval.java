package com.roomreserve.model;

import java.time.LocalDateTime;

public class Approval {
    private String status;
    private String comments;
    private LocalDateTime actionTime;
    private String approverName;
    
    // Constructors, getters, and setters
    public Approval() {}
    
    public Approval(String status, String comments, LocalDateTime actionTime, String approverName) {
        this.status = status;
        this.comments = comments;
        this.actionTime = actionTime;
        this.approverName = approverName;
    }
    
    // Getters and setters...
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }
    public LocalDateTime getActionTime() { return actionTime; }
    public void setActionTime(LocalDateTime actionTime) { this.actionTime = actionTime; }
    public String getApproverName() { return approverName; }
    public void setApproverName(String approverName) { this.approverName = approverName; }
}