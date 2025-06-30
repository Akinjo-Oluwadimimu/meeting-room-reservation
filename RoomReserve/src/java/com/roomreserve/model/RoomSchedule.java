package com.roomreserve.model;

import java.util.List;

public class RoomSchedule {
    private int roomId;
    private String roomName;
    private List<TimeSlot> timeSlots;
    
    // Getters and setters
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    public List<TimeSlot> getTimeSlots() { return timeSlots; }
    public void setTimeSlots(List<TimeSlot> timeSlots) { this.timeSlots = timeSlots; }
}