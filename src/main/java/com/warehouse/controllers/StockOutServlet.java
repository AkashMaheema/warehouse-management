package com.warehouse.controllers;

import com.google.gson.Gson;
import com.warehouse.dao.*;
import com.warehouse.models.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@WebServlet("/StockOut")
public class StockOutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null) {
                showStockOutList(request, response);
            } else {
                switch (action) {
                    case "new":
                        showNewForm(request, response);
                        break;
                    case "view":
                        viewStockOut(request, response);
                        break;
                    case "pending":
                        showPendingApprovals(request, response);
                        break;
                    case "get":
                        getStockOutForEdit(request, response);
                        break;
                    case "locations":
                        showItemLocations(request, response);
                        break;
                    default:
                        showStockOutList(request, response);
                        break;
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        System.out.println("action : " +action);

        try {
            if (action == null) {
                throw new ServletException("Invalid action specified");
            }

            switch (action) {
                case "create":
                    handleCreate(request, response, result);
                    break;
                case "update":
                    handleUpdate(request, response, result);
                    break;
                case "approve":
                    handleApprove(request, response, result);
                    break;
                case "reject":
                    handleReject(request, response, result);
                    break;
                case "dispatch":
                    handleDispatch(request, response, result);
                    break;
                default:
                    throw new ServletException("Invalid action specified");
            }
        } catch (Exception e) {
            handleError(response, result, e);
        } finally {
            out.print(new Gson().toJson(result));
            out.flush();
        }
    }

    private void showStockOutList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        StockOutDAO dao = new StockOutDAO();
        List<StockOut> stockOuts = dao.getStockOuts();

        request.setAttribute("stockOutList", stockOuts);
        request.getRequestDispatcher("manageOrders.jsp").forward(request, response);
    }

    private void showPendingApprovals(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        StockOutDAO dao = new StockOutDAO();
        List<StockOut> pendingRequests = dao.getStockOutsByStatus("pending");

        // Check stock availability for each request
        Map<Integer, String> availabilityMessages = new HashMap<>();
        InventoryDAO inventoryDAO = new InventoryDAO();

        for (StockOut stockOutRequest : pendingRequests) {
            StringBuilder message = new StringBuilder();
            for (StockOutItem item : stockOutRequest.getItems()) {
                int availableQty = inventoryDAO.getAvailableQuantity(item.getProductId());
                if (availableQty < item.getQuantity()) {
                    message.append(String.format("Product %s: Requested %d, Available %d. ",
                            item.getProductName(), item.getQuantity(), availableQty));
                }
            }
            if (message.length() > 0) {
                availabilityMessages.put(stockOutRequest.getId(), message.toString());
            }
        }

        // Get all products and customers for the edit modal
        ProductDAO productDAO = new ProductDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        request.setAttribute("stockOutList", pendingRequests);
        request.setAttribute("availabilityMessages", availabilityMessages);
        request.setAttribute("productList", productDAO.getAll());
        request.setAttribute("customerList", customerDAO.getAll());

        request.getRequestDispatcher("pendingApprovals.jsp").forward(request, response);
    }

    private void getStockOutForEdit(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int stockOutId = Integer.parseInt(request.getParameter("id"));
        StockOutDAO dao = new StockOutDAO();
        StockOut stockOut = dao.getStockOutById(stockOutId);

        // Check stock availability for each item
        InventoryDAO inventoryDAO = new InventoryDAO();
        Map<Integer, Integer> availableQuantities = new HashMap<>();
        for (StockOutItem item : stockOut.getItems()) {
            availableQuantities.put(item.getProductId(),
                    inventoryDAO.getAvailableQuantity(item.getProductId()));
        }

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("stockOut", stockOut);
        responseData.put("availableQuantities", availableQuantities);

        response.setContentType("application/json");
        response.getWriter().print(new Gson().toJson(responseData));
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        WeightDAO weightDAO = new WeightDAO();
        InventoryDAO inventoryDAO = new InventoryDAO();

        List<Product> products = productDAO.getAll();
        List<Inventory> inventoryItems = inventoryDAO.getAllInventory();

        request.setAttribute("productList", products);
        request.setAttribute("weightList", weightDAO.getAll());
        request.setAttribute("customerList", customerDAO.getAll());
        request.setAttribute("inventoryList", inventoryItems);

        Gson gson = new Gson();
        request.setAttribute("productListJson", gson.toJson(products));
        request.setAttribute("weightListJson", gson.toJson(weightDAO.getAll()));
        request.setAttribute("inventoryListJson", gson.toJson(inventoryItems));

        request.getRequestDispatcher("stock_out.jsp").forward(request, response);
    }

    private void viewStockOut(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int stockOutId = Integer.parseInt(request.getParameter("id"));
        String disableUpdate = request.getParameter("disableUpdate");

        StockOutDAO dao = new StockOutDAO();
        StockOut stockOut = dao.getStockOutById(stockOutId);

        if (stockOut != null) {
            ProductDAO productDAO = new ProductDAO();
            CustomerDAO customerDAO = new CustomerDAO();
            InventoryDAO inventoryDAO = new InventoryDAO();
            WeightDAO weightDAO = new WeightDAO();

            // Create lookup maps
            Map<Integer, Product> productMap = new HashMap<>();
            Map<Integer, List<Inventory>> inventoryMap = new HashMap<>();
            Map<Integer, Weight> weightMap = new HashMap<>();

            // Populate maps
            for (Product p : productDAO.getAll()) {
                productMap.put(p.getProductId(), p);
            }
            for (Inventory item : inventoryDAO.getAllInventory()) {
                inventoryMap.computeIfAbsent(item.getProductId(), k -> new ArrayList<>()).add(item);
            }
            for (Weight w : weightDAO.getAll()) {
                weightMap.put(w.getWeightId(), w);
            }

            request.setAttribute("productMap", productMap);
            request.setAttribute("inventoryMap", inventoryMap);
            request.setAttribute("stockOut", stockOut);
            request.setAttribute("customerList", customerDAO.getAll());
            request.setAttribute("disableUpdate", disableUpdate);
            request.setAttribute("weightMap", weightMap);

            request.getRequestDispatcher("stock_out_view.jsp").forward(request, response);
        } else {
            response.sendRedirect("StockOut");
        }
    }

    private void showItemLocations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int stockOutId = Integer.parseInt(request.getParameter("id"));
        String productIdStr = request.getParameter("productId");
        int productId = Integer.parseInt(productIdStr);

        StockOutDAO dao = new StockOutDAO();
        StockOut stockOut = dao.getStockOutById(stockOutId);

        if (stockOut != null) {
            InventoryDAO inventoryDAO = new InventoryDAO();
            List<Inventory> inventoryItems = inventoryDAO.getInventoryByProduct(productId);

            request.setAttribute("stockOut", stockOut);
            request.setAttribute("inventoryItems", inventoryItems);
            request.setAttribute("productId", productId);

            request.getRequestDispatcher("stock_out_locations.jsp").forward(request, response);
        } else {
            response.sendRedirect("StockOut");
        }
    }


    private void handleCreate(HttpServletRequest request, HttpServletResponse response,
                              Map<String, Object> result) throws Exception {
        // Get basic form data
        String customerIdStr = request.getParameter("customerId");
        String dispatchDateStr = request.getParameter("dispatch_date");

        if (customerIdStr == null || dispatchDateStr == null) {
            throw new ServletException("Missing required fields");
        }

        int customerId = Integer.parseInt(customerIdStr);
        Date dispatchDate = Date.valueOf(dispatchDateStr);
        int userId = 0; // TODO: Get from session

        Integer orderId = null;
        if (request.getParameter("orderId") != null && !request.getParameter("orderId").isEmpty()) {
            orderId = Integer.parseInt(request.getParameter("orderId"));
        }

        // Get item arrays
        String[] productIds = request.getParameterValues("productId");
        String[] weightIds = request.getParameterValues("weightId");
        String[] quantities = request.getParameterValues("quantity");
        String[] expireDates = request.getParameterValues("expire_date");

        // Validate all required fields
        if (productIds == null || weightIds == null || quantities == null || expireDates == null ||
                productIds.length == 0 || productIds.length != weightIds.length ||
                productIds.length != quantities.length || productIds.length != expireDates.length) {
            throw new ServletException("Invalid item data submitted");
        }

        // Check stock availability
        InventoryDAO inventoryDAO = new InventoryDAO();
        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);

            if (inventoryDAO.getAvailableQuantity(productId) < quantity) {
                throw new ServletException("Not enough stock available for product ID: " + productId);
            }
        }

        // Process the stock out
        StockOutDAO stockOutDAO = new StockOutDAO();
        int stockOutId = stockOutDAO.insertMainStockOut(customerId, dispatchDate, userId, orderId, "pending");

        for (int i = 0; i < productIds.length; i++) {
            stockOutDAO.insertStockOutItem(
                    stockOutId,
                    Integer.parseInt(productIds[i]),
                    Integer.parseInt(quantities[i]),
                    Date.valueOf(expireDates[i])
            );
        }

        result.put("success", true);
        result.put("stockOutId", stockOutId);
        result.put("message", "Stock out request created successfully");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response,
                              Map<String, Object> result) throws Exception {
        int stockOutId = Integer.parseInt(request.getParameter("stockOutId"));
        StockOutDAO stockOutDAO = new StockOutDAO();

        // First delete all existing items
        stockOutDAO.deleteStockOutItems(stockOutId);

        // Then add the updated items
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] expireDates = request.getParameterValues("expire_date");



        // Check stock availability before updating
        InventoryDAO inventoryDAO = new InventoryDAO();
        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);
            System.out.println("qty:"+quantities[i]);

            if (inventoryDAO.getAvailableQuantity(productId) < quantity) {
                throw new ServletException("Not enough stock available for product ID: " + productId);
            }
        }

        for (int i = 0; i < productIds.length; i++) {
            stockOutDAO.insertStockOutItem(
                    stockOutId,
                    Integer.parseInt(productIds[i]),
                    Integer.parseInt(quantities[i]),
                    Date.valueOf(expireDates[i])
            );
        }

        // Update customer and dispatch date if changed
        String customerIdStr = request.getParameter("customerId");
        String dispatchDateStr = request.getParameter("dispatch_date");

        if (customerIdStr != null && dispatchDateStr != null) {
            int customerId = Integer.parseInt(customerIdStr);
            Date dispatchDate = Date.valueOf(dispatchDateStr);
            stockOutDAO.updateStockOutDetails(stockOutId, customerId, dispatchDate);
        }

        result.put("success", true);
        result.put("message", "Stock out request updated successfully");
        result.put("stockOutId", stockOutId);
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response,
                               Map<String, Object> result) throws Exception {
        int stockOutId = Integer.parseInt(request.getParameter("stockOutId"));
        StockOutDAO dao = new StockOutDAO();
        StockOut stockOut = dao.getStockOutById(stockOutId);

        // Check stock availability one more time
        InventoryDAO inventoryDAO = new InventoryDAO();
        for (StockOutItem item : stockOut.getItems()) {
            int availableQty = inventoryDAO.getAvailableQuantity(item.getProductId());
            if (availableQty < item.getQuantity()) {
                throw new ServletException(String.format(
                        "Cannot approve: Product %s has only %d available (requested %d)",
                        item.getProductName(), availableQty, item.getQuantity()));
            }
        }

        dao.updateStockOutStatus(stockOutId, "approved");
        result.put("success", true);
        result.put("message", "Stock out approved successfully");
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response,
                              Map<String, Object> result) throws Exception {
        int stockOutId = Integer.parseInt(request.getParameter("stockOutId"));
        StockOutDAO dao = new StockOutDAO();

        dao.updateStockOutStatus(stockOutId, "rejected");
        result.put("success", true);
        result.put("message", "Stock out rejected successfully");
    }

    private void handleDispatch(HttpServletRequest request, HttpServletResponse response,
                                Map<String, Object> result) throws Exception {
        int stockOutId = Integer.parseInt(request.getParameter("stockOutId"));
        StockOutDAO dao = new StockOutDAO();

        try {
            // Update inventory and space capacity
            boolean success = dao.updateInventoryOnDispatch(stockOutId);

            if (success) {
                // Update status
                dao.updateStockOutStatus(stockOutId, "dispatched");

                result.put("success", true);
                result.put("message", "Stock out dispatched successfully");
            } else {
                result.put("success", false);
                result.put("message", "Dispatch failed due to insufficient stock");
            }
        } catch (SQLException e) {
            result.put("success", false);
            result.put("message", "Dispatch failed: " + e.getMessage());
        }
    }

    private void handleError(HttpServletResponse response, Map<String, Object> result, Exception e) {
        if (e instanceof NumberFormatException) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.put("message", "Invalid number format: " + e.getMessage());
        } else if (e instanceof IllegalArgumentException) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.put("message", "Invalid date format: " + e.getMessage());
        } else if (e instanceof SQLException) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.put("message", "Database error: " + e.getMessage());
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.put("message", e.getMessage());
        }
        result.put("success", false);
    }
}