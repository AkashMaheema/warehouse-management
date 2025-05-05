package com.warehouse.controllers;

import com.warehouse.dao.CategoryDAO;
import com.warehouse.dao.ProductDAO;
import com.warehouse.dao.StockInDAO;
import com.warehouse.dao.WeightDAO;
import com.warehouse.models.Category;
import com.warehouse.models.Product;
import com.warehouse.models.StockIn;
import com.warehouse.models.Weight;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/StockInServlet")
public class StockInServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StockInDAO dao = new StockInDAO();

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        WeightDAO weightDAO = new WeightDAO();

        List<Product> products = productDAO.getAll();
        List<Category> categories = categoryDAO.getAll();
        List<Weight> weights = weightDAO.getAll();

        request.setAttribute("productList", products);
        request.setAttribute("categoryList", categories);
        request.setAttribute("weightList", weights);

//        request.setAttribute("productList", dao.getProductList());
//        request.setAttribute("categoryList", dao.getCategoryList());
//        request.setAttribute("weightList", dao.getWeightList());
        request.setAttribute("zoneList", dao.getZoneList());
        request.setAttribute("rackList", dao.getRackList());
        request.setAttribute("supplierList", dao.getSupplierList());

        request.getRequestDispatcher("stock_in.jsp").forward(request, response);  // your JSP file
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String supplier = request.getParameter("supplier");
        Date arrivalDate = Date.valueOf(request.getParameter("arrival_date"));

        String[] productNames = request.getParameterValues("product_name[]");
        String[] categories = request.getParameterValues("category[]");
        String[] weights = request.getParameterValues("weight[]");
        String[] quantities = request.getParameterValues("quantity[]");
        String[] expireDates = request.getParameterValues("expire_date[]");
        String[] zones = request.getParameterValues("zone[]");
        String[] racks = request.getParameterValues("rack[]");

        List<StockIn> stockInList = new ArrayList<>();

        for (int i = 0; i < productNames.length; i++) {
            StockIn stock = new StockIn();
            stock.setSupplier(supplier);
            stock.setArrivalDate(arrivalDate);
            stock.setProductName(productNames[i]);
            stock.setCategory(categories[i]);
            stock.setWeight(Double.parseDouble(weights[i]));
            stock.setQuantity(Integer.parseInt(quantities[i]));
            stock.setExpireDate(Date.valueOf(expireDates[i]));
            stock.setZone(zones[i]);
            stock.setRack(racks[i]);

            stockInList.add(stock);
        }

        StockInDAO dao = new StockInDAO();
        for (StockIn s : stockInList) {
            dao.insertStockIn(s);
        }

        response.sendRedirect("StockInServlet");  // triggers doGet()
    }
}
