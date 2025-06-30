package com.roomreserve.controller;

import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.User;
import com.roomreserve.util.AuthUtil;
import com.roomreserve.util.EmailUtil;
import com.roomreserve.util.TokenGenerator;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserController", urlPatterns = {"/admin/UserController"})
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createUser(request, response);
                    break;
                case "edit":
                    updateUser(request, response);
                    break;
               case "toggleStatus":
                    toggleStatus(request, response);
                    break;
                     
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "delete":
                    deleteUser(request, response);
                    break;
                case "removeMember":
                    //removeDepartmentMember(request, response);
                    break;
                case "search":
                    searchUsers(request, response);
                    break;
                default:
                    response.sendRedirect("department_management.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        int userId = Integer.parseInt(request.getParameter("userId"));
        userDAO.toggleUserStatus(userId);
        session.setAttribute("message", "User status updated successfully");
        response.sendRedirect("user_management.jsp");
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = new User();
        String tempPassword = AuthUtil.generateTempPassword();
        String hashedPassword = AuthUtil.hashPassword(tempPassword);
        user.setFirstName(request.getParameter("first-name"));
        user.setLastName(request.getParameter("last-name"));
        user.setUsername(request.getParameter("username"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setRole(request.getParameter("role"));
        user.setPasswordHash(hashedPassword);
        
        try {
            if (userDAO.isUsernameTaken(user.getUsername())) {
                request.setAttribute("error", "Username already taken");
                request.getRequestDispatcher("user_management.jsp?create").forward(request, response);
                return;
            }
            
            if (userDAO.isEmailTaken(user.getEmail())) {
                request.setAttribute("error", "Email already reeadygistered");
                request.getRequestDispatcher("user_management.jsp?create").forward(request, response);
                return;
            }
            
            int userId = userDAO.createUser(user);
            
            EmailUtil.sendTempPasswordEmail(user.getEmail(), tempPassword);
            
            // Generate verification token
            String token = TokenGenerator.generateToken();
            Timestamp expiresAt = TokenGenerator.getExpirationTime();
            userDAO.createVerificationToken(userId, token, expiresAt);
            
            // Send verification email
            String verificationLink = request.getRequestURL().toString()
                    .replace("admin/UserController", "verify-email") + "?token=" + token;
            EmailUtil.sendVerificationEmail(user.getEmail(), verificationLink);
            request.setAttribute("message", "User created successfully");
            session.setAttribute("message", "User created successfully");
            response.sendRedirect("user_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error creating user");
            request.getRequestDispatcher("user_management.jsp?action=create").forward(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = Integer.parseInt(request.getParameter("userId"));
        User user = new User();
        user.setUserId(userId);
        user.setFirstName(request.getParameter("first-name"));
        user.setLastName(request.getParameter("last-name"));
        user.setUsername(request.getParameter("username"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setRole(request.getParameter("role"));
        
        try {
            userDAO.updateUser(user);
            session.setAttribute("message", "User updated successfully");
            response.sendRedirect("user_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating user");
            request.getRequestDispatcher("user_management.jsp?action=edit&id=" + userId).forward(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = Integer.parseInt(request.getParameter("id"));
        
        try {
            userDAO.deleteUser(userId);
            session.setAttribute("message", "User deleted successfully");
            response.sendRedirect("user_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting user");
            request.getRequestDispatcher("user_management.jsp").forward(request, response);
        }
    }

    private void searchUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String searchquery = request.getParameter("search_query");
        
        Boolean isActive = null;

        try {
            if (status != null && !status.isEmpty()) {
                isActive = Boolean.parseBoolean(status);
            }
        } catch (NumberFormatException e) {
            // Handle invalid parameters if needed
        }
    
        
        List<User> users = userDAO.searchUsers(searchquery, role, isActive);
        
        request.getRequestDispatcher("/admin/room_management.jsp").forward(request, response);
    }
    
}
