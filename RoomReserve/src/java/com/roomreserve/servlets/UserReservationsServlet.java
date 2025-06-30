package com.roomreserve.servlets;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/user/reservations")
public class UserReservationsServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    
    @Override
    public void init() throws ServletException {
        super.init();
        reservationDAO = new ReservationDAO();
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            List<Reservation> reservations;
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String show = request.getParameter("show");
            boolean includePast = "all".equals(show);
            
            int roomId = 0;
            if (request.getParameter("roomId") != null && !request.getParameter("roomId").isEmpty()) {
                roomId = Integer.parseInt(request.getParameter("roomId"));
            }
             
            String searchDate = null;
            Date startDate = null;
            Date endDate = null;
            if (request.getParameter("startDate") != null && !request.getParameter("startDate").isEmpty()) {
                try {
                    searchDate = request.getParameter("startDate");
                    String[] dates = searchDate.split(" to ");
                    String startDateStr = dates[0].trim();
                    String endDateStr = null;
                    if (dates.length > 1) {
                        endDateStr = dates[1].trim();
                    } else {
                        endDateStr = dates[0].trim();
                    }
                    
                    startDate = DATE_FORMAT.parse(startDateStr);
                    endDate = DATE_FORMAT.parse(endDateStr);
                } catch (ParseException ex) {
                    Logger.getLogger(UserReservationsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            String status  = request.getParameter("status");
            if (status != null && !status.isEmpty()) {
                reservations = reservationDAO.getUserReservations(user.getUserId(), includePast, status, roomId, startDate, endDate);
            } else {
                reservations = reservationDAO.getUserReservations(user.getUserId(), includePast, null, roomId, startDate, endDate);
            }
            
            
            request.setAttribute("reservations", reservations);
            request.setAttribute("rooms", roomDAO.getAllRooms());
            request.setAttribute("showAll", includePast);
            request.setAttribute("statusFilter", status);
            request.setAttribute("roomIdFilter", roomId);
            request.setAttribute("dateFilter", searchDate);
            request.setAttribute("show", (includePast ? "all" : "current"));
            
            request.getRequestDispatcher("/user/reservations.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(UserReservationsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        
        try {
            if ("cancel".equals(action)) {
                String reason = request.getParameter("reason");
                String notes = request.getParameter("notes");
                boolean success = reservationDAO.cancelReservation(reservationId, user.getUserId(), reason, notes);
                
                if (success) {
                    session.setAttribute("success", "Reservation cancelled successfully");
                } else {
                    session.setAttribute("error", "Failed to cancel reservation");
                }
            } else if ("update".equals(action)) {
                Reservation reservation = new Reservation();
                reservation.setId(reservationId);
                reservation.setTitle(request.getParameter("title"));
                reservation.setPurpose(request.getParameter("purpose"));
                
                String reservationDate = request.getParameter("reservationDate");
                String startDate = reservationDate + " " + request.getParameter("startTime");
                String endDate = reservationDate + " " + request.getParameter("endTime");
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd' 'HH:mm");
                reservation.setStartTime(LocalDateTime.parse(startDate, formatter));
                reservation.setEndTime(LocalDateTime.parse(endDate, formatter));
                reservation.setAttendees(Integer.parseInt(request.getParameter("attendees")));
                
                boolean success = reservationDAO.updateReservation(reservation, user.getUserId());
                if (success) {
                    session.setAttribute("success", "Reservation updated successfully");
                } else {
                    session.setAttribute("error", "Failed to update reservation");
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/user/reservations");
        } catch (Exception e) {
            session.setAttribute("error", "Error processing request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user/reservations");
        }
    }
}