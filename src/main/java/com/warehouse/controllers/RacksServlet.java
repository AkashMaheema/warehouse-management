package com.warehouse.controllers;

import com.warehouse.dao.RacksDAO;
import com.warehouse.dao.ZoneDAO;
import com.warehouse.models.Rack;
import com.warehouse.models.Zone;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageRacks")
public class RacksServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");
        RacksDAO racksDAO = new RacksDAO();
        ZoneDAO zoneDAO = new ZoneDAO();

        try {
            switch (action) {
                case "create":
                    // Create a new rack
                    String newRackName = req.getParameter("rackName");
                    int newZoneId = Integer.parseInt(req.getParameter("zoneId"));
                    int newRackCapacity = Integer.parseInt(req.getParameter("rackCapacity"));
                    int newUsedCapacity = Integer.parseInt(req.getParameter("usedCapacity"));

                    racksDAO.add(newRackName, newZoneId, newRackCapacity, newUsedCapacity);
                    zoneDAO.updateZoneUsedCapacity(newZoneId);  // Recalculate used capacity of this zone
                    break;

                case "update":
                    // Update an existing rack
                    int rackIdToUpdate = Integer.parseInt(req.getParameter("id"));
                    String updatedRackName = req.getParameter("rackName");
                    int updatedZoneId = Integer.parseInt(req.getParameter("zoneId"));
                    int updatedRackCapacity = Integer.parseInt(req.getParameter("rackCapacity"));
                    int updatedUsedCapacity = Integer.parseInt(req.getParameter("usedCapacity"));

                    int oldZoneId = racksDAO.getRackZoneId(rackIdToUpdate);  // Get old zone ID before update
                    racksDAO.update(rackIdToUpdate, updatedRackName, updatedZoneId, updatedRackCapacity, updatedUsedCapacity);

                    // If the zone changed, update both zones
                    if (oldZoneId != updatedZoneId) {
                        zoneDAO.updateZoneUsedCapacity(oldZoneId);
                    }
                    zoneDAO.updateZoneUsedCapacity(updatedZoneId);
                    break;

                case "delete":
                    // Delete a rack
                    int rackIdToDelete = Integer.parseInt(req.getParameter("id"));
                    int zoneIdOfRack = racksDAO.getRackZoneId(rackIdToDelete);  // Get the zone ID before deletion

                    racksDAO.delete(rackIdToDelete);
                    zoneDAO.updateZoneUsedCapacity(zoneIdOfRack);  // Update the zone after deletion
                    break;

                default:
                    res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error occurred: " + e.getMessage());
            return;
        }

        // Redirect back to the manageRacks page after action
        res.sendRedirect("manageRacks");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        RacksDAO racksDAO = new RacksDAO();
        ZoneDAO zoneDAO = new ZoneDAO();

        // Fetch all racks from the database
        List<Rack> racks = racksDAO.getAll();

        // Fetch all zones to populate the dropdown
        List<Zone> zones = zoneDAO.getAll();

        // Set attributes for the JSP page
        req.setAttribute("racks", racks);
        req.setAttribute("zones", zones);

        // Forward to the manageRacks.jsp page
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageRacks.jsp");
        dispatcher.forward(req, res);
    }
}
