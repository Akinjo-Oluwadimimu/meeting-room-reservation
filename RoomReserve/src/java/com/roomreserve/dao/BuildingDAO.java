package com.roomreserve.dao;

import com.roomreserve.model.Building;
import com.roomreserve.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BuildingDAO {
    
    // SQL queries as constants
    private static final String GET_ALL_BUILDINGS = "SELECT * FROM buildings ORDER BY name";
    private static final String GET_BUILDING_BY_ID = "SELECT * FROM buildings WHERE building_id = ?";
    private static final String INSERT_BUILDING = "INSERT INTO buildings (name, code, location, floor_count) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_BUILDING = "UPDATE buildings SET name = ?, code = ?, location = ?, floor_count = ? WHERE building_id = ?";
    private static final String DELETE_BUILDING = "DELETE FROM buildings WHERE building_id = ?";
    private static final String CHECK_BUILDING_USAGE = "SELECT COUNT(*) FROM rooms WHERE building_id = ?";

    /**
     * Get all buildings from the database
     */
    public List<Building> getAllBuildings() throws SQLException {
        List<Building> buildings = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_BUILDINGS)) {
            
            while (rs.next()) {
                Building building = extractBuildingFromResultSet(rs);
                buildings.add(building);
            }
        }
        return buildings;
    }

    /**
     * Get a single building by ID
     */
    public Building getBuildingById(int buildingId) throws SQLException {
        Building building = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_BUILDING_BY_ID)) {
            
            stmt.setInt(1, buildingId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    building = extractBuildingFromResultSet(rs);
                }
            }
        }
        return building;
    }

    /**
     * Add a new building to the database
     */
    public boolean addBuilding(Building building) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_BUILDING, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, building.getName());
            stmt.setString(2, building.getCode());
            stmt.setString(3, building.getLocation());
            stmt.setInt(4, building.getFloorCount());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    building.setId(generatedKeys.getInt(1));
                }
            }
            return true;
        }
    }

    /**
     * Update an existing building
     */
    public boolean updateBuilding(Building building) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_BUILDING)) {
            
            stmt.setString(1, building.getName());
            stmt.setString(2, building.getCode());
            stmt.setString(3, building.getLocation());
            stmt.setInt(4, building.getFloorCount());
            stmt.setInt(5, building.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete a building (only if not in use by rooms)
     */
    public boolean deleteBuilding(int buildingId) throws SQLException {
        // First check if building has any rooms
        if (isBuildingInUse(buildingId)) {
            return false;
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_BUILDING)) {
            
            stmt.setInt(1, buildingId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Check if a building has any rooms assigned to it
     */
    public boolean isBuildingInUse(int buildingId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(CHECK_BUILDING_USAGE)) {
            
            stmt.setInt(1, buildingId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Helper method to extract Building object from ResultSet
     */
    private Building extractBuildingFromResultSet(ResultSet rs) throws SQLException {
        Building building = new Building();
        building.setId(rs.getInt("building_id"));
        building.setName(rs.getString("name"));
        building.setCode(rs.getString("code"));
        building.setLocation(rs.getString("location"));
        building.setFloorCount(rs.getInt("floor_count"));
        building.setCreatedAt(rs.getTimestamp("created_at"));
        return building;
    }
    
    public List<Building> searchBuildings(String query) throws SQLException {
        List<Building> buildings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM buildings b " +
                    "WHERE 1=1");

        // Add search conditions if query is provided
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (b.name LIKE ? OR b.code LIKE ? OR b.location LIKE ? OR b.floor_count LIKE ? OR b.created_at LIKE ?)");
        };
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Set search query parameters
            if (query != null && !query.trim().isEmpty()) {
                String searchParam = "%" + query + "%";
                stmt.setString(paramIndex++, searchParam);
                stmt.setString(paramIndex++, searchParam);
                stmt.setString(paramIndex++, searchParam);
                stmt.setString(paramIndex++, searchParam);
                stmt.setString(paramIndex++, searchParam);
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Building bdg = new Building();
                bdg.setId(rs.getInt("building_id"));
                bdg.setName(rs.getString("name"));
                bdg.setCode(rs.getString("code"));
                bdg.setFloorCount(rs.getInt("floor_count"));
                bdg.setLocation(rs.getString("location"));
                bdg.setCreatedAt(rs.getTimestamp("created_at"));
                buildings.add(bdg);
            }
        }
        return buildings;
    }
}