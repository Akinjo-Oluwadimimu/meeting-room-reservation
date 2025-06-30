package com.roomreserve.dao;

import com.roomreserve.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import javax.sql.DataSource;

public class PasswordResetDAO {

    public PasswordResetDAO() {
    }

    public void createPasswordResetToken(int userId, String token, Date expiresAt) throws SQLException {
        String sql = "INSERT INTO password_resets (user_id, token, expires_at) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, new Timestamp(expiresAt.getTime()));
            ps.executeUpdate();
        }
    }

    public boolean isTokenValid(String token) throws SQLException {
        String sql = "SELECT expires_at FROM password_resets WHERE token = ? AND expires_at > NOW()";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Token is valid if found and not expired
            }
        }
    }

    public int getUserIdByToken(String token) throws SQLException {
        String sql = "SELECT user_id FROM password_resets WHERE token = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
                throw new SQLException("Invalid token");
            }
        }
    }

    public void deleteTokensForUser(int userId) throws SQLException {
        String sql = "DELETE FROM password_resets WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}