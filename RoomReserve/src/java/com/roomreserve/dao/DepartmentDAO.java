package com.roomreserve.dao;

import com.roomreserve.model.Department;
import com.roomreserve.model.DepartmentMember;
import com.roomreserve.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {
    // Create new department
    public boolean createDepartment(Department department) throws SQLException {
        String sql = "INSERT INTO departments (name, code, description) VALUES (?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, department.getName());
            stmt.setString(2, department.getCode());
            stmt.setString(3, department.getDescription());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    department.setId(generatedKeys.getInt(1));
                }
            }
            return true;
        }
    }
    
    // Get all departments
    public List<Department> getAllDepartments() throws SQLException {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT d.*, u.username as head_name FROM departments d " +
                     "LEFT JOIN users u ON d.head_id = u.user_id";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("department_id"));
                dept.setName(rs.getString("name"));
                dept.setCode(rs.getString("code"));
                dept.setDescription(rs.getString("description"));
                dept.setHeadId(rs.getInt("head_id"));
                dept.setCreatedAt(rs.getTimestamp("created_at"));
                departments.add(dept);
            }
        }
        return departments;
    }
    
    // Get department by ID
    public Department getDepartmentById(int departmentId) throws SQLException {
        String sql = "SELECT * FROM departments WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, departmentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("department_id"));
                dept.setName(rs.getString("name"));
                dept.setCode(rs.getString("code"));
                dept.setDescription(rs.getString("description"));
                dept.setHeadId(rs.getInt("head_id"));
                dept.setCreatedAt(rs.getTimestamp("created_at"));
                return dept;
            }
        }
        return null;
    }
    
    // Update department
    public boolean updateDepartment(Department department) throws SQLException {
        String sql = "UPDATE departments SET name = ?, code = ?, description = ? " +
                     "WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, department.getName());
            stmt.setString(2, department.getCode());
            stmt.setString(3, department.getDescription());
            stmt.setInt(4, department.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
       
    // Delete department
    public boolean deleteDepartment(int departmentId) throws SQLException {
        String sql = "DELETE FROM departments WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, departmentId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Add member to department
    public boolean addDepartmentMember(int departmentId, int userId, boolean isHead) throws SQLException {
        String sql = "INSERT INTO department_members (department_id, user_id, is_head) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE is_head = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, departmentId);
            stmt.setInt(2, userId);
            stmt.setBoolean(3, isHead);
            stmt.setBoolean(4, isHead);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Remove member from department
    public boolean removeDepartmentMember(int departmentId, int userId) throws SQLException {
        String sql = "DELETE FROM department_members WHERE department_id = ? AND user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, departmentId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Get all members of a department
    public List<DepartmentMember> getDepartmentMembers(int departmentId) throws SQLException {
        List<DepartmentMember> members = new ArrayList<>();
        String sql = "SELECT dm.*, u.username, u.email FROM department_members dm " +
                     "JOIN users u ON dm.user_id = u.user_id " +
                     "WHERE dm.department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, departmentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                DepartmentMember member = new DepartmentMember();
                member.setDepartmentId(rs.getInt("department_id"));
                member.setUserId(rs.getInt("user_id"));
                member.setIsHead(rs.getBoolean("is_head"));
                member.setUserName(rs.getString("username"));
                member.setUserEmail(rs.getString("email"));
                members.add(member);
            }
        }
        return members;
    }
    
    // Set department head
    public boolean setDepartmentHead(int departmentId, int userId) throws SQLException {
        // First remove any existing head for this department
        String clearSql = "UPDATE department_members SET is_head = FALSE WHERE department_id = ?";
        String setSql = "INSERT INTO department_members (department_id, user_id, is_head) VALUES (?, ?, TRUE) " +
                        "ON DUPLICATE KEY UPDATE is_head = TRUE";
        String updateDeptSql = "UPDATE departments SET head_id = ? WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement clearStmt = conn.prepareStatement(clearSql);
                 PreparedStatement setStmt = conn.prepareStatement(setSql);
                 PreparedStatement updateDeptStmt = conn.prepareStatement(updateDeptSql)) {
                
                // Clear existing heads
                clearStmt.setInt(1, departmentId);
                clearStmt.executeUpdate();
                
                // Set new head in members table
                setStmt.setInt(1, departmentId);
                setStmt.setInt(2, userId);
                setStmt.executeUpdate();
                
                // Update department head reference
                updateDeptStmt.setInt(1, userId);
                updateDeptStmt.setInt(2, departmentId);
                updateDeptStmt.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
    
    // Get department head
    public int getDepartmentHead(int departmentId) throws SQLException {
        // First remove any existing head for this department
        String sql = "SELECT head_id FROM departments WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, departmentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int headId = rs.getInt("head_id");
                return headId;
            }
        }
        return 0;
    }
    
    // Get department head
    public boolean removeDepartmentHead(int departmentId) throws SQLException {
        // First remove any existing head for this department
        String sql = "UPDATE departments SET head_id = ? WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setNull(1, Types.INTEGER);
            stmt.setInt(2, departmentId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public List<Department> searchDepartments(String query) throws SQLException {
        List<Department> departments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT d.*, u.username as head_name FROM departments d " +
                    "LEFT JOIN users u ON d.head_id = u.user_id " +
                    "WHERE 1=1");

        // Add search conditions if query is provided
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (d.name LIKE ? OR d.code LIKE ? OR d.created_at LIKE ? OR u.first_name LIKE ? OR u.last_name LIKE ?)");
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
                Department dept = new Department();
                dept.setId(rs.getInt("department_id"));
                dept.setName(rs.getString("name"));
                dept.setCode(rs.getString("code"));
                dept.setDescription(rs.getString("description"));
                dept.setHeadId(rs.getInt("head_id"));
                dept.setCreatedAt(rs.getTimestamp("created_at"));
                departments.add(dept);
            }
        }
        return departments;
    }
}