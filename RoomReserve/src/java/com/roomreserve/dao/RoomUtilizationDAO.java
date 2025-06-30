package com.roomreserve.dao;

import com.roomreserve.model.RoomUtilization;
import com.roomreserve.model.CancellationAnalysis;
import com.roomreserve.model.ReservationAnalytics;

import com.roomreserve.util.DBUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class RoomUtilizationDAO {
    
    private Connection connection;

    public RoomUtilizationDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public List<RoomUtilization> getRoomUtilization(LocalDateTime start, LocalDateTime end) {
        List<RoomUtilization> utilizationList = new ArrayList<>();
        String sql = "SELECT * FROM room_utilization WHERE " +
                     "EXISTS (SELECT 1 FROM reservations r WHERE r.room_id = room_utilization.room_id " +
                     "AND r.start_time >= ? AND r.end_time <= ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                RoomUtilization util = new RoomUtilization();
                util.setRoomId(rs.getInt("room_id"));
                util.setRoomName(rs.getString("name"));
                util.setBuildingName(rs.getString("building_name"));
                util.setCompletedCount(rs.getInt("completed_count"));
                util.setCancelledCount(rs.getInt("cancelled_count"));
                util.setNoShowCount(rs.getInt("no_show_count"));
                util.setUtilizedMinutes(rs.getInt("utilized_minutes"));
                util.setScheduledMinutes(rs.getInt("scheduled_minutes"));
                utilizationList.add(util);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return utilizationList;
    }

    public Map<String, Double> getUtilizationTrend(String period) {
        Map<String, Double> trend = new LinkedHashMap<>();
        String sql;
        
        switch (period.toLowerCase()) {
            case "hour":
                sql = "SELECT HOUR(start_time) AS time_period, " +
                      "SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) / COUNT(*) AS avg_utilization " +
                      "FROM reservations WHERE status = 'completed' " +
                      "GROUP BY HOUR(start_time) ORDER BY HOUR(start_time)";
                break;
            case "day":
                sql = "SELECT DAYNAME(start_time) AS time_period, " +
                      "SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) / COUNT(*) AS avg_utilization " +
                      "FROM reservations WHERE status = 'completed' " +
                      "GROUP BY DAYOFWEEK(start_time), DAYNAME(start_time) ORDER BY DAYOFWEEK(start_time)";
                break;
            case "week":
                sql = "SELECT CONCAT('Week ', WEEK(start_time)) AS time_period, " +
                      "SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) / COUNT(*) AS avg_utilization " +
                      "FROM reservations WHERE status = 'completed' " +
                      "GROUP BY WEEK(start_time) ORDER BY WEEK(start_time)";
                break;
            case "month":
                sql = "SELECT MONTHNAME(start_time) AS time_period, " +
                      "SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) / COUNT(*) AS avg_utilization " +
                      "FROM reservations WHERE status = 'completed' " +
                      "GROUP BY MONTH(start_time), MONTHNAME(start_time) ORDER BY MONTH(start_time)";
                break;
            default:
                return trend;
        }

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                trend.put(rs.getString("time_period"), rs.getDouble("avg_utilization"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trend;
    }

    public List<CancellationAnalysis> getCancellationAnalysis(LocalDateTime start, LocalDateTime end) {
        List<CancellationAnalysis> cancellations = new ArrayList<>();
        String sql = "SELECT r.*, u.first_name, u.last_name, rm.name " +
                     "FROM reservations r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "WHERE r.status = 'cancelled' AND r.end_time >= ? AND r.end_time <= ? " +
                     "ORDER BY r.cancelled_at DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));
            
            ResultSet rs = stmt.executeQuery();
            int i = 1;
            while (rs.next()) {
                CancellationAnalysis ca = new CancellationAnalysis();
                ca.setReasonId(i);
                ca.setReservationId(rs.getInt("reservation_id"));
                ca.setReason(rs.getString("cancellation_reason"));
                ca.setNotes(rs.getString("cancellation_note"));
                ca.setCancelledByName(rs.getString("first_name") + " " + rs.getString("last_name"));
                ca.setCancelledAt(rs.getTimestamp("cancelled_at").toLocalDateTime());
                ca.setRoomName(rs.getString("name"));
                ca.setOriginalTime(rs.getTimestamp("start_time").toLocalDateTime());
                i++;
                cancellations.add(ca);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cancellations;
    }

    public Map<String, Integer> getCancellationReasons(LocalDateTime start, LocalDateTime end) {
        Map<String, Integer> reasons = new HashMap<>();
        String sql = "SELECT cancellation_reason, COUNT(*) as count FROM reservations r " +
                     "WHERE r.status = 'cancelled' AND r.end_time >= ? AND r.end_time <= ? " +
                     "GROUP BY cancellation_reason ORDER BY count DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reasons.put(rs.getString("cancellation_reason"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reasons;
    }
    
    public Map<String, Double> getCancellationRates(LocalDateTime start, LocalDateTime end) {
        Map<String, Double> rates = new HashMap<>();
        String sql = "SELECT rm.name, " +
                     "COUNT(*) AS total, " +
                     "SUM(CASE WHEN r.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled, " +
                     "SUM(CASE WHEN r.status = 'no-show' THEN 1 ELSE 0 END) AS no_shows " +
                     "FROM reservations r " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "WHERE r.start_time BETWEEN ? AND ? " +
                     "GROUP BY rm.name";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int total = rs.getInt("total");
                int cancelled = rs.getInt("cancelled") + rs.getInt("no_shows");
                rates.put(rs.getString("name"), (cancelled * 100.0) / total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rates;
    }
    
    public Map<Integer, Double> getPeakUsageHours(LocalDateTime start, LocalDateTime end) {
        Map<Integer, Double> hours = new HashMap<>();
        String sql = "SELECT HOUR(start_time) as hour, " +
                     "COUNT(*) as total, " +
                     "(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reservations " +
                     "WHERE start_time BETWEEN ? AND ?)) as percentage " +
                     "FROM reservations " +
                     "WHERE start_time BETWEEN ? AND ? " +
                     "GROUP BY HOUR(start_time) " +
                     "ORDER BY total DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));
            stmt.setTimestamp(3, Timestamp.valueOf(start));
            stmt.setTimestamp(4, Timestamp.valueOf(end));

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                hours.put(rs.getInt("hour"), rs.getDouble("percentage"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hours;
    }
    
    public List<ReservationAnalytics> getRoomUtilization(LocalDateTime start, LocalDateTime end, String period) {
        List<ReservationAnalytics> analytics = new ArrayList<>();
        String sql = buildUtilizationQuery(period);

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                analytics.add(mapToReservationAnalytics(rs, period));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return analytics;
    }
    
    private ReservationAnalytics mapToReservationAnalytics(ResultSet rs, String period) throws SQLException {
        ReservationAnalytics analytics = new ReservationAnalytics();
        analytics.setRoomId(rs.getInt("room_id"));
        analytics.setRoomName(rs.getString("name"));
        analytics.setBuildingName(rs.getString("building_name"));
        analytics.setPeriod(rs.getString("period"));
        analytics.setReservationCount(rs.getInt("reservations"));
        analytics.setTotalMinutes(rs.getInt("total_minutes"));
        analytics.setPeriodType(period);
        return analytics;
    }
    
    private String buildUtilizationQuery(String period) {
        switch (period.toLowerCase()) {
            case "hour":
                return "SELECT rm.room_id, rm.name, b.name as building_name, " +
                       "DATE_FORMAT(r.start_time, '%Y-%m-%d %H:00') as period, " +
                       "COUNT(*) as reservations, " +
                       "SUM(TIMESTAMPDIFF(MINUTE, r.start_time, r.end_time)) as total_minutes " +
                       "FROM reservations r " +
                       "JOIN rooms rm ON r.room_id = rm.room_id " +
                       "JOIN buildings b ON rm.building_id = b.building_id " +
                       "WHERE r.start_time BETWEEN ? AND ? " +
                       "GROUP BY rm.room_id, rm.name, b.name, period " +
                       "ORDER BY period";
                        
            case "day":
                return "SELECT rm.room_id, rm.name, b.name as building_name, " +
                       "DATE(r.start_time) as period, " +
                       "COUNT(*) as reservations, " +
                       "SUM(TIMESTAMPDIFF(MINUTE, r.start_time, r.end_time)) as total_minutes " +
                       "FROM reservations r " +
                       "JOIN rooms rm ON r.room_id = rm.room_id " +
                       "JOIN buildings b ON rm.building_id = b.building_id " +
                       "WHERE r.start_time BETWEEN ? AND ? " +
                       "GROUP BY rm.room_id, rm.name, b.name, period " +
                       "ORDER BY period";
                        
            case "week":
                return "SELECT rm.room_id, rm.name, b.name as building_name, " +
                       "YEARWEEK(r.start_time) as period, " +
                       "COUNT(*) as reservations, " +
                       "SUM(TIMESTAMPDIFF(MINUTE, r.start_time, r.end_time)) as total_minutes " +
                       "FROM reservations r " +
                       "JOIN rooms rm ON r.room_id = rm.room_id " +
                       "JOIN buildings b ON rm.building_id = b.building_id " +
                       "WHERE r.start_time BETWEEN ? AND ? " +
                       "GROUP BY rm.room_id, rm.name, b.name, period " +
                       "ORDER BY period";
                        
            case "month":
                return "SELECT rm.room_id, rm.name, b.name as building_name, " +
                       "DATE_FORMAT(r.start_time, '%Y-%m') as period, " +
                       "COUNT(*) as reservations, " +
                       "SUM(TIMESTAMPDIFF(MINUTE, r.start_time, r.end_time)) as total_minutes " +
                       "FROM reservations r " +
                       "JOIN rooms rm ON r.room_id = rm.room_id " +
                       "JOIN buildings b ON rm.building_id = b.building_id " +
                       "WHERE r.start_time BETWEEN ? AND ? " +
                       "GROUP BY rm.room_id, rm.name, b.name, period " +
                       "ORDER BY period";
                        
            default:
                throw new IllegalArgumentException("Invalid period: " + period);
        }
    }


    public double getOverallUtilizationRate(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT SUM(CASE WHEN status = 'completed' THEN TIMESTAMPDIFF(MINUTE, start_time, end_time) ELSE 0 END) / " +
                     "SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) * 100 AS utilization_rate " +
                     "FROM reservations WHERE start_time >= ? AND end_time <= ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("utilization_rate");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}