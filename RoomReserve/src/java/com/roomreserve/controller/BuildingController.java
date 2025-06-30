package com.roomreserve.controller;

import com.roomreserve.dao.BuildingDAO;
import com.roomreserve.dao.DepartmentDAO;
import com.roomreserve.model.Building;
import com.roomreserve.model.Department;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BuildingController", urlPatterns = {"/admin/BuildingController"})
public class BuildingController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BuildingDAO buildingDAO;

    public void init() {
        buildingDAO = new BuildingDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createBuilding(request, response);
                    break;
                case "edit":
                    updateBuilding(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "delete":
                    deleteBuilding(request, response);
                    break;
                default:
                    response.sendRedirect("building_management.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void createBuilding(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Building building = new Building();
        building.setName(request.getParameter("name"));
        building.setCode(request.getParameter("code"));
        building.setFloorCount(Integer.parseInt(request.getParameter("floor")));
        building.setLocation(request.getParameter("location"));
        
        try {
            buildingDAO.addBuilding(building);
            session.setAttribute("message", "Building added successfully");
            response.sendRedirect("building_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error adding building");
            request.getRequestDispatcher("building_management.jsp?action=create").forward(request, response);
        }
    }

    private void updateBuilding(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int buildingId = Integer.parseInt(request.getParameter("buildingId"));
        Building building = new Building();
        building.setId(buildingId);
        building.setName(request.getParameter("name"));
        building.setCode(request.getParameter("code"));
        building.setFloorCount(Integer.parseInt(request.getParameter("floor")));
        building.setLocation(request.getParameter("location"));
        
        try {
            buildingDAO.updateBuilding(building);
            session.setAttribute("message", "Building updated successfully");
            response.sendRedirect("building_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating building");
            request.getRequestDispatcher("building_management.jsp?action=edit&id=" + buildingId).forward(request, response);
        }
    }

    private void deleteBuilding(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int buildingId = Integer.parseInt(request.getParameter("id"));
        
        try {
            buildingDAO.deleteBuilding(buildingId);
            session.setAttribute("message", "Building deleted successfully");
            response.sendRedirect("building_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting Building");
            request.getRequestDispatcher("building_management.jsp").forward(request, response);
        }
    }
}
