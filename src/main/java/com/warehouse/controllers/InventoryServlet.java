package com.warehouse.controllers;

import com.warehouse.dao.InventoryDAO;
import com.warehouse.dao.ProductDAO;
import com.warehouse.models.Inventory;
import com.warehouse.models.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/Inventory")
public class InventoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            InventoryDAO dao = new InventoryDAO();
            ProductDAO productDAO = new ProductDAO();
            List<Product> productList = productDAO.getAll();
            List<Product> lowStockProducts = productDAO.getLowStockProducts();
            List<Inventory> inventoryList = dao.getAllInventory();

            Map<String, Integer> stockLevels = new HashMap<>();

            for (Inventory inv : inventoryList) {
                stockLevels.merge(inv.getProductName(), inv.getQuantity(), Integer::sum);
            }

            request.setAttribute("stockLevels", stockLevels);
            request.setAttribute("reorderList", lowStockProducts);
            request.setAttribute("inventoryList", inventoryList);
            request.getRequestDispatcher("viewInventory.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error retrieving inventory", e);
        }
    }
}
