package com.warehouse.controllers;

import com.warehouse.dao.WeightDAO;
import com.warehouse.models.Weight;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageWeights")
public class WeightServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");
        WeightDAO dao = new WeightDAO();

        switch (action) {
            case "create":
                dao.add(Double.parseDouble(req.getParameter("weightValue")));
                break;
            case "update":
                dao.update(Integer.parseInt(req.getParameter("id")), Double.parseDouble(req.getParameter("weightValue")));
                break;
            case "delete":
                dao.delete(Integer.parseInt(req.getParameter("id")));
                break;
            default:
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        WeightDAO dao = new WeightDAO();
        List<Weight> weights = dao.getAll();

        req.setAttribute("weights", weights);
        // Forward the request to the JSP
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageWeights.jsp");
        dispatcher.forward(req, res);
    }
}
