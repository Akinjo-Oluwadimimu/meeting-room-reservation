/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.roomreserve.servlets;

import com.roomreserve.util.AdminReportService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    private AdminReportService reportService;

    @Override
    public void init() throws ServletException {
        try {
            this.reportService = new AdminReportService();
        } catch (SQLException ex) {
            Logger.getLogger(AdminReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("view".equals(action)) {
                int reportId = Integer.parseInt(request.getParameter("id"));
                LocalDate startDate = parseDate(request.getParameter("start_date"));
                LocalDate endDate = parseDate(request.getParameter("end_date"));
                
                Map<String, Object> params = new LinkedHashMap<>();
                params.put("start_date", startDate);
                params.put("end_date", endDate);
                
                request.setAttribute("reportResult", 
                    reportService.generateReport(reportId, params));
            }
            
            request.setAttribute("reports", reportService.getAvailableReports());
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        int reportId = Integer.parseInt(request.getParameter("report_id"));
        LocalDate startDate = parseDate(request.getParameter("start_date"));
        LocalDate endDate = parseDate(request.getParameter("end_date"));
        
        Map<String, Object> params = new HashMap<>();
        params.put("start_date", startDate);
        params.put("end_date", endDate);
        
        try {
            if ("export-excel".equals(action)) {
                byte[] excelData = reportService.exportReportToExcel(reportId, params);
                sendFile(response, excelData, "application/vnd.ms-excel", "report.xlsx");
                
            } else if ("export-pdf".equals(action)) {
                byte[] pdfData = reportService.exportReportToPDF(reportId, params);
                sendFile(response, pdfData, "application/pdf", "report.pdf");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Error exporting report: " + e.getMessage());
            doGet(request, response);
        }
    }

    private LocalDate parseDate(String dateStr) {
        return dateStr != null ? LocalDate.parse(dateStr) : LocalDate.now();
    }

    private void sendFile(HttpServletResponse response, byte[] data, 
                         String contentType, String fileName) throws IOException {
        response.setContentType(contentType);
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setContentLength(data.length);
        response.getOutputStream().write(data);
    }
}