package com.roomreserve.servlets;


import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.exceptions.ValidationException;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.Room;
import com.roomreserve.model.User;
import com.roomreserve.util.EmailService;
import com.roomreserve.util.ReservationValidationService;
import com.roomreserve.util.SettingsService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/user/reservation/*")
public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;
    private UserDAO userDAO;
    private EmailService emailService;
    private ReservationValidationService validationService;
    
    @Override
    public void init() throws ServletException {
        try {
            super.init();
            reservationDAO = new ReservationDAO();
            roomDAO = new RoomDAO();
            userDAO = new UserDAO();
            emailService = new EmailService();
            this.validationService = new ReservationValidationService(new SettingsService());
        } catch (SQLException ex) {
            Logger.getLogger(ReservationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Room room = roomDAO.getRoomById(roomId);
            
            if (room == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            response.sendRedirect(request.getContextPath() + "/user/rooms?roomId=" + room.getId());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        } catch (SQLException ex) {
            Logger.getLogger(ReservationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Reservation reservation = new Reservation();
            String reservationDate = request.getParameter("reservationDate");
            String startDate = reservationDate + " " + request.getParameter("startTime");
            String endDate = reservationDate + " " + request.getParameter("endTime");
            reservation.setRoomId(Integer.parseInt(request.getParameter("roomId")));
            reservation.setTitle(request.getParameter("title"));
            reservation.setPurpose(request.getParameter("purpose"));
            reservation.setAttendees(Integer.parseInt(request.getParameter("attendees")));
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd' 'HH:mm");
            reservation.setStartTime(LocalDateTime.parse(startDate, formatter));
            reservation.setEndTime(LocalDateTime.parse(endDate, formatter));
            
            if (!reservationDAO.isRoomAvailable(reservation.getRoomId(), 
                    reservation.getStartTime(), reservation.getEndTime())) {
                request.setAttribute("error", "The room is not available during the selected time slot");
                session.setAttribute("fieldError", "time");
                session.setAttribute("errorCode", "ROOM_AVAILABILITY");
                doGet(request, response);
                return;
            }

            // Validate before processing
            validationService.validateReservation(reservation);
            
            // Process valid reservation
            int id = reservationDAO.createReservation(reservation, userId);
            if (id > 0) {
                reservation.setId(id);
                User user = userDAO.findById(userId);
                session.setAttribute("success", "Reservation created successfully");
                emailService.sendReservationConfirmation(reservation, user);
                response.sendRedirect(request.getContextPath() + "/user/reservations");
            } else {
                session.setAttribute("error", "Failed to create reservation");
                doGet(request, response);
            }
        } catch (ValidationException e) {
            // Handle validation errors
            session.setAttribute("error", e.getMessage());
            session.setAttribute("fieldError", e.getFieldName());
            session.setAttribute("errorCode", e.getErrorCode());
            
            // Redisplay form with errors
            doGet(request, response);
        } catch (NumberFormatException | ServletException | IOException | SQLException e) {
            session.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
    
}
