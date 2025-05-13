package com.warehouse.controllers;

import com.warehouse.dao.InventoryDAO;
import com.warehouse.models.Inventory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/Inventory")
public class InventoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            InventoryDAO dao = new InventoryDAO();
            List<Inventory> list = dao.getAllInventory();
            request.setAttribute("inventoryList", list);
            request.getRequestDispatcher("viewInventory.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error retrieving inventory", e);
        }
    }
}
