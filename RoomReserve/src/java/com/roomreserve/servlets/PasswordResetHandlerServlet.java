package com.roomreserve.servlets;


import com.roomreserve.dao.PasswordResetDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.util.AuthUtil;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/reset-password")
public class PasswordResetHandlerServlet extends HttpServlet {
    private PasswordResetDAO passwordResetDao;
    private UserDAO userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        passwordResetDao = new PasswordResetDAO();
        userDao = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        
        try {
            if (token == null || token.isEmpty()) {
                request.setAttribute("error", "Invalid or missing reset token");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // Validate token
            if (!passwordResetDao.isTokenValid(token)) {
                request.setAttribute("error", "Invalid or expired token");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // Token is valid, proceed to password reset form
            String email = userDao.getEmailByResetToken(token);
            request.setAttribute("token", token);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error validating token: " + e.getMessage());
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        try {
            // Validate inputs
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            if (password.length() < 8) {
                request.setAttribute("error", "Password must be at least 8 characters");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // Validate token
            if (!passwordResetDao.isTokenValid(token)) {
                request.setAttribute("error", "Invalid or expired token");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // Update password
            int userId = passwordResetDao.getUserIdByToken(token);
            String passwordHash = AuthUtil.hashPassword(password);
            userDao.updatePassword(userId, passwordHash);

            // Delete all reset tokens for this user
            passwordResetDao.deleteTokensForUser(userId);

            // Send confirmation email would go here

            request.setAttribute("message", "Password updated successfully. You can now login with your new password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error resetting password: " + e.getMessage());
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }
}
