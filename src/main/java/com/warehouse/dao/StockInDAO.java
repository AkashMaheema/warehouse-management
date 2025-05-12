package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.*;

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

    public int insertMainStock(int supplierId, Date arrivalDate, String status) throws SQLException {
        String sql = "INSERT INTO stock_in (supplier_id, arrival_date, status) VALUES (?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, supplierId);
            ps.setDate(2, arrivalDate);
            ps.setString(3, status);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                throw new SQLException("Failed to get generated stockin_id");
            }
        }
    }

    public int insertStockItem(int stockInId, int productId, int quantity, Date expireDate) {
        String sql = "INSERT INTO stock_contain_items (stockin_id, product_id, quantity, expiry_date) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, stockInId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setDate(4, expireDate);

            int affectedRows = ps.executeUpdate();

            // Retrieve the generated key (stock_contain_id)
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);  // Return the generated stock_contain_id
                }
            }

            return -1; // Return -1 if no generated key is available
        } catch (SQLException e) {
            e.printStackTrace();
            return -1; // Return -1 on error
        }
    }


    public boolean insertStockManage(int stockContainId, int zoneId, int rackId,
                                     int allocatedQuantity, int weightId) {
        String sql = "INSERT INTO space_manage (stock_contain_id, zone_id, rack_id, allocated_quantity, weight_id) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockContainId);
            ps.setInt(2, zoneId);
            ps.setInt(3, rackId);
            ps.setInt(4, allocatedQuantity);
            ps.setInt(5, weightId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //no usage until implement the admin approval part

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

    public List<StockIn> getStocks() throws SQLException {
        List<StockIn> pendingStocks = new ArrayList<>();
        String sql = "SELECT s.stockin_id, s.supplier_id, sup.name as supplier_name, s.status, " +
                "s.arrival_date, s.timestamp " +
                "FROM stock_in s " +
                "JOIN suppliers sup ON s.supplier_id = sup.supplier_id " +
                "ORDER BY s.timestamp DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StockIn stock = new StockIn();
                stock.setId(rs.getInt("stockin_id"));
                stock.setSupplierId(rs.getInt("supplier_id"));
                stock.setSupplierName(rs.getString("supplier_name"));
                stock.setArrivalDate(rs.getDate("arrival_date"));
                stock.setStatus(rs.getString("status"));
                stock.setCreatedDate(rs.getDate("timestamp"));
                pendingStocks.add(stock);
            }
        }
        return pendingStocks;
    }

    // Get stock by ID
    public StockIn getStockInById(int stockInId) throws SQLException {
        String sql = "SELECT s.stockin_id, s.supplier_id, sup.name as supplier_name, " +
                "s.arrival_date, s.timestamp " +
                "FROM stock_in s " +
                "JOIN suppliers sup ON s.supplier_id = sup.supplier_id " +
                "WHERE s.stockin_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockInId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                StockIn stock = new StockIn();
                stock.setId(rs.getInt("stockin_id"));
                stock.setSupplierId(rs.getInt("supplier_id"));
                stock.setSupplierName(rs.getString("supplier_name"));
                stock.setArrivalDate(rs.getDate("arrival_date"));
                stock.setCreatedDate(rs.getDate("timestamp"));
                stock.setItems(getStockItems(stockInId));
                return stock;
            }
        }
        return null;
    }

    // Update stock status
    public boolean updateStockStatus(int stockInId, String status) throws SQLException {
        String sql = "UPDATE stock_in SET status = ? WHERE stockin_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, stockInId);
            return ps.executeUpdate() > 0;
        }
    }

    // Get items for a stock
    private List<StockItem> getStockItems(int stockInId) throws SQLException {
        List<StockItem> items = new ArrayList<>();
        String sql = "SELECT sci.stock_contain_id, sci.stockin_id ,sci.product_id, p.product_name, p.category_id,p.weight_id, " +
                "sci.quantity, sci.expiry_date, " +
                "sm.zone_id, z.zone_name, sm.rack_id, r.rack_name " +
                "FROM stock_contain_items sci " +
                "JOIN products p ON sci.product_id = p.product_id " +
                "JOIN space_manage sm ON sci.stock_contain_id = sm.stock_contain_id " +
                "JOIN zones z ON sm.zone_id = z.zone_id " +
                "JOIN racks r ON sm.rack_id = r.rack_id " +
                "WHERE sci.stockin_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockInId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StockItem item = new StockItem();
                item.setId(rs.getInt("stock_contain_id"));
                item.setStockInId(rs.getInt("stockin_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setCategoryId(rs.getInt("category_id"));
                item.setWeightId(rs.getInt("weight_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setZoneId(rs.getInt("zone_id"));
                item.setRackId(rs.getInt("rack_id"));
                item.setExpireDate(rs.getDate("expiry_date"));
                items.add(item);
            }
        }
        return items;
    }
    public boolean updateMainStock(int stockInId, int supplierId, Date arrivalDate, String status) throws SQLException {
        String sql = "UPDATE stock_in SET supplier_id = ?, arrival_date = ?, status = ? WHERE stockin_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.setDate(2, arrivalDate);
            ps.setString(3, status);
            ps.setInt(4, stockInId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        }
    }
    public boolean updateStockItem(int stockContainId, int stockInId, int productId, int quantity, Date expireDate) throws SQLException {
        String sql = "UPDATE stock_contain_items SET stockin_id = ?, product_id = ?, quantity = ?, expiry_date = ? WHERE stock_contain_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockInId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setDate(4, expireDate);
            ps.setInt(5, stockContainId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        }
    }
    public void deleteStockItemsByStockInId(int stockInId) throws SQLException {
        // First delete from stock_manage (assumes it depends on stock_contain_items)
        String deleteManage = "DELETE FROM space_manage WHERE stock_contain_id IN (SELECT stock_contain_id FROM stock_contain_items WHERE stockin_id = ?)";
        try (PreparedStatement ps = conn.prepareStatement(deleteManage)) {
            ps.setInt(1, stockInId);
            ps.executeUpdate();
        }

        // Then delete from stock_contain_items
        String deleteItems = "DELETE FROM stock_contain_items WHERE stockin_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteItems)) {
            ps.setInt(1, stockInId);
            ps.executeUpdate();
        }
    }

}
