package com.roomreserve.util;

import com.roomreserve.dao.EmailTemplateDAO;
import com.roomreserve.dao.NotificationDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.EmailTemplate;
import com.roomreserve.model.Notification;
import com.roomreserve.model.User;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NotificationService {
    private NotificationDAO notificationDAO;
    private EmailTemplateDAO templateDAO;
    private UserDAO userDAO;
//    private EmailService emailService;

    public NotificationService() {
        try {
            this.notificationDAO = new NotificationDAO();
        this.templateDAO = new EmailTemplateDAO();
            this.userDAO = new UserDAO();
//        this.emailService = new EmailService();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationService.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public List<Notification> getNotifications(int userId, int lastId, int limit) {
        if (lastId == 0) {
            // Get recent notifications for dropdown
            return notificationDAO.getRecentNotifications(userId, limit);
        } else {
            // Get older notifications for pagination
            return notificationDAO.getOlderNotifications(userId, lastId, limit);
        }
    }
    
    public int getUnreadCount(int userId) {
        return notificationDAO.getUnreadCount(userId);
    }
    
    
    public boolean hasMoreNotifications(int userId, int lastId) {
        return notificationDAO.countOlderNotifications(userId, lastId) > 0;
    }

    public boolean sendNotification(int userId, String templateName, Map<String, String> variables) {
        // Get user and template
        User user = userDAO.findById(userId);
        EmailTemplate template = templateDAO.getTemplateByName(templateName);
        
        if (user == null || template == null) {
            return false;
        }

        // Process template with variables
        String subject = processTemplate(template.getSubject(), variables);
        String message = processTemplate(template.getContent(), variables);

        // Create notification
        Notification notification = new Notification(userId, template.getTemplateId(), subject, message);
        boolean notificationSaved = notificationDAO.addNotification(notification);
        
        if (!notificationSaved) {
            return false;
        }

        // Send email if enabled
//        if (user.isEmailEnabled()) {
//            boolean emailSent = emailService.sendEmail(
//                user.getEmail(),
//                subject,
//                message
//            );
//            
//            if (emailSent) {
//                notification.setEmailSent(true);
//                // Update notification to mark email as sent
//                // Note: In a real implementation, you might want to add this update to NotificationDAO
//            }
//        }

        return true;
    }

    private String processTemplate(String template, Map<String, String> variables) {
        String result = template;
        for (Map.Entry<String, String> entry : variables.entrySet()) {
            String placeholder = "{" + entry.getKey() + "}";
            result = result.replace(placeholder, entry.getValue());
        }
        return result;
    }
}