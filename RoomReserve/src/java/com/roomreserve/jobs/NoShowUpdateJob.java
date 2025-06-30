package com.roomreserve.jobs;

import com.roomreserve.dao.ReservationDAO;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class NoShowUpdateJob implements Job {
    
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        try {
            // Get DAO from JobDataMap
            ReservationDAO reservationDAO = (ReservationDAO) context.getJobDetail()
                .getJobDataMap().get("reservationDAO");
            
            // Execute the no-show update
            reservationDAO.updateNoShowReservations();
            
        } catch (Exception e) {
            throw new JobExecutionException("Failed to update no-show reservations", e, false);
        }
    }
}