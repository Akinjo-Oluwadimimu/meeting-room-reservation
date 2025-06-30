package com.roomreserve.util;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.jobs.NoShowUpdateJob;
import com.roomreserve.jobs.ReservationUpdateJob;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;

public class QuartzSchedulerSetup {
    
    private Scheduler scheduler;
    private ReservationDAO reservationDAO;
    
    public QuartzSchedulerSetup(ReservationDAO reservationDAO) {
        this.reservationDAO = reservationDAO;
    }
    
    public void start() throws SchedulerException {
        SchedulerFactory schedulerFactory = new StdSchedulerFactory();
        scheduler = schedulerFactory.getScheduler();
        
        // Create JobDataMap to share the DAO
        JobDataMap jobDataMap = new JobDataMap();
        jobDataMap.put("reservationDAO", reservationDAO);
        
        // 1. Setup the daily completed reservations job (existing)
        JobDetail completedJob = JobBuilder.newJob(ReservationUpdateJob.class)
            .withIdentity("reservationUpdateJob", "reservationGroup")
            .usingJobData(jobDataMap)
            .build();
        
        Trigger completedTrigger = TriggerBuilder.newTrigger()
            .withIdentity("midnightTrigger", "reservationGroup")
            .withSchedule(CronScheduleBuilder.dailyAtHourAndMinute(0, 0))
            .build();
        
        // 2. Setup the new no-show job (every 30 minutes)
        JobDetail noShowJob = JobBuilder.newJob(NoShowUpdateJob.class)
            .withIdentity("noShowUpdateJob", "reservationGroup")
            .usingJobData(jobDataMap)
            .build();
        
        Trigger noShowTrigger = TriggerBuilder.newTrigger()
            .withIdentity("thirtyMinTrigger", "reservationGroup")
            .withSchedule(CronScheduleBuilder.cronSchedule("0 */30 * * * ?"))
            .build();
        
        // Schedule both jobs
        scheduler.scheduleJob(completedJob, completedTrigger);
        scheduler.scheduleJob(noShowJob, noShowTrigger);
        
        scheduler.start();
    }
    
    public void shutdown() throws SchedulerException {
        if (scheduler != null) {
            scheduler.shutdown();
        }
    }
}
