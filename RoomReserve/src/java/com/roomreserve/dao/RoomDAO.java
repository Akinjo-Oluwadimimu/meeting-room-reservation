package com.roomreserve.dao;

import com.roomreserve.model.Amenity;
import com.roomreserve.model.Building;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.Room;
import com.roomreserve.model.RoomImage;
import com.roomreserve.model.RoomSchedule;
import com.roomreserve.model.RoomUtilization;
import com.roomreserve.model.TimeSlot;
import com.roomreserve.model.User;
import com.roomreserve.util.DBUtil;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class RoomDAO {
    private RoomImageDAO roomImageDAO;

    public RoomDAO() {
        this.roomImageDAO = new RoomImageDAO();
    }

    public boolean deleteRoom(int roomId) throws SQLException {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public void deleteRoomAmenities(int roomId) throws SQLException {
        String sql = "DELETE FROM room_amenity_mapping WHERE room_id = ?";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.executeUpdate();
        }
    }
    
    public List<Room> searchRooms(String query, Integer buildingId, Boolean isActive) throws SQLException {
        List<Room> rooms = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, b.name as building_name FROM rooms r " +
            "JOIN buildings b ON r.building_id = b.building_id " +
            "WHERE 1=1"
        );

        // Add search conditions if query is provided
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (r.name LIKE ? OR r.room_number LIKE ? OR r.description LIKE ?)");
        }

        // Filter by building if provided
        if (buildingId != null) {
            sql.append(" AND r.building_id = ?");
        }

        // Filter by status if provided
        if (isActive != null) {
            sql.append(" AND r.is_active = ?");
        }

        sql.append(" ORDER BY r.name");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Set search query parameters
            if (query != null && !query.trim().isEmpty()) {
                String searchParam = "%" + query + "%";
                stmt.setString(paramIndex++, searchParam);
                stmt.setString(paramIndex++, searchParam);
                stmt.setString(paramIndex++, searchParam);
            }

            // Set building filter parameter
            if (buildingId != null) {
                stmt.setInt(paramIndex++, buildingId);
            }

            // Set status filter parameter
            if (isActive != null) {
                stmt.setBoolean(paramIndex++, isActive);
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("room_id"));
                room.setBuildingId(rs.getInt("building_id"));
                BuildingDAO buildingDAO = new BuildingDAO();
                Building building = buildingDAO.getBuildingById(room.getBuildingId());
                room.setBuilding(building);
                room.setName(rs.getString("name"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setFloor(rs.getInt("floor"));
                room.setCapacity(rs.getInt("capacity"));
                room.setRoomType(rs.getString("room_type"));
                room.setDescription(rs.getString("description"));
                room.setActive(rs.getBoolean("is_active"));
                rooms.add(room);
            }
        }
        return rooms;
    }
    
    public List<Room> getAllRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, b.name as building_name FROM rooms r JOIN buildings b ON r.building_id = b.building_id";
        BuildingDAO buildingDAO = new BuildingDAO();
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("room_id"));
                room.setBuildingId(rs.getInt("building_id"));
                room.setBuilding(buildingDAO.getBuildingById(room.getBuildingId()));
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
                
                rooms.add(room);
            }
        }
        return rooms;
    }
    
    public List<Room> getAllAvailableRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, b.name as building_name FROM rooms r JOIN buildings b ON r.building_id = b.building_id WHERE r.is_active = true";
        BuildingDAO buildingDAO = new BuildingDAO();
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("room_id"));
                room.setBuildingId(rs.getInt("building_id"));
                room.setBuilding(buildingDAO.getBuildingById(room.getBuildingId()));
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
                
                rooms.add(room);
            }
        }
        return rooms;
    }
    
    // Get room by ID
    public Room getRoomById(int roomId) throws SQLException {
        String sql = "SELECT r.*, b.name as building_name FROM rooms r JOIN buildings b ON r.building_id = b.building_id WHERE r.room_id = ?";
        BuildingDAO buildingDAO = new BuildingDAO();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("room_id"));
                room.setBuildingId(rs.getInt("building_id"));
                room.setBuilding(buildingDAO.getBuildingById(room.getBuildingId()));
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
                
                room.setAmenities(getRoomAmenities(roomId));
                
                // Set cover image if exists
                if (room.getCoverImageId() > 0) {
                    room.setCoverImage(roomImageDAO.getImageById(room.getCoverImageId()));
                }
                
                return room;
            }
        }
        return null;
    }
  
    // Add new room
    public int addRoom(Room room) throws SQLException {
        String sql = "INSERT INTO rooms (building_id, name, room_number, floor, capacity, room_type, description, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, room.getBuildingId());
            stmt.setString(2, room.getName());
            stmt.setString(3, room.getRoomNumber());
            stmt.setInt(4, room.getFloor());
            stmt.setInt(5, room.getCapacity());
            stmt.setString(6, room.getRoomType());
            stmt.setString(7, room.getDescription());
            stmt.setBoolean(8, room.isActive());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating room failed, no rows affected.");
            }
            
            // Get the generated room ID
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int roomId = generatedKeys.getInt(1);
                    
                    // Add amenities if any
                    if (room.getAmenities() != null && !room.getAmenities().isEmpty()) {
                        addRoomAmenities(roomId, room.getAmenities());
                    }
                    
                    return roomId;
                } else {
                    throw new SQLException("Creating room failed, no ID obtained.");
                }
            }
        }
    }

    // Update room
    public boolean updateRoom(Room room) throws SQLException {
        String sql = "UPDATE rooms SET building_id = ?, name = ?, room_number = ?, floor = ?, " +
                     "capacity = ?, room_type = ?, description = ?, is_active = ? WHERE room_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, room.getBuildingId());
            stmt.setString(2, room.getName());
            stmt.setString(3, room.getRoomNumber());
            stmt.setInt(4, room.getFloor());
            stmt.setInt(5, room.getCapacity());
            stmt.setString(6, room.getRoomType());
            stmt.setString(7, room.getDescription());
            stmt.setBoolean(8, room.isActive());
            stmt.setInt(9, room.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            // Update amenities
            if (affectedRows > 0 && room.getAmenities() != null) {
                updateRoomAmenities(room.getId(), room.getAmenities());
            } 
            
            if (affectedRows > 0 && room.getAmenities() == null) {
                deleteRoomAmenities(room.getId());
            } 
            
            return affectedRows > 0;
        }
    }
    
    // Set cover image for a room
    public boolean setCoverImage(int roomId, int imageId) throws SQLException {
        String sql = "UPDATE rooms SET cover_image_id = ? WHERE room_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, imageId);
            stmt.setInt(2, roomId);
            return stmt.executeUpdate() > 0;
        }
    }

//    
//    // Delete room
//    public boolean deleteRoom(int roomId) throws SQLException {
//        String sql = "DELETE FROM rooms WHERE room_id = ?";
//        
//        try (Connection conn = DBUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setInt(1, roomId);
//            return stmt.executeUpdate() > 0;
//        }
//    }
//    
    // Get all buildings
    public List<Building> getAllBuildings() throws SQLException {
        List<Building> buildings = new ArrayList<>();
        String sql = "SELECT * FROM buildings";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Building building = new Building();
                building.setId(rs.getInt("building_id"));
                building.setName(rs.getString("name"));
                building.setCode(rs.getString("code"));
                building.setLocation(rs.getString("location"));
                building.setFloorCount(rs.getInt("floor_count"));
                
                buildings.add(building);
            }
        }
        return buildings;
    }
    
    // Get all amenities
    public List<Amenity> getAllAmenities() throws SQLException {
        List<Amenity> amenities = new ArrayList<>();
        String sql = "SELECT * FROM room_amenities";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
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
    
    // Add amenities to a room
    private void addRoomAmenities(int roomId, List<Amenity> amenities) throws SQLException {
        String sql = "INSERT INTO room_amenity_mapping (room_id, amenity_id) VALUES (?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (Amenity amenity : amenities) {
                stmt.setInt(1, roomId);
                stmt.setInt(2, amenity.getId());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    
    // Update room amenities (delete existing and add new)
    private void updateRoomAmenities(int roomId, List<Amenity> amenities) throws SQLException {
        // First delete existing mappings
        String deleteSql = "DELETE FROM room_amenity_mapping WHERE room_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
            
            stmt.setInt(1, roomId);
            stmt.executeUpdate();
        }
        
        // Then add new mappings if amenities list is not empty
        if (!amenities.isEmpty()) {
            addRoomAmenities(roomId, amenities);
        }
    }
    
    // Search rooms with filters
    public List<Room> searchRooms(String buildingId, String roomType, String minCapacity, 
                                 String maxCapacity, String[] amenities) throws SQLException {
        List<Room> rooms = new ArrayList<>();
        BuildingDAO buildingDAO = new BuildingDAO();
        
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT r.*, b.name as building_name FROM rooms r " +
            "JOIN buildings b ON r.building_id = b.building_id ");// +
            //"WHERE r.is_active = true");
        
        // Amenities filter
        if (amenities != null && amenities.length > 0) {
            sql.append("JOIN room_amenity_mapping ram ON r.room_id = ram.room_id ");
        }
        
        List<Object> params = new ArrayList<>();
        
        // Building filter
        if (buildingId != null && !buildingId.isEmpty()) {
            sql.append(" AND r.building_id = ?");
            params.add(Integer.parseInt(buildingId));
        }
        
        // Room type filter
        if (roomType != null && !roomType.isEmpty()) {
            sql.append(" AND r.room_type = ?");
            params.add(roomType);
        }
        
        // Capacity filters
        if (minCapacity != null && !minCapacity.isEmpty()) {
            sql.append(" AND r.capacity >= ?");
            params.add(Integer.parseInt(minCapacity));
        }
        if (maxCapacity != null && !maxCapacity.isEmpty()) {
            sql.append(" AND r.capacity <= ?");
            params.add(Integer.parseInt(maxCapacity));
        }
        
        // Amenities filter
        if (amenities != null && amenities.length > 0) {
            sql.append(" AND ram.amenity_id IN (");
            for (int i = 0; i < amenities.length; i++) {
                sql.append(i == 0 ? "?" : ",?");
                params.add(Integer.parseInt(amenities[i]));
            }
            sql.append(")");
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("room_id"));
                room.setBuildingId(rs.getInt("building_id"));
                room.setBuilding(buildingDAO.getBuildingById(room.getBuildingId()));
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
                
                room.setAmenities(getRoomAmenities(room.getId()));
                
                // Set cover image if exists
                if (room.getCoverImageId() > 0) {
                    room.setCoverImage(roomImageDAO.getImageById(room.getCoverImageId()));
                }
                
                rooms.add(room);
            }
        }
        return rooms;
    }
    
    public List<Room> searchAvailableRooms(String buildingId, String roomType, String minCapacity, 
                                 String maxCapacity, String[] amenities) throws SQLException {
        List<Room> rooms = new ArrayList<>();
        BuildingDAO buildingDAO = new BuildingDAO();
        
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT r.*, b.name as building_name FROM rooms r " +
            "JOIN buildings b ON r.building_id = b.building_id ");// +
            //"WHERE r.is_active = true");
        
        // Amenities filter
        if (amenities != null && amenities.length > 0) {
            sql.append("JOIN room_amenity_mapping ram ON r.room_id = ram.room_id ");
        }
        
        List<Object> params = new ArrayList<>();
        
        // Building filter
        if (buildingId != null && !buildingId.isEmpty()) {
            sql.append(" AND r.building_id = ?");
            params.add(Integer.parseInt(buildingId));
        }
        
        // Room type filter
        if (roomType != null && !roomType.isEmpty()) {
            sql.append(" AND r.room_type = ?");
            params.add(roomType);
        }
        
        // Capacity filters
        if (minCapacity != null && !minCapacity.isEmpty()) {
            sql.append(" AND r.capacity >= ?");
            params.add(Integer.parseInt(minCapacity));
        }
        if (maxCapacity != null && !maxCapacity.isEmpty()) {
            sql.append(" AND r.capacity <= ?");
            params.add(Integer.parseInt(maxCapacity));
        }
        
        // Amenities filter
        if (amenities != null && amenities.length > 0) {
            sql.append(" AND ram.amenity_id IN (");
            for (int i = 0; i < amenities.length; i++) {
                sql.append(i == 0 ? "?" : ",?");
                params.add(Integer.parseInt(amenities[i]));
            }
            sql.append(")");
        }
        
        sql.append(" AND r.is_active = true");
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("room_id"));
                room.setBuildingId(rs.getInt("building_id"));
                room.setBuilding(buildingDAO.getBuildingById(room.getBuildingId()));
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
                
                room.setAmenities(getRoomAmenities(room.getId()));
                
                // Set cover image if exists
                if (room.getCoverImageId() > 0) {
                    room.setCoverImage(roomImageDAO.getImageById(room.getCoverImageId()));
                }
                
                rooms.add(room);
            }
        }
        return rooms;
    }
    
    public boolean toggleRoomStatus(int roomId) throws SQLException {
        String sql = "UPDATE rooms SET is_active = NOT is_active WHERE room_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Count all rooms
    public int countAllRooms() throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             ResultSet resultSet = stmt.executeQuery(sql);
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        }
    }
    
    public List<Room> getAllRooms(int offset, int limit, 
                                 String buildingFilter, Integer capacityFilter, 
                                 List<Integer> amenityFilters) throws SQLException {
        List<Room> rooms = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT r.*, GROUP_CONCAT(a.amenity_name) as amenities " +
            "FROM rooms r " +
            "LEFT JOIN room_amenity_mapping ram ON r.room_id = ram.room_id " +
            "LEFT JOIN room_amenities a ON ram.amenity_id = a.amenity_id " +
            "WHERE r.is_active = true "
        );
        
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();
        
        if (buildingFilter != null && !buildingFilter.isEmpty()) {
            conditions.add("r.building = ?");
            parameters.add(buildingFilter);
        }
        
        if (capacityFilter != null && capacityFilter > 0) {
            conditions.add("r.capacity >= ?");
            parameters.add(capacityFilter);
        }
        
        if (amenityFilters != null && !amenityFilters.isEmpty()) {
            conditions.add("ram.amenity_id IN (" + 
                String.join(",", Collections.nCopies(amenityFilters.size(), "?")) + 
                ")");
            parameters.addAll(amenityFilters);
        }
        
        if (!conditions.isEmpty()) {
            query.append(" AND ").append(String.join(" AND ", conditions));
        }
        
        query.append(" GROUP BY r.room_id ORDER BY r.room_name LIMIT ? OFFSET ?");
        parameters.add(limit);
        parameters.add(offset);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room(
//                    rs.getInt("room_id"),
//                    rs.getString("room_name"),
//                    rs.getInt("capacity"),
//                    rs.getString("location"),
//                    rs.getString("building"),
//                    rs.getInt("floor"),
//                    rs.getString("description"),
//                    rs.getString("image_url"),
//                    rs.getBoolean("is_active")
                );
                
                String amenities = rs.getString("amenities");
                if (amenities != null) {
                    //room.setAmenities(Arrays.asList(amenities.split(",")));
                }
                
                rooms.add(room);
            }
        }
        
        return rooms;
    }
    
    public int getRoomCount(String buildingFilter, Integer capacityFilter, 
                          List<Integer> amenityFilters) throws SQLException {
        StringBuilder query = new StringBuilder(
            "SELECT COUNT(DISTINCT r.room_id) as count FROM meeting_rooms r " +
            "LEFT JOIN room_amenity_mapping ram ON r.room_id = ram.room_id " +
            "WHERE r.is_active = true "
        );
        
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();
        
        if (buildingFilter != null && !buildingFilter.isEmpty()) {
            conditions.add("r.building = ?");
            parameters.add(buildingFilter);
        }
        
        if (capacityFilter != null && capacityFilter > 0) {
            conditions.add("r.capacity >= ?");
            parameters.add(capacityFilter);
        }
        
        if (amenityFilters != null && !amenityFilters.isEmpty()) {
            conditions.add("ram.amenity_id IN (" + 
                String.join(",", Collections.nCopies(amenityFilters.size(), "?")) + 
                ")");
            parameters.addAll(amenityFilters);
        }
        
        if (!conditions.isEmpty()) {
            query.append(" AND ").append(String.join(" AND ", conditions));
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
            return 0;
        }
    }
    
    
    
    public int getAvailableRoomsCount() {
        String sql = "SELECT COUNT(*) FROM rooms WHERE is_active = true";
        
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
    
    public int getTotalRoomsCount() {
        String sql = "SELECT COUNT(*) FROM rooms";
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
    
    public List<RoomUtilization> getRoomUtilization() {
        List<RoomUtilization> utilization = new ArrayList<>();
        String sql = "SELECT " +
                     "ru.room_id, " +
                     "ru.name, " +
                     "rm.capacity as total_slots, " +
                     "COUNT(CASE WHEN res.status = 'approved' AND res.end_time > NOW() THEN 1 END) as reserved_slots, " +
                     "ru.utilized_minutes, " +
                     "ru.scheduled_minutes " +
                     "FROM room_utilization ru " +
                     "JOIN rooms rm ON ru.room_id = rm.room_id " +
                     "LEFT JOIN reservations res ON ru.room_id = res.room_id " +
                     "WHERE rm.is_active = true " +
                     "GROUP BY ru.room_id, ru.name, rm.capacity, ru.utilized_minutes, ru.scheduled_minutes";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                RoomUtilization ru = new RoomUtilization();
                ru.setRoomId(rs.getInt("room_id"));
                ru.setName(rs.getString("name"));
                ru.setTotalSlots(rs.getInt("total_slots"));
                ru.setReservedSlots(rs.getInt("reserved_slots"));

                // Calculate utilization percentage (current reservations vs capacity)
                double reservationUtilization = 0;
                if (ru.getTotalSlots() > 0) {
                    reservationUtilization = ((double) ru.getReservedSlots() / ru.getTotalSlots()) * 100;
                }
                ru.setUtilizationPercentage(reservationUtilization);

                // Calculate time-based utilization from the view
                double timeUtilization = 0;
                int utilizedMinutes = rs.getInt("utilized_minutes");
                int scheduledMinutes = rs.getInt("scheduled_minutes");
                if (scheduledMinutes > 0) {
                    timeUtilization = ((double) utilizedMinutes / scheduledMinutes) * 100;
                }
                ru.setTimeUtilizationPercentage(timeUtilization);

                // Set appropriate CSS class based on reservation utilization
                if (timeUtilization >= 80) {
                    ru.setUtilizationClass("bg-green-600");
                } else if (timeUtilization >= 50) {
                    ru.setUtilizationClass("bg-yellow-500");
                } else {
                    ru.setUtilizationClass("bg-red-600");
                }

                utilization.add(ru);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return utilization;
    }
    
    public List<RoomSchedule> getTodaysSchedule(LocalDate date) {
        List<RoomSchedule> schedules = new ArrayList<>();
        
        // First get all active rooms
        String roomSql = "SELECT room_id, name FROM rooms WHERE is_active = true";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(roomSql)) {
            ResultSet roomRs;
            roomRs = stmt.executeQuery();
            
            while (roomRs.next()) {
                RoomSchedule schedule = new RoomSchedule();
                schedule.setRoomId(roomRs.getInt("room_id"));
                schedule.setRoomName(roomRs.getString("name"));
                
                // Define time slots for the day (8AM-6PM in 2-hour blocks)
                List<TimeSlot> timeSlots = new ArrayList<>();
                LocalDateTime start = date.atTime(8, 0);
                
                for (int i = 0; i < 5; i++) {
                    TimeSlot slot = new TimeSlot();
                    LocalDateTime end = start.plusHours(2);
                    
                    // Check for reservations in this time slot
                    String reservationSql = "SELECT r.reservation_id, r.purpose, r.title, u.first_name, u.last_name " +
                                          "FROM reservations r " +
                                          "JOIN users u ON r.user_id = u.user_id " +
                                          "WHERE r.room_id = ? AND (r.status = 'approved' OR r.status = 'completed' OR r.status = 'no-show') " +
                                          "AND ((r.start_time >= ? AND r.start_time < ?) " +
                                          "OR (r.end_time > ? AND r.end_time <= ?) " +
                                          "OR (r.start_time <= ? AND r.end_time >= ?))";
                    
                    try (PreparedStatement resStmt = conn.prepareStatement(reservationSql)) {
                        resStmt.setInt(1, schedule.getRoomId());
                        resStmt.setTimestamp(2, Timestamp.valueOf(start));
                        resStmt.setTimestamp(3, Timestamp.valueOf(end));
                        resStmt.setTimestamp(4, Timestamp.valueOf(start));
                        resStmt.setTimestamp(5, Timestamp.valueOf(end));
                        resStmt.setTimestamp(6, Timestamp.valueOf(start));
                        resStmt.setTimestamp(7, Timestamp.valueOf(end));
                        
                        ResultSet resRs = resStmt.executeQuery();
                        if (resRs.next()) {
                            Reservation reservation = new Reservation();
                            reservation.setId(resRs.getInt("reservation_id"));
                            reservation.setPurpose(resRs.getString("purpose"));
                            reservation.setTitle(resRs.getString("title"));
                            
                            User user = new User();
                            user.setFirstName(resRs.getString("first_name"));
                            user.setLastName(resRs.getString("last_name"));
                            reservation.setUser(user);
                            
                            // Set appropriate status class based on event type
                            if (reservation.getPurpose().toLowerCase().contains("meeting") || reservation.getTitle().toLowerCase().contains("meeting")) {
                                reservation.setStatus("bg-blue-100 text-blue-800");
                            } else if (reservation.getPurpose().toLowerCase().contains("lecture") || reservation.getTitle().toLowerCase().contains("lecture")) {
                                reservation.setStatus("bg-green-100 text-green-800");
                            } else {
                                reservation.setStatus("bg-gray-100 text-gray-800");
                            }
                            
                            slot.setReservation(reservation);
                            slot.setEventName(reservation.getTitle());
                        }
                    }
                    
                    timeSlots.add(slot);
                    start = end;
                }
                
                schedule.setTimeSlots(timeSlots);
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return schedules;
    }
    
    public List<RoomSchedule> getUserTodaysSchedule(LocalDate date) {
        List<RoomSchedule> schedules = new ArrayList<>();
        
        // First get all active rooms
        String roomSql = "SELECT room_id, name FROM rooms WHERE is_active = true";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(roomSql)) {
            ResultSet roomRs;
            roomRs = stmt.executeQuery();
            
            while (roomRs.next()) {
                RoomSchedule schedule = new RoomSchedule();
                schedule.setRoomId(roomRs.getInt("room_id"));
                schedule.setRoomName(roomRs.getString("name"));
                
                // Define time slots for the day (8AM-6PM in 2-hour blocks)
                List<TimeSlot> timeSlots = new ArrayList<>();
                LocalDateTime start = date.atTime(8, 0);
                
                for (int i = 0; i < 5; i++) {
                    TimeSlot slot = new TimeSlot();
                    LocalDateTime end = start.plusHours(2);
                    
                    // Check for reservations in this time slot
                    String reservationSql = "SELECT r.reservation_id, r.purpose, r.title, u.first_name, u.last_name " +
                                          "FROM reservations r " +
                                          "JOIN users u ON r.user_id = u.user_id " +
                                          "WHERE r.room_id = ? AND (r.status = 'approved' OR r.status = 'completed' OR r.status = 'no-show') " +
                                          "AND ((r.start_time >= ? AND r.start_time < ?) " +
                                          "OR (r.end_time > ? AND r.end_time <= ?) " +
                                          "OR (r.start_time <= ? AND r.end_time >= ?))";
                    
                    try (PreparedStatement resStmt = conn.prepareStatement(reservationSql)) {
                        resStmt.setInt(1, schedule.getRoomId());
                        resStmt.setTimestamp(2, Timestamp.valueOf(start));
                        resStmt.setTimestamp(3, Timestamp.valueOf(end));
                        resStmt.setTimestamp(4, Timestamp.valueOf(start));
                        resStmt.setTimestamp(5, Timestamp.valueOf(end));
                        resStmt.setTimestamp(6, Timestamp.valueOf(start));
                        resStmt.setTimestamp(7, Timestamp.valueOf(end));
                        
                        ResultSet resRs = resStmt.executeQuery();
                        if (resRs.next()) {
                            Reservation reservation = new Reservation();
                            reservation.setId(resRs.getInt("reservation_id"));
                            reservation.setPurpose(resRs.getString("purpose"));
                            reservation.setTitle(resRs.getString("title"));
                            
                            User user = new User();
                            user.setFirstName(resRs.getString("first_name"));
                            user.setLastName(resRs.getString("last_name"));
                            reservation.setUser(user);
                            
                            // Set appropriate status class based on event type
                            if (reservation.getPurpose().toLowerCase().contains("meeting") || reservation.getTitle().toLowerCase().contains("meeting")) {
                                reservation.setStatus("bg-blue-100 text-blue-800");
                            } else if (reservation.getPurpose().toLowerCase().contains("lecture") || reservation.getTitle().toLowerCase().contains("lecture")) {
                                reservation.setStatus("bg-green-100 text-green-800");
                            } else {
                                reservation.setStatus("bg-gray-100 text-gray-800");
                            }
                            
                            slot.setReservation(reservation);
                            slot.setEventName(reservation.getTitle());
                        }
                    }
                    
                    timeSlots.add(slot);
                    start = end;
                }
                
                schedule.setTimeSlots(timeSlots);
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return schedules;
    }
}
