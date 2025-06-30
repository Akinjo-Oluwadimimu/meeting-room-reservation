package com.roomreserve.util;

import com.roomreserve.dao.ReservationDAO;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.quartz.SchedulerException;

public class QuartzInitializer implements ServletContextListener {
    
    private QuartzSchedulerSetup scheduler;
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Initialize your DAO
        ReservationDAO reservationDAO = new ReservationDAO();
        
        // Initialize scheduler
        scheduler = new QuartzSchedulerSetup(reservationDAO);
        
        try {
            scheduler.start();
            sce.getServletContext().log("Quartz Scheduler started successfully");
        } catch (SchedulerException e) {
            sce.getServletContext().log("Failed to start Quartz Scheduler", e);
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            if (scheduler != null) {
                scheduler.shutdown();
            }
            sce.getServletContext().log("Quartz Scheduler shutdown complete");
        } catch (SchedulerException e) {
            sce.getServletContext().log("Error shutting down Quartz Scheduler", e);
        }
    }
}