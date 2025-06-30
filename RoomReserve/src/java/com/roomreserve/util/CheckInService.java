package com.roomreserve.util;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.model.CheckInResult;
import com.roomreserve.model.Reservation;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class CheckInService {
    private final ReservationDAO reservationDAO;
//    private final NotificationService notificationService;

    public CheckInService(ReservationDAO reservationDAO) {
        this.reservationDAO = reservationDAO;
//        this.notificationService = notificationService;
    }

    public CheckInResult checkIn(int reservationId) {
        try {
            // 1. Validate and retrieve reservation
            Reservation reservation = reservationDAO.getReservationById(reservationId);
            if (reservation == null) {
                return new CheckInResult(false, "Reservation not found");
            }

            // 2. Check if already checked in
            if (reservation.getCheckInTime() != null) {
                return new CheckInResult(false, "Already checked in at " + reservation.getCheckInTime());
            }

            // 3. Validate check-in time window (e.g., 15 minutes before to 2 hours after start time)
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime startTime = reservation.getStartTime();
            LocalDateTime endTime = reservation.getEndTime();
            LocalDateTime earliestCheckIn = startTime.minusMinutes(15);
            LocalDateTime latestCheckIn = startTime.plusHours(2);

            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a");
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEE, MMM d");

            if (now.isBefore(earliestCheckIn)) {
                Duration untilOpen = Duration.between(now, earliestCheckIn);
                long minutes = untilOpen.toMinutes();

                String message;
                if (minutes > 120) {
                    long hours = untilOpen.toHours();
                    message = String.format("Check-in opens in %d hour%s (%s on %s)", 
                        hours, hours != 1 ? "s" : "",
                        earliestCheckIn.format(timeFormatter),
                        earliestCheckIn.format(dateFormatter));
                } else {
                    message = String.format("Check-in opens in %d minute%s (%s)", 
                        minutes, minutes != 1 ? "s" : "",
                        earliestCheckIn.format(timeFormatter));
                }

                return new CheckInResult(false, message);
            }

            if (now.isAfter(latestCheckIn)) {
                return new CheckInResult(false, 
                    String.format("Check-in closed. The cutoff time was %s on %s", 
                        latestCheckIn.format(timeFormatter),
                        latestCheckIn.format(dateFormatter)));
            }

            // 4. Perform check-in
            reservationDAO.markAsCheckedIn(reservationId);

            // 5. Send confirmation
//            notificationService.sendCheckInConfirmation(reservation);

            return new CheckInResult(true, "Successfully checked in");
        } catch (Exception e) {
            return new CheckInResult(false, "Check-in failed: " + e.getMessage());
        }
    }
}