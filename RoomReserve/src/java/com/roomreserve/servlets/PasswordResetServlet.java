package com.roomreserve.servlets;

import com.roomreserve.dao.PasswordResetDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.util.EmailUtil;
import com.roomreserve.util.TokenGenerator;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/forgot-password")
public class PasswordResetServlet extends HttpServlet {
    private UserDAO userDao;
    private PasswordResetDAO passwordResetDao;
    private EmailUtil emailUtil;

    @Override
    public void init() throws ServletException {
        super.init();
        userDao = new UserDAO();
        passwordResetDao = new PasswordResetDAO();
        emailUtil = new EmailUtil();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        try {
            // Check if user exists
            if (!userDao.userExists(email)) {
                // For security, don't reveal if email doesn't exist
                request.setAttribute("message", "If an account exists with this email, a reset link has been sent.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Generate token and expiration (1 hour from now)
            String token = TokenGenerator.generateToken();
            LocalDateTime expiryDate = LocalDateTime.now().plusHours(1);
            Date expiresAt = Date.from(expiryDate.atZone(ZoneId.systemDefault()).toInstant());

            // Store token in database
            int userId = userDao.getUserIdByEmail(email);
            passwordResetDao.createPasswordResetToken(userId, token, expiresAt);

            // Send email with reset link
            String resetLink = request.getRequestURL().toString()
                    .replace("forgot-password", "reset-password") + "?token=" + token;
            
            emailUtil.sendPasswordResetEmail(email, resetLink);

            request.setAttribute("message", "If an account exists with this email, a reset link has been sent.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing your request: " + e.getMessage());
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
}