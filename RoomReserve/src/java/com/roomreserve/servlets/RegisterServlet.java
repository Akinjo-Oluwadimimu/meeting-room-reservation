package com.roomreserve.servlets;

import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.User;
import com.roomreserve.util.AuthUtil;
import com.roomreserve.util.EmailUtil;
import com.roomreserve.util.TokenGenerator;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        String firstName = request.getParameter("first-name");
        String lastName = request.getParameter("last-name");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        //int departmentId = Integer.parseInt(request.getParameter("department"));
        
        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Validate password strength
        if (!isPasswordValid(password)) {
            request.setAttribute("errorMessage", 
                "Password must be at least 8 characters and contain uppercase, lowercase, number, and special character");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        try {
            // Check if username or email already exists
            if (userDAO.isUsernameTaken(username)) {
                request.setAttribute("errorMessage", "Username already taken");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (userDAO.isEmailTaken(email)) {
                request.setAttribute("errorMessage", "Email already registered");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Create user object
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            //user.setDepartmentId(departmentId);
            user.setPasswordHash(AuthUtil.hashPassword(password));
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setPhone(phone);
            user.setRole(role);
            
            // Save user to database
            int userId = userDAO.createUser(user);
            
            // Generate verification token
            String token = TokenGenerator.generateToken();
            Timestamp expiresAt = TokenGenerator.getExpirationTime();
            userDAO.createVerificationToken(userId, token, expiresAt);
            
            // Send verification email
            String verificationLink = request.getRequestURL().toString()
                    .replace("register", "verify-email") + "?token=" + token;
            EmailUtil.sendVerificationEmail(email, verificationLink);
            
            // Redirect to success page
            response.sendRedirect("register-success.jsp");
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    private boolean isPasswordValid(String password) {
        int strength = 0;

        // Length check
        if (password.length() >= 8) strength++;

        // Uppercase
        if (password.matches(".*[A-Z].*")) strength++;

        // Lowercase
        if (password.matches(".*[a-z].*")) strength++;

        // Number
        if (password.matches(".*\\d.*")) strength++;

        // Special character (escaped properly)
        if (password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?].*")) strength++;


        return strength >= 3;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}