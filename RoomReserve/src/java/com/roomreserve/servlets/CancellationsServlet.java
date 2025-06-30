package com.roomreserve.servlets;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet({"/manager/cancellations", "/admin/cancellations"})
public class CancellationsServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    private static final int DEFAULT_LIMIT = 10;
    
    @Override
    public void init() throws ServletException {
        super.init();
        reservationDAO = new ReservationDAO();
        roomDAO = new RoomDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !(user.getRole().equals("manager") || user.getRole().equals("admin"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            int page = 1;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            int limit = DEFAULT_LIMIT;
            if (request.getParameter("limit") != null) {
                limit = Integer.parseInt(request.getParameter("limit"));
            }

            int offset = (page - 1) * limit;
            int totalPages = 0;
            
            List<Reservation> cancellations;
            
            int roomId = 0;
            if (request.getParameter("roomId") != null && !request.getParameter("roomId").isEmpty()) {
                roomId = Integer.parseInt(request.getParameter("roomId"));
            }
             
            String searchDate = null;
            Date startDate = null;
            Date endDate = null;
            if (request.getParameter("startDate") != null && !request.getParameter("startDate").isEmpty()) {
                searchDate = request.getParameter("startDate");
                String[] dates = searchDate.split(" to ");
                String startDateStr = dates[0].trim(); 
                String endDateStr = null;
                if (dates.length > 1) {
                    endDateStr = dates[1].trim();
                } else {
                    endDateStr = dates[0].trim();
                }

                startDate = DATE_FORMAT.parse(startDateStr);
                endDate = DATE_FORMAT.parse(endDateStr);
            }
                
            String status  = request.getParameter("status");
            if ("cancelled".equals(status)  || "no-show".equals(status)) {
                cancellations = reservationDAO.getCancelledReservations(status, roomId, startDate, endDate, limit, offset);
                int totalReservations = reservationDAO.countCancellationsByStatus(status, roomId, startDate, endDate, limit, offset);
                totalPages = (int) Math.ceil((double) totalReservations / limit);
            } else {
                cancellations = reservationDAO.getCancelledReservations(null, roomId, startDate, endDate, limit, offset);
                int totalReservations = reservationDAO.countCancellationsByStatus(null, roomId, startDate, endDate, limit, offset);
                totalPages = (int) Math.ceil((double) totalReservations / limit);
            }
            
            request.setAttribute("cancellations", cancellations);
            request.setAttribute("rooms", roomDAO.getAllRooms());
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("offset", offset);
            request.setAttribute("limit", limit);
            request.setAttribute("statusFilter", status);
            request.setAttribute("roomIdFilter", roomId);
            request.setAttribute("dateFilter", searchDate);
            
            if (user.getRole().equals("manager")){
                request.getRequestDispatcher("/manager/cancellations.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/cancellations.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room or user ID");
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(CancellationsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}