package com.roomreserve.servlets;

import com.roomreserve.dao.LoginLogDAO;
import com.roomreserve.model.LoginLog;
import com.roomreserve.util.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "LoginLogServlet", urlPatterns = {"/admin/login-logs"})
public class LoginLogServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int DEFAULT_LIMIT = 20;
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            
            LoginLogDAO loginLogDAO = new LoginLogDAO(DBUtil.getConnection());
            
            try {
                // Get pagination parameters
                int page = 1;
                if (request.getParameter("page") != null) {
                    page = Integer.parseInt(request.getParameter("page"));
                }
                
                int limit = DEFAULT_LIMIT;
                if (request.getParameter("limit") != null) {
                    limit = Integer.parseInt(request.getParameter("limit"));
                }
                
                int offset = (page - 1) * limit;
                
                // Get filter parameters
                String username = null;
                if (request.getParameter("username") != null && !request.getParameter("username").isEmpty()) {
                    username = request.getParameter("username");
                }
                
                Date startDate = null;
                if (request.getParameter("startDate") != null && !request.getParameter("startDate").isEmpty()) {
                    startDate = DATE_FORMAT.parse(request.getParameter("startDate"));
                }
                
                Date endDate = null;
                if (request.getParameter("endDate") != null && !request.getParameter("endDate").isEmpty()) {
                    endDate = DATE_FORMAT.parse(request.getParameter("endDate"));
                }
                
                // Get logs
                List<LoginLog> logs = loginLogDAO.getLoginLogs(offset, limit, username, startDate, endDate);
                int totalLogs = loginLogDAO.getLoginLogsCount(username, startDate, endDate);
                int totalPages = (int) Math.ceil((double) totalLogs / limit);
                
                // Set attributes for JSP
                request.setAttribute("logs", logs);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("limit", limit);
                request.setAttribute("usernameFilter", username);
                request.setAttribute("startDateFilter", startDate != null ? DATE_FORMAT.format(startDate) : "");
                request.setAttribute("endDateFilter", endDate != null ? DATE_FORMAT.format(endDate) : "");
                
                request.getRequestDispatcher("login_logs.jsp").forward(request, response);
                
            } catch (SQLException | ParseException | NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error retrieving login logs");
                request.getRequestDispatcher("login_logs.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(LoginLogServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}