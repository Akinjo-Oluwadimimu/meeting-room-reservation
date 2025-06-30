package com.roomreserve.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    private static final String SMTP_USER = "your_email@gmail.com";
    private static final String SMTP_PASSWORD = "your_email_password";
    private static final String FROM_EMAIL = "your_email@gmail.com";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "465";

    public static void sendVerificationEmail(String toEmail, String verificationLink) {
        String subject = "Verify Your RoomReserve Account";
        String body = "Please click the following link to verify your email address:\n\n" +
                     verificationLink + "\n\n" +
                     "This link will expire in 24 hours.\n\n" +
                     "If you didn't create an account with RoomReserve, please ignore this email.";

        sendEmail(toEmail, subject, body);
    }
    
    public static void sendTempPasswordEmail(String toEmail, String tempPassword) {
        String subject = "Your Temporary Password";
        String body = "Your temporary password is: " + tempPassword + "\n\n" +
                     "Please login and change your password immediately.";
        
        sendEmail(toEmail, subject, body);
    }
    
    public static void sendPasswordResetEmail(String toEmail, String resetLink) {
        String subject = "Password Reset Request - RoomReserve";
        String body = "You requested a password reset for your RoomReserve account.\n\n"
            + "To reset your password, click this link:\n" + resetLink + "\n\n"
            + "This link will expire in 1 hour. If you didn't request this, please ignore this email.";
        
        sendEmail(toEmail, subject, body);
    }

    private static void sendEmail(String toEmail, String subject, String body) {
        Properties props = new Properties();
        
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true"); // ✅ Required for SSL
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // ✅ Force TLS 1.2 or higher

        Session session = Session.getInstance(props,
            new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD); // Use App Password!
                }
            });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            System.out.println("Email sent successfully.");
        } catch (MessagingException e) {
            e.printStackTrace(); // ← shows useful debug output
            throw new RuntimeException("Failed to send email", e);
        }
    }

}