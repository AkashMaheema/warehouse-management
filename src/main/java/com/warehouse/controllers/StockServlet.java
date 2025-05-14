package com.warehouse.controllers;

import com.warehouse.dao.StockInDAO;
import com.warehouse.models.StockIn;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/Stocks")
public class StockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            StockInDAO stockInDAO = new StockInDAO();
            List<StockIn> Stocks = stockInDAO.getStocks();

            request.setAttribute("Stocks", Stocks);
            request.getRequestDispatcher("manageStock.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error occurred", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int stockInId = Integer.parseInt(request.getParameter("stockInId"));

        try {
            StockInDAO stockInDAO = new StockInDAO();

            if ("approve".equals(action)) {
                if (stockInDAO.updateStockStatus(stockInId, "approved")) {
                    request.getSession().setAttribute("successMessage", "Stock approved successfully!");
                    // Here you would also update inventory
                }
            } else if ("reject".equals(action)) {
                if (stockInDAO.updateStockStatus(stockInId, "rejected")) {
                    request.getSession().setAttribute("successMessage", "Stock rejected!");
                }
            }

            response.sendRedirect("Stocks");

        } catch (SQLException e) {
            throw new ServletException("Database error occurred", e);
        }
    }
}