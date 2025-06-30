package com.roomreserve.servlets;

import com.google.gson.Gson;
import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.model.Reservation;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// ApprovalRequestsServlet.java
@WebServlet("/approval-requests")
public class ApprovalRequestsServlet extends HttpServlet {
    private ReservationDAO reservationDao;
    
    @Override
    public void init() {
        reservationDao = new ReservationDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String timeFilter = request.getParameter("filter");
        if (timeFilter == null) timeFilter = "all";
        
        List<Reservation> pendingReservations = reservationDao.getPendingReservations(timeFilter, 5);
        int totalCount = reservationDao.getPendingReservationsCount(timeFilter);
        
        Map<String, Object> resp = new HashMap<>();
        resp.put("data", pendingReservations); // Just the 5 records
        resp.put("totalCount", totalCount); 

        String json = new Gson().toJson(resp);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
}