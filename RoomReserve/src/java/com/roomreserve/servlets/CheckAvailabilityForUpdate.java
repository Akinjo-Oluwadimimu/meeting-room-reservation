package com.roomreserve.servlets;

import com.roomreserve.dao.ReservationDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/user/checkAvailabilityForUpdate")
public class CheckAvailabilityForUpdate extends HttpServlet {
    private ReservationDAO reservationService;

    @Override
    public void init() {
        reservationService = new ReservationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String startDateTimeStr = request.getParameter("startDateTime");
            String endDateTimeStr = request.getParameter("endDateTime");
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
            LocalDateTime startDateTime = LocalDateTime.parse(startDateTimeStr, formatter);
            LocalDateTime endDateTime = LocalDateTime.parse(endDateTimeStr, formatter);
            
            boolean isAvailable = reservationService.isRoomAvailableForUpdate(reservationId, roomId, startDateTime, endDateTime);
            
            // Create a proper JSON response
            String jsonResponse = String.format(
                "{\"available\": %b, \"message\": \"%s\"}", 
                isAvailable,
                isAvailable ? "Room is available" : "Room is not available at the selected time"
            );
           
            response.getWriter().write(jsonResponse);
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(
                "{\"error\": \"Invalid request\", \"details\": \"" + 
                e.getMessage().replace("\"", "\\\"") + "\"}"
            );
        }
    }
}