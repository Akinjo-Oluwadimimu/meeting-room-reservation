package com.roomreserve.util;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.UserDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.User;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class ReminderService {
    private final ReservationDAO reservationDAO;
    private final UserDAO userDAO;
    private final EmailService emailService;
    private final ScheduledExecutorService scheduler;
    private final int reminderHoursBefore;
    private final int checkFrequency;

    public ReminderService(int reminderHoursBefore, int checkFrequency) throws SQLException {
        this.reservationDAO = new ReservationDAO();
        this.userDAO = new UserDAO();
        this.emailService = new EmailService();
        this.scheduler = Executors.newScheduledThreadPool(1);
        this.reminderHoursBefore = reminderHoursBefore;
        this.checkFrequency = checkFrequency;
    }

    public void start() {
        // Run every 30 minutes
        scheduler.scheduleAtFixedRate(this::checkAndSendReminders, 0, checkFrequency, TimeUnit.MINUTES);
    }

    public void shutdown() {
        scheduler.shutdown();
    }

    private void checkAndSendReminders() {
        try {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime reminderWindowStart = now.plusHours(reminderHoursBefore);
            LocalDateTime reminderWindowEnd = reminderWindowStart.plusMinutes(30); // 30-minute window
            
            List<Reservation> upcomingReservations = reservationDAO.getReservationsNeedingReminders(
                now, reminderWindowStart, reminderWindowEnd);
            
            for (Reservation reservation : upcomingReservations) {
                User user = userDAO.findById(reservation.getUserId());
                emailService.sendReservationReminder(reservation, user);
                
                // Mark as sent
                reservationDAO.markReminderSent(reservation.getId());
            }
        } catch (Exception e) {
            // Log error
            System.err.println("Error in reminder service: " + e.getMessage());
        }
    }
}