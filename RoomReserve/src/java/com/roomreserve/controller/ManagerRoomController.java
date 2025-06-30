package com.roomreserve.controller;

import com.roomreserve.dao.RoomDAO;
import com.roomreserve.dao.RoomImageDAO;
import com.roomreserve.model.Amenity;
import com.roomreserve.model.Building;
import com.roomreserve.model.Room;
import com.roomreserve.model.RoomImage;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet(name = "ManagerRoomController", urlPatterns = {"/manager/RoomController"})
public class ManagerRoomController extends HttpServlet {
    private RoomDAO roomDAO;
    private RoomImageDAO roomImageDAO;
    
    @Override
    public void init() {
        roomDAO = new RoomDAO();
        roomImageDAO = new RoomImageDAO();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "create":
                    addRoom(request, response);
                    break;
                case "edit":
                    updateRoom(request, response);
                    break;
                case "delete":
                    deleteRoom(request, response);
                    break;
                case "toggleStatus":
                    toggleStatus(request, response);
                    break;
                default:
                    //listRooms(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        Room room = extractRoomFromRequest(request);
        int roomId = roomDAO.addRoom(room);
        
        // Handle image uploads if any
        handleImageUploads(request, roomId);
        session.setAttribute("message", "Room added successfully");
        response.sendRedirect("room_management.jsp");
    }
    
    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        Room room = extractRoomFromRequest(request);
        room.setId(roomId);
        roomDAO.updateRoom(room);
        // Handle image uploads if any
        handleImageUploads(request, roomId);
        session.setAttribute("message", "Room updated successfully");
        response.sendRedirect("room_management.jsp");
    }
    
    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        int roomId = Integer.parseInt(request.getParameter("id"));
        // 1. First delete all images (and their physical files)
        List<RoomImage> images = roomImageDAO.getImagesByRoom(roomId);
        for (RoomImage image : images) {
            deleteImageFile(image.getImageUrl(), request);
        }
        roomImageDAO.deleteImagesByRoom(roomId);
        
        roomDAO.deleteRoomAmenities(roomId);
        
        boolean deleted = roomDAO.deleteRoom(roomId);
        
        if (deleted) {
            session.setAttribute("message", "Room deleted successfully");
            response.sendRedirect("room_management.jsp?success=Room+deleted+successfully");
        } else {
            request.setAttribute("error", "Failed to delete room");
            request.getRequestDispatcher("room_management.jsp").forward(request, response);
        }
    }
    
    private void deleteImageFile(String imageUrl, HttpServletRequest request) {
        try {
            String realPath = request.getServletContext().getRealPath("");
            String filePath = realPath + imageUrl.replace(request.getContextPath(), "");
            File file = new File(filePath);
            if (file.exists()) {
                if (!file.delete()) {
                    System.err.println("Failed to delete image file: " + filePath);
                }
            }
        } catch (Exception e) {
            System.err.println("Error deleting image file: " + e.getMessage());
        }
    }
    
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        roomDAO.toggleRoomStatus(roomId);
        session.setAttribute("message", "Room status updated successfully");
        response.sendRedirect("room_management.jsp");
    }
    
    private Room extractRoomFromRequest(HttpServletRequest request) {
        Room room = new Room();
        room.setBuildingId(Integer.parseInt(request.getParameter("building_id")));
        room.setName(request.getParameter("name"));
        room.setRoomNumber(request.getParameter("room_number"));
        room.setFloor(Integer.parseInt(request.getParameter("floor")));
        room.setCapacity(Integer.parseInt(request.getParameter("capacity")));
        room.setRoomType(request.getParameter("room_type"));
        room.setDescription(request.getParameter("description"));
        room.setActive(request.getParameter("is_active") != null);
        
        // Get selected amenities
        String[] amenityIds = request.getParameterValues("amenities");
        if (amenityIds != null && amenityIds.length > 0) {
            List<Amenity> amenities = new ArrayList<>();
            for (String amenityId : amenityIds) {
                Amenity amenity = new Amenity();
                amenity.setId(Integer.parseInt(amenityId));
                amenities.add(amenity);
            }
            room.setAmenities(amenities);
        }
        
        return room;
    }

    private void handleImageUploads(HttpServletRequest request, int roomId) 
            throws ServletException, IOException, SQLException {
        // Configure upload settings
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // Process each file part
        for (Part part : request.getParts()) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + System.currentTimeMillis() + 
                                 getFileExtension(part.getSubmittedFileName());
                String filePath = uploadPath + File.separator + fileName;
                part.write(filePath);

                // Save to database
                String imageUrl = request.getContextPath() + "/uploads/" + fileName;
                RoomImage image = new RoomImage(roomId, imageUrl, "", false);
                int imageId = 0;
                try {
                    imageId = roomImageDAO.addImage(image);
                } catch (SQLException ex) {
                    Logger.getLogger(ManagerRoomController.class.getName()).log(Level.SEVERE, null, ex);
                }

                // Set first uploaded image as primary if none exists
                if (roomImageDAO.getPrimaryImage(roomId) == null) {
                    roomImageDAO.setAsPrimary(imageId, roomId);
                    roomDAO.setCoverImage(roomId, imageId);
                }
            }
        }
    }

    private String getFileExtension(String fileName) {
        return fileName.substring(fileName.lastIndexOf("."));
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        try {
            // Check if user is admin
            if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("manager")) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            if (action == null) {
                action = "list";
            }
            
            switch (action) {
                case "delete":
                    deleteRoom(request, response);
                    break;
                case "search":
                    searchRooms(request, response);
                    break;
                default:
                    doPost(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void searchRooms(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        String buildingId = request.getParameter("building_id");
        String roomType = request.getParameter("room_type");
        String minCapacity = request.getParameter("min_capacity");
        String maxCapacity = request.getParameter("max_capacity");
        String[] amenities = request.getParameterValues("amenities");
        
        List<Room> rooms = roomDAO.searchRooms(buildingId, roomType, minCapacity, maxCapacity, amenities);
        List<Building> buildings = roomDAO.getAllBuildings();
        List<Amenity> allAmenities = roomDAO.getAllAmenities();
        
        request.setAttribute("rooms", rooms);
        request.setAttribute("buildings", buildings);
        request.setAttribute("amenities", allAmenities);
        request.setAttribute("searchParams", request.getParameterMap());
        
        request.getRequestDispatcher("/manager/room_management.jsp").forward(request, response);
    }
}