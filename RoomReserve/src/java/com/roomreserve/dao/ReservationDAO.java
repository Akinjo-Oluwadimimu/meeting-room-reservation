package com.roomreserve.dao;

import com.roomreserve.model.Approval;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.ReservationStats;
import com.roomreserve.model.Room;
import com.roomreserve.model.StatusUpdate;
import com.roomreserve.model.User;
import com.roomreserve.util.DBUtil;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReservationDAO {
    private final RoomDAO roomDAO;
    private final UserDAO userDAO;

    public ReservationDAO() {
        roomDAO = new RoomDAO();
        userDAO = new UserDAO();
    }
    // Get all reservations
    public List<Reservation> getAllReservationss() throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations r ORDER BY r.start_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet resultSet = stmt.executeQuery(sql);
            
            while (resultSet.next()) {
                reservations.add(mapResultSetToReservation(resultSet));
            }
        }
        return reservations;
    }

    // Get reservation by ID
    public Reservation getReservationById(int reservationId) throws SQLException {
        String sql = "SELECT * FROM reservations r WHERE r.reservation_id = ?";
        Reservation reservation = null;
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            
            try (ResultSet resultSet = stmt.executeQuery()) {
                if (resultSet.next()) {
                    reservation = mapResultSetToReservation(resultSet);
                }
            }
        }
        return reservation;
    }
    
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setTitle(rs.getString("title"));
        reservation.setId(rs.getInt("reservation_id"));
        reservation.setUserId(rs.getInt("user_id"));
        reservation.setRoomId(rs.getInt("room_id"));
        reservation.setAttendees(rs.getInt("attendees"));
        reservation.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
        reservation.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
        reservation.setStartDate(rs.getTimestamp("start_time").toLocalDateTime());
        reservation.setEndDate(rs.getTimestamp("end_time").toLocalDateTime());
        reservation.setPurpose(rs.getString("purpose"));
        reservation.setStatus(rs.getString("status"));
        reservation.setRejectionReason(rs.getString("rejection_reason"));
        reservation.setCancellationReason(rs.getString("cancellation_reason"));
        reservation.setCancellationNote(rs.getString("cancellation_note"));
        reservation.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        if (rs.getTimestamp("check_in_time") != null) {
            reservation.setCheckInTime(rs.getTimestamp("check_in_time").toLocalDateTime());
        }
        if (rs.getTimestamp("cancelled_at") != null) {
            reservation.setCancellationTime(rs.getTimestamp("cancelled_at").toLocalDateTime());
        }
        Room room = roomDAO.getRoomById(rs.getInt("room_id"));
        reservation.setRoom(room);
        reservation.setRoomName(room.getName());
        reservation.setBuildingName(room.getBuilding().getName());
        User user = userDAO.findById(rs.getInt("user_id"));
        reservation.setUser(user);
        reservation.setUserName(user.getFirstName() + " " + user.getLastName());
        return reservation;
    }

    // Update reservation status
    public boolean updateReservationStatus(int reservationId, String status) throws SQLException {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, reservationId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    // Delete reservation
    public boolean deleteReservation(int reservationId) throws SQLException {
        String sql = "DELETE FROM reservations WHERE reservation_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reservationId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Count all reservations
    public int countAllReservations() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
             ResultSet resultSet = stmt.executeQuery(sql);
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        }
    }

    // Count reservations by status
    public int countReservations(String status, String searchType, String query, Date startDate, Date endDate) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM reservations r " +
        "JOIN rooms rm ON r.room_id = rm.room_id " +
        "JOIN buildings b ON rm.building_id = b.building_id " +
        "JOIN users u ON r.user_id = u.user_id " +
        "WHERE 1=1" );
        
        List<Object> params = new ArrayList<>();
        
        if (status != null) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        
        
        if (searchType != null) {
            switch(searchType) {
                case "user":
                    if (query != null) {
                        sql.append(" AND (u.username LIKE ?  OR u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ?)");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                    }
                    break;
                case "room":
                    if (query != null) {
                        sql.append(" AND (rm.name LIKE ?  OR rm.room_type LIKE ? OR rm.description LIKE ? OR b.name LIKE ?)");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                    }
                    break;
                case "date":
                    if (startDate != null && endDate != null) {
                        sql.append(" AND DATE(start_time) BETWEEN ? AND ?");
                        params.add(startDate);
                        params.add(endDate);
                    }
                    break;
            }
        }
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet resultSet = stmt.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
        }
    }
    

    // Get room utilization data
    public List<Object[]> getRoomUtilizationData(String period) throws SQLException {
        List<Object[]> data = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = null;
        switch(period) {
            case "7":
                sql = new StringBuilder("SELECT r.name AS label, " +
                "COUNT(b.reservation_id) AS total_bookings, " +
                "ROUND((COUNT(b.reservation_id) * 100.0 / " +
                "(SELECT COUNT(*) FROM reservations " +
                "WHERE date(start_time) BETWEEN CURRENT_DATE - ? AND CURRENT_DATE " +
                "AND status = 'completed')), 2) AS utilization_percentage " +
                "FROM rooms r LEFT JOIN " +
                "reservations b ON r.room_id = b.room_id " +
                "AND date(start_time) BETWEEN CURRENT_DATE - ? AND CURRENT_DATE " +
                "AND b.status = 'completed' GROUP BY r.name ORDER BY " +
                "utilization_percentage DESC ");
                    params.add(7);
                    params.add(7);
                break;
            case "30":
                sql = new StringBuilder("SELECT r.name AS label, " +
                "COUNT(b.reservation_id) AS total_bookings, " +
                "ROUND((COUNT(b.reservation_id) * 100.0 / " +
                "(SELECT COUNT(*) FROM reservations " +
                "WHERE date(start_time) BETWEEN CURRENT_DATE - ? AND CURRENT_DATE " +
                "AND status = 'completed')), 2) AS utilization_percentage " +
                "FROM rooms r LEFT JOIN " +
                "reservations b ON r.room_id = b.room_id " +
                "AND date(start_time) BETWEEN CURRENT_DATE - ? AND CURRENT_DATE " +
                "AND b.status = 'completed' GROUP BY r.name ORDER BY " +
                "utilization_percentage DESC ");
                    params.add(30);
                    params.add(30);
                break;
            case "current_month":
                sql = new StringBuilder("SELECT r.name AS label, " +
                "COUNT(b.reservation_id) AS total_bookings, " +
                "ROUND((COUNT(b.reservation_id) * 100.0 / " +
                "(SELECT COUNT(*) FROM reservations " +
                "WHERE EXTRACT(MONTH FROM start_time) = EXTRACT(MONTH FROM CURRENT_DATE) " +
                "AND EXTRACT(YEAR FROM start_time) = EXTRACT(YEAR FROM CURRENT_DATE) " +
                "AND status = 'completed')), 2) AS utilization_percentage " +
                "FROM rooms r LEFT JOIN " +
                "reservations b ON r.room_id = b.room_id " +
                "AND EXTRACT(MONTH FROM b.start_time) = EXTRACT(MONTH FROM CURRENT_DATE) " +
                "AND EXTRACT(YEAR FROM b.start_time) = EXTRACT(YEAR FROM CURRENT_DATE) " +
                "AND b.status = 'completed' GROUP BY r.name " +
                "ORDER BY utilization_percentage DESC; ");
                break;
            case "last_month":
                sql = new StringBuilder("SELECT r.name AS label, " +
                "COUNT(b.reservation_id) AS total_bookings, " +
                "ROUND((COUNT(b.reservation_id) * 100.0 / " +
                "(SELECT COUNT(*) FROM reservations " +
                "WHERE EXTRACT(MONTH FROM start_time) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL 1 month) " +
                "AND EXTRACT(YEAR FROM start_time) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL 1 month) " +
                "AND status = 'completed')), 2) AS utilization_percentage " +
                "FROM rooms r LEFT JOIN " +
                "reservations b ON r.room_id = b.room_id " +
                "AND EXTRACT(MONTH FROM b.start_time) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL 1 month) " +
                "AND EXTRACT(YEAR FROM b.start_time) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL 1 month) " +
                "AND b.status = 'completed' GROUP BY r.name " +
                "ORDER BY utilization_percentage DESC; ");
                break;    
        }
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet resultSet = stmt.executeQuery()) {
                while (resultSet.next()) {
                    Object[] row = new Object[3];
                    row[0] = resultSet.getString("label");
                    row[1] = resultSet.getInt("total_bookings");
                    row[2] = resultSet.getDouble("utilization_percentage");
                    data.add(row);
                }
            }
        }
        return data;
    }
    
    public int countReservationsByStatus(String status, String period) {
        String sql = null;
        switch(period) {
            case "current_month":
                sql = "SELECT COUNT(*) FROM reservations r " +
                "WHERE r.status = ?" +
                "AND r.start_time >= DATE_FORMAT(CURRENT_DATE, '%Y-%m-01') " +
                "AND r.start_time < DATE_FORMAT(CURRENT_DATE + INTERVAL 1 MONTH, '%Y-%m-01') ";
                break;
            case "last_month":
                sql = "SELECT COUNT(*) FROM reservations r " +
                "WHERE r.status = ?" +
                "AND r.start_time >= DATE_FORMAT(CURRENT_DATE - INTERVAL 1 MONTH, '%Y-%m-01') " +
                "AND r.start_time < DATE_FORMAT(CURRENT_DATE, '%Y-%m-01') ";
                break;
            case "last_quarter":
                sql = "SELECT COUNT(*) FROM reservations r " +
                "WHERE r.status = ?" +
                "AND r.start_time >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) " +
                "AND r.start_time < CURRENT_DATE ";
                break;  
        }
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    } 

    // Get room utilization data
    public List<Object[]> getRoomUtilizationData(int days) throws SQLException {
        List<Object[]> data = new ArrayList<>();
        String sql = "SELECT DATE(start_time) as date, COUNT(*) as count, " +
                     "ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reservations WHERE DATE(start_time) = date), 2) as percentage " +
                     "FROM reservations " +
                     "WHERE start_time >= DATE_SUB(CURDATE(), INTERVAL ? DAY) " +
                     "GROUP BY DATE(start_time) " +
                     "ORDER BY date";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, days);
            
            try (ResultSet resultSet = stmt.executeQuery()) {
                while (resultSet.next()) {
                    Object[] row = new Object[3];
                    row[0] = resultSet.getDate("date");
                    row[1] = resultSet.getInt("count");
                    row[2] = resultSet.getDouble("percentage");
                    data.add(row);
                }
            }
        }
        return data;
    }
    
    public int countReservationsBefore(Date date, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = ? AND created_at < ?";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setTimestamp(2, new Timestamp(date.getTime()));
            try (ResultSet resultSet = stmt.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
        }
    }
  
    public int getPendingApprovalsCount() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = 'pending'";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getPendingApprovalsCount(int userId) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = 'pending' AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getActiveReservationsCount() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = 'approved' AND end_time > NOW()";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getNewApprovalsSinceYesterday() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = 'pending' AND created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getReservationIncreasePercentage() {
        // Simplified calculation - in a real app you'd compare current week to previous week
        return 12;
    }
    
    public int getConflictCount() {
        String sql = "SELECT COUNT(*) FROM reservation_conflicts";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Reservation> getPendingReservations(String timeFilter, int limit) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations r " +
                     "WHERE r.status = 'pending' ";
        
        switch(timeFilter) {
            case "today":
                sql += "AND DATE(r.start_time) = CURDATE() ";
                break;
            case "week":
                sql += "AND YEARWEEK(r.start_time, 1) = YEARWEEK(CURDATE(), 1) ";
                break;
        }

        sql += "ORDER BY r.start_time ASC LIMIT ?";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public int getPendingReservationsCount(String timeFilter) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM reservations r " +
                     "WHERE r.status = 'pending' ";
        
        switch(timeFilter) {
            case "today":
                sql += "AND DATE(r.start_time) = CURDATE() ";
                break;
            case "week":
                sql += "AND YEARWEEK(r.start_time, 1) = YEARWEEK(CURDATE(), 1) ";
                break;
        }
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    
    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations r ORDER BY r.start_time ASC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
             ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    } 
    
    public List<Reservation> getAllReservations(int offset, int limit) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations r ORDER BY r.start_time ASC LIMIT ? OFFSET ?";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    } 
    
    public List<Reservation> getRecentReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations r ORDER BY r.created_at DESC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
             ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    } 
    
    public List<Reservation> getReservationsByDateRange(LocalDateTime start, LocalDateTime end) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE start_time >= ? AND end_time <= ? ORDER BY start_time ASC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setTimestamp(1, Timestamp.valueOf(start));
            statement.setTimestamp(2, Timestamp.valueOf(end));
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public List<Reservation> getReservationsByUserAndDateRange(int userId, LocalDateTime start, LocalDateTime end) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE start_time >= ? AND end_time <= ? AND user_id = ? ORDER BY start_time ASC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setTimestamp(1, Timestamp.valueOf(start));
            statement.setTimestamp(2, Timestamp.valueOf(end));
            statement.setInt(3, userId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public List<Reservation> getCancellationsByUserAndDateRange(int userId, LocalDateTime start, LocalDateTime end) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE start_time >= ? AND end_time <= ? AND user_id = ? AND status = 'cancelled' ORDER BY start_time ASC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setTimestamp(1, Timestamp.valueOf(start));
            statement.setTimestamp(2, Timestamp.valueOf(end));
            statement.setInt(3, userId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> getReservationsByRoom(int roomId) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE room_id = ? ORDER BY start_time ASC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, roomId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public List<Reservation> getUserUpcomingReservation(int userId, Date start, Date end) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE start_time BETWEEN NOW() AND ?  AND status = 'approved' AND user_id = ? ORDER BY start_time ASC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            //statement.setTimestamp(1, new Timestamp(start.getTime()));
            statement.setTimestamp(1, new Timestamp(end.getTime()));
            statement.setInt(2, userId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public boolean updateReservation(Reservation reservation) {
        String sql = "UPDATE reservations SET room_id = ?, user_id = ?, title = ?, start_time = ?, " +
                     "end_time = ?, purpose = ?, status = ? WHERE reservation_id = ?";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, reservation.getRoomId());
            statement.setInt(2, reservation.getUserId());
            statement.setString(3, reservation.getTitle());
//            statement.setTimestamp(4, Timestamp.valueOf(reservation.getStartTime()));
//            statement.setTimestamp(5, Timestamp.valueOf(reservation.getEndTime()));
//            statement.setString(6, reservation.getPurpose());
            statement.setString(7, reservation.getStatus());
            statement.setInt(8, reservation.getId());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean changeReservationStatus(int reservationId, String status) {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setInt(2, reservationId);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int createReservation(Reservation reservation, int userId) throws SQLException {
        String sql = "INSERT INTO reservations (room_id, user_id, title, start_time, end_time, purpose, attendees, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'pending')";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, reservation.getRoomId());
            statement.setInt(2, userId);
            statement.setString(3, reservation.getTitle());
            statement.setTimestamp(4, Timestamp.valueOf(reservation.getStartTime()));
            statement.setTimestamp(5, Timestamp.valueOf(reservation.getEndTime()));
            statement.setString(6, reservation.getPurpose());
            statement.setInt(7, reservation.getAttendees());

            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        }
    }
    
    public List<LocalDateTime[]> getAvailableSlots(int roomId, LocalDateTime date) {
        List<LocalDateTime[]> slots = new ArrayList<>();
        String sql = "SELECT start_time, end_time FROM reservations " +
                     "WHERE room_id = ? AND DATE(start_time) = DATE(?) " +
                     "AND status IN ('approved', 'pending') " +
                     "ORDER BY start_time";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, roomId);
            statement.setTimestamp(2, Timestamp.valueOf(date));
            
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                LocalDateTime start = rs.getTimestamp("start_time").toLocalDateTime();
                LocalDateTime end = rs.getTimestamp("end_time").toLocalDateTime();
                slots.add(new LocalDateTime[]{start, end});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return slots;
    }

    public boolean isRoomAvailable(int roomId, LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT COUNT(*) FROM reservations " +
                     "WHERE room_id = ? " +
                     "AND status IN ('approved', 'pending') " +
                     "AND ((start_time < ? AND end_time > ?) " +
                     "OR (start_time < ? AND end_time > ?) " +
                     "OR (start_time >= ? AND end_time <= ?))";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, roomId);
            statement.setTimestamp(2, Timestamp.valueOf(end));
            statement.setTimestamp(3, Timestamp.valueOf(start));
            statement.setTimestamp(4, Timestamp.valueOf(end));
            statement.setTimestamp(5, Timestamp.valueOf(start));
            statement.setTimestamp(6, Timestamp.valueOf(start));
            statement.setTimestamp(7, Timestamp.valueOf(end));
            
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean isRoomAvailableForUpdate(int reservationId, int roomId, LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT COUNT(*) FROM reservations " +
                     "WHERE room_id = ? " +
                     "AND reservation_id != ? " +  // Exclude the current reservation being updated
                     "AND status IN ('approved', 'pending') " +
                     "AND ((start_time < ? AND end_time > ?) " +
                     "OR (start_time < ? AND end_time > ?) " +
                     "OR (start_time >= ? AND end_time <= ?))";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, roomId);
            statement.setInt(2, reservationId);
            statement.setTimestamp(3, Timestamp.valueOf(end));
            statement.setTimestamp(4, Timestamp.valueOf(start));
            statement.setTimestamp(5, Timestamp.valueOf(end));
            statement.setTimestamp(6, Timestamp.valueOf(start));
            statement.setTimestamp(7, Timestamp.valueOf(start));
            statement.setTimestamp(8, Timestamp.valueOf(end));

            System.out.println(statement);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Reservation> getUserReservations(int userId, boolean includePast, String status, int room, Date startDate, Date endDate) {
        List<Reservation> reservations = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM reservations r WHERE r.user_id = ? " );
        
        List<Object> params = new ArrayList<>();
        params.add(userId);
        
        if (!includePast) {
            sql.append("AND r.end_time >= NOW() ");
        }
        
        if (status != null) {
            sql.append(" AND r.status = ?");
            params.add(status);
        }
        
        if (room != 0) {
            sql.append(" AND r.room_id = ?");
            params.add(room);
        }
        
        if (startDate != null && endDate != null) {
            sql.append(" AND DATE(start_time) BETWEEN ? AND ?");
            params.add(startDate);
            params.add(endDate);
        }
        
        sql.append(" ORDER BY r.start_time DESC");

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public List<Reservation> getTodaysReservations(int userId, Date date) {
        List<Reservation> reservations = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM reservations r WHERE r.user_id = ? AND r.end_time >= NOW() AND DATE(start_time) = ? AND r.status IN ('approved', 'no-show', 'completed') ORDER BY r.start_time ASC");
        
        List<Object> params = new ArrayList<>();
        params.add(userId);
        params.add(date);

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public Reservation getReservationById(int reservationId, int userId) {
        String sql = "SELECT r.*, rm.name as room_name, b.name as building_name, " +
                     "GROUP_CONCAT(CONCAT(ra.status, '|', ra.comments, '|', " +
                     "COALESCE(ra.action_time, ''), '|', " +
                     "COALESCE(CONCAT(u.first_name, ' ', u.last_name), '')) SEPARATOR ';;') as approval_info " +
                     "FROM reservations r " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "JOIN buildings b ON rm.building_id = b.building_id " +
                     "LEFT JOIN reservation_approvals ra ON r.reservation_id = ra.reservation_id " +
                     "LEFT JOIN users u ON ra.approver_id = u.user_id " +
                     "WHERE r.reservation_id = ? AND r.user_id = ? " +
                     "GROUP BY r.reservation_id";

        Reservation reservation = null;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, reservationId);
            statement.setInt(2, userId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                reservation = mapResultSetToReservation(rs);

                // Process approval information
                String approvalInfo = rs.getString("approval_info");
                if (approvalInfo != null && !approvalInfo.isEmpty()) {
                    List<Approval> approvals = new ArrayList<>();
                    String[] approvalEntries = approvalInfo.split(";;");

                    for (String entry : approvalEntries) {
                        String[] parts = entry.split("\\|");
                        if (parts.length >= 4) {
                            Approval approval = new Approval();
                            approval.setStatus(parts[0]);
                            approval.setComments(parts[1]);

                            if (!parts[2].isEmpty()) {
                                approval.setActionTime(rs.getTimestamp("action_time").toLocalDateTime());
                            }

                            if (!parts[3].isEmpty()) {
                                approval.setApproverName(parts[3]);
                            }

                            approvals.add(approval);
                        }
                    }
                    reservation.setApprovals(approvals);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservation;
    }

    public boolean cancelReservation(int reservationId, int userId, String reason, String notes) {
        String sql = "UPDATE reservations SET status = 'cancelled', " +
                     "cancellation_reason = ?, cancellation_note = ?, updated_at = NOW(), cancelled_at = NOW() " +
                     "WHERE reservation_id = ? AND user_id = ?";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, reason);
            statement.setString(2, notes);
            statement.setInt(3, reservationId);
            statement.setInt(4, userId);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReservation(Reservation reservation, int userId) {
        String sql = "UPDATE reservations SET title = ?, purpose = ?, " +
                     "start_time = ?, end_time = ?, attendees = ?, " +
                     "updated_at = NOW() " +
                     "WHERE reservation_id = ? AND user_id = ? " +
                     "AND status IN ('pending', 'approved')";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, reservation.getTitle());
            statement.setString(2, reservation.getPurpose());
            statement.setTimestamp(3, Timestamp.valueOf(reservation.getStartTime()));
            statement.setTimestamp(4, Timestamp.valueOf(reservation.getEndTime()));
            statement.setInt(5, reservation.getAttendees());
            statement.setInt(6, reservation.getId());
            statement.setInt(7, userId);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Reservation> getPendingReservations(int offset, int limit) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations r WHERE r.status = 'pending' " +
                     "ORDER BY r.start_time ASC LIMIT ? OFFSET ?";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    } 
    
    public int countReservationsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM reservations r " +
                     "WHERE r.status = ?" ;

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    } 
    
    public List<Reservation> getReservations(String status, String searchType, String query, Date startDate, Date endDate, int offset, int limit) {
        List<Reservation> reservations = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM reservations r " +
            "JOIN rooms rm ON r.room_id = rm.room_id " +
            "JOIN buildings b ON rm.building_id = b.building_id " +
            "JOIN users u ON r.user_id = u.user_id " +
            "WHERE 1=1" );
        List<Object> params = new ArrayList<>();
        
        if (status != null) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        
        
        if (searchType != null) {
            switch(searchType) {
                case "user":
                    if (query != null) {
                        sql.append(" AND (u.username LIKE ?  OR u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ?)");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                    }
                    break;
                case "room":
                    if (query != null) {
                        sql.append(" AND (rm.name LIKE ?  OR rm.room_type LIKE ? OR rm.description LIKE ? OR b.name LIKE ?)");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                        params.add("%" + query + "%");
                    }
                    break;
                case "date":
                    if (startDate != null && endDate != null) {
                        sql.append(" AND DATE(start_time) BETWEEN ? AND ?");
                        params.add(startDate);
                        params.add(endDate);
                    }
                    break;
            }
        }
                
        sql.append(" ORDER BY r.start_time DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    } 

    public boolean updateReservationStatus(int reservationId, String newStatus, int managerId, String comments) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Get current status
            String currentStatus = getReservationStatus(conn, reservationId);
            
            // 2. Update reservation
            String updateSql = "UPDATE reservations SET status = ? ";
            
            if (newStatus.equals("rejected")) {
                updateSql += ", rejection_reason = ? ";
            }
            updateSql += "WHERE reservation_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setString(1, newStatus);
                if (newStatus.equals("rejected")) {
                    stmt.setString(2, comments);
                    stmt.setInt(3, reservationId);
                } else {
                    stmt.setInt(2, reservationId);
                }
                stmt.executeUpdate();
            }
            
            // 3. Record audit trail
            String auditSql = "INSERT INTO reservation_audit (reservation_id, changed_by, old_status, new_status, comments) " +
                              "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(auditSql)) {
                stmt.setInt(1, reservationId);
                stmt.setInt(2, managerId);
                stmt.setString(3, currentStatus);
                stmt.setString(4, newStatus);
                stmt.setString(5, comments);
                stmt.executeUpdate();
            }
            
            // 4. Create notification
            createStatusNotification(conn, reservationId, newStatus);
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    private String getReservationStatus(Connection conn, int reservationId) throws SQLException {
        String sql = "SELECT status FROM reservations WHERE reservation_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getString("status") : null;
        }
    }

    private void createStatusNotification(Connection conn, int reservationId, String newStatus) throws SQLException {
        String sql = "INSERT INTO notifications (user_id, title, message) " +
                     "SELECT r.user_id, " +
                     "CONCAT('Reservation ', r.reservation_id, ' ', ?), " +
                     "CONCAT('Your reservation for ', rm.name, ' on ', " +
                     "DATE_FORMAT(r.start_time, '%M %d, %Y'), ' has been ', ?) " +
                     "FROM reservations r " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "WHERE r.reservation_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus.equals("approved") ? "Approved" : "Rejected");
            stmt.setString(2, newStatus.equals("approved") ? "approved" : "rejected");
            stmt.setInt(3, reservationId);
            stmt.executeUpdate();
        }
    }

    public List<StatusUpdate> getStatusUpdates(int reservationId) {
        List<StatusUpdate> updates = new ArrayList<>();
        String sql = "SELECT ra.*, u.first_name, u.last_name " +
                     "FROM reservation_audit ra " +
                     "JOIN users u ON ra.changed_by = u.user_id " +
                     "WHERE ra.reservation_id = ? " +
                     "ORDER BY ra.changed_at DESC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                StatusUpdate update = new StatusUpdate();
                update.setUpdateId(rs.getInt("audit_id"));
                update.setReservationId(rs.getInt("reservation_id"));
                update.setManagerId(rs.getInt("changed_by"));
                update.setManagerName(rs.getString("first_name") + " " + rs.getString("last_name"));
                update.setOldStatus(rs.getString("old_status"));
                update.setNewStatus(rs.getString("new_status"));
                update.setComments(rs.getString("comments"));
                update.setUpdateTime(rs.getTimestamp("changed_at").toLocalDateTime());
                updates.add(update);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return updates;
    }
    
    public ReservationStats getReservationStats(int roomId, String period) {
        ReservationStats stats = new ReservationStats();
        String sql = "";

        switch(period) {
            case "day":
                sql = "SELECT COUNT(*) as total, " +
                      "SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved, " +
                      "SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) as cancelled, " +
                      "AVG(TIMESTAMPDIFF(HOUR, start_time, end_time)) as avg_duration " +
                      "FROM reservations " +
                      "WHERE room_id = ? AND DATE(start_time) = CURDATE()";
                break;
            case "week":
                // Similar for week/month/year
        }

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                stats.setTotalReservations(rs.getInt("total"));
                stats.setApprovedReservations(rs.getInt("approved"));
                stats.setCancelledReservations(rs.getInt("cancelled"));
                stats.setAvgDuration(rs.getDouble("avg_duration"));

                // Calculate rates
                if (stats.getTotalReservations() > 0) {
                    stats.setApprovalRate(Math.round(
                        (stats.getApprovedReservations() * 100.0) / stats.getTotalReservations()
                    ));
                    stats.setCancellationRate(Math.round(
                        (stats.getCancelledReservations() * 100.0) / stats.getTotalReservations()
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    
    public boolean cancelApprovedReservation(int reservationId, int userId, String reason) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public List<Reservation> searchByUserName(String query) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, rm.name as room_name, b.name AS building_name, " +
                     "u.first_name, u.last_name, u.email, u.username " +
                     "FROM reservations r " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "JOIN buildings b ON rm.building_id = b.building_id " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "WHERE u.username LIKE ?  OR u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ?" +
                     "ORDER BY r.start_time ASC";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql)) {
            for (int i = 1; i <= 4; i++) {
                statement.setString(i, "%"+ query +"%");
            }
            
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public void updateCompletedReservations() {
        LocalDateTime yesterday = LocalDateTime.now().minusDays(1);
        String sql = "UPDATE reservations SET status = 'completed' " +
                     "WHERE status = 'approved' " +
                     "AND end_time < ? " +
                     "AND end_time > (start_time + INTERVAL 15 MINUTE)";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(yesterday));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Runs every 30 minutes checking for no-shows
    public void updateNoShowReservations() {
        LocalDateTime now = LocalDateTime.now();
        String sql = "UPDATE reservations SET status = 'no-show' " +
                     "WHERE status = 'approved' " +
                     "AND start_time < ? " +
                     "AND start_time > (NOW() - INTERVAL 24 HOUR) " +
                     "AND end_time < NOW() " +
                     "AND check_in_time IS NULL";

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(now));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // When user checks in via mobile app/kiosk
    public void markAsCheckedIn(int reservationId) {
        String sql = "UPDATE reservations SET check_in_time = NOW(), status = 'completed' " +
                     "WHERE reservation_id = ? AND status = 'approved'";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<Reservation> getAllCancelledReservations() {
        return getCancelledReservationsWithQuery(
            "WHERE r.status IN ('cancelled', 'no-show') " +
            "ORDER BY r.start_time DESC");
    }

    public List<Reservation> getCancelledReservationsByDateRange(LocalDateTime start, LocalDateTime end) {
        return getCancelledReservationsWithQuery(
            "WHERE r.status IN ('cancelled', 'no-show') " +
            "AND r.start_time BETWEEN ? AND ? " +
            "ORDER BY r.start_time DESC", 
            Timestamp.valueOf(start), Timestamp.valueOf(end));
    }

    public List<Reservation> getCancelledReservationsByRoom(int roomId) {
        return getCancelledReservationsWithQuery(
            "WHERE r.status IN ('cancelled', 'no-show') " +
            "AND r.room_id = ? " +
            "ORDER BY r.start_time DESC", 
            roomId);
    }

    public List<Reservation> getCancelledReservationsByUser(int userId) {
        return getCancelledReservationsWithQuery(
            "WHERE r.status IN ('cancelled', 'no-show') " +
            "AND r.user_id = ? " +
            "ORDER BY r.start_time DESC", 
            userId);
    }

    public List<Reservation> getCancelledReservations(String status, int room, Date startDate, Date endDate, int limit, int offset) {
        List<Reservation> cancellations = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM reservations r " +
            "JOIN rooms rm ON r.room_id = rm.room_id " +
            "JOIN buildings b ON rm.building_id = b.building_id " +
            "JOIN users u ON r.user_id = u.user_id " +
            "WHERE 1=1 AND r.status IN ('cancelled', 'no-show') " );
        List<Object> params = new ArrayList<>();
        
        if (status != null) {
            sql.append(" AND r.status = ?");
            params.add(status);
        }
        
        if (room != 0) {
            sql.append(" AND r.room_id = ?");
            params.add(room);
        }
        
        if (startDate != null && endDate != null) {
            sql.append(" AND DATE(start_time) BETWEEN ? AND ?");
            params.add(startDate);
            params.add(endDate);
        }
                
        sql.append(" ORDER BY r.start_time ASC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                cancellations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cancellations;
    } 
        
    public int countCancellationsByStatus(String status, int room, Date startDate, Date endDate, int limit, int offset) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM reservations r " +
        "JOIN rooms rm ON r.room_id = rm.room_id " +
        "JOIN buildings b ON rm.building_id = b.building_id " +
        "JOIN users u ON r.user_id = u.user_id " +
        "WHERE 1=1 AND r.status IN ('cancelled', 'no-show')" );
        
        List<Object> params = new ArrayList<>();
        
        if (status != null) {
            sql.append(" AND r.status = ?");
            params.add(status);
        }
        
        if (room != 0) {
            sql.append(" AND r.room_id = ?");
            params.add(room);
        }
        
        if (startDate != null && endDate != null) {
            sql.append(" AND DATE(start_time) BETWEEN ? AND ?");
            params.add(startDate);
            params.add(endDate);
        }
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet resultSet = stmt.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
        }
    }
    
    private List<Reservation> getCancelledReservationsWithQuery(String whereClause, Object... params) {
        List<Reservation> cancellations = new ArrayList<>();
        String sql = "SELECT r.*, rm.name, b.name AS building_name, " +
                     "u.first_name, u.last_name, u.email, u.user_id " +
                     "FROM reservations r " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "JOIN buildings b ON rm.building_id = b.building_id " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.status IN ('cancelled', 'no-show') " +
                     whereClause;

        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                if (params[i] instanceof Date) {
                    stmt.setTimestamp(i + 1, (Timestamp) params[i]);
                } else if (params[i] instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) params[i]);
                }
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                cancellations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cancellations;
    }
    
    public Map<String, String> getCancellationStats(int userId) {
        Map<String, String> stats = new HashMap<>();
        String query = "SELECT COUNT(*) as count, MAX(cancelled_at) as last_date, " +
                      "(SELECT rm.name FROM reservations r, rooms rm WHERE " +
                      "r.status = 'cancelled' AND r.room_id = rm.room_id AND user_id = ? " +
                      "ORDER BY cancelled_at DESC LIMIT 1) as last_room " +
                      "FROM reservations WHERE status = 'cancelled' AND user_id = ? " +
                      "AND cancelled_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("count", String.valueOf(rs.getInt("count")));
                stats.put("last_room", rs.getString("last_room"));
                
                // Calculate time difference text
                Timestamp lastDate = rs.getTimestamp("last_date");
                if (lastDate != null) {
                    stats.put("timeframe", calculateTimeAgo(lastDate));
                } else {
                    stats.put("timeframe", "No recent cancellations");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    private String calculateTimeAgo(Timestamp date) {
        Instant now = Instant.now();
        Instant then = date.toInstant();
        Duration duration = Duration.between(then, now);

        if (duration.toDays() > 30) {
            return "Over a month ago";
        } else if (duration.toDays() > 0) {
            return duration.toDays() + " days ago";
        } else if (duration.toHours() > 0) {
            return duration.toHours() + " hours ago";
        } else {
            return "Less than an hour ago";
        }
    }
    
    public Map<String, Object> getUpcomingMeetingsStats(int userId) {
        Map<String, Object> stats = new HashMap<>();

        // Get count of upcoming meetings (next 7 days)
        String countQuery = "SELECT COUNT(*) as count FROM reservations " +
                          "WHERE start_time > NOW() " +
                          "AND start_time < DATE_ADD(NOW(), INTERVAL 7 DAY) " +
                          "AND status = 'approved' AND user_id = ?";

        // Get next meeting details
        String nextMeetingQuery = "SELECT rm.name, start_time, end_time " +
                                "FROM reservations r, rooms rm " +
                                "WHERE start_time > NOW() " +
                                "AND r.status = 'approved' AND r.room_id = rm.room_id AND user_id = ? " +
                                "ORDER BY start_time ASC LIMIT 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement countStmt = conn.prepareStatement(countQuery);
             PreparedStatement meetingStmt = conn.prepareStatement(nextMeetingQuery)) {

            // Get upcoming meeting count
            countStmt.setInt(1, userId);
            ResultSet countRs = countStmt.executeQuery();
            if (countRs.next()) {
                stats.put("count", countRs.getInt("count"));
            }

            // Get next meeting details
            meetingStmt.setInt(1, userId);
            ResultSet meetingRs = meetingStmt.executeQuery();
            if (meetingRs.next()) {
                Map<String, String> nextMeeting = new HashMap<>();
                nextMeeting.put("room", meetingRs.getString("name"));

                Timestamp startTime = meetingRs.getTimestamp("start_time");
                Timestamp endTime = meetingRs.getTimestamp("end_time");

                // Format the time display
                SimpleDateFormat dateFormat = new SimpleDateFormat("h:mm a");
                String timeRange = dateFormat.format(startTime) + " - " + dateFormat.format(endTime);

                // Determine if it's today or another day
                String dayInfo;
                if (isToday(startTime)) {
                    dayInfo = "Today, " + timeRange;
                } else if (isTomorrow(startTime)) {
                    dayInfo = "Tomorrow, " + timeRange;
                } else {
                    SimpleDateFormat dayFormat = new SimpleDateFormat("EEE, MMM d");
                    dayInfo = dayFormat.format(startTime) + ", " + timeRange;
                }

                nextMeeting.put("timeInfo", dayInfo);
                stats.put("nextMeeting", nextMeeting);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    private boolean isToday(Timestamp timestamp) {
        LocalDate today = LocalDate.now();
        LocalDate date = timestamp.toLocalDateTime().toLocalDate();
        return date.isEqual(today);
    }

    private boolean isTomorrow(Timestamp timestamp) {
        LocalDate tomorrow = LocalDate.now().plusDays(1);
        LocalDate date = timestamp.toLocalDateTime().toLocalDate();
        return date.isEqual(tomorrow);
    }
    
    public List<Reservation> getReservationsNeedingReminders(LocalDateTime now, 
        LocalDateTime windowStart, LocalDateTime windowEnd) throws SQLException {

        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE " +
                     "start_time BETWEEN ? AND ? " +
                     "AND status = 'approved' " +
                     "AND reminder_sent = FALSE";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setTimestamp(1, Timestamp.valueOf(windowStart));
            statement.setTimestamp(2, Timestamp.valueOf(windowEnd));

            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        }
        return reservations;
    }

    public boolean markReminderSent(int reservationId) throws SQLException {
        String sql = "UPDATE reservations SET reminder_sent = TRUE, reminder_sent_at = CURRENT_TIMESTAMP " +
                     "WHERE reservation_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, reservationId);
            return statement.executeUpdate() > 0;
        }
    }
    
    public Map<String, Object> getUsageStatistics(LocalDateTime start, LocalDateTime end) {
        Map<String, Object> stats = new HashMap<>();
        
        // Total reservations
        String totalSql = "SELECT COUNT(*) FROM reservations WHERE start_time BETWEEN ? AND ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(totalSql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalReservations", rs.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Reservations by status
        String statusSql = "SELECT status, COUNT(*) FROM reservations WHERE start_time BETWEEN ? AND ? GROUP BY status";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(statusSql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));
            ResultSet rs = stmt.executeQuery();
            Map<String, Integer> statusCounts = new HashMap<>();
            while (rs.next()) {
                statusCounts.put(rs.getString(1), rs.getInt(2));
            }
            stats.put("reservationsByStatus", statusCounts);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Room utilization
        String roomSql = "SELECT r.name, COUNT(*) as bookings " +
                         "FROM reservations res JOIN rooms r ON res.room_id = r.room_id " +
                         "WHERE res.start_time BETWEEN ? AND ? " +
                         "GROUP BY r.name ORDER BY bookings DESC LIMIT 10";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(roomSql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));
            ResultSet rs = stmt.executeQuery();
            Map<String, Integer> roomUsage = new LinkedHashMap<>();
            while (rs.next()) {
                roomUsage.put(rs.getString("name"), rs.getInt("bookings"));
            }
            stats.put("roomUtilization", roomUsage);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return stats;
    }
}
