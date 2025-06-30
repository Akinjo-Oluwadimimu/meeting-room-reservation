package com.roomreserve.servlets;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            RoomDAO roomDAO = new RoomDAO();
            ReservationDAO reservationDAO = new ReservationDAO();

            // Get current counts
            int totalUsers = userDAO.countAllUsers();
            int totalRooms = roomDAO.countAllRooms();
            int activeReservations = reservationDAO.countReservationsByStatus("approved");
            int pendingApprovals = reservationDAO.countReservationsByStatus("pending");

            // Get previous period counts for percentage calculations
            int previousMonthUsers = userDAO.countUsersCreatedBefore(getDateOneWeekAgo());
            int previousWeekReservations = reservationDAO.countReservationsBefore(getDateOneWeekAgo(), "approved");
            int previousPendingApprovals = reservationDAO.countReservationsBefore(getDateYesterday(), "pending");

            // Calculate percentages
            double userGrowthPercentage = calculatePercentageChange(previousMonthUsers, totalUsers);
            double reservationGrowthPercentage = calculatePercentageChange(previousWeekReservations, activeReservations);
            double pendingChangePercentage = calculatePercentageChange(previousPendingApprovals, pendingApprovals);

            // Get recent reservations
            List<Reservation> recentReservations = reservationDAO.getRecentReservations();

            // Get room utilization data
            List<Object[]> utilizationData = reservationDAO.getRoomUtilizationData(7);
            
            NumberFormat nf = NumberFormat.getInstance();
            nf.setMaximumFractionDigits(1);
            String formattedPercentage = nf.format(Math.abs(userGrowthPercentage));
            request.setAttribute("formattedUserGrowth", formattedPercentage);

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("activeReservations", activeReservations);
            request.setAttribute("pendingApprovals", pendingApprovals);
            request.setAttribute("userGrowthPercentage", nf.format(Math.abs(userGrowthPercentage)));
            request.setAttribute("reservationGrowthPercentage", nf.format(Math.abs(reservationGrowthPercentage)));
            request.setAttribute("pendingChangePercentage", nf.format(Math.abs(pendingChangePercentage)));
            request.setAttribute("recentReservations", recentReservations);
            request.setAttribute("utilizationData", utilizationData);
            request.setAttribute("approvedCount", reservationDAO.countReservationsByStatus("approved"));
            request.setAttribute("pendingCount", reservationDAO.countReservationsByStatus("pending"));
            request.setAttribute("cancelledCount", reservationDAO.countReservationsByStatus("cancelled"));
            request.setAttribute("rejectedCount", reservationDAO.countReservationsByStatus("rejected"));
            request.setAttribute("noShowCount", reservationDAO.countReservationsByStatus("no-show"));
            request.setAttribute("completedCount", reservationDAO.countReservationsByStatus("completed"));
            

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private Date getDateOneMonthAgo() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -1);
        return cal.getTime();
    }

    private Date getDateOneWeekAgo() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.WEEK_OF_YEAR, -1);
        return cal.getTime();
    }

    private Date getDateYesterday() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_YEAR, -1);
        return cal.getTime();
    }

    private double calculatePercentageChange(int oldValue, int newValue) {
        if (oldValue == 0) return 0;
        return ((newValue - oldValue) / (double) oldValue) * 100;
    }
}