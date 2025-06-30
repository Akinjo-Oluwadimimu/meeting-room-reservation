package com.roomreserve.servlets;

import com.roomreserve.dao.UserDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/check-user")
public class CheckUserExistsServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO(); // or inject this

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("type");
        String value = request.getParameter("value");

        boolean exists = false;
        if (null != type) switch (type) {
            case "username":
                try {
                    exists = userDAO.isUsernameTaken(value);
                } catch (SQLException ex) {
                    Logger.getLogger(CheckUserExistsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }   break;
            case "email":
                try {
                    exists = userDAO.isEmailTaken(value);
                } catch (SQLException ex) {
                    Logger.getLogger(CheckUserExistsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }   break;
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"exists\": " + exists + "}");
    }
}

