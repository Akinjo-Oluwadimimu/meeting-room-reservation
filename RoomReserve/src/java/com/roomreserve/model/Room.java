package com.roomreserve.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

public class Room {
    private int id;
    private int buildingId;
    private String name;
    private String roomNumber;
    private int floor;
    private int capacity;
    private String roomType; // "conference", "lecture", "seminar", "lab", "other"
    private String description;
    private boolean active;
    private boolean favorite;
    private Integer coverImageId;
    private Timestamp createdAt;
    private List<Amenity> amenities;
    private Building building;
    private List<RoomImage> images;
    private RoomImage coverImage;

    // Constructors
    public Room() {}

    public Room(int id, String name, int capacity, boolean active) {
        this.id = id;
        this.name = name;
        this.capacity = capacity;
        this.active = active;
    }

    public Room(int id, int buildingId, String name, String roomNumber, int floor, 
                int capacity, String roomType, String description, boolean active, 
                Timestamp createdAt) {
        this.id = id;
        this.buildingId = buildingId;
        this.name = name;
        this.roomNumber = roomNumber;
        this.floor = floor;
        this.capacity = capacity;
        this.roomType = roomType;
        this.description = description;
        this.active = active;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBuildingId() {
        return buildingId;
    }

    public void setBuildingId(int buildingId) {
        this.buildingId = buildingId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public int getFloor() {
        return floor;
    }

    public boolean isFavorite() {
        return favorite;
    }

    public void setFavorite(boolean favorite) {
        this.favorite = favorite;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<Amenity> getAmenities() {
        return amenities;
    }

    public void setAmenities(List<Amenity> amenities) {
        this.amenities = amenities;
    }

    public Building getBuilding() {
        return building;
    }

    public void setBuilding(Building building) {
        this.building = building;
    }

    public Integer getCoverImageId() {
        return coverImageId;
    }

    public void setCoverImageId(Integer coverImageId) {
        this.coverImageId = coverImageId;
    }

    public List<RoomImage> getImages() {
        return images;
    }

    public void setImages(List<RoomImage> images) {
        this.images = images;
    }

    public RoomImage getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(RoomImage coverImage) {
        this.coverImage = coverImage;
    }
    
    

    // Helper methods
    public String getFullLocation() {
        return building != null ? building.getName() + ", Floor " + floor : "Floor " + floor;
    }

    public boolean hasAmenity(String amenityName) {
        return amenities.stream()
                .anyMatch(a -> a.getName().equalsIgnoreCase(amenityName));
    }
}