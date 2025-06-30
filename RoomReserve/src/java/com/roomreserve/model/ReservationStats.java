package com.roomreserve.model;

import java.time.LocalDate;
import java.util.Map;

public class ReservationStats {
    private LocalDate startDate;
    private LocalDate endDate;
    private int totalReservations;
    private int approvedReservations;
    private int rejectedReservations;
    private int pendingReservations;
    private int cancelledReservations;
    private Map<String, Integer> reservationsByRoom;
    private Map<String, Integer> reservationsByDepartment;
    private Map<String, Integer> reservationsByPurpose;
    private double averageDurationHours;
    private int peakHour;
    private double utilizationRate;
    private int conflictCount;
    private double avgDuration;
    private double approvalRate;
    private double cancellationRate;
    
    // Getters and Setters
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    
    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
    
    public int getTotalReservations() { return totalReservations; }
    public void setTotalReservations(int totalReservations) { this.totalReservations = totalReservations; }
    
    public int getApprovedReservations() { return approvedReservations; }
    public void setApprovedReservations(int approvedReservations) { this.approvedReservations = approvedReservations; }
    
    public int getRejectedReservations() { return rejectedReservations; }
    public void setRejectedReservations(int rejectedReservations) { this.rejectedReservations = rejectedReservations; }
    
    public int getPendingReservations() { return pendingReservations; }
    public void setPendingReservations(int pendingReservations) { this.pendingReservations = pendingReservations; }
    
    public int getCancelledReservations() { return cancelledReservations; }
    public void setCancelledReservations(int cancelledReservations) { this.cancelledReservations = cancelledReservations; }
    
    public Map<String, Integer> getReservationsByRoom() { return reservationsByRoom; }
    public void setReservationsByRoom(Map<String, Integer> reservationsByRoom) { this.reservationsByRoom = reservationsByRoom; }
    
    public Map<String, Integer> getReservationsByDepartment() { return reservationsByDepartment; }
    public void setReservationsByDepartment(Map<String, Integer> reservationsByDepartment) { this.reservationsByDepartment = reservationsByDepartment; }
    
    public Map<String, Integer> getReservationsByPurpose() { return reservationsByPurpose; }
    public void setReservationsByPurpose(Map<String, Integer> reservationsByPurpose) { this.reservationsByPurpose = reservationsByPurpose; }
    
    public double getAverageDurationHours() { return averageDurationHours; }
    public void setAverageDurationHours(double averageDurationHours) { this.averageDurationHours = averageDurationHours; }
    
    public int getPeakHour() { return peakHour; }
    public void setPeakHour(int peakHour) { this.peakHour = peakHour; }
    
    public double getUtilizationRate() { return utilizationRate; }
    public void setUtilizationRate(double utilizationRate) { this.utilizationRate = utilizationRate; }
    
    public int getConflictCount() { return conflictCount; }
    public void setConflictCount(int conflictCount) { this.conflictCount = conflictCount; }

    public double getAvgDuration() {
        return avgDuration;
    }

    public void setAvgDuration(double avgDuration) {
        this.avgDuration = avgDuration;
    }

    public void setApprovalRate(double approvalRate) {
        this.approvalRate = approvalRate;
    }

    public void setCancellationRate(double cancellationRate) {
        this.cancellationRate = cancellationRate;
    }
    
    
    
    // Utility methods
    public double getApprovalRate() {
        return totalReservations > 0 ? 
            (double) approvedReservations / totalReservations * 100 : 0;
    }
    
    public double getCancellationRate() {
        return totalReservations > 0 ? 
            (double) cancelledReservations / totalReservations * 100 : 0;
    }
}