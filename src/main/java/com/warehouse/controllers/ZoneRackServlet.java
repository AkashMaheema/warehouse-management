package com.warehouse.controllers;

import com.warehouse.config.DBConnection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.sql.*;
import java.util.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.math.BigDecimal;


@WebServlet("/ZoneRackServlet")
public class ZoneRackServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;

        String type = request.getParameter("type"); // "zone" or "rack"
        String productId = request.getParameter("productId");
        String zoneId = request.getParameter("zoneId"); // for rack selection

        try {
            conn = DBConnection.getConnection();
            StringBuilder html = new StringBuilder();

            if ("zone".equals(type)) {
                // Query to get available zones for this product
                String sql = "SELECT z.zone_id, z.zone_name, z.zone_capacity, z.used_capacity " +
                        "FROM zones z " +
                        "LEFT JOIN inventory s ON z.zone_id = s.zone_id " +
                        "WHERE (s.product_id IS NULL OR s.product_id = ?) " +
                        "AND (z.zone_capacity - z.used_capacity) > 0 " +
                        "UNION " +
                        "SELECT z.zone_id, z.zone_name, z.zone_capacity, z.used_capacity " +
                        "FROM zones z " +
                        "WHERE z.used_capacity = 0";

                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, productId);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("zone_id");
                    String name = rs.getString("zone_name");
                    BigDecimal capacity = rs.getBigDecimal("zone_capacity");
                    BigDecimal used = rs.getBigDecimal("used_capacity");
                    BigDecimal available = capacity.subtract(used);

                    html.append("<tr>")
                            .append("<td>").append(name).append("</td>")
                            .append("<td>").append(available).append("</td>")
                            .append("<td><button class='btn btn-success btn-sm select-zone' ")
                            .append("data-id='").append(id).append("' ")
                            .append("data-name='").append(name).append("'>Select</button></td>")
                            .append("</tr>");
                }
            }
            else if ("rack".equals(type)) {
                // Query to get available racks for selected zone and product
                String sql = "SELECT r.rack_id, r.rack_name, r.rack_capacity, r.used_capacity " +
                        "FROM racks r " +
                        "LEFT JOIN space_manage sa ON r.rack_id = sa.rack_id " +
                        "LEFT JOIN stock_contain_items sc ON sa.stock_contain_id = sc.stock_contain_id " +
                        "WHERE r.zone_id = ? " +
                        "AND (sc.product_id IS NULL OR sc.product_id = ?) " +
                        "AND (r.rack_capacity - r.used_capacity) > 0 " +
                        "UNION " +
                        "SELECT r.rack_id, r.rack_name, r.rack_capacity, r.used_capacity " +
                        "FROM racks r " +
                        "WHERE r.zone_id = ? AND r.used_capacity = 0";


                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, zoneId);
                stmt.setString(2, productId);
                stmt.setString(3, zoneId);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("rack_id");
                    String name = rs.getString("rack_name");
                    BigDecimal capacity = rs.getBigDecimal("rack_capacity");
                    BigDecimal used = rs.getBigDecimal("used_capacity");
                    BigDecimal available = capacity.subtract(used);

                    html.append("<tr>")
                            .append("<td>").append(name).append("</td>")
                            .append("<td>").append(available).append("</td>")
                            .append("<td><button class='btn btn-success btn-sm select-rack' ")
                            .append("data-id='").append(id).append("' ")
                            .append("data-name='").append(name).append("'>Select</button></td>")
                            .append("</tr>");
                }
            }

            response.setContentType("text/html");
            response.getWriter().write(html.toString());

        } catch (SQLException e) {
            e.printStackTrace(); // Still logs it to the server console

            response.setContentType("text/plain");
            response.getWriter().write("500 Internal Server Error:\n" + e.getMessage());
        }
    }
}
