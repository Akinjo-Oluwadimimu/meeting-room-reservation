package com.roomreserve.servlets;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.exceptions.ValidationException;
import com.roomreserve.model.User;
import com.roomreserve.util.AuthUtil;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("/login");
            return;
        }
        
        try {
            User user = userDAO.findById(userId);
            
            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("updateProfile".equals(action)) {
                // Update profile information
                User user = new User();
                user.setUserId(userId);
                user.setFirstName(request.getParameter("firstName"));
                user.setLastName(request.getParameter("lastName"));
                user.setEmail(request.getParameter("email"));
                user.setPhone(request.getParameter("phone"));
                
                if (userDAO.updateUser(user)) {
                    user = userDAO.findById(userId);
                    session.setAttribute("user", user);
                    session.setAttribute("success", "Profile updated successfully!");
                } else {
                    session.setAttribute("error", "Failed to update profile.");
                }
                
            } else if ("changePassword".equals(action)) {
                // Change password
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                
                // Validate passwords match
                if (!newPassword.equals(confirmPassword)) {
                    session.setAttribute("error", "New passwords do not match.");
                    response.sendRedirect("profile.jsp");
                    return;
                }
                
                // Verify current password (you would hash and compare)
                User user = userDAO.findById(userId);

                if (user != null && AuthUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
                    validatePassword(newPassword, confirmPassword);
                    String newPasswordHash = AuthUtil.hashPassword(newPassword);
                    if (userDAO.updatePassword(userId, newPasswordHash)) {
                        session.setAttribute("success", "Password changed successfully!");
                    } else {
                        session.setAttribute("error", "Failed to change password.");
                    }
                } else {
                    // Current password wrong
                    session.setAttribute("errorMessage", "Current password wrong.");
                    session.setAttribute("fieldError", "oldPassword");
                }
            }
            response.sendRedirect("profile.jsp");
        } catch (IOException | SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect("profile.jsp");
        } catch (ValidationException e) {
            // Handle validation errors
            session.setAttribute("errorMessage", e.getMessage());
            session.setAttribute("fieldError", e.getFieldName());
            
            response.sendRedirect("profile.jsp");
        }
    }
    
    private void validatePassword(String password, String confirmPassword) throws ValidationException {
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            throw new ValidationException("confirmPassword", "Passwords do not match");
        }
        
        // Check minimum length
        if (password.length() < 8) {
            throw new ValidationException("password", "Password must be at least 8 characters long");
        }
        
        // Check for at least one uppercase letter
        if (!password.matches(".*[A-Z].*")) {
            throw new ValidationException("password", "Password must contain at least one uppercase letter");
        }
        
        // Check for at least one lowercase letter
        if (!password.matches(".*[a-z].*")) {
            throw new ValidationException("password", "Password must contain at least one lowercase letter");
        }
        
        // Check for at least one digit
        if (!password.matches(".*\\d.*")) {
            throw new ValidationException("password", "Password must contain at least one number");
        }
        
        // Check for at least one special character
        if (!password.matches(".*[@$!%*?&].*")) {
            throw new ValidationException("password", "Password must contain at least one special character (@$!%*?&)");
        }
    }
}
