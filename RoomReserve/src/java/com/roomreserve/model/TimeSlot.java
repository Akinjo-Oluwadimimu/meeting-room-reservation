package com.roomreserve.model;

public class TimeSlot {
    private Reservation reservation;
    private String eventName;
    
    // Getters and setters
    public Reservation getReservation() { return reservation; }
    public void setReservation(Reservation reservation) { this.reservation = reservation; }
    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }
}