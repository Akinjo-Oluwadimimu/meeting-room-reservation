package com.roomreserve.dao;

import com.roomreserve.model.Amenity;
import com.roomreserve.model.Room;
import com.roomreserve.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FavoriteRoomDAO {
    private final Connection connection;
    private final RoomImageDAO roomImageDAO;

    public FavoriteRoomDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
        this.roomImageDAO = new RoomImageDAO();
    }

    // Add room to user's favorites
    public boolean addFavorite(int userId, int roomId) {
        String query = "INSERT INTO user_favorites (user_id, room_id) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) { // Duplicate entry
                return false;
            }
            e.printStackTrace();
            return false;
        }
    }
    
    public int getFavoriteRoomCount(int userId) {
        String query = "SELECT COUNT(*) FROM user_favorites WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
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
    
    public String getRecentFavoriteRoom(int userId) {
        String query = "SELECT r.* FROM rooms r " +
                      "JOIN user_favorites uf ON r.room_id = uf.room_id " +
                      "WHERE uf.user_id = ? ORDER BY uf.created_at DESC LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("r.name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Remove room from user's favorites
    public boolean removeFavorite(int userId, int roomId) {
        String query = "DELETE FROM user_favorites WHERE user_id = ? AND room_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all favorite rooms for a user
    public List<Room> getUserFavorites(int userId) {
        List<Room> favorites = new ArrayList<>();
        String query = "SELECT r.* FROM rooms r " +
                      "JOIN user_favorites uf ON r.room_id = uf.room_id " +
                      "WHERE uf.user_id = ? ORDER BY uf.created_at DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("room_id"));
                room.setBuildingId(rs.getInt("building_id"));
                room.setName(rs.getString("name"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setFloor(rs.getInt("floor"));
                room.setCapacity(rs.getInt("capacity"));
                room.setRoomType(rs.getString("room_type"));
                room.setDescription(rs.getString("description"));
                room.setActive(rs.getBoolean("is_active"));
                room.setCoverImageId(rs.getInt("cover_image_id"));
                
                // Load images
                room.setImages(roomImageDAO.getImagesByRoom(room.getId()));
                
                // Get amenities for this room
                room.setAmenities(getRoomAmenities(room.getId()));
                
                // Set cover image if exists
                if (room.getCoverImageId() > 0) {
                    room.setCoverImage(roomImageDAO.getImageById(room.getCoverImageId()));
                }
                
                favorites.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return favorites;
    }
    
    public boolean getFavoriteStatus(int userId, int roomId) {
        ResultSet rs = null;
        try {
            String sql="select * from user_favorites where room_id=? and user_id=?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, roomId);
            stmt.setInt(2, userId);
            rs = stmt.executeQuery();

            if(!rs.wasNull() && rs.next())
                return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Set default favorite room
    public boolean setDefaultFavorite(int userId, int roomId) {
        String query = "UPDATE users SET default_favorite_room = ? WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, roomId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get amenities for a specific room
    private List<Amenity> getRoomAmenities(int roomId) throws SQLException {
        List<Amenity> amenities = new ArrayList<>();
        String sql = "SELECT a.* FROM room_amenity_mapping ram JOIN room_amenities a ON ram.amenity_id = a.amenity_id WHERE ram.room_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Amenity amenity = new Amenity();
                amenity.setId(rs.getInt("amenity_id"));
                amenity.setName(rs.getString("name"));
                amenity.setDescription(rs.getString("description"));
                amenity.setIconClass(rs.getString("icon_class"));
                
                amenities.add(amenity);
            }
        }
        return amenities;
    }
}