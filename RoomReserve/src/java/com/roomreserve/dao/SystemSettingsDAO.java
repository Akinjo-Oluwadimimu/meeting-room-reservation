/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.roomreserve.dao;


import com.roomreserve.model.SystemSetting;
import com.roomreserve.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SystemSettingsDAO  {
    private Connection connection;

    public SystemSettingsDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public List<SystemSetting> getAllSettings() {
        List<SystemSetting> settings = new ArrayList<>();
        String sql = "SELECT * FROM system_settings ORDER BY setting_key";

        try (Statement statement = connection.createStatement();
             ResultSet rs = statement.executeQuery(sql)) {

            while (rs.next()) {
                settings.add(mapResultSetToSetting(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return settings;
    }

    public SystemSetting getSettingByKey(String key) {
        String sql = "SELECT * FROM system_settings WHERE setting_key = ?";
        SystemSetting setting = null;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, key);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                setting = mapResultSetToSetting(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return setting;
    }

    public boolean updateSetting(String key, String value) {
        String sql = "UPDATE system_settings SET setting_value = ?, updated_at = CURRENT_TIMESTAMP WHERE setting_key = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, value);
            statement.setString(2, key);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createSetting(SystemSetting setting) {
        String sql = "INSERT INTO system_settings (setting_key, setting_value, setting_description, is_editable) " +
                     "VALUES (?, ?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, setting.getKey());
            statement.setString(2, setting.getValue());
            statement.setString(3, setting.getDescription());
            statement.setBoolean(4, setting.isEditable());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSetting(String key) {
        String sql = "DELETE FROM system_settings WHERE setting_key = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, key);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private SystemSetting mapResultSetToSetting(ResultSet rs) throws SQLException {
        SystemSetting setting = new SystemSetting();
        setting.setSettingId(rs.getInt("setting_id"));
        setting.setKey(rs.getString("setting_key"));
        setting.setValue(rs.getString("setting_value"));
        setting.setDescription(rs.getString("setting_description"));
        setting.setEditable(rs.getBoolean("is_editable"));
        setting.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        setting.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return setting;
    }
}