package com.roomreserve.model;

import java.sql.Timestamp;

public class RoomImage {
    private int imageId;
    private int roomId;
    private String imageUrl;
    private String caption;
    private boolean isPrimary;
    private Timestamp uploadedAt;
    private Integer uploadedBy;
    private int imageOrder;

    // Constructors
    public RoomImage() {
    }

    public RoomImage(int roomId, String imageUrl, String caption, boolean isPrimary) {
        this.roomId = roomId;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.isPrimary = isPrimary;
    }

    public RoomImage(int imageId, int roomId, String imageUrl, String caption, 
                    boolean isPrimary, Timestamp uploadedAt, Integer uploadedBy) {
        this.imageId = imageId;
        this.roomId = roomId;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.isPrimary = isPrimary;
        this.uploadedAt = uploadedAt;
        this.uploadedBy = uploadedBy;
    }

    // Getters and Setters
    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public Integer getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(Integer uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public int getImageOrder() {
        return imageOrder;
    }

    public void setImageOrder(int imageOrder) {
        this.imageOrder = imageOrder;
    }
}