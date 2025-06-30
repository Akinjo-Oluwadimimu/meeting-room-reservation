package com.roomreserve.model;

public class RoomUtilization {
    private int roomId;
    private String name;
    private int reservedSlots;
    private int totalSlots;
    private double utilizationPercentage;
    private String utilizationClass;
    private String roomName;
    private String buildingName;
    private int completedCount;
    private int cancelledCount;
    private int noShowCount;
    private int utilizedMinutes;
    private int scheduledMinutes;
    private int cancelledMinutes;
    private double utilizationRate;
    private double timeUtilizationPercentage; 
    
    
    // Getters and setters
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getReservedSlots() { return reservedSlots; }
    public void setReservedSlots(int reservedSlots) { this.reservedSlots = reservedSlots; }
    public int getTotalSlots() { return totalSlots; }
    public void setTotalSlots(int totalSlots) { this.totalSlots = totalSlots; }
    public double getUtilizationPercentage() { return utilizationPercentage; }
    public void setUtilizationPercentage(double utilizationPercentage) { this.utilizationPercentage = utilizationPercentage; }
    public String getUtilizationClass() { return utilizationClass; }
    public void setUtilizationClass(String utilizationClass) { this.utilizationClass = utilizationClass; }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getBuildingName() {
        return buildingName;
    }

    public void setBuildingName(String buildingName) {
        this.buildingName = buildingName;
    }

    public int getCompletedCount() {
        return completedCount;
    }

    public void setUtilizationRate(double utilizationRate) {
        this.utilizationRate = utilizationRate;
    }

    public void setCompletedCount(int completedCount) {
        this.completedCount = completedCount;
    }

    public int getCancelledCount() {
        return cancelledCount;
    }

    public void setCancelledCount(int cancelledCount) {
        this.cancelledCount = cancelledCount;
    }

    public int getNoShowCount() {
        return noShowCount;
    }

    public double getTimeUtilizationPercentage() {
        return timeUtilizationPercentage;
    }

    public void setTimeUtilizationPercentage(double timeUtilizationPercentage) {
        this.timeUtilizationPercentage = timeUtilizationPercentage;
    }

    public void setNoShowCount(int noShowCount) {
        this.noShowCount = noShowCount;
    }

    public int getUtilizedMinutes() {
        return utilizedMinutes;
    }

    public void setUtilizedMinutes(int utilizedMinutes) {
        this.utilizedMinutes = utilizedMinutes;
    }

    public int getScheduledMinutes() {
        return scheduledMinutes;
    }

    public void setScheduledMinutes(int scheduledMinutes) {
        this.scheduledMinutes = scheduledMinutes;
    }

    public int getCancelledMinutes() {
        return cancelledMinutes;
    }

    public void setCancelledMinutes(int cancelledMinutes) {
        this.cancelledMinutes = cancelledMinutes;
    }
    
    public double getUtilizationRate() {
        if (scheduledMinutes == 0) return 0;
        return (double) utilizedMinutes / scheduledMinutes * 100;
    }
    
    public double getCancellationRate() {
        if (scheduledMinutes == 0) return 0;
        return (double) cancelledMinutes / scheduledMinutes * 100;
    }
    
}