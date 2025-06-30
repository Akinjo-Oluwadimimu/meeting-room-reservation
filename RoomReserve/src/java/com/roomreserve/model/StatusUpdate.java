/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.roomreserve.model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class StatusUpdate {
    private int updateId;
    private int reservationId;
    private int managerId;
    private String managerName;
    private String oldStatus;
    private String newStatus;
    private String comments;
    private LocalDateTime updateTime;

    public StatusUpdate() {
    }

    public StatusUpdate(int updateId, int reservationId, int managerId, String managerName, String oldStatus, String newStatus, String comments, LocalDateTime updateTime) {
        this.updateId = updateId;
        this.reservationId = reservationId;
        this.managerId = managerId;
        this.managerName = managerName;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.comments = comments;
        this.updateTime = updateTime;
    }

    public int getUpdateId() {
        return updateId;
    }

    public void setUpdateId(int updateId) {
        this.updateId = updateId;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }
    
    public Date getTimeUpdated() {
        return Date.from(updateTime.atZone(ZoneId.systemDefault()).toInstant());
    }
    
}