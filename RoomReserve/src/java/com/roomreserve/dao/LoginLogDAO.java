package com.roomreserve.dao;


import com.roomreserve.model.LoginLog;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class LoginLogDAO {
    private Connection connection;

    public LoginLogDAO(Connection connection) {
        this.connection = connection;
    }

    // Log a login attempt
    public boolean logLoginAttempt(LoginLog loginLog) throws SQLException {
        String sql = "INSERT INTO login_logs (user_id, username, ip_address, user_agent, status, failure_reason) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, loginLog.getUserId());
            statement.setString(2, loginLog.getUsername());
            statement.setString(3, loginLog.getIpAddress());
            statement.setString(4, loginLog.getUserAgent());
            statement.setString(5, loginLog.getStatus());
            statement.setString(6, loginLog.getFailureReason());
            
            return statement.executeUpdate() > 0;
        }
    }

    // Get login logs with pagination
    public List<LoginLog> getLoginLogs(int offset, int limit, String username, 
                                      Date startDate, Date endDate) throws SQLException {
        List<LoginLog> logs = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM login_logs WHERE 1=1");
        
        List<Object> params = new ArrayList<>();
        
        if (username != null) {
            sql.append(" AND username LIKE ?");
            params.add("%" + username + "%");
        }
        
        if (startDate != null) {
            sql.append(" AND login_time >= ?");
            params.add(new Timestamp(startDate.getTime()));
        }
        
        if (endDate != null) {
            sql.append(" AND login_time <= ?");
            params.add(new Timestamp(endDate.getTime()));
        }
        
        sql.append(" ORDER BY login_time DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);
        
        try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                LoginLog log = new LoginLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setUsername(rs.getString("username"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setUserAgent(rs.getString("user_agent"));
                log.setLoginTime(rs.getTimestamp("login_time"));
                log.setStatus(rs.getString("status"));
                log.setFailureReason(rs.getString("failure_reason"));
                
                logs.add(log);
            }
        }
        
        return logs;
    }

    // Get total count of login logs
    public int getLoginLogsCount(String username, Date startDate, Date endDate) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM login_logs WHERE 1=1");
        
        List<Object> params = new ArrayList<>();
        
        if (username != null) {
            sql.append(" AND username LIKE ?");
            params.add("%" + username + "%");
        }
        
        if (startDate != null) {
            sql.append(" AND login_time >= ?");
            params.add(new Timestamp(startDate.getTime()));
        }
        
        if (endDate != null) {
            sql.append(" AND login_time <= ?");
            params.add(new Timestamp(endDate.getTime()));
        }
        
        try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }
}