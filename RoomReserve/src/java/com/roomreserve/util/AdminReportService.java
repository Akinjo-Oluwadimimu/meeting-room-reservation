package com.roomreserve.util;

import com.roomreserve.dao.ReportDAO;
import com.roomreserve.model.ReportDefinition;
import com.roomreserve.model.ReportResult;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class AdminReportService {
    private final ReportDAO reportDAO;

    public AdminReportService() throws SQLException {
        this.reportDAO = new ReportDAO();
    }

    public List<ReportDefinition> getAvailableReports() {
        try {
            return reportDAO.getAllReportDefinitions();
        } catch (Exception e) {
            throw new RuntimeException("Failed to load report definitions", e);
        }
    }

    public ReportResult generateReport(int reportId, Map<String, Object> parameters) {
        try {
            return reportDAO.executeReport(reportId, parameters);
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate report", e);
        }
    }

    public byte[] exportReportToExcel(int reportId, Map<String, Object> parameters) {
        try {
            return reportDAO.exportReportToExcel(reportId, parameters);
        } catch (Exception e) {
            throw new RuntimeException("Failed to export report to Excel", e);
        }
    }

    public byte[] exportReportToPDF(int reportId, Map<String, Object> parameters) {
        try {
            return reportDAO.exportReportToPDF(reportId, parameters);
        } catch (Exception e) {
            throw new RuntimeException("Failed to export report to PDF", e);
        }
    }
}