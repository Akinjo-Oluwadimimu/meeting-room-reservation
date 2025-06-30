/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.roomreserve.servlets;

import com.google.gson.Gson;
import com.roomreserve.dao.NotificationDAO;
import com.roomreserve.model.Notification;
import com.roomreserve.util.NotificationService;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet({"/notifications", "/user/notifications"})
public class NotificationServlet extends HttpServlet {
    private static final int DEFAULT_LIMIT = 10;
    private NotificationDAO notificationDAO;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        try {
            super.init();
            this.notificationDAO = new NotificationDAO();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        this.notificationService = new NotificationService();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        
        // Handle AJAX request for dropdown
        if ("loadMore".equals(action)) {
            int lastId = Integer.parseInt(request.getParameter("lastId"));
            List<Notification> moreNotifications = notificationService.getNotifications(userId, lastId, DEFAULT_LIMIT);
            
            boolean hasMore = notificationService.hasMoreNotifications(userId, moreNotifications.isEmpty() ? 0 : 
                moreNotifications.get(moreNotifications.size() - 1).getNotificationId());
            request.setAttribute("hasMore", hasMore);
        
            session.setAttribute("hasMore", hasMore);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(moreNotifications));
            return;
        }

        // Handle mark as read from dropdown
        String markAsReadParam = request.getParameter("markAsRead");
        if (markAsReadParam != null) {
            int notificationId = Integer.parseInt(markAsReadParam);
            notificationDAO.markAsRead(notificationId);
        }
        
        String markAsUnreadParam = request.getParameter("markAsUnread");
        if (markAsUnreadParam != null) {
            int notificationId = Integer.parseInt(markAsUnreadParam);
            notificationDAO.markAsUnread(notificationId);
        }


        // For initial page load
        List<Notification> notifications = notificationService.getNotifications(userId, 0, DEFAULT_LIMIT);
        request.setAttribute("notifications", notifications);
        
        // Check if there are more notifications
        boolean hasMore = notificationService.hasMoreNotifications(userId, notifications.isEmpty() ? 0 : 
            notifications.get(notifications.size() - 1).getNotificationId());
        request.setAttribute("hasMore", hasMore);
        
        request.getRequestDispatcher("/notifications.jsp").forward(request, response);
    }
    
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        Integer userId = (Integer) session.getAttribute("userId");
//        
//        if (userId == null) {
//            response.sendRedirect("login");
//            return;
//        }
//
//        // Get user notifications
//        request.setAttribute("notifications", notificationDAO.getAllNotifications(userId));
//        request.getRequestDispatcher("/notifications.jsp").forward(request, response);
//    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login");
            return;
        }

        if ("markAsRead".equals(action)) {
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            notificationDAO.markAsRead(notificationId);
        } else if ("markAsUnread".equals(action)) {
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            notificationDAO.markAsUnread(notificationId);
        } else if ("delete".equals(action)) {
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            notificationDAO.deleteNotification(notificationId);
        }

        response.sendRedirect("notifications");
    }
}