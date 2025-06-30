package com.roomreserve.model;

import java.time.LocalDateTime;

public class SystemSetting {
    private int settingId;
    private String key;
    private String value;
    private String description;
    private boolean editable;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public SystemSetting(int settingId, String key, String value, String description, boolean editable, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.settingId = settingId;
        this.key = key;
        this.value = value;
        this.description = description;
        this.editable = editable;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public SystemSetting() {
    }

    public int getSettingId() {
        return settingId;
    }

    public void setSettingId(int settingId) {
        this.settingId = settingId;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isEditable() {
        return editable;
    }

    public void setEditable(boolean editable) {
        this.editable = editable;
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
    
    
    
    
}