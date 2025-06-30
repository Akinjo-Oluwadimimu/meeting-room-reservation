package com.roomreserve.dao;

import com.roomreserve.model.EmailTemplate;
import com.roomreserve.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmailTemplateDAO {

    private Connection connection;

    public EmailTemplateDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public List<EmailTemplate> getAllTemplates() {
        List<EmailTemplate> templates = new ArrayList<>();
        String sql = "SELECT * FROM email_templates ORDER BY template_name";

        try (Statement statement = connection.createStatement();
             ResultSet rs = statement.executeQuery(sql)) {

            while (rs.next()) {
                templates.add(mapResultSetToTemplate(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return templates;
    }

    public EmailTemplate getTemplateById(int templateId) {
        String sql = "SELECT * FROM email_templates WHERE template_id = ?";
        EmailTemplate template = null;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, templateId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                template = mapResultSetToTemplate(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return template;
    }

    public EmailTemplate getTemplateByName(String templateName) {
        String sql = "SELECT * FROM email_templates WHERE template_name = ?";
        EmailTemplate template = null;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, templateName);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                template = mapResultSetToTemplate(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return template;
    }

    public boolean updateTemplate(EmailTemplate template) {
        String sql = "UPDATE email_templates SET subject = ?, content = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE template_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, template.getSubject());
            statement.setString(2, template.getContent());
            statement.setInt(3, template.getTemplateId());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createTemplate(EmailTemplate template) {
        String sql = "INSERT INTO email_templates (template_name, subject, content) VALUES (?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, template.getTemplateName());
            statement.setString(2, template.getSubject());
            statement.setString(3, template.getContent());

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    template.setTemplateId(generatedKeys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTemplate(int templateId) {
        String sql = "DELETE FROM email_templates WHERE template_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, templateId);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private EmailTemplate mapResultSetToTemplate(ResultSet rs) throws SQLException {
        EmailTemplate template = new EmailTemplate();
        template.setTemplateId(rs.getInt("template_id"));
        template.setTemplateName(rs.getString("template_name"));
        template.setSubject(rs.getString("subject"));
        template.setContent(rs.getString("content"));
        template.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        template.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return template;
    }
}