package com.roomreserve.servlets;

import com.roomreserve.dao.LoginLogDAO;
import com.roomreserve.dao.NotificationDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.LoginLog;
import com.roomreserve.model.Notification;
import com.roomreserve.model.User;
import com.roomreserve.util.AuthUtil;
import com.roomreserve.util.DBUtil;
import com.roomreserve.util.NotificationService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            super.init();
            this.notificationDAO = new NotificationDAO();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            
            String ipAddress = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String rememberMe = request.getParameter("remember-me");
            
            UserDAO userDAO = new UserDAO();
            LoginLogDAO loginLogDAO = new LoginLogDAO(DBUtil.getConnection());
            
            
            try {
                User user = userDAO.findByUsername(username);
                LoginLog loginLog = new LoginLog();
                loginLog.setUsername(username);
                loginLog.setIpAddress(ipAddress);
                loginLog.setUserAgent(userAgent);
                
                if (user == null) {
                    // User not found
                    loginLog.setStatus("FAILED");
                    loginLog.setFailureReason("USER_NOT_FOUND");
                    loginLogDAO.logLoginAttempt(loginLog);
                    
                    request.setAttribute("errorMessage", "Invalid username or password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                
                if (!AuthUtil.verifyPassword(password, user.getPasswordHash())) {
                    // Wrong password
                    loginLog.setUserId(user.getUserId());
                    loginLog.setStatus("FAILED");
                    loginLog.setFailureReason("WRONG_PASSWORD");
                    loginLogDAO.logLoginAttempt(loginLog);
                    
                    request.setAttribute("errorMessage", "Invalid username or password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                
                if (!user.isActive()) {
                    // Account inactive
                    loginLog.setUserId(user.getUserId());
                    loginLog.setStatus("FAILED");
                    loginLog.setFailureReason("ACCOUNT_INACTIVE");
                    loginLogDAO.logLoginAttempt(loginLog);
                    
                    request.setAttribute("errorMessage", "Your account is disabled");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                
                // Successful login
                loginLog.setUserId(user.getUserId());
                loginLog.setStatus("SUCCESS");
                loginLogDAO.logLoginAttempt(loginLog);
                NotificationService notificationService = new NotificationService();
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userRole", user.getRole());
                session.setAttribute("userEmail", user.getEmail());
//                int unreadCount = notificationDAO.getUnreadCount(user.getUserId());
//                session.setAttribute("unreadCount", unreadCount);
                // Get recent notifications for dropdown
//                List<Notification> recentNotifications = notificationService.getNotifications(user.getUserId(), 0, 5);
//                session.setAttribute("recentNotifications", recentNotifications);
                
                // Determine redirect first
                String redirectPage = determineRedirectPage(user.getRole());
                
                // Perform redirect before any other operations
                response.sendRedirect(request.getContextPath() + redirectPage);
                
                // Then handle other operations
                new UserDAO().updateLastLogin(user.getUserId());
                handleRememberMe(request, response, rememberMe, user.getUsername());
                
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Database error occurred");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private void handleRememberMe(HttpServletRequest request,
            HttpServletResponse response, String rememberMe, String username) {
        
        if ("on".equals(rememberMe)) {
            Cookie usernameCookie = new Cookie("rememberedUsername", username);
            usernameCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            usernameCookie.setHttpOnly(true);
            usernameCookie.setPath(request.getContextPath());
            response.addCookie(usernameCookie);
        } else {
            removeRememberMeCookie(request, response);
        }
    }
    
    private void removeRememberMeCookie(HttpServletRequest request,
            HttpServletResponse response) {
        
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUsername".equals(cookie.getName())) {
                    cookie.setMaxAge(0);
                    cookie.setPath(request.getContextPath());
                    response.addCookie(cookie);
                    break;
                }
            }
        }
    }
    
    private String determineRedirectPage(String role) {
        switch (role) {
            case "admin":
                return "/admin";
            case "manager":
                return "/manager";
            default:
                return "/user";
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        checkRememberedUsername(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
        dispatcher.forward(request, response);
    }
    
    private void checkRememberedUsername(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUsername".equals(cookie.getName())) {
                    request.setAttribute("rememberedUsername", cookie.getValue());
                    break;
                }
            }
        }
    }
}