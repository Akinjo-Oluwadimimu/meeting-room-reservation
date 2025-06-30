package com.roomreserve.controller;

import com.roomreserve.model.UserReport;
import com.roomreserve.util.ReportService;
import java.io.*;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/user/reports/*")
public class UserReportController extends HttpServlet {
    private ReportService reportService;

    @Override
    public void init() throws ServletException {
        try {
            this.reportService = new ReportService(getServletContext());
        } catch (SQLException ex) {
            Logger.getLogger(UserReportController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        int userId = (int) request.getSession().getAttribute("userId");
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List reports
            request.setAttribute("reports", reportService.getUserReports(userId));
            request.getRequestDispatcher("/user/userreports/list.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/download/")) {
            // Download report file
            int reportId = Integer.parseInt(pathInfo.substring(10));
            downloadReport(reportId, userId, response);
        } else if (pathInfo.startsWith("/status/")) {
            // Check report status (for AJAX)
            int reportId = Integer.parseInt(pathInfo.substring(8));
            checkReportStatus(reportId, userId, response);
        } else {
            // Show report form
            request.getRequestDispatcher("/user/userreports/new.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = (int) request.getSession().getAttribute("userId");
        String reportType = request.getParameter("reportType");
        String dateRange = request.getParameter("dateRange");
        String format = request.getParameter("format");
        
        LocalDate startDate = null;
        LocalDate endDate = null;
        
        if ("custom".equals(dateRange)) {
            startDate = LocalDate.parse(request.getParameter("startDate"));
            endDate = LocalDate.parse(request.getParameter("endDate"));
        }
        
        int reportId = reportService.generateReport(userId, reportType, dateRange, startDate, endDate, format);
        
        response.sendRedirect(request.getContextPath() + "/user/reports/status/" + reportId);
    }

    private void downloadReport(int reportId, int userId, HttpServletResponse response) throws IOException {
        try {
            UserReport report = reportService.getReport(reportId, userId);
            
            if (report == null || !"ready".equals(report.getStatus())) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            File file = new File(report.getFilePath());
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Set content type and headers
            String contentType = getContentType(report.getFormat());
            response.setContentType(contentType);
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"" + file.getName() + "\"");
            
            // Copy file to response output stream
            Files.copy(file.toPath(), response.getOutputStream());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void checkReportStatus(int reportId, int userId, HttpServletResponse response) throws IOException {
        try {
            UserReport report = reportService.getReport(reportId, userId);
            
            if (report == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            response.setContentType("application/json");
            response.getWriter().write(String.format(
                "{\"reportId\":\"%s\",\"status\":\"%s\",\"ready\":%b,\"downloadUrl\":\"%s\"}",
                reportId,
                report.getStatus(),
                "ready".equals(report.getStatus()),
                "ready".equals(report.getStatus()) ? 
                    "download/" + reportId : ""
            ));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String getContentType(String format) {
        switch (format.toLowerCase()) {
            case "pdf": return "application/pdf";
            case "csv": return "text/csv";
            case "xlsx": return "application/vnd.ms-excel";
            default: return "application/octet-stream";
        }
    }
}
