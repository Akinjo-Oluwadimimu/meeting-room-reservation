package com.roomreserve.model;

public class DepartmentMember {
    private int departmentId;
    private int userId;
    private boolean isHead;
    private String userName; // Additional for display
    private String userEmail; // Additional for display
    
    // Getters and Setters
    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public boolean getIsHead() { return isHead; }
    public void setIsHead(boolean isHead) { this.isHead = isHead; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
}