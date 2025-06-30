package com.roomreserve.dao;

import com.roomreserve.model.RoomImage;
import com.roomreserve.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RoomImageDAO {
    private Connection connection;

    public RoomImageDAO() {
        try {
            this.connection = DBUtil.getConnection();
        } catch (SQLException ex) {
            Logger.getLogger(RoomImageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Add a new image
    public int addImage(RoomImage image) throws SQLException {
        String sql = "INSERT INTO room_images (room_id, image_url, caption, is_primary, uploaded_by) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, image.getRoomId());
            stmt.setString(2, image.getImageUrl());
            stmt.setString(3, image.getCaption());
            stmt.setBoolean(4, image.isPrimary());
            stmt.setObject(5, image.getUploadedBy(), Types.INTEGER);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating image failed, no rows affected.");
            }
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Creating image failed, no ID obtained.");
                }
            }
        }
    }

    // Get all images for a room
    public List<RoomImage> getImagesByRoom(int roomId) throws SQLException {
        List<RoomImage> images = new ArrayList<>();
        String sql = "SELECT * FROM room_images WHERE room_id = ? ORDER BY image_order ASC, uploaded_at DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    images.add(mapResultSetToRoomImage(rs));
                }
            }
        }
        return images;
    }

    // Get a single image by ID
    public RoomImage getImageById(int imageId) throws SQLException {
        String sql = "SELECT * FROM room_images WHERE image_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, imageId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRoomImage(rs);
                }
            }
        }
        return null;
    }

    // Update image caption
    public boolean updateCaption(int imageId, String caption) throws SQLException {
        String sql = "UPDATE room_images SET caption = ? WHERE image_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, caption);
            stmt.setInt(2, imageId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Set an image as primary (and clear others)
    public boolean setAsPrimary(int imageId, int roomId) throws SQLException {
        connection.setAutoCommit(false);
        try {
            // Clear existing primary images
            String clearSql = "UPDATE room_images SET is_primary = false WHERE room_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(clearSql)) {
                stmt.setInt(1, roomId);
                stmt.executeUpdate();
            }
            
            // Set new primary image
            String setSql = "UPDATE room_images SET is_primary = true WHERE image_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(setSql)) {
                stmt.setInt(1, imageId);
                int affected = stmt.executeUpdate();
                connection.commit();
                return affected > 0;
            }
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public void deleteImagesByRoom(int roomId) throws SQLException {
        String sql = "DELETE FROM room_images WHERE room_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.executeUpdate();
        }
    }
    
    // Update image order
    public boolean updateImageOrder(int imageId, int order) throws SQLException {
        String sql = "UPDATE room_images SET image_order = ? WHERE image_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, order);
            stmt.setInt(2, imageId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Delete an image
    public boolean deleteImage(int imageId) throws SQLException {
        String sql = "DELETE FROM room_images WHERE image_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, imageId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Get primary image for a room
    public RoomImage getPrimaryImage(int roomId) throws SQLException {
        String sql = "SELECT * FROM room_images WHERE room_id = ? AND is_primary = true LIMIT 1";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRoomImage(rs);
                }
            }
        }
        return null;
    }

    // Helper method to map ResultSet to RoomImage object
    private RoomImage mapResultSetToRoomImage(ResultSet rs) throws SQLException {
        RoomImage image = new RoomImage();
        image.setImageId(rs.getInt("image_id"));
        image.setRoomId(rs.getInt("room_id"));
        image.setImageUrl(rs.getString("image_url"));
        image.setCaption(rs.getString("caption"));
        image.setPrimary(rs.getBoolean("is_primary"));
        image.setUploadedAt(rs.getTimestamp("uploaded_at"));
        image.setUploadedBy(rs.getObject("uploaded_by", Integer.class));
        image.setImageOrder(rs.getInt("image_order"));
        return image;
    }
}