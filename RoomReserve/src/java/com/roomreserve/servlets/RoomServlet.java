package com.roomreserve.servlets;

import com.roomreserve.dao.RoomDAO;
import com.roomreserve.model.Amenity;
import com.roomreserve.model.Building;
import com.roomreserve.model.Room;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "RoomServlet", urlPatterns = {"/admin/rooms"})
public class RoomServlet extends HttpServlet {

    private RoomDAO roomDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        roomDAO = new RoomDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        try {
            // Check if user is admin
            if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("admin")) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            if (action == null) {
                action = "list";
            }
            
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteRoom(request, response);
                    break;
                case "search":
                    searchRooms(request, response);
                    break;
                default:
                    listRooms(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        try {
            // Check if user is admin
            if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("admin")) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            if (action == null) {
                action = "list";
            }
            
            switch (action) {
                case "insert":
                    insertRoom(request, response);
                    break;
                case "update":
                    updateRoom(request, response);
                    break;
                case "search":
                    searchRooms(request, response);
                    break;
                case "toggleStatus":
                    toggleStatus(request, response);
                    break;
                default:
                    listRooms(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void listRooms(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        List<Room> rooms = roomDAO.getAllRooms();
        List<Building> buildings = roomDAO.getAllBuildings();
        List<Amenity> amenities = roomDAO.getAllAmenities();
        
        request.setAttribute("rooms", rooms);
        request.setAttribute("buildings", buildings);
        request.setAttribute("amenities", amenities);
        
        request.getRequestDispatcher("/admin/rooms.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        List<Building> buildings = roomDAO.getAllBuildings();
        List<Amenity> amenities = roomDAO.getAllAmenities();
        
        request.setAttribute("buildings", buildings);
        request.setAttribute("amenities", amenities);
        
        request.getRequestDispatcher("/admin/room_form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        int roomId = Integer.parseInt(request.getParameter("id"));
        Room room = roomDAO.getRoomById(roomId);
        List<Building> buildings = roomDAO.getAllBuildings();
        List<Amenity> amenities = roomDAO.getAllAmenities();
        
        request.setAttribute("room", room);
        request.setAttribute("buildings", buildings);
        request.setAttribute("amenities", amenities);
        
        request.getRequestDispatcher("/admin/room_form.jsp").forward(request, response);
    }
    
    private void insertRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
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
        
        roomDAO.addRoom(room);
        response.sendRedirect("rooms");
    }
    
    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        Room room = new Room();
        room.setId(Integer.parseInt(request.getParameter("room_id")));
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
        
        roomDAO.updateRoom(room);
        response.sendRedirect("rooms");
    }
    
    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        int roomId = Integer.parseInt(request.getParameter("id"));
        roomDAO.deleteRoom(roomId);
        response.sendRedirect("rooms");
    }
    
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        roomDAO.toggleRoomStatus(roomId);
        response.sendRedirect("rooms");
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
        
        request.getRequestDispatcher("/admin/rooms.jsp").forward(request, response);
    }
}