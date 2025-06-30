package com.roomreserve.util;

import com.roomreserve.dao.ReservationDAO;
import com.roomreserve.dao.UserReportDAO;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.UserReport;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import javax.servlet.ServletContext;

public class ReportService {
    private final UserReportDAO reportDAO;
    private final ReservationDAO reservationDAO;
    private final UserReportGenerator reportGenerator;
    private final ExecutorService executorService;

    public ReportService(ServletContext context) throws SQLException {
        this.reportDAO = new UserReportDAO();
        this.reservationDAO = new ReservationDAO();
        this.reportGenerator = new UserReportGenerator(context);
        this.executorService = Executors.newFixedThreadPool(3);
    }

    public List<UserReport> getUserReports(int userId) {
        try {
            return reportDAO.getUserReports(userId);
        } catch (Exception e) {
            throw new RuntimeException("Failed to get user reports", e);
        }
    }

    public UserReport getReport(int reportId, int userId) {
        try {
            return reportDAO.getReportById(reportId, userId);
        } catch (Exception e) {
            throw new RuntimeException("Failed to get report", e);
        }
    }

    public int generateReport(int userId, String reportType, String dateRange, 
                            LocalDate startDate, LocalDate endDate, String format) {
        UserReport report = new UserReport();
        report.setUserId(userId);
        report.setReportType(reportType);
        report.setDateRange(dateRange);
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        report.setFormat(format);

        try {
            int reportId = reportDAO.createReport(report);
            executorService.submit(() -> generateReportAsync(reportId, reportType));
            return reportId;
        } catch (Exception e) {
            throw new RuntimeException("Failed to create report", e);
        }
    }

    private void generateReportAsync(int reportId, String reportType) {
        try {
            UserReport report = reportDAO.getReportById(reportId, 0); // 0 ignores user_id check
            
            // Determine date range
            LocalDate[] dates = calculateDateRange(report.getDateRange(), 
                                                 report.getStartDate(), 
                                                 report.getEndDate());
            String filePath = null;
            if (null != reportType) switch (reportType) {
                case "reservation_history":{
                    // Get data for report
                    List<Reservation> reservations = reservationDAO.getReservationsByUserAndDateRange(
                        report.getUserId(), dates[0].atStartOfDay(), dates[1].atTime(23, 59, 59));

                    // Generate report file
                    filePath = reportGenerator.generateReport(
                        report.getReportType(), 
                        reservations, 
                        report.getFormat(), 
                        dates[0], 
                        dates[1]);
                    break;
                    }
                case "cancellations":
                    List<Reservation> reservations = reservationDAO.getCancellationsByUserAndDateRange(
                        report.getUserId(), dates[0].atStartOfDay(), dates[1].atTime(23, 59, 59));

                    // Generate report file
                    filePath = reportGenerator.generateReport(
                        report.getReportType(), 
                        reservations, 
                        report.getFormat(), 
                        dates[0], 
                        dates[1]);
                    break;
            }
            
            // Update report status
            reportDAO.updateReportStatus(reportId, "ready", filePath);
        } catch (Exception e) {
            try {
                reportDAO.updateReportStatus(reportId, "failed", null);
            } catch (Exception ex) {
                // Log error
            }
        }
    }

    private LocalDate[] calculateDateRange(String dateRange, LocalDate customStart, LocalDate customEnd) {
        LocalDate now = LocalDate.now();
        
        switch (dateRange) {
            case "last_7_days":
                return new LocalDate[]{now.minusDays(7), now};
            case "last_month":
                return new LocalDate[]{now.minusMonths(1), now};
            case "last_quarter":
                return new LocalDate[]{now.minusMonths(3), now};
            case "custom":
                return new LocalDate[]{customStart, customEnd};
            default:
                throw new IllegalArgumentException("Invalid date range: " + dateRange);
        }
    }
}
