package com.warehouse.controllers;

import com.google.gson.Gson;
import com.warehouse.dao.ProductDAO;
import com.warehouse.dao.ReorderDAO;
import com.warehouse.dao.SupplierDAO;
import com.warehouse.models.Product;
import com.warehouse.models.ReorderItem;
import com.warehouse.models.Supplier;
import com.warehouse.utils.EmailService;
import com.warehouse.utils.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/ReorderServlet")
public class CreateReorderServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        ProductDAO productDAO = new ProductDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        Product selectedProduct = productDAO.getProductById(productId);
        List<Product> lowStockProducts = productDAO.getLowStockProducts();
        List<Supplier> suppliers = supplierDAO.getAll();

        Gson gson = new Gson();
        request.setAttribute("GlowStockProducts", gson.toJson(lowStockProducts));
        request.setAttribute("selectedProduct", selectedProduct);
        request.setAttribute("lowStockProducts", lowStockProducts);
        System.out.println(gson.toJson(lowStockProducts));
        request.setAttribute("GlowStockProducts", gson.toJson(suppliers));
        request.setAttribute("suppliers", suppliers);
        System.out.println(gson.toJson(suppliers));
        request.getRequestDispatcher("reorder.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("supplierId"));

        String[] productIds = request.getParameterValues("productIds");
        String[] quantities = request.getParameterValues("quantities");
        String[] additional = request.getParameterValues("addProduct");

        List<ReorderItem> items = new ArrayList<>();

        for (int i = 0; i < productIds.length; i++) {
            int pid = Integer.parseInt(productIds[i]);
            int qty = Integer.parseInt(quantities[i]);
            items.add(new ReorderItem(pid, qty));
        }

        if (additional != null) {
            for (String pidStr : additional) {
                int pid = Integer.parseInt(pidStr);
                int qty = Integer.parseInt(request.getParameter("qty_" + pid));
                items.add(new ReorderItem(pid, qty));
            }
        }

        SupplierDAO supplierDAO = new SupplierDAO();
        Supplier supplier = supplierDAO.getSupplierById(supplierId);

        EmailService.sendReorderEmail(supplier.getEmail(), supplier.getName(), items);

        // Add to the end of doPost
        ReorderDAO reorderDAO = new ReorderDAO();
        for (ReorderItem item : items) {
            reorderDAO.saveReorder(item.getProductId(), item.getQuantity(), supplierId);
        }

        response.sendRedirect("Inventory?success=Reorder+request+sent+successfully");
    }
}
