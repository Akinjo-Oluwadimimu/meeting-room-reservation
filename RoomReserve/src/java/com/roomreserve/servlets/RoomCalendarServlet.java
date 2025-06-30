package com.roomreserve.servlets;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.Room;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "RoomCalendarServlet", urlPatterns = {"/manager/room-calendar"})
public class RoomCalendarServlet extends HttpServlet {

    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize DAOs (could use dependency injection)
        reservationDAO = new ReservationDAO();
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get all rooms for the dropdown
            List<Room> allRooms = roomDAO.getAllRooms();
            request.setAttribute("allRooms", allRooms);
            
            // Check if a specific room was requested
            String roomIdParam = request.getParameter("roomId");
            if (roomIdParam != null && !roomIdParam.isEmpty()) {
                int roomId = Integer.parseInt(roomIdParam);
                Room room = roomDAO.getRoomById(roomId);
                
                if (room != null) {
                    // Get date range parameters
                    String startStr = request.getParameter("start");
                    String endStr = request.getParameter("end");
                    
                    LocalDateTime start = startStr != null ? 
                        LocalDateTime.parse(startStr, DateTimeFormatter.ISO_DATE_TIME) : 
                        LocalDateTime.now().withHour(0).withMinute(0);
                        
                    LocalDateTime end = endStr != null ? 
                        LocalDateTime.parse(endStr, DateTimeFormatter.ISO_DATE_TIME) : 
                        LocalDateTime.now().plusDays(7).withHour(23).withMinute(59);
                    
                    // Get reservations for the selected room
                    List<Reservation> reservations = reservationDAO.getReservationsByRoom(roomId);
                    
                    request.setAttribute("selectedRoom", room);
                    request.setAttribute("reservations", reservations);
                    request.setAttribute("startDate", start);
                    request.setAttribute("endDate", end);
                }
            }
            
            request.getRequestDispatcher("/manager/room_calendar.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading room calendar" + e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("approve".equals(action) || "reject".equals(action)) {
                int reservationId = Integer.parseInt(request.getParameter("reservationId"));
                boolean success = reservationDAO.changeReservationStatus(reservationId, action + "d");
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/manager/room-calendar?roomId=" + 
                        request.getParameter("roomId") + "&success=Status updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/manager/room-calendar?roomId=" + 
                        request.getParameter("roomId") + "&error=Update failed");
                }
            }
            // Handle other POST actions (create, update, delete)
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manager/room-calendar?roomId=" + 
                request.getParameter("roomId") + "&error=Operation failed");
        }
    }
}