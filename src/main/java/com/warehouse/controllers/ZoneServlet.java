package com.warehouse.controllers;

import com.warehouse.dao.ZoneDAO;
import com.warehouse.models.Zone;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageZone")
public class ZoneServlet extends HttpServlet {
    private ZoneDAO dao;

    @Override
    public void init() throws ServletException {
        super.init();
        dao = new ZoneDAO();
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "create":
                    dao.add(
                            req.getParameter("name"),
                            Integer.parseInt(req.getParameter("capacity")),
                            Integer.parseInt(req.getParameter("used"))
                    );
                    break;
                case "update":
                    dao.update(
                            Integer.parseInt(req.getParameter("id")),
                            req.getParameter("name"),
                            Integer.parseInt(req.getParameter("capacity")),
                            Integer.parseInt(req.getParameter("used"))
                    );
                    break;
                case "delete":
                    dao.delete(Integer.parseInt(req.getParameter("id")));
                    break;
                default:
                    res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    return;
            }
            res.sendRedirect("manageZone");
        } catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format");
        } catch (Exception e) {
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            List<Zone> zones = dao.getAll();
            System.out.println("Fetched zones: " + zones.size()); // Debug line
            req.setAttribute("zones", zones); // This is CRUCIAL
            RequestDispatcher dispatcher = req.getRequestDispatcher("/ZoneUI.jsp");
            dispatcher.forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load zones: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, res);
        }
    }
}