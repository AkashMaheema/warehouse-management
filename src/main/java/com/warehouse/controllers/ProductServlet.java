package com.warehouse.controllers;

import com.google.gson.Gson;
import com.warehouse.dao.ProductDAO;
import com.warehouse.dao.WeightDAO;
import com.warehouse.dao.CategoryDAO;
import com.warehouse.models.Product;
import com.warehouse.models.Weight;
import com.warehouse.models.Category;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageProduct")
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        WeightDAO weightDAO = new WeightDAO();

        // Fetch all products, categories, and weights
        List<Product> products = productDAO.getAll();
        List<Category> categories = categoryDAO.getAll();
        List<Weight> weights = weightDAO.getAll();

        // Set the attributes to forward to JSP
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("weights", weights);

        // Forward the request to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manageProduct.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        ProductDAO productDAO = new ProductDAO();

        switch (action) {
            case "create":
                String name = request.getParameter("productName");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int weightId = Integer.parseInt(request.getParameter("weightId"));
                int reorderLevel = Integer.parseInt(request.getParameter("reorderLevel"));

                Product product = new Product(name, categoryId, weightId, reorderLevel);
                int productId = productDAO.add(product);
                if (productId != -1) {
                    product.setProductId(productId);
                }

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String json = new Gson().toJson(product);
                response.getWriter().write(json);
                break;

            case "update":
                int updateProductId = Integer.parseInt(request.getParameter("productId"));
                String updatedName = request.getParameter("productName");
                int updatedCategoryId = Integer.parseInt(request.getParameter("categoryId"));
                int updatedWeightId = Integer.parseInt(request.getParameter("weightId"));
                int updatedReorderLevel = Integer.parseInt(request.getParameter("reorderLevel"));

                Product updatedProduct = new Product(updateProductId, updatedName, updatedCategoryId, updatedWeightId, updatedReorderLevel);
                productDAO.update(updatedProduct);
                response.setStatus(HttpServletResponse.SC_OK);
                break;

            case "delete":
                productDAO.delete(Integer.parseInt(request.getParameter("productId")));
                response.setStatus(HttpServletResponse.SC_OK);
                break;

            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                break;
        }
    }
}

