package com.roomreserve.util;


import com.roomreserve.dao.EmailTemplateDAO;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.model.EmailTemplate;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.Room;
import com.roomreserve.model.User;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {
    private final EmailTemplateDAO templateDAO;
    private final RoomDAO roomDAO;
    private static final String SMTP_USER = "your_email@gmail.com";
    private static final String SMTP_PASSWORD = "your_email_password";
    private static final String FROM_EMAIL = "your_email@gmail.com";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "465";

    public EmailService() throws SQLException {
        this.templateDAO = new EmailTemplateDAO();
        this.roomDAO = new RoomDAO();
    }

    public void sendReservationConfirmation(Reservation reservation, User user) {
        try {
            EmailTemplate template = templateDAO.getTemplateByName("reservation_confirmation");
            Room room = roomDAO.getRoomById(reservation.getRoomId());
            
            Map<String, String> variables = new HashMap<>();
            variables.put("user_name", user.getFirstName() + " " + user.getLastName());
            variables.put("room_name", room.getName());
            variables.put("reservation_id", String.valueOf(reservation.getId()));
            variables.put("reservation_date", reservation.getStartTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")));
            variables.put("start_time", reservation.getStartTime().format(DateTimeFormatter.ofPattern("h:mm a")));
            variables.put("end_time", reservation.getEndTime().format(DateTimeFormatter.ofPattern("h:mm a")));
            variables.put("purpose", !reservation.getPurpose().isEmpty() ? reservation.getPurpose() : "Not specified");
            variables.put("system_url", "RoomReserve");

            sendEmail(user.getEmail(), replaceVariables(template.getSubject(), variables), replaceVariables(template.getContent(), variables));
        } catch (SQLException e) {
            throw new RuntimeException("Error sending reservation confirmation email", e);
        }
    }

    public void sendReservationApproval(Reservation reservation) {
        try {
            EmailTemplate template = templateDAO.getTemplateByName("reservation_approval");
            Room room = roomDAO.getRoomById(reservation.getRoomId());
            
            Map<String, String> variables = new HashMap<>();
            variables.put("user_name", reservation.getUser().getFirstName() + " " + reservation.getUser().getLastName());
            variables.put("room_name", room.getName());
            variables.put("reservation_id", String.valueOf(reservation.getId()));
            variables.put("reservation_date", reservation.getStartTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")));
            variables.put("start_time", reservation.getStartTime().format(DateTimeFormatter.ofPattern("h:mm a")));
            variables.put("end_time", reservation.getEndTime().format(DateTimeFormatter.ofPattern("h:mm a")));

            sendEmail(reservation.getUser().getEmail(), replaceVariables(template.getSubject(), variables), replaceVariables(template.getContent(), variables));
        } catch (SQLException e) {
            throw new RuntimeException("Error sending reservation approval email", e);
        }
    }

    public void sendReservationRejection(Reservation reservation, String reason) {
        try {
            EmailTemplate template = templateDAO.getTemplateByName("reservation_rejection");
            Room room = roomDAO.getRoomById(reservation.getRoomId());
            
            Map<String, String> variables = new HashMap<>();
            variables.put("user_name", reservation.getUser().getFirstName() + " " + reservation.getUser().getLastName());
            variables.put("room_name", room.getName());
            variables.put("reservation_id", String.valueOf(reservation.getId()));
            variables.put("reservation_date", reservation.getStartTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")));
            variables.put("start_time", reservation.getStartTime().format(DateTimeFormatter.ofPattern("h:mm a")));
            variables.put("end_time", reservation.getEndTime().format(DateTimeFormatter.ofPattern("h:mm a")));
            variables.put("rejection_reason", reason);
            variables.put("admin_email", "admin.email");

            sendEmail(reservation.getUser().getEmail(), replaceVariables(template.getSubject(), variables), replaceVariables(template.getContent(), variables));
        } catch (SQLException e) {
            throw new RuntimeException("Error sending reservation rejection email", e);
        }
    }

    public void sendReservationReminder(Reservation reservation, User user) {
        try {
            EmailTemplate template = templateDAO.getTemplateByName("reservation_reminder");
            Room room = roomDAO.getRoomById(reservation.getRoomId());
            
            long hoursUntil = java.time.Duration.between(java.time.LocalDateTime.now(), 
                reservation.getStartTime()).toHours();
            
            Map<String, String> variables = new HashMap<>();
            variables.put("user_name", user.getFirstName() + " " + user.getLastName());
            variables.put("room_name", room.getName());
            variables.put("reservation_id", String.valueOf(reservation.getId()));
            variables.put("reservation_date", reservation.getStartTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")));
            variables.put("start_time", reservation.getStartTime().format(DateTimeFormatter.ofPattern("h:mm a")));
            variables.put("end_time", reservation.getEndTime().format(DateTimeFormatter.ofPattern("h:mm a")));
            variables.put("hours_until", String.valueOf(hoursUntil));

            sendEmail(user.getEmail(), replaceVariables(template.getSubject(), variables), replaceVariables(template.getContent(), variables));
        } catch (SQLException e) {
            throw new RuntimeException("Error sending reservation reminder email", e);
        }
    }

    public void sendPasswordReset(User user, String resetLink) {
        EmailTemplate template = templateDAO.getTemplateByName("password_reset");
        Map<String, String> variables = new HashMap<>();
        variables.put("user_name", user.getFirstName() + " " + user.getLastName());
        variables.put("reset_link", resetLink);
        variables.put("expiry_hours", "24");
        sendEmail(user.getEmail(), replaceVariables(template.getSubject(), variables), replaceVariables(template.getContent(), variables));
    }

    private String replaceVariables(String content, Map<String, String> variables) {
        String result = content;
        for (Map.Entry<String, String> entry : variables.entrySet()) {
            result = result.replace("#{" + entry.getKey() + "}", entry.getValue());
        }
        return result;
    }

    
    private static void sendEmail(String toEmail, String subject, String htmlContent) {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true"); // ✅ Required for SSL
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // ✅ Force TLS 1.2 or higher


        Session session = Session.getInstance(props,
            new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
                }
            });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html");

            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send email", e);
        }
    }
}