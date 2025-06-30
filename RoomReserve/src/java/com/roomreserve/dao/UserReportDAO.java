package com.roomreserve.dao;

import com.roomreserve.model.UserReport;
import com.roomreserve.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserReportDAO {
    private Connection connection;

    public UserReportDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public List<UserReport> getUserReports(int userId) throws SQLException {
        List<UserReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM user_reports WHERE user_id = ? ORDER BY generated_at DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                reports.add(mapResultSetToReport(rs));
            }
        }
        return reports;
    }

    public UserReport getReportById(int reportId, int userId) throws SQLException {
        String sql = "SELECT * FROM user_reports WHERE report_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToReport(rs);
            }
        }
        return null;
    }

    public int createReport(UserReport report) throws SQLException {
        String sql = "INSERT INTO user_reports (user_id, report_type, date_range, " +
                     "start_date, end_date, format) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, report.getUserId());
            stmt.setString(2, report.getReportType());
            stmt.setString(3, report.getDateRange());
            stmt.setDate(4, report.getStartDate() != null ? Date.valueOf(report.getStartDate()) : null);
            stmt.setDate(5, report.getEndDate() != null ? Date.valueOf(report.getEndDate()) : null);
            stmt.setString(6, report.getFormat());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating report failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating report failed, no ID obtained.");
                }
            }
        }
    }

    public boolean updateReportStatus(int reportId, String status, String filePath) throws SQLException {
        String sql = "UPDATE user_reports SET status = ?, file_path = ? WHERE report_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, filePath);
            stmt.setInt(3, reportId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    public List<UserReport> getPendingReports() throws SQLException {
        List<UserReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM user_reports WHERE status = 'pending'";
        
        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                reports.add(mapResultSetToReport(rs));
            }
        }
        return reports;
    }

    private UserReport mapResultSetToReport(ResultSet rs) throws SQLException {
        UserReport report = new UserReport();
        report.setReportId(rs.getInt("report_id"));
        report.setUserId(rs.getInt("user_id"));
        report.setReportType(rs.getString("report_type"));
        report.setDateRange(rs.getString("date_range"));
        
        Date startDate = rs.getDate("start_date");
        report.setStartDate(startDate != null ? startDate.toLocalDate() : null);
        
        Date endDate = rs.getDate("end_date");
        report.setEndDate(endDate != null ? endDate.toLocalDate() : null);
        
        report.setFormat(rs.getString("format"));
        report.setGeneratedAt(rs.getTimestamp("generated_at").toLocalDateTime());
        report.setStatus(rs.getString("status"));
        report.setFilePath(rs.getString("file_path"));
        
        return report;
    }
}