package com.roomreserve.controller;

import com.roomreserve.dao.ExportDAO;
import com.roomreserve.model.ExportRequest;
import com.roomreserve.model.User;
import com.roomreserve.util.ExportService;
import java.io.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet({"/manager/export/*", "/admin/export/*"})
public class ExportController extends HttpServlet {
    private ExportService exportService;

    @Override
    public void init() throws ServletException {
        try {
            this.exportService = new ExportService(new ExportDAO(getServletContext()));
        } catch (SQLException ex) {
            Logger.getLogger(ExportController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        User user = (User) request.getSession().getAttribute("user");
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List reports
            request.setAttribute("exports", exportService.getExportHistory(user));
            if (user.getRole().equals("manager")){
                request.getRequestDispatcher("/manager/export.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/export.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/download")) {
            // Download report file
            String filePath = request.getParameter("path");
            downloadFile(response, filePath);
        } else if (pathInfo.startsWith("/history")) {
            request.setAttribute("exports", exportService.getExportHistory(user));
            if (user.getRole().equals("manager")){
                request.getRequestDispatcher("/manager/export.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/export.jsp").forward(request, response);
            }
        } else {
            // Show report form
            if (user.getRole().equals("manager")){
                request.getRequestDispatcher("/manager/export.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/export.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        User user = (User) request.getSession().getAttribute("user");
        
        try {
            String filePath = null;
            String format = request.getParameter("format");
            ExportRequest.ExportFormat exportFormat = ExportRequest.ExportFormat.valueOf(format.toUpperCase());
            
            if (null != action) switch (action) {
                case "reservations":{
                    LocalDate start = parseDate(request.getParameter("startDate"));
                        LocalDate end = parseDate(request.getParameter("endDate"));
                        filePath = exportService.exportReservations(user, start, end, exportFormat);
                        break;
                    }
                case "rooms":
                    filePath = exportService.exportRooms(user, exportFormat);
                    break;
                case "usage":{
                    LocalDate start = parseDate(request.getParameter("startDate"));
                        LocalDate end = parseDate(request.getParameter("endDate"));
                        filePath = exportService.exportUsage(user, start, end, exportFormat);
                        break;
                    }
            }
            
            if (filePath != null) {
                downloadFile(response, filePath);
            } else {
                throw new Exception("Failed to generate export");
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Export failed: " + e.getMessage());
            if (user.getRole().equals("manager")){
                request.getRequestDispatcher("/manager/export.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/export.jsp").forward(request, response);
            }
        }
    }

    private LocalDate parseDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) return null;
        return LocalDate.parse(dateStr, DateTimeFormatter.ISO_DATE);
    }

    private void downloadFile(HttpServletResponse response, String filePath) 
            throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            throw new FileNotFoundException("Export file not found");
        }
        
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        response.setContentType(contentType);
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"" + file.getName() + "\"");
        
        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}