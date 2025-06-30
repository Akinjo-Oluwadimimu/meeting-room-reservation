package com.roomreserve.model;

import java.time.LocalDateTime;

public class AuditLog {
    private int id;
    private Integer userId;
    private String action;
    private String tableAffected;
    private Integer recordId;
    private String oldValues;
    private String newValues;
    private String ipAddress;
    private LocalDateTime actionTime;
    
    public AuditLog(int id, Integer userId, String action, String tableAffected, Integer recordId, String oldValues, String newValues, String ipAddress, LocalDateTime actionTime) {
        this.id = id;
        this.userId = userId;
        this.action = action;
        this.tableAffected = tableAffected;
        this.recordId = recordId;
        this.oldValues = oldValues;
        this.newValues = newValues;
        this.ipAddress = ipAddress;
        this.actionTime = actionTime;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getTableAffected() {
        return tableAffected;
    }

    public void setTableAffected(String tableAffected) {
        this.tableAffected = tableAffected;
    }

    public Integer getRecordId() {
        return recordId;
    }

    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }

    public String getOldValues() {
        return oldValues;
    }

    public void setOldValues(String oldValues) {
        this.oldValues = oldValues;
    }

    public String getNewValues() {
        return newValues;
    }

    public void setNewValues(String newValues) {
        this.newValues = newValues;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public LocalDateTime getActionTime() {
        return actionTime;
    }

    public void setActionTime(LocalDateTime actionTime) {
        this.actionTime = actionTime;
    }
    
    
}