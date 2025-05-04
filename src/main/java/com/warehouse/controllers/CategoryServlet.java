package com.warehouse.controllers;

import com.warehouse.dao.CategoryDAO;
import com.warehouse.models.Category;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageCategory")
public class CategoryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");
        CategoryDAO dao = new CategoryDAO();

        switch (action) {
            case "create":
                dao.add(req.getParameter("name"));
                break;
            case "update":
                dao.update(Integer.parseInt(req.getParameter("id")), req.getParameter("name"));
                break;
            case "delete":
                dao.delete(Integer.parseInt(req.getParameter("id")));
                break;
            default:
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        CategoryDAO dao = new CategoryDAO();
        List<Category> categories = dao.getAll();

        req.setAttribute("categories", categories);
        // Forward the request to the JSP
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageCategory.jsp");
        dispatcher.forward(req, res);
    }
}


