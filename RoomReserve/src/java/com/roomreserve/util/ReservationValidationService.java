package com.roomreserve.util;


import com.roomreserve.exceptions.ValidationException;
import com.roomreserve.model.Reservation;
import java.time.Duration;
import java.time.LocalDateTime;

public class ReservationValidationService {

    private final SettingsService settingsService;

    public ReservationValidationService(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    public void validateReservation(Reservation reservation) {
        settingsService.refreshCache();
        LocalDateTime start = reservation.getStartTime();
        LocalDateTime end = reservation.getEndTime();
        
        // 1. Basic time validation
        if (start == null || end == null) {
            throw new ValidationException("time", "NULL_VALUE", "Start and end times must be specified");
        }

        if (end.isBefore(start) || end.isEqual(start)) {
            throw new ValidationException("endTime", "INVALID_END_TIME", "End time must be after start time");
        }

        // 2. Duration validation
        Duration duration = Duration.between(start, end);
        int minDuration = settingsService.getIntSetting("min_meeting_duration", 15);
        int maxDuration = settingsService.getIntSetting("max_meeting_duration", 240);

        if (duration.toMinutes() < minDuration) {
            throw new ValidationException("duration", "MIN_DURATION", 
                "Minimum booking duration is " + minDuration + " minutes");
        }

        if (duration.toMinutes() > maxDuration) {
            throw new ValidationException("duration", "MAX_DURATION",
                "Maximum booking duration is " + maxDuration + " minutes");
        }

        // 3. Advance notice validation
        LocalDateTime now = LocalDateTime.now();
        int minAdvanceHours = settingsService.getIntSetting("min_booking_hours", 2);

        if (start.isBefore(now.plusHours(minAdvanceHours))) {
            throw new ValidationException("startTime", "MIN_ADVANCE",
                "Must book at least " + minAdvanceHours + " hours in advance");
        }
        
        int maxBookingDays = settingsService.getIntSetting("max_booking_days", 30);

        if (start.isAfter(now.plusDays(maxBookingDays))) {
            throw new ValidationException("startTime", "MAX_ADVANCE",
                "Reservations can only be made up to " + maxBookingDays + " days in advance");
        }

        // 4. Weekend validation
        boolean allowWeekends = settingsService.getBooleanSetting("allow_weekend_bookings", false);
        if (!allowWeekends && (start.getDayOfWeek().getValue() > 5)) {
            throw new ValidationException("date", "WEEKEND_BOOKING",
                "Weekend bookings are not allowed");
        }

        boolean businessHours = settingsService.getBooleanSetting("allow_only_business_hours", false);
        System.out.println("allow_only_business_hours = " + businessHours);
        if (businessHours) {
            System.out.println("Business hours restriction triggered");
            if (start.getHour() < 8 || end.getHour() > 18 || 
                (end.getHour() == 18 && end.getMinute() > 0)) {
                throw new ValidationException("time", "BUSINESS_HOURS",
                    "Bookings are only allowed between 8:00 AM and 6:00 PM");
            }
        }

    }
}