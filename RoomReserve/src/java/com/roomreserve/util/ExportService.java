package com.roomreserve.util;

import com.roomreserve.dao.ExportDAO;
import com.roomreserve.exceptions.ReportGenerationException;
import com.roomreserve.model.ExportRequest;
import com.roomreserve.model.User;
import java.time.LocalDate;
import java.util.List;

public class ExportService {
    private final ExportDAO exportDAO;

    public ExportService(ExportDAO exportDAO) {
        this.exportDAO = exportDAO;
    }

    public String exportReservations(User manager, LocalDate start, LocalDate end, 
            ExportRequest.ExportFormat format) throws ReportGenerationException {
        String filePath = exportDAO.generateReservationsReport(start, end, format);
        
        ExportRequest request = new ExportRequest();
        request.setManagerId(manager.getUserId());
        request.setExportType(ExportRequest.ExportType.RESERVATIONS);
        request.setStartDate(start);
        request.setEndDate(end);
        request.setFormat(format);
        request.setFilePath(filePath);
        
        exportDAO.saveExportRequest(request);
        return filePath;
    }

    public String exportRooms(User manager, ExportRequest.ExportFormat format) throws ReportGenerationException {
        String filePath = exportDAO.generateRoomsReport(format);
        
        ExportRequest request = new ExportRequest();
        request.setManagerId(manager.getUserId());
        request.setExportType(ExportRequest.ExportType.ROOMS);
        request.setFormat(format);
        request.setFilePath(filePath);
        
        exportDAO.saveExportRequest(request);
        return filePath;
    }

    public String exportUsage(User manager, LocalDate start, LocalDate end, 
            ExportRequest.ExportFormat format) throws ReportGenerationException {
        String filePath = exportDAO.generateUsageReport(start, end, format);
        
        ExportRequest request = new ExportRequest();
        request.setManagerId(manager.getUserId());
        request.setExportType(ExportRequest.ExportType.USAGE);
        request.setStartDate(start);
        request.setEndDate(end);
        request.setFormat(format);
        request.setFilePath(filePath);
        
        exportDAO.saveExportRequest(request);
        return filePath;
    }

    public List<ExportRequest> getExportHistory(User manager) {
        return exportDAO.getExportHistory(manager.getUserId());
    }
}