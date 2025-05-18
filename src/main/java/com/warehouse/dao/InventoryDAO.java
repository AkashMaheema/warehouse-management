package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.Inventory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {
    public List<Inventory> getAllInventory() throws SQLException {
        List<Inventory> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        String sql = "SELECT i.inventory_id, i.product_id, p.product_name, " +
                "i.zone_id, z.zone_name, i.rack_id, r.rack_name, " +
                "i.quantity, i.expiry_date, i.arrival_date, i.holding_time " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "JOIN zones z ON i.zone_id = z.zone_id " +
                "JOIN racks r ON i.rack_id = r.rack_id";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Inventory inv = new Inventory();
                inv.setInventoryId(rs.getInt("inventory_id"));
                inv.setProductId(rs.getInt("product_id"));
                inv.setProductName(rs.getString("product_name"));
                inv.setZoneId(rs.getInt("zone_id"));
                inv.setZoneName(rs.getString("zone_name"));
                inv.setRackId(rs.getInt("rack_id"));
                inv.setRackName(rs.getString("rack_name"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setExpiryDate(rs.getDate("expiry_date"));
                inv.setArrivalDate(rs.getDate("arrival_date"));
                inv.setHoldingTime(rs.getInt("holding_time"));
                list.add(inv);
            }
        }
        return list;
    }

    public int getAvailableQuantity(int productId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        // Include only non-zero quantity items that aren't already allocated
        String sql = "SELECT COALESCE(SUM(i.quantity - COALESCE(sm.allocated_quantity, 0)), 0) AS available " +
                "FROM inventory i " +
                "LEFT JOIN space_manage sm ON i.inventory_id = sm.stock_contain_id " +
                "WHERE i.product_id = ? AND i.quantity > 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt("available") : 0;
        }
    }

    public List<Inventory> getInventoryByProduct(int productId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        List<Inventory> inventoryList = new ArrayList<>();
        String sql = "SELECT i.inventory_id, i.product_id, i.quantity, i.expiry_date, " +
                "z.zone_id, z.zone_name, r.rack_id, r.rack_name " +
                "FROM inventory i " +
                "JOIN zones z ON i.zone_id = z.zone_id " +
                "JOIN racks r ON i.rack_id = r.rack_id " +
                "WHERE i.product_id = ? AND i.quantity > 0 " +
                "ORDER BY i.expiry_date ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Inventory inv = new Inventory();
                inv.setInventoryId(rs.getInt("inventory_id"));
                inv.setProductId(rs.getInt("product_id"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setExpiryDate(rs.getDate("expiry_date"));
                inv.setZoneId(rs.getInt("zone_id"));
                inv.setZoneName(rs.getString("zone_name"));
                inv.setRackId(rs.getInt("rack_id"));
                inv.setRackName(rs.getString("rack_name"));
                inventoryList.add(inv);
            }
        }
        return inventoryList;
    }


}
