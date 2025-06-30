package com.roomreserve.model;

public class Amenity {
    private int id;
    private String name;
    private String description;
    private String iconClass;

    public Amenity() {
    }

    public Amenity(int id, String name, String description, String iconClass) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.iconClass = iconClass;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIconClass() {
        return iconClass;
    }

    public void setIconClass(String iconClass) {
        this.iconClass = iconClass;
    }
}