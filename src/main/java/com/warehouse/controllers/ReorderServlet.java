package com.warehouse.controllers;

import com.warehouse.dao.ReorderDAO;
import com.warehouse.models.ReorderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/Reorder")
public class ReorderServlet extends HttpServlet {

    private final ReorderDAO reorderDAO = new ReorderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ReorderItem> reorderList = reorderDAO.getAllReorders();
        request.setAttribute("reorderList", reorderList);
        request.getRequestDispatcher("manageReorder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reorderId = Integer.parseInt(request.getParameter("reorderId"));
        String status = request.getParameter("status");
        boolean updated = reorderDAO.updateStatus(reorderId, status);

        if (updated) {
            request.setAttribute("message", "Status updated successfully.");
        } else {
            request.setAttribute("error", "Failed to update status.");
        }

        response.sendRedirect("Reorder");
    }
}
