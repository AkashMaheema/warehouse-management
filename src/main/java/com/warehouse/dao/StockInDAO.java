package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.StockIn;
import com.warehouse.models.Rack;
import com.warehouse.models.Zone;
import com.warehouse.models.Supplier;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;


public class StockInDAO {
    private final Connection conn;

    public StockInDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Zone> getZoneList() {
        List<Zone> list = new ArrayList<>();
        String sql = "SELECT zone_id, zone_name FROM zones";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Zone(rs.getInt("zone_id"), rs.getString("zone_name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Rack> getRackList() {
        List<Rack> list = new ArrayList<>();
        String sql = "SELECT rack_id, rack_name FROM racks";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Rack(rs.getInt("rack_id"), rs.getString("rack_name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public List<Supplier> getSupplierList() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT supplier_id, name FROM suppliers";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Supplier(rs.getInt("supplier_id"), rs.getString("name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }



    public int insertMainStock(int supplierId, Date arrivalDate) throws SQLException {
        String sql = "INSERT INTO stock_in (supplier_id, arrival_date) VALUES (?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, supplierId);
            ps.setDate(2, arrivalDate);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                throw new SQLException("Failed to get generated stockin_id");
            }
        }
    }

    public boolean insertStockItem(int stockInId, int productId, int quantity,
                                   int zoneId, int rackId, Date expireDate) {
        String sql = "INSERT INTO stock_contain_items (stockin_id, product_id, quantity, " +
                "zone_id, rack_id, expiry_date) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockInId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setInt(4, zoneId);
            ps.setInt(5, rackId);
            ps.setDate(6, expireDate);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void deleteMainStock(int stockInId) {
        try {
            // Delete items first to maintain referential integrity
            String deleteItems = "DELETE FROM stock_contain_items WHERE stockin_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteItems)) {
                ps.setInt(1, stockInId);
                ps.executeUpdate();
            }

            // Then delete the main record
            String deleteMain = "DELETE FROM stock_in WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteMain)) {
                ps.setInt(1, stockInId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
