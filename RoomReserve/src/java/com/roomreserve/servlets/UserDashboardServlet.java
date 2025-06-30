package com.roomreserve.servlets;

import com.roomreserve.dao.FavoriteRoomDAO;
import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.RoomSchedule;
import com.roomreserve.model.RoomUtilization;
import com.roomreserve.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/user"})
public class UserDashboardServlet extends HttpServlet {
    
    private final ReservationDAO reservationDao = new ReservationDAO();
    private final FavoriteRoomDAO favoriteRoomDAO;
    private final RoomDAO roomDao;

    public UserDashboardServlet() throws SQLException {
        this.favoriteRoomDAO = new FavoriteRoomDAO();
        this.roomDao = new RoomDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get the logged-in manager from session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Parse date parameter or use today's date
            LocalDate localDate = LocalDate.now();
            
            // Convert LocalDate to java.util.Date
            Date date = Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
            
            // Get dashboard data
            Map<String, String> stats = reservationDao.getCancellationStats(user.getUserId());
        
            request.setAttribute("cancellationCount", stats.getOrDefault("count", "0"));
            request.setAttribute("lastCancelledRoom", stats.getOrDefault("last_room", "N/A"));
            request.setAttribute("timeframe", stats.getOrDefault("timeframe", "No recent cancellations"));
            
            // New upcoming meetings code
            Map<String, Object> upcomingStats = reservationDao.getUpcomingMeetingsStats(user.getUserId());
            request.setAttribute("upcomingCount", upcomingStats.getOrDefault("count", 0));

            @SuppressWarnings("unchecked")
            Map<String, String> nextMeeting = (Map<String, String>) upcomingStats.get("nextMeeting");
            if (nextMeeting != null) {
                request.setAttribute("nextMeetingRoom", nextMeeting.get("room"));
                request.setAttribute("nextMeetingTime", nextMeeting.get("timeInfo"));
            } else {
                request.setAttribute("nextMeetingRoom", "No upcoming meetings");
                request.setAttribute("nextMeetingTime", "");
            }
            
            int favoriteRoomsCount = favoriteRoomDAO.getFavoriteRoomCount(user.getUserId());
            request.setAttribute("favoriteRoomsCount", favoriteRoomsCount);
            if (favoriteRoomsCount > 0){
                String lastfavoriteRoom = favoriteRoomDAO.getRecentFavoriteRoom(user.getUserId());
                request.setAttribute("recentFavoriteRoom", "Most Recent: " + lastfavoriteRoom);
            } else {
                request.setAttribute("recentFavoriteRoom", "No recent favorites");
            }
            
            int pendingApprovalsCount = reservationDao.getPendingApprovalsCount(user.getUserId());
            
            // Get today's schedule
            List<Reservation> todaysSchedule = reservationDao.getTodaysReservations(user.getUserId(), date);
            List<Reservation> userUpcomingReservation = reservationDao.getUserUpcomingReservation(user.getUserId(), date, getDateOneWeekAfter());
            // Prepare data for the view
            request.setAttribute("user", user);
            request.setAttribute("rooms", roomDao.getAllAvailableRooms());
            request.setAttribute("pendingApprovalsCount", pendingApprovalsCount);
            request.setAttribute("todaysSchedule", todaysSchedule);
            request.setAttribute("userUpcomingReservation", userUpcomingReservation);
            
            // Forward to the manager dashboard JSP
            request.getRequestDispatcher("/user/dashboard.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(UserDashboardServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private Date getDateOneWeekAfter() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.WEEK_OF_YEAR, +1);
        return cal.getTime();
    }
}