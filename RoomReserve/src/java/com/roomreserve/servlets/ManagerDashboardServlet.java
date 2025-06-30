package com.roomreserve.servlets;

import com.roomreserve.dao.*;
import com.roomreserve.model.*;
import com.roomreserve.util.EmailService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager"})
public class ManagerDashboardServlet extends HttpServlet {
    
    private final ReservationDAO reservationDao;
    private final EmailService emailService;
    private final RoomDAO roomDao;
    private final UserDAO userDao = new UserDAO();

    public ManagerDashboardServlet() throws SQLException {
        this.roomDao = new RoomDAO();
        this.emailService = new EmailService();
        this.reservationDao = new ReservationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get the logged-in manager from session
        HttpSession session = request.getSession();
        User manager = (User) session.getAttribute("user");
        String timeFilter = request.getParameter("filter");
        if (timeFilter == null) timeFilter = "all";
        List<RoomSchedule> todaysSchedule = null;
        
        if (manager == null || !manager.getRole().equals("manager")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Parse date parameter or use today's date
        LocalDate date;
        try {
            String dateParam = request.getParameter("date");
            if (dateParam != null && !dateParam.isEmpty()) {
                date = LocalDate.parse(dateParam, DateTimeFormatter.ofPattern("MMM d, yyyy"));
            } else {
                date = LocalDate.now();
            }
        } catch (Exception e) {
            date = LocalDate.now();
        }

        // Get today's schedule data
        todaysSchedule = roomDao.getTodaysSchedule(date);
        request.setAttribute("todaysSchedule", todaysSchedule);
        
        // Get dashboard data
        int pendingApprovalsCount = reservationDao.getPendingApprovalsCount();
        int activeReservationsCount = reservationDao.getActiveReservationsCount();
        int availableRoomsCount = roomDao.getAvailableRoomsCount();
        int totalRoomsCount = roomDao.getTotalRoomsCount();
        int conflictCount = reservationDao.getConflictCount();

        // Get pending reservations for approval
        //List<com.roomreserve.model.Reservation> pendingReservations = reservationDao.getPendingReservations(timeFilter, 5); // limit to 5

        // Get room utilization data
        List<RoomUtilization> roomUtilization = roomDao.getRoomUtilization();

        // Get today's schedule
        todaysSchedule = roomDao.getTodaysSchedule(date);

        // Prepare data for the view
        request.setAttribute("manager", manager);
        //request.setAttribute("currentDate", DateUtil.formatDate(date));
        request.setAttribute("pendingApprovalsCount", pendingApprovalsCount);
        request.setAttribute("activeReservationsCount", activeReservationsCount);
        request.setAttribute("availableRoomsCount", availableRoomsCount);
        request.setAttribute("totalRoomsCount", totalRoomsCount);
        request.setAttribute("conflictCount", conflictCount);
        request.setAttribute("newApprovalsSinceYesterday", reservationDao.getNewApprovalsSinceYesterday());
        request.setAttribute("reservationIncreasePercentage", reservationDao.getReservationIncreasePercentage());
        request.setAttribute("inactiveRooms", totalRoomsCount - availableRoomsCount); // This could be calculated
        request.setAttribute("conflictMessage", conflictCount > 0 ? "Needs immediate attention" : "No conflicts");
        //request.setAttribute("pendingReservations", pendingReservations);
        request.setAttribute("roomUtilization", roomUtilization);
        request.setAttribute("todaysSchedule", todaysSchedule);

        // Forward to the manager dashboard JSP
        request.getRequestDispatcher("/manager/dashboard.jsp").forward(request, response);
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
            } else if ("cancel".equals(action)) {
                cancelApprovedReservation(request, response, manager);
            } 
            
            response.sendRedirect(request.getContextPath() + (toCalendar ? "/manager/room-calendar?roomId=" + roomId : "/manager"));
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/dashboard");
        }
    }
    
    private void updateReservationStatus(HttpServletRequest request, HttpServletResponse response, User manager) 
            throws Exception {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        String comments = request.getParameter("comments");
        String status = "approve".equals(request.getParameter("action")) ? "approved" : "rejected";
        
        boolean success = reservationDao.updateReservationStatus(
            reservationId, status, manager.getUserId(), comments);
        
        if (success) {
            Reservation reservation = reservationDao.getReservationById(reservationId);
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

    private void cancelApprovedReservation(HttpServletRequest request, HttpServletResponse response, User manager) 
            throws Exception {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        String reason = request.getParameter("reason");
        
        boolean success = reservationDao.cancelApprovedReservation(
            reservationId, manager.getUserId(), reason);
        
        if (success) {
            Reservation reservation = reservationDao.getReservationById(reservationId);
            emailService.sendReservationRejection(reservation, reason);
        } else {
            throw new Exception("Failed to cancel reservation");
        }
        
        request.getSession().setAttribute("success", "Reservation cancelled successfully");
    }
}