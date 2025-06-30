package com.roomreserve.servlets;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.Room;
import com.roomreserve.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/user/calendar")
public class UserCalendarServlet extends HttpServlet {

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
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
        
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            int userId = user.getUserId();
            
                
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
            List<Reservation> reservations = reservationDAO.getUserReservations(userId, true, null, 0, null, null);

            request.setAttribute("reservations", reservations);
            request.setAttribute("startDate", start);
            request.setAttribute("endDate", end);
                
            request.getRequestDispatcher("/user/calendar.jsp").forward(request, response);
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
                    response.sendRedirect(request.getContextPath() + "/user/calendar?roomId=" + 
                        request.getParameter("roomId") + "&success=Status updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/calendar?roomId=" + 
                        request.getParameter("roomId") + "&error=Update failed");
                }
            }
            // Handle other POST actions (create, update, delete)
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/user/calendar?roomId=" + 
                request.getParameter("roomId") + "&error=Operation failed");
        }
    }
}