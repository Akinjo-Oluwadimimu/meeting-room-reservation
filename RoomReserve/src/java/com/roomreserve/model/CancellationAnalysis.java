package com.roomreserve.model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class CancellationAnalysis {
    private int reasonId;
    private int reservationId;
    private String reason;
    private String notes;
    private String cancelledByName;
    private LocalDateTime cancelledAt;
    private String roomName;
    private LocalDateTime originalTime;

    public CancellationAnalysis() {
    }

    public CancellationAnalysis(int reasonId, int reservationId, String reason, String notes, String cancelledByName, LocalDateTime cancelledAt, String roomName, LocalDateTime originalTime) {
        this.reasonId = reasonId;
        this.reservationId = reservationId;
        this.reason = reason;
        this.notes = notes;
        this.cancelledByName = cancelledByName;
        this.cancelledAt = cancelledAt;
        this.roomName = roomName;
        this.originalTime = originalTime;
    }

    public int getReasonId() {
        return reasonId;
    }

    public void setReasonId(int reasonId) {
        this.reasonId = reasonId;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getCancelledByName() {
        return cancelledByName;
    }

    public void setCancelledByName(String cancelledByName) {
        this.cancelledByName = cancelledByName;
    }

    public LocalDateTime getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(LocalDateTime cancelledAt) {
        this.cancelledAt = cancelledAt;
    }
    
    public Date getCancellationDate() {
        return Date.from(cancelledAt.atZone(ZoneId.systemDefault()).toInstant());
    }                                       

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public LocalDateTime getOriginalTime() {
        return originalTime;
    }
    
    public Date getOriginalDate() {
        return Date.from(originalTime.atZone(ZoneId.systemDefault()).toInstant());
    } 

    public void setOriginalTime(LocalDateTime originalTime) {
        this.originalTime = originalTime;
    }
    
    
}