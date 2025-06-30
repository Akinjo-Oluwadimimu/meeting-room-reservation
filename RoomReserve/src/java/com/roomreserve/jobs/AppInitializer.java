package com.roomreserve.jobs;

import com.roomreserve.util.ReminderService;
import com.roomreserve.util.SettingsService;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppInitializer implements ServletContextListener {
    private ReminderService reminderService;
    private SettingsService settingsService;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            
            settingsService = new SettingsService();
            sce.getServletContext().setAttribute("settingsService", settingsService);

            int reminderHours = settingsService.getIntSetting("reminder_hours_before", 24); // Could be configurable
            int checkFrequency = settingsService.getIntSetting("reminder_check_interval", 30);
            reminderService = new ReminderService(reminderHours, checkFrequency);
            reminderService.start();
            
            // Initialize with default settings if not exists
            ensureDefaultSettings();
        } catch (SQLException ex) {
            Logger.getLogger(AppInitializer.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (reminderService != null) {
            reminderService.shutdown();
        }
    }
    

    private void ensureDefaultSettings() {
        Map<String, String> defaultSettings = new HashMap<>();
        defaultSettings.put("system_name", "College Meeting Room System");
        defaultSettings.put("max_booking_days", "30");
        defaultSettings.put("min_booking_hours", "2");
        defaultSettings.put("allow_weekend_bookings", "false");
        defaultSettings.put("reminder_hours_before", "24");
        defaultSettings.put("reminder_check_interval", "30");
        defaultSettings.put("reservation_timeout_minutes", "15");

        defaultSettings.forEach((key, value) -> {
            if (settingsService.getSetting(key) == null) {
                settingsService.updateSetting(key, value);
            }
        });
    }
}