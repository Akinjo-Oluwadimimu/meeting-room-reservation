package com.roomreserve.model;


import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class ExportRequest {
    private int exportId;
    private int managerId;
    private ExportType exportType;
    private LocalDate startDate;
    private LocalDate endDate;
    private ExportFormat format;
    private String filePath;
    private LocalDateTime createdAt;

    public enum ExportType {
        RESERVATIONS, ROOMS, USERS, USAGE
    }

    public enum ExportFormat {
        CSV, EXCEL, PDF
    }

    public ExportRequest() {
    }

    public ExportRequest(int exportId, int managerId, ExportType exportType, LocalDate startDate, LocalDate endDate, ExportFormat format, String filePath, LocalDateTime createdAt) {
        this.exportId = exportId;
        this.managerId = managerId;
        this.exportType = exportType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.format = format;
        this.filePath = filePath;
        this.createdAt = createdAt;
    }

    public int getExportId() {
        return exportId;
    }

    public void setExportId(int exportId) {
        this.exportId = exportId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public ExportType getExportType() {
        return exportType;
    }

    public void setExportType(ExportType exportType) {
        this.exportType = exportType;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public ExportFormat getFormat() {
        return format;
    }

    public void setFormat(ExportFormat format) {
        this.format = format;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public Date getDateCreated() {
        return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }
    
}