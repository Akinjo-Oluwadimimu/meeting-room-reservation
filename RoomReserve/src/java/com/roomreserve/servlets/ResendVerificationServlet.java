package com.roomreserve.servlets;

import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.User;
import com.roomreserve.util.EmailUtil;
import com.roomreserve.util.TokenGenerator;
import java.io.IOException;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/resend-verification")
public class ResendVerificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                int userId = (int) session.getAttribute("userId");
                UserDAO userDAO = new UserDAO();
                User user = userDAO.findById(userId);
                
                // Generate new verification token
                String token = TokenGenerator.generateToken();
                Timestamp expiresAt = TokenGenerator.getExpirationTime();
                userDAO.updateVerificationToken(userId, token, expiresAt);
                
                // Send verification email
                String verificationLink = request.getRequestURL().toString()
                        .replace("resend-verification", "verify-email") 
                        + "?token=" + token;
                
                EmailUtil.sendVerificationEmail(user.getEmail(), verificationLink);
                
                // Redirect with success message
                response.sendRedirect("verify-email-prompt.jsp?sent=true");
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Failed to resend verification email. Please try again.");
                request.getRequestDispatcher("verify-email-prompt.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}