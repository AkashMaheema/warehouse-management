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
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");
        ZoneDAO dao = new ZoneDAO();

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
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        ZoneDAO dao = new ZoneDAO();
        List<Zone> zones = dao.getAll();
        req.setAttribute("zones", zones);
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageZone.jsp");
        dispatcher.forward(req, res);
    }
}