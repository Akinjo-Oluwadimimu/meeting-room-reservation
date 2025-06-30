package com.roomreserve.model;

import java.time.LocalDateTime;

public class ReservationAnalytics {
    private int roomId;
    private String roomName;
    private String buildingName;
    private String period;
    private String periodType; // hour, day, week, month
    private int reservationCount;
    private int totalMinutes;
    private double utilizationRate;

    public ReservationAnalytics() {
    }

    public ReservationAnalytics(int roomId, String roomName, String buildingName, String period, String periodType, int reservationCount, int totalMinutes, double utilizationRate) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.buildingName = buildingName;
        this.period = period;
        this.periodType = periodType;
        this.reservationCount = reservationCount;
        this.totalMinutes = totalMinutes;
        this.utilizationRate = utilizationRate;
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

    public void setBuildingName(String buildingName) {
        this.buildingName = buildingName;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getPeriodType() {
        return periodType;
    }

    public void setPeriodType(String periodType) {
        this.periodType = periodType;
    }

    public int getReservationCount() {
        return reservationCount;
    }

    public void setReservationCount(int reservationCount) {
        this.reservationCount = reservationCount;
    }

    public int getTotalMinutes() {
        return totalMinutes;
    }

    public void setTotalMinutes(int totalMinutes) {
        this.totalMinutes = totalMinutes;
    }
    
    // Constructors, getters, setters
    
    public double getUtilizationRate() {
        return (totalMinutes * 100.0) / (reservationCount * 60); // Assuming 60 min slots
    }
}
