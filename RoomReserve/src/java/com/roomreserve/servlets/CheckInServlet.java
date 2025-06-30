package com.roomreserve.servlets;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.model.CheckInResult;
import com.roomreserve.util.CheckInService;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/user/checkin")
public class CheckInServlet extends HttpServlet {
    private CheckInService checkInService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        // Initialize with dependencies
        this.checkInService = new CheckInService(
            new ReservationDAO()
//            new NotificationService()
        );
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws IOException {
        
        String reservationId = request.getParameter("reservationId");
        
        CheckInResult result = checkInService.checkIn(Integer.parseInt(reservationId));
        
        response.setContentType("application/json");
        response.getWriter().print(gson.toJson(result));
    }
}