package com.roomreserve.util;

import com.roomreserve.dao.SystemSettingsDAO;
import com.roomreserve.model.SystemSetting;
import java.sql.SQLException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class SettingsService {
    private final SystemSettingsDAO settingsDAO;
    private final Map<String, String> settingsCache;
    private final Map<String, SystemSetting> fullSettingsCache;

    public SettingsService() throws SQLException {
        this.settingsDAO = new SystemSettingsDAO();
        this.settingsCache = new ConcurrentHashMap<>();
        this.fullSettingsCache = new ConcurrentHashMap<>();
        loadCache();
    }

    public String getSetting(String key) {
        return settingsCache.get(key);
    }

    public String getSetting(String key, String defaultValue) {
        return settingsCache.getOrDefault(key, defaultValue);
    }

    public int getIntSetting(String key, int defaultValue) {
        try {
            return Integer.parseInt(settingsCache.get(key));
        } catch (NumberFormatException | NullPointerException e) {
            return defaultValue;
        }
    }

    public boolean getBooleanSetting(String key, boolean defaultValue) {
        String value = settingsCache.get(key);
        if (value == null) return defaultValue;
        return Boolean.parseBoolean(value) || "1".equals(value) || "true".equalsIgnoreCase(value);
    }

    public List<SystemSetting> getAllSettings() {
        return new ArrayList<>(fullSettingsCache.values());
    }

    public Map<String, String> getAllSettingsAsMap() {
        return new HashMap<>(settingsCache);
    }

    public boolean updateSetting(String key, String value) {
        boolean success = settingsDAO.updateSetting(key, value);
        if (success) {
            refreshCache();
        }
        return success;
    }

    public void refreshCache() {
        List<SystemSetting> settings = settingsDAO.getAllSettings();
        settingsCache.clear();
        fullSettingsCache.clear();
        
        for (SystemSetting setting : settings) {
            settingsCache.put(setting.getKey(), setting.getValue());
            fullSettingsCache.put(setting.getKey(), setting);
        }
    }

    private void loadCache() {
        refreshCache();
    }
}