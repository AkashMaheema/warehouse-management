package com.warehouse.controllers;

import com.warehouse.dao.SupplierDAO;
import com.warehouse.models.Supplier;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageSupplier")
public class SupplierServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");
        SupplierDAO dao = new SupplierDAO();

        switch (action) {
            case "create":
                dao.add(
                        req.getParameter("name"),
                        req.getParameter("contactPerson"),
                        req.getParameter("phone"),
                        req.getParameter("email")
                );
                break;
            case "update":
                dao.update(
                        Integer.parseInt(req.getParameter("id")),
                        req.getParameter("name"),
                        req.getParameter("contactPerson"),
                        req.getParameter("phone"),
                        req.getParameter("email")
                );
                break;
            case "delete":
                dao.delete(Integer.parseInt(req.getParameter("id")));
                break;
            default:
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                return;
        }

        res.sendRedirect(req.getContextPath() + "/manageSupplier");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        SupplierDAO dao = new SupplierDAO();
        List<Supplier> suppliers = dao.getAll();

        req.setAttribute("suppliers", suppliers);
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageSupplier.jsp");
        dispatcher.forward(req, res);
    }
}

