package com.roomreserve.servlets;

import com.roomreserve.dao.EmailTemplateDAO;
import com.roomreserve.dao.SystemSettingsDAO;
import com.roomreserve.model.EmailTemplate;
import com.roomreserve.model.SystemSetting;
import com.roomreserve.util.SettingsService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet(name = "AdminSettingsServlet", urlPatterns = {"/admin/settings"})
public class AdminSettingsServlet extends HttpServlet {
    
    private SystemSettingsDAO settingsDAO;
    private EmailTemplateDAO templateDAO;
    private SettingsService settingsService;
    
    @Override
    public void init() throws ServletException {
        try {
            super.init();
            settingsDAO = new SystemSettingsDAO();
            templateDAO = new EmailTemplateDAO();
            settingsService = (SettingsService) getServletContext().getAttribute("settingsService");
        } catch (SQLException ex) {
            Logger.getLogger(AdminSettingsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("email-templates".equals(action)) {
                List<EmailTemplate> templates = templateDAO.getAllTemplates();
                request.setAttribute("templates", templates);
                request.getRequestDispatcher("/admin/email_templates.jsp").forward(request, response);
            } else {
                List<SystemSetting> settings = settingsDAO.getAllSettings();
                request.setAttribute("settings", settings);
                request.getRequestDispatcher("/admin/system_settings.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error loading settings: " + e.getMessage());
            request.getRequestDispatcher("/admin/system_settings.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("update-setting".equals(action)) {
                String key = request.getParameter("key");
                String value = request.getParameter("value");
                
                boolean success = settingsDAO.updateSetting(key, value);
                if (success) {
                    settingsService.updateSetting(key, value);
                    request.getSession().setAttribute("success", "Setting updated successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to update setting");
                }
                response.sendRedirect(request.getContextPath() + "/admin/settings");
                
            } else if ("update-template".equals(action)) {
                int templateId = Integer.parseInt(request.getParameter("templateId"));
                String subject = request.getParameter("subject");
                String content = request.getParameter("content");
                
                EmailTemplate template = templateDAO.getTemplateById(templateId);
                template.setSubject(subject);
                template.setContent(content);
                
                boolean success = templateDAO.updateTemplate(template);
                if (success) {
                    request.getSession().setAttribute("success", "Template updated successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to update template");
                }
                response.sendRedirect(request.getContextPath() + "/admin/settings?action=email-templates");
                
            } // Add more actions as needed
            
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/settings");
        }
    }
}