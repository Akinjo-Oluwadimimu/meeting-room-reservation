package com.roomreserve.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Department {
    private int id;
    private String name;
    private String code;
    private String description;
    private int headId; // user_id of department head
    private Timestamp createdAt;

    // Constructors, Getters and Setters
    public Department() {}

    public Department(int id, String name, String code, String description, int headId, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.code = code;
        this.description = description;
        this.headId = headId;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getHeadId() {
        return headId;
    }

    public void setHeadId(int headId) {
        this.headId = headId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}