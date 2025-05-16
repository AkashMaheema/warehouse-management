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

}
