package com.roomreserve.servlets;

import com.roomreserve.dao.ReportGenerator;
import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.ReservationStats;
import com.roomreserve.model.StatusUpdate;
import com.roomreserve.model.User;
import com.roomreserve.util.EmailService;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/manager/reservations")
public class ManagerReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    private EmailService emailService;
    private ReportGenerator reportGenerator;
    private static final int DEFAULT_LIMIT = 10;
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    
    @Override
    public void init() throws ServletException {
        try {
            reservationDAO = new ReservationDAO();
            reportGenerator = new ReportGenerator();
            emailService = new EmailService();
        } catch (SQLException ex) {
            Logger.getLogger(ReservationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User manager = (User) request.getSession().getAttribute("user");
        
        try {
            if ("export".equals(action)) {
                exportReservations(request, response);
                return;
            } else if ("stats".equals(action)) {
                showStatistics(request, response);
                return;
            } else if ("view".equals(action)) {
                viewReservationDetails(request, response);
                return;
            }
            
            // Get pagination parameters
            int page = 1;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            int limit = DEFAULT_LIMIT;
            if (request.getParameter("limit") != null) {
                limit = Integer.parseInt(request.getParameter("limit"));
            }

            int offset = (page - 1) * limit;
            int totalPages = 0;

            String searchType = null;
            if (request.getParameter("searchType") != null && !request.getParameter("searchType").isEmpty()) {
                searchType = request.getParameter("searchType");
            }
            
            String query = null;
            if (request.getParameter("query") != null && !request.getParameter("query").isEmpty()) {
                query = request.getParameter("query");
            }
                
            Date startDate = null;
            Date endDate = null;
            if (searchType != null && !searchType.isEmpty() && searchType.equals("date") 
                    && query != null && !query.isEmpty()) {
                String[] dates = query.split(" to ");
                String startDateStr = dates[0].trim(); 
                String endDateStr = null;
                if (dates.length > 1) {
                    endDateStr = dates[1].trim();
                } else {
                    endDateStr = dates[0].trim();
                }

                // Parse into java.util.Date
                startDate = DATE_FORMAT.parse(startDateStr);
                endDate = DATE_FORMAT.parse(endDateStr);
            }
                
            String status  = request.getParameter("status");
            if (status == null) {
                // Default: show pending reservations
                List<Reservation> pendingReservations = reservationDAO.getReservations("pending", searchType, query, startDate, endDate, offset, limit);
                int totalReservations = reservationDAO.countReservations("pending", searchType, query, startDate, endDate);
                totalPages = (int) Math.ceil((double) totalReservations / limit);
                status = "pending";
                request.setAttribute("reservations", pendingReservations);
                
            } else if (status.equals("all")) {
                List<Reservation> allReservations = reservationDAO.getReservations(null, searchType, query, startDate, endDate, offset, limit);
                int totalReservations = reservationDAO.countReservations(null, searchType, query, startDate, endDate);
                totalPages = (int) Math.ceil((double) totalReservations / limit);
                request.setAttribute("reservations", allReservations);
            } else {
                List<Reservation> reservations = reservationDAO.getReservations(status, searchType, query, startDate, endDate, offset, limit);
                int totalReservations = reservationDAO.countReservations(status, searchType, query, startDate, endDate);
                totalPages = (int) Math.ceil((double) totalReservations / limit);
                request.setAttribute("reservations", reservations);
            }
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("statusFilter", status);
            request.setAttribute("searchTypeFilter", searchType);
            request.setAttribute("searchQueryFilter", query);
            request.getRequestDispatcher("/manager/reservations.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/manager/reservations.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User manager = (User) request.getSession().getAttribute("user");
        boolean toCalendar = false;
        int roomId = 0;
        if (request.getParameter("calendar") != null && !request.getParameter("calendar").isEmpty()) {
            toCalendar = Boolean.parseBoolean(request.getParameter("calendar"));
            roomId = Integer.parseInt(request.getParameter("roomId"));
        }
        
        try {
            if ("approve".equals(action) || "reject".equals(action)) {
                updateReservationStatus(request, response, manager);
            } else if ("no show".equals(action) || "completed".equals(action)) {
                markReservationStatus(request, response, manager);
            } else if ("cancel".equals(action)) {
                cancelApprovedReservation(request, response, manager);
            } else if ("export".equals(action)) {
                exportReservations(request, response);
                return;
            } 
            
            response.sendRedirect(request.getContextPath() + (toCalendar ? "/manager/room-calendar?roomId=" + roomId : "/manager/reservations"));
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/reservations");
        }
   }

    private void updateReservationStatus(HttpServletRequest request, HttpServletResponse response, User manager) 
            throws Exception {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        String comments = request.getParameter("comments");
        String status = "approve".equals(request.getParameter("action")) ? "approved" : "rejected";
        
        boolean success = reservationDAO.updateReservationStatus(
            reservationId, status, manager.getUserId(), comments);
        
        if (success) {
            Reservation reservation = reservationDAO.getReservationById(reservationId);
            if ("approve".equals(request.getParameter("action"))){
                emailService.sendReservationApproval(reservation);
            } else {
                emailService.sendReservationRejection(reservation, comments);
            }
            
        } else {
            throw new Exception("Failed to update reservation status");
        }
        
        request.getSession().setAttribute("success", 
            "Reservation " + status + " successfully");
    }
    
    private void markReservationStatus(HttpServletRequest request, HttpServletResponse response, User manager) 
            throws Exception {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        String comments = request.getParameter("comments");
        String status = "no show".equals(request.getParameter("action")) ? "no-show" : "completed";
        
        boolean success = reservationDAO.updateReservationStatus(
            reservationId, status, manager.getUserId(), comments);
        
        if (success) {
            Reservation reservation = reservationDAO.getReservationById(reservationId);
//            if ("approve".equals(request.getParameter("action"))){
//                emailService.sendReservationApproval(reservation);
//            } else {
//                emailService.sendReservationRejection(reservation, comments);
//            }
            
        } else {
            throw new Exception("Failed to update reservation status");
        }
        
        request.getSession().setAttribute("success", 
            "Reservation marked as " + status + " successfully");
    }

    private void cancelApprovedReservation(HttpServletRequest request, HttpServletResponse response, User manager) 
            throws Exception {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        String reason = request.getParameter("reason");
        
        boolean success = reservationDAO.cancelApprovedReservation(
            reservationId, manager.getUserId(), reason);
        
        if (!success) {
            throw new Exception("Failed to cancel reservation");
        }
        
        request.getSession().setAttribute("success", "Reservation cancelled successfully");
    }

    private void exportReservations(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
        LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));
        String format = request.getParameter("format");
        
        if ("excel".equals(format)) {
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=reservations.xlsx");
            reportGenerator.generateExcelReport(startDate, endDate, response.getOutputStream());
        } else if ("pdf".equals(format)) {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=reservations.pdf");
            reportGenerator.generatePdfReport(startDate, endDate, response.getOutputStream());
        }
    }

    private void showStatistics(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        String period = request.getParameter("period");
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        
        ReservationStats stats = reservationDAO.getReservationStats(roomId, period);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/manager/statistics.jsp").forward(request, response);
    }
    
    private void viewReservationDetails(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        int reservationId = Integer.parseInt(request.getParameter("id"));
                
        Reservation reservation = reservationDAO.getReservationById(reservationId);
        List<StatusUpdate> updates = reservationDAO.getStatusUpdates(reservationId);

        request.setAttribute("reservation", reservation);
        request.setAttribute("updates", updates);
        request.getRequestDispatcher("/manager/reservation-details.jsp").forward(request, response);
    }
    
    
}