package com.roomreserve.filters;

import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.Notification;
import com.roomreserve.util.NotificationService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {
    
    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
        "/login.jsp", "/register.jsp", "/about.jsp", "/contact.jsp", "/site.webmanifest",
        "/index.jsp", "/images", "/css", "/js", "/fonts", "/error", "/check-user", "/reset-password",
        "/login", "/register", "/forgot-password", "/reset-password", "/verify-email",
        "/resources"
    ));

    private static final Set<String> MINIMAL_FOOTER_PATHS = new HashSet<>(Arrays.asList(
        "/login.jsp", "/register.jsp", "/forgot-password.jsp", "/reset-password.jsp",
        "/verify-email-prompt.jsp", "/verify-email.jsp"
    ));

    private static final Set<String> VERIFICATION_BYPASS_PATHS = new HashSet<>(Arrays.asList(
        "/verify-email", "/resend-verification", "/logout", "/verify-email-prompt.jsp", "/forgot-password", "/reset-password"
    ));

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        String contextPath = request.getContextPath();
        String finalPath = normalizePath(request.getRequestURI().substring(contextPath.length()));
        
        request.setAttribute("useMinimalFooter", shouldUseMinimalFooter(finalPath));
        
        // Handle public paths
        if (isPublicPath(finalPath)) {
            if (isAuthPage(finalPath) && isLoggedIn(session)) {
                response.sendRedirect(contextPath + "/index.jsp");
                return;
            }
            chain.doFilter(request, response);
            return;
        }
        
        // Authentication check
        if (!isLoggedIn(session)) {
            handleUnauthenticatedRequest(finalPath, session, request, response, contextPath);
            return;
        }
        
        // Verification check
        if (!isVerificationBypassPath(finalPath) && !checkEmailVerification(session, response, contextPath)) {
            return;
        }
        
        // Role check
        if (!checkRoleAccess(finalPath, session, response)) {
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId != null) {
            NotificationService notificationService = new NotificationService();
            
            // Get unread count for badge
            int unreadCount = notificationService.getUnreadCount(userId);
            request.setAttribute("unreadCount", unreadCount);
            
            // Get recent notifications for dropdown
            List<Notification> recentNotifications = notificationService.getNotifications(userId, 0, 5);
            request.setAttribute("recentNotifications", recentNotifications);
        }
        
        chain.doFilter(request, response);
    }

    private String normalizePath(String path) {
        return path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
    }

    private boolean shouldUseMinimalFooter(String path) {
        return MINIMAL_FOOTER_PATHS.stream().anyMatch(p -> 
            path.startsWith(p) || path.equals(p.replace(".jsp", ""))
        );
    }

    private boolean isPublicPath(String path) {
        return PUBLIC_PATHS.stream().anyMatch(p -> 
            path.startsWith(p) || path.equals(p.replace(".jsp", ""))
        );
    }

    private boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("userId") != null;
    }

    private boolean isAuthPage(String path) {
        return path.endsWith("login.jsp") || path.endsWith("register.jsp") || 
               path.equals("/login") || path.equals("/register");
    }

    private boolean isVerificationBypassPath(String path) {
        return VERIFICATION_BYPASS_PATHS.stream().anyMatch(p -> 
            path.startsWith(p) || path.equals(p.replace(".jsp", ""))
        );
    }

    private void handleUnauthenticatedRequest(String path, HttpSession session,
            HttpServletRequest request, HttpServletResponse response, String contextPath) 
            throws IOException {
        if (!isAuthPage(path)) {
            String redirectAfterLogin = path;
            if (request.getQueryString() != null) {
                redirectAfterLogin += "?" + request.getQueryString();
            }
            
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("redirectAfterLogin", redirectAfterLogin);
        }
        response.sendRedirect(contextPath + "/login.jsp");
    }

    private boolean checkEmailVerification(HttpSession session, 
            HttpServletResponse response, String contextPath) 
            throws IOException {
        try {
            UserDAO userDAO = new UserDAO();
            int userId = (int) session.getAttribute("userId");

            if (!userDAO.isVerified(userId)) {
                response.sendRedirect(contextPath + "/verify-email-prompt.jsp");
                return false;
            }
            return true;
        } catch (SQLException e) {
            Logger.getLogger(AuthFilter.class.getName()).log(Level.SEVERE, "Database error during verification check", e);
            response.sendRedirect(contextPath + "/error/500.jsp");
            return false;
        }
    }

    private boolean checkRoleAccess(String path, HttpSession session, 
            HttpServletResponse response) 
            throws IOException {
        String userRole = (String) session.getAttribute("userRole");
        
        if (path.startsWith("/admin/") && !"admin".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        
        if (path.startsWith("/manager/") && !("manager".equals(userRole) || "admin".equals(userRole))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        
        if (path.startsWith("/faculty/") && !("faculty".equals(userRole) || "admin".equals(userRole))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        
        if (path.startsWith("/user/") && !("student".equals(userRole) || "admin".equals(userRole) || "faculty".equals(userRole) || "staff".equals(userRole))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        
        return true;
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Logger.getLogger(AuthFilter.class.getName()).log(Level.INFO, "AuthFilter initialized");
    }

    @Override
    public void destroy() {
        Logger.getLogger(AuthFilter.class.getName()).log(Level.INFO, "AuthFilter destroyed");
    }
}