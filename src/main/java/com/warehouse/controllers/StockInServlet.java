package com.warehouse.controllers;

import com.google.gson.Gson;
import com.warehouse.dao.CategoryDAO;
import com.warehouse.dao.ProductDAO;
import com.warehouse.dao.SupplierDAO;
import com.warehouse.dao.StockInDAO;
import com.warehouse.dao.WeightDAO;
import com.warehouse.models.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/StockIn")
public class StockInServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                // Show new stock form
                showNewForm(request, response);
            } else if ("view".equals(action)) {
                viewStock(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        StockInDAO dao = new StockInDAO();
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        WeightDAO weightDAO = new WeightDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        List<Product> products = productDAO.getAll();
        List<Category> categories = categoryDAO.getAll();
        List<Weight> weights = weightDAO.getAll();
        List<Supplier> suppliers = supplierDAO.getAll();

        request.setAttribute("productList", products);
        request.setAttribute("categoryList", categories);
        request.setAttribute("weightList", weights);
        request.setAttribute("zoneList", dao.getZoneList());
        request.setAttribute("rackList", dao.getRackList());
        request.setAttribute("supplierList", suppliers);

        Gson gson = new Gson();
        request.setAttribute("productListJson", gson.toJson(products));
        request.setAttribute("weightListJson", gson.toJson(weights));

        request.getRequestDispatcher("stock_in.jsp").forward(request, response);
    }

    private void viewStock(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int stockInId = Integer.parseInt(request.getParameter("id"));
        StockInDAO dao = new StockInDAO();
        StockIn stockIn = dao.getStockInById(stockInId);

        if (stockIn != null) {

            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            WeightDAO weightDAO = new WeightDAO();
            SupplierDAO supplierDAO = new SupplierDAO();

//            // Create lookup maps
//            Map<Integer, Product> productMap = new HashMap<>();
//            Map<Integer, Zone> zoneMap = new HashMap<>();
//            Map<Integer, Rack> rackMap = new HashMap<>();
//
//            // Populate maps
//            for (Product p : productDAO.getAll()) {
//                productMap.put(p.getProductId(), p);
//            }
//            for (Zone z : zoneMap.getAll()) {
//                zoneMap.put(z.getZoneId(), z);
//            }
//            for (Rack r : rackDAO.getAll()) {
//                rackMap.put(r.getRackId(), r);
//            }
//            request.setAttribute("productMap", productMap);
//            request.setAttribute("zoneMap", zoneMap);
//            request.setAttribute("rackMap", rackMap);

            request.setAttribute("stockIn", stockIn);
            request.setAttribute("productList", productDAO.getAll());
            request.setAttribute("categoryList", categoryDAO.getAll());
            request.setAttribute("weightList", weightDAO.getAll());
            request.setAttribute("zoneList", dao.getZoneList());
            request.setAttribute("rackList", dao.getRackList());
            request.setAttribute("supplierList", supplierDAO.getAll());

            Gson gson = new Gson();
            request.setAttribute("productListJson", gson.toJson(productDAO.getAll()));
            request.setAttribute("weightListJson", gson.toJson(weightDAO.getAll()));
            String stockInJson = gson.toJson(stockIn);
            System.out.println("=== StockIn JSON ===");
            System.out.println(stockInJson);
            request.setAttribute("debugStockInJson", stockInJson);
            request.getRequestDispatcher("stock_in.jsp").forward(request, response);
        } else {
            response.sendRedirect("StockIn");
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Get main stock info (single record)
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            Date arrivalDate = Date.valueOf(request.getParameter("arrival_date"));

            // 2. Get all item details (multiple records)
            String[] productIds = request.getParameterValues("productId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] expireDates = request.getParameterValues("expire_date[]");
            String[] zoneIds = request.getParameterValues("zoneid[]");
            String[] rackIds = request.getParameterValues("rackid[]");
            String[] weightIds = request.getParameterValues("weightId[]");
            String[] categoryIds = request.getParameterValues("categoryId[]");
            String status = "pending";

            // Validate all arrays have same length
            if (!allArraysSameLength(productIds, quantities, expireDates, zoneIds, rackIds)) {
                throw new ServletException("Invalid form data: arrays have different lengths");
            }

            // 3. Create and insert the main stock record
            StockInDAO dao = new StockInDAO();
            int stockInId = dao.insertMainStock(supplierId, arrivalDate, status);

            // 4. Insert all items
            boolean allItemsInserted = true;
            for (int i = 0; i < productIds.length; i++) {
                int stockContainId = dao.insertStockItem(
                        stockInId,
                        Integer.parseInt(productIds[i]),
                        Integer.parseInt(quantities[i]),
//                        Integer.parseInt(zoneIds[i]),
//                        Integer.parseInt(rackIds[i]),
                        Date.valueOf(expireDates[i])
                );

                if (stockContainId == -1) {
                    allItemsInserted = false;
                    break;
                }

                boolean manageSuccess = dao.insertStockManage(
                        stockContainId,
                        Integer.parseInt(zoneIds[i]),
                        Integer.parseInt(rackIds[i]),
                        Integer.parseInt(quantities[i]),
                        Integer.parseInt(weightIds[i])
                );

                if (!manageSuccess) {
                    allItemsInserted = false;
                    break;
                }
            }


            // 5. Handle result
            if (allItemsInserted) {
                request.getSession().setAttribute("successMessage", "Stock successfully added!");
            } else {
                // Rollback if any item failed
                request.getSession().setAttribute("errorMessage", "Failed to add some stock items");
                request.getRequestDispatcher("error.jsp").forward(request, response);

            }

            response.sendRedirect("StockIn");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private boolean allArraysSameLength(String[]... arrays) {
        if (arrays.length == 0) return true;
        int length = arrays[0].length;
        for (String[] array : arrays) {
            if (array.length != length) return false;
        }
        return true;
    }
}
