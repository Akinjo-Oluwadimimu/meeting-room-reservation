/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.roomreserve.servlets;

import com.google.gson.Gson;
import com.roomreserve.dao.ReservationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/utilization")
public class UtilizationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String period = request.getParameter("period");
            
            // Your service call to get data based on period
            ReservationDAO reservationDAO = new ReservationDAO();
            List<Object[]> data = reservationDAO.getRoomUtilizationData(period);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Convert data to JSON
            String json = new Gson().toJson(data);
            response.getWriter().write(json);
        } catch (SQLException ex) {
            Logger.getLogger(UtilizationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}

