package com.roomreserve.controller;

import com.google.gson.Gson;
import com.roomreserve.dao.RoomDAO;
import com.roomreserve.dao.RoomImageDAO;
import com.roomreserve.model.RoomImage;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "RoomImageController", urlPatterns = {"/admin/RoomImageController", "/manager/RoomImageController"})
public class RoomImageController extends HttpServlet {
    
    private RoomDAO roomDAO;
    private RoomImageDAO roomImageDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
        roomImageDAO = new RoomImageDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "upload":
                    uploadImage(request, response);
                    break;
                case "set-primary":
                    setPrimaryImage(request, response);
                    break;
                case "update-caption":
                    updateCaption(request, response);
                    break;
                case "reorder":
                    reorderImages(request, response);
                    break;
                case "delete":
                    deleteImage(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void uploadImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        Part filePart = request.getPart("image");
        String caption = request.getParameter("caption");

        // Save file to server
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String fileName = UUID.randomUUID().toString() + "_" + System.currentTimeMillis() + 
                         getFileExtension(filePart.getSubmittedFileName());
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // Save to database
        String imageUrl = request.getContextPath() + "/uploads/" + fileName;
        RoomImage image = new RoomImage(roomId, imageUrl, caption, false);
        roomImageDAO.addImage(image);

        response.setContentType("application/json");
        new Gson().toJson(image, response.getWriter());
    }

    private void setPrimaryImage(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        int imageId = Integer.parseInt(request.getParameter("imageId"));
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        
        // Set the selected image as primary
        roomImageDAO.setAsPrimary(imageId, roomId);
        roomDAO.setCoverImage(roomId, imageId);
        
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void updateCaption(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        int imageId = Integer.parseInt(request.getParameter("imageId"));
        String caption = request.getParameter("caption");
        
        roomImageDAO.updateCaption(imageId, caption);
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void reorderImages(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String[] imageIds = request.getParameterValues("imageIds[]");
        
        for (int i = 0; i < imageIds.length; i++) {
            roomImageDAO.updateImageOrder(Integer.parseInt(imageIds[i]), i);
        }
        
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void deleteImage(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        int imageId = Integer.parseInt(request.getParameter("imageId"));
        RoomImage image = roomImageDAO.getImageById(imageId);
        
        // Delete file from server
        String filePath = getServletContext().getRealPath("") + 
                         image.getImageUrl().replace(request.getContextPath(), "");
        new File(filePath).delete();
        
        // Delete from database
        roomImageDAO.deleteImage(imageId);
        
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private String getFileExtension(String fileName) {
        return fileName.substring(fileName.lastIndexOf("."));
    }
}