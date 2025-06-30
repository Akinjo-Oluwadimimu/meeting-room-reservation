package com.roomreserve.servlets;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.StatusUpdate;
import com.roomreserve.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/reservations/*")
public class ReservationDetailServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        reservationDAO = new ReservationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/user/reservations");
            return;
        }

        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 2) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int reservationId = Integer.parseInt(pathParts[1]);
            Reservation reservation = reservationDAO.getReservationById(reservationId, user.getUserId());
            List<StatusUpdate> updates = reservationDAO.getStatusUpdates(reservationId);

            if (reservation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            request.setAttribute("reservation", reservation);
            request.setAttribute("updates", updates);
            request.getRequestDispatcher("/user/reservation-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}