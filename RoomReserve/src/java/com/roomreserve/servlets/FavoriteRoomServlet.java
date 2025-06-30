package com.roomreserve.servlets;

import com.roomreserve.dao.FavoriteRoomDAO;
import com.roomreserve.model.Room;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/user/favorites")
public class FavoriteRoomServlet extends HttpServlet {
    private FavoriteRoomDAO favoriteDao;

    @Override
    public void init() {
        try {
            favoriteDao = new FavoriteRoomDAO();
        } catch (SQLException ex) {
            Logger.getLogger(FavoriteRoomServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        int roomId = Integer.parseInt(request.getParameter("room_id"));

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        boolean success = false;
        switch (action) {
            case "add":
                success = favoriteDao.addFavorite(userId, roomId);
                break;
            case "remove":
                success = favoriteDao.removeFavorite(userId, roomId);
                break;
            case "set-default":
                success = favoriteDao.setDefaultFavorite(userId, roomId);
                break;
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + "}");
        out.flush();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Room> favorites = favoriteDao.getUserFavorites(userId);
        request.setAttribute("favoriteRooms", favorites);
        request.getRequestDispatcher("/user/favorites.jsp").forward(request, response);
    }
}