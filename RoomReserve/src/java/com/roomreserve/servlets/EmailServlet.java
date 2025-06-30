package com.roomreserve.servlets;

import com.roomreserve.model.Reservation;
import com.roomreserve.model.User;
import com.roomreserve.util.EmailService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/email")
public class EmailServlet extends HttpServlet {
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        try {
            super.init();
            this.emailService = new EmailService();
        } catch (SQLException ex) {
            Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        try {
            switch (action) {
                case "send-confirmation":
                    Reservation reservation = getReservationFromRequest(request);
                    emailService.sendReservationConfirmation(reservation, user);
                    session.setAttribute("success", "Confirmation email sent successfully");
                    break;
                    
                case "send-approval":
                    reservation = getReservationFromRequest(request);
                    //emailService.sendReservationApproval(reservation, user);
                    session.setAttribute("success", "Approval email sent successfully");
                    break;
                    
                case "send-rejection":
                    reservation = getReservationFromRequest(request);
                    String reason = request.getParameter("reason");
                    //emailService.sendReservationRejection(reservation, user, reason);
                    session.setAttribute("success", "Rejection email sent successfully");
                    break;
                    
                case "send-reminder":
                    reservation = getReservationFromRequest(request);
                    emailService.sendReservationReminder(reservation, user);
                    session.setAttribute("success", "Reminder email sent successfully");
                    break;
                    
                case "send-password-reset":
                    String resetLink = request.getParameter("resetLink");
                    emailService.sendPasswordReset(user, resetLink);
                    session.setAttribute("success", "Password reset email sent successfully");
                    break;
                    
                default:
                    session.setAttribute("error", "Invalid email action");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Error sending email: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + request.getParameter("redirect"));
    }

    private Reservation getReservationFromRequest(HttpServletRequest request) {
        // Implementation to get reservation from request parameters
        // This would typically call your ReservationDAO
        return new Reservation(); // Simplified for example
    }
}