package com.roomreserve.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Building {
    private int id;
    private String name;
    private String code;
    private String location;
    private int floorCount;
    private Timestamp createdAt;

    public Building() {
    }

    public Building(int id, String name, String code, String location, int floorCount, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.code = code;
        this.location = location;
        this.floorCount = floorCount;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getFloorCount() {
        return floorCount;
    }

    public void setFloorCount(int floorCount) {
        this.floorCount = floorCount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    
}