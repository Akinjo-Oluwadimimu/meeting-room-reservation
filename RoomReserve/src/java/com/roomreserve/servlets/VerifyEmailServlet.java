package com.roomreserve.servlets;

import com.roomreserve.dao.UserDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/verify-email"})
public class VerifyEmailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String token = request.getParameter("token");
        
        if (token == null || token.isEmpty()) {
            request.setAttribute("errorContent", "The server cannot process your request due to invalid verification link.");
            request.getRequestDispatcher("/errors/400.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        try {
            // Verify token and mark user as verified
            boolean verified = userDAO.verifyEmailToken(token);
            
            if (verified) {
                response.sendRedirect("login.jsp?verified=true");
            } else {
                request.setAttribute("errorContent", "The server cannot process your request due to invalid or expired verification link.");
                request.getRequestDispatcher("/errors/400.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorContent", "Error verifying email. Please try again.");
            request.getRequestDispatcher("/errors/400.jsp").forward(request, response);
        }
    }
}