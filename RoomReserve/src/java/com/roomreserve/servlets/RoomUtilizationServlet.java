/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.roomreserve.servlets;


import com.roomreserve.dao.RoomUtilizationDAO;
import com.roomreserve.model.RoomUtilization;
import com.roomreserve.model.CancellationAnalysis;
import com.roomreserve.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet({"/manager/analytics", "/admin/analytics"})
public class RoomUtilizationServlet extends HttpServlet {
    private RoomUtilizationDAO utilizationDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            super.init();
            utilizationDAO = new RoomUtilizationDAO();
        } catch (SQLException ex) {
            Logger.getLogger(RoomUtilizationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !(user.getRole().equals("manager") || user.getRole().equals("admin"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String period = request.getParameter("period") != null ? 
                        request.getParameter("period") : "week";
        
        LocalDateTime end = LocalDateTime.now();
        LocalDateTime start = calculateStartDate(period, end);
        String duration = getDuration(period);
        
        // Room utilization data
        List<RoomUtilization> utilization = utilizationDAO.getRoomUtilization(start, end);
        double overallRate = utilizationDAO.getOverallUtilizationRate(start, end);
        Map<String, Double> trend = utilizationDAO.getUtilizationTrend(period);
        int totalCompleted = utilization.stream()
                                      .mapToInt(u -> u.getCompletedCount())
                                      .sum();
        int totalCancelled = utilization.stream()
                                      .mapToInt(u -> u.getCancelledCount())
                                      .sum();
        int totalScheduled = utilization.stream()
                                      .mapToInt(u -> u.getCompletedCount() + u.getCancelledCount() + u.getNoShowCount())
                                      .sum();
        
        // Cancellation analysis
        List<CancellationAnalysis> cancellations = utilizationDAO.getCancellationAnalysis(start, end);
        Map<String, Integer> cancellationReasons = utilizationDAO.getCancellationReasons(start, end);
        
        request.setAttribute("period", period);
        request.setAttribute("duration", duration);
        request.setAttribute("startDate", start);
        request.setAttribute("endDate", end);
        request.setAttribute("utilization", utilization);
        request.setAttribute("overallRate", overallRate);
        request.setAttribute("trend", trend);
        request.setAttribute("cancellations", cancellations);
        request.setAttribute("cancellationReasons", cancellationReasons);
        request.setAttribute("totalCompleted", totalCompleted);
        request.setAttribute("totalCancelled", totalCancelled);
        request.setAttribute("totalScheduled", totalScheduled);
        request.setAttribute("utilizationData", utilizationDAO.getRoomUtilization(start, end, period));
        request.setAttribute("cancellationRates", utilizationDAO.getCancellationRates(start, end));
        request.setAttribute("cancellationReasons", utilizationDAO.getCancellationReasons(start, end));
        request.setAttribute("peakHours", utilizationDAO.getPeakUsageHours(start, end));
        
        if (user.getRole().equals("manager")){
            request.getRequestDispatcher("/manager/analytics.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/admin/analytics.jsp").forward(request, response);
        }
    }
    
    private LocalDateTime calculateStartDate(String period, LocalDateTime end) {
        switch (period.toLowerCase()) {
            case "hour":
                return end.minusHours(24);
            case "day":
                return end.minusDays(7);
            case "week":
                return end.minusWeeks(4);
            case "month":
                return end.minusMonths(12);
            default:
                return end.minusWeeks(4);
        }
    }
    
    private String getDuration(String period) {
        switch (period.toLowerCase()) {
            case "hour":
                return "Past 24 hours";
            case "day":
                return "Past 7 days";
            case "week":
                return "Past 4 weeks";
            case "month":
                return "Past 12 months";
            default:
                return "Past 4 weeks";
        }
    }
}
