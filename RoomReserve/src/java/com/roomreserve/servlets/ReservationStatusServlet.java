package com.roomreserve.servlets;

import com.google.gson.Gson;
import com.roomreserve.dao.ReservationDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/reservation-status")
public class ReservationStatusServlet extends HttpServlet {
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String period = request.getParameter("period");
    ReservationDAO reservationDAO = new ReservationDAO();
    Map<String, Integer> data = new HashMap<>();
    data.put("approvedCount", reservationDAO.countReservationsByStatus("approved", period));
    data.put("pendingCount", reservationDAO.countReservationsByStatus("pending", period));
    data.put("cancelledCount", reservationDAO.countReservationsByStatus("cancelled", period));
    data.put("rejectedCount", reservationDAO.countReservationsByStatus("rejected", period));
    data.put("completedCount", reservationDAO.countReservationsByStatus("completed", period));
    data.put("noShowCount", reservationDAO.countReservationsByStatus("no-show", period));
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    String json = new Gson().toJson(data);
    response.getWriter().write(json);
    }
}