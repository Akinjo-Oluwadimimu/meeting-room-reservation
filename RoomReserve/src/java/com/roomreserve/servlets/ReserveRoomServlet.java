package com.roomreserve.servlets;

import com.roomreserve.dao.RoomDAO;
import com.roomreserve.model.Room;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ReserveRoomServlet", urlPatterns = {"/user/reserve/*"})
public class ReserveRoomServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        RoomDAO roomDAO = new RoomDAO();
        Room room = new Room();
        try {
            room = roomDAO.getRoomById(roomId);
        } catch (SQLException ex) {
            Logger.getLogger(ViewRoomServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        session.setAttribute("room", room);
        request.getRequestDispatcher("/user/reserve.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}