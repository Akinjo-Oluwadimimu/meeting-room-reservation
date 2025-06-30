package com.roomreserve.jobs;

import com.roomreserve.dao.ReservationDAO;
import javax.servlet.ServletContext;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class ReservationUpdateJob implements Job {
    
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        try {
            // Get DAO from JobDataMap
            ReservationDAO reservationDAO = (ReservationDAO) context.getJobDetail()
                .getJobDataMap().get("reservationDAO");
            
            // Get ServletContext if needed
            ServletContext servletContext = (ServletContext) context.getScheduler()
                .getContext().get("servletContext");
            
            // Execute the update
            reservationDAO.updateCompletedReservations();
            
            // Log success
            if (servletContext != null) {
                servletContext.log("Successfully updated completed reservations");
            }
            
        } catch (Exception e) {
            throw new JobExecutionException("Failed to update reservations", e, false);
        }
    }
}
