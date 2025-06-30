package com.roomreserve.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Reservation {
    
    
    private int id;
    private int userId;
    private int roomId;
    private int attendees;
    private String title;
    private String description;
    private String purpose;
    private Timestamp startDateTime;
    private Timestamp endDateTime;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String status; // "pending", "approved", "rejected", "cancelled", "completed"
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String rejectionReason;
    private String cancellationReason;
    private String roomName;
    private String userName;
    private String buildingName;
    private String approvalStatus;
    private String approverName;
    private String cancellationNote;
    private User user;
    private Room room;
    private Date startDate;
    private Date endDate;
    private LocalDateTime checkInTime;
    private String checkedInBy;
    private List<ApprovalLog> approvalLogs;
    private List<Approval> approvals = new ArrayList<>();
    private LocalDateTime cancellationTime;
    
    public Reservation() {}

    public Reservation(int id, int userId, int roomId, String title, String description, 
                      Timestamp startDateTime, Timestamp endDateTime, 
                      String status, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.roomId = roomId;
        this.title = title;
        this.description = description;
        this.startDateTime = startDateTime;
        this.endDateTime = endDateTime;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCancellationNote() {
        return cancellationNote;
    }

    public LocalDateTime getCancellationTime() {
        return cancellationTime;
    }

    public void setCancellationTime(LocalDateTime cancellationTime) {
        this.cancellationTime = cancellationTime;
    }

    public void setCancellationNote(String cancellationNote) {
        this.cancellationNote = cancellationNote;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public String getApproverName() {
        return approverName;
    }

    public void setApproverName(String approverName) {
        this.approverName = approverName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getBuildingName() {
        return buildingName;
    }

    public List<Approval> getApprovals() {
        return approvals;
    }

    public void setApprovals(List<Approval> approvals) {
        this.approvals = approvals;
    }

    public void setBuildingName(String buildingName) {
        this.buildingName = buildingName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getStartDateTime() {
        return startDateTime;
    }

    public void setStartDateTime(Timestamp startDateTime) {
        this.startDateTime = startDateTime;
    }

    public Timestamp getEndDateTime() {
        return endDateTime;
    }

    public void setEndDateTime(Timestamp endDateTime) {
        this.endDateTime = endDateTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public List<ApprovalLog> getApprovalLogs() {
        return approvalLogs;
    }

    public void setApprovalLogs(List<ApprovalLog> approvalLogs) {
        this.approvalLogs = approvalLogs;
    }
    
    // Helper methods
    public boolean isPending() {
        return "pending".equalsIgnoreCase(status);
    }

    public boolean isApproved() {
        return "approved".equalsIgnoreCase(status);
    }
    
    public boolean isNoShow() {
        return "no-show".equalsIgnoreCase(status);
    }
    
    public boolean isCompleted() {
        return "completed".equalsIgnoreCase(status);
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }

    public boolean isUpcoming() {
        return this.startTime.isAfter(LocalDateTime.now());
    }
    
    public boolean isCheckable() {
        return isApproved() && LocalDateTime.now().isAfter(this.startTime.minusMinutes(15)) && LocalDateTime.now().isBefore(this.startTime.plusHours(2));
    }


    public int getAttendees() {
        return attendees;
    }

    public void setAttendees(int attendees) {
        this.attendees = attendees;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public LocalDateTime getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(LocalDateTime checkInTime) {
        this.checkInTime = checkInTime;
    }

    public String getCheckedInBy() {
        return checkedInBy;
    }

    public void setCheckedInBy(String checkedInBy) {
        this.checkedInBy = checkedInBy;
    }

    public Date getStartDate() {
        return Date.from(startTime.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    public void setStartDate(LocalDateTime startTime) {
        this.startDate = Date.from(startTime.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    public Date getEndDate() {
        return Date.from(endTime.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    
    public Date getCancellationDate() {
        return Date.from(cancellationTime.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    public void setEndDate(LocalDateTime endTime) {
        this.endDate = Date.from(endTime.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    public Date getDateCreated() {
        return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    public Date getCheckedInTime() {
        return Date.from(checkInTime.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    public void addApproval(Approval approval) {
        this.approvals.add(approval);
    }
    
    public String getCurrentApprovalStatus() {
        if (approvals.isEmpty()) return "pending";
        return approvals.get(approvals.size() - 1).getStatus();
    }
    
    public String getLastApprovalComment() {
        if (approvals.isEmpty()) return null;
        return approvals.get(approvals.size() - 1).getComments();
    }
    
    public String getLastApproverName() {
        if (approvals.isEmpty()) return null;
        return approvals.get(approvals.size() - 1).getApproverName();
    }
    
    public LocalDateTime getLastApprovalTime() {
        if (approvals.isEmpty()) return null;
        return approvals.get(approvals.size() - 1).getActionTime();
    }
}