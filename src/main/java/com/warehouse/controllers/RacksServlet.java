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
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/manageRacks")
public class RacksServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String action = req.getParameter("action");
        RacksDAO racksDAO = new RacksDAO();
        ZoneDAO zoneDAO = new ZoneDAO();

        try {
            switch (action) {
                case "create":
                    String newRackName = req.getParameter("rackName");
                    int newZoneId = Integer.parseInt(req.getParameter("zoneId"));
                    int newRackCapacity = Integer.parseInt(req.getParameter("rackCapacity"));
                    int newUsedCapacity = Integer.parseInt(req.getParameter("usedCapacity"));

                    // Fetch current total rack capacity in the target zone
                    int currentTotalRackCapacity = racksDAO.getTotalRackCapacityInZone(newZoneId);
                    int zoneTotalCapacity = zoneDAO.getZoneCapacity(newZoneId);

                    // Check if adding the new rack would exceed the zone's capacity
                    if ((currentTotalRackCapacity + newRackCapacity) > zoneTotalCapacity) {
                        req.setAttribute("warning", "Adding this rack will exceed the zone's capacity!");
                        req.setAttribute("racks", racksDAO.getAll());
                        req.setAttribute("zones", zoneDAO.getAll());
                        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageRacks.jsp");
                        dispatcher.forward(req, res);
                        return;
                    }

                    // Proceed with creating the new rack
                    boolean created = racksDAO.add(newRackName, newZoneId, newRackCapacity, newUsedCapacity);
                    if (!created) {
                        req.setAttribute("warning", "Error occurred while adding the rack.");
                        req.setAttribute("racks", racksDAO.getAll());
                        req.setAttribute("zones", zoneDAO.getAll());
                        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageRacks.jsp");
                        dispatcher.forward(req, res);
                    }
                    break;

                case "update":
                    try {
                        int rackIdToUpdate = Integer.parseInt(req.getParameter("id"));
                        String updatedRackName = req.getParameter("rackName");
                        int updatedZoneId = Integer.parseInt(req.getParameter("zoneId"));
                        int updatedRackCapacity = Integer.parseInt(req.getParameter("rackCapacity"));
                        int updatedUsedCapacity = Integer.parseInt(req.getParameter("usedCapacity"));

                        // Validate used capacity doesn't exceed rack capacity
                        if (updatedUsedCapacity > updatedRackCapacity) {
                            res.setContentType("application/json");
                            PrintWriter out = res.getWriter();
                            out.print("{\"success\": false, \"message\": \"Used capacity cannot exceed rack capacity\"}");
                            return;
                        }

                        // Fetch old rack details
                        int oldZoneId = racksDAO.getRackZoneId(rackIdToUpdate);
                        int oldRackCapacity = racksDAO.getRackCapacity(rackIdToUpdate);

                        // Fetch current total rack capacity in the target zone
                        int currentTotalRackCapacityUpdate = racksDAO.getTotalRackCapacityInZone(updatedZoneId);

                        // Adjust if the zone hasn't changed
                        if (oldZoneId == updatedZoneId) {
                            currentTotalRackCapacityUpdate -= oldRackCapacity; // remove old rack's capacity
                        }

                        int zoneTotalCapacityUpdate = zoneDAO.getZoneCapacity(updatedZoneId);

                        // Check if updating the rack will exceed the zone's capacity
                        if ((currentTotalRackCapacityUpdate + updatedRackCapacity) > zoneTotalCapacityUpdate) {
                            res.setContentType("application/json");
                            PrintWriter out = res.getWriter();
                            out.print("{\"success\": false, \"message\": \"Updating this rack will exceed the zone's total capacity\"}");
                            return;
                        }

                        // Proceed with updating the rack
                        boolean updated = racksDAO.update(rackIdToUpdate, updatedRackName, updatedZoneId,
                                updatedRackCapacity, updatedUsedCapacity);

                        if (updated) {
                            // Update zone used capacity if the zone has changed
                            if (oldZoneId != updatedZoneId) {
                                zoneDAO.updateZoneUsedCapacity(oldZoneId);
                            }
                            zoneDAO.updateZoneUsedCapacity(updatedZoneId);

                            res.setContentType("application/json");
                            PrintWriter out = res.getWriter();
                            out.print("{\"success\": true, \"message\": \"Rack updated successfully\"}");
                        } else {
                            res.setContentType("application/json");
                            PrintWriter out = res.getWriter();
                            out.print("{\"success\": false, \"message\": \"Failed to update rack\"}");
                        }
                    } catch (Exception e) {
                        res.setContentType("application/json");
                        res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        PrintWriter out = res.getWriter();
                        out.print("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
                    }
                    return;
                case "delete":
                    int rackIdToDelete = Integer.parseInt(req.getParameter("id"));
                    int zoneIdOfRack = racksDAO.getRackZoneId(rackIdToDelete);

                    // Proceed with deleting the rack
                    racksDAO.delete(rackIdToDelete);

                    // Update the zone's used capacity
                    zoneDAO.updateZoneUsedCapacity(zoneIdOfRack);
                    break;

                default:
                    res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error occurred: " + e.getMessage());
            return;
        }

        // Redirect after successful create/update/delete
        res.sendRedirect("manageRacks");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String viewType = req.getParameter("view");

        if ("grid".equals(viewType)) {
            // Handle rack grid view request
            int zoneId = Integer.parseInt(req.getParameter("zoneId"));
            RacksDAO racksDAO = new RacksDAO();
            ZoneDAO zoneDAO = new ZoneDAO();

            List<Rack> racks = racksDAO.getRacksByZone(zoneId);
            Zone zone = zoneDAO.getZoneById(zoneId);

            req.setAttribute("racks", racks);
            req.setAttribute("zoneName", zone.getZoneName());
            RequestDispatcher dispatcher = req.getRequestDispatcher("/RackGrid.jsp");
            dispatcher.forward(req, res);
        } else {
            // Handle default racks management view
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


}
