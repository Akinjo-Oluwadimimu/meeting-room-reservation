package com.roomreserve.controller;

import com.roomreserve.dao.DepartmentDAO;
import com.roomreserve.model.Department;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DepartmentController", urlPatterns = {"/admin/DepartmentController"})
public class DepartmentController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DepartmentDAO departmentDAO;

    public void init() {
        departmentDAO = new DepartmentDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createDepartment(request, response);
                    break;
                case "edit":
                    updateDepartment(request, response);
                    break;
                case "setHead":
                    setDepartmentHead(request, response);
                    break;
                case "addMember":
                    addDepartmentMember(request, response);
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
                    deleteDepartment(request, response);
                    break;
                case "removeMember":
                    removeDepartmentMember(request, response);
                    break;
                default:
                    response.sendRedirect("department_management.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void createDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Department department = new Department();
        department.setName(request.getParameter("name"));
        department.setCode(request.getParameter("code"));
        department.setDescription(request.getParameter("description"));
        
        try {
            departmentDAO.createDepartment(department);
            session.setAttribute("message", "Department created successfully");
            response.sendRedirect("department_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error creating department");
            request.getRequestDispatcher("department_management.jsp?action=create").forward(request, response);
        }
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        Department department = new Department();
        department.setId(departmentId);
        department.setName(request.getParameter("name"));
        department.setCode(request.getParameter("code"));
        department.setDescription(request.getParameter("description"));
        
        try {
            departmentDAO.updateDepartment(department);
            session.setAttribute("message", "Department updated successfully");
            response.sendRedirect("department_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating department");
            request.getRequestDispatcher("department_management.jsp?action=edit&id=" + departmentId).forward(request, response);
        }
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int departmentId = Integer.parseInt(request.getParameter("id"));
        
        try {
            departmentDAO.deleteDepartment(departmentId);
            session.setAttribute("message", "Department deleted successfully");
            response.sendRedirect("department_management.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting department");
            request.getRequestDispatcher("department_management.jsp").forward(request, response);
        }
    }

    private void setDepartmentHead(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        try {
            departmentDAO.setDepartmentHead(departmentId, userId);
            session.setAttribute("message", "Department head set successfully");
            response.sendRedirect("department_management.jsp?action=manageMembers&id=" + departmentId);
        } catch (Exception e) {
            request.setAttribute("error", "Error setting department head");
            request.getRequestDispatcher("department_management.jsp?action=manageMembers&id=" + departmentId).forward(request, response);
        }
    }

    private void addDepartmentMember(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        boolean isHead = "on".equals(request.getParameter("isHead"));
        
        try {
            departmentDAO.addDepartmentMember(departmentId, userId, isHead);
            if (isHead) {
                departmentDAO.setDepartmentHead(departmentId, userId);
            }
            session.setAttribute("message", "Department member added successfully");
            response.sendRedirect("department_management.jsp?action=manageMembers&id=" + departmentId);
        } catch (Exception e) {
            request.setAttribute("error", "Error adding member to department");
            request.getRequestDispatcher("department_management.jsp?action=manageMembers&id=" + departmentId).forward(request, response);
        }
    }

    private void removeDepartmentMember(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        try {
            departmentDAO.removeDepartmentMember(departmentId, userId);
            int headId = departmentDAO.getDepartmentHead(departmentId);
            if (headId == userId) {
                departmentDAO.removeDepartmentHead(departmentId);
            }
            session.setAttribute("message", "Department member removed successfully");
            response.sendRedirect("department_management.jsp?action=manageMembers&id=" + departmentId);
        } catch (Exception e) {
            request.setAttribute("error", "Error removing member from department");
            request.getRequestDispatcher("department_management.jsp?action=manageMembers&id=" + departmentId).forward(request, response);
        }
    }
}
