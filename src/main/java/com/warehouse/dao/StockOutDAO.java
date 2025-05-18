package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class StockOutDAO {
    private final Connection conn;

    public StockOutDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int insertMainStockOut(int customerId, Date dispatchDate, int userId, Integer orderId, String status) throws SQLException {
        String sql = "INSERT INTO stock_out (customer_id, dispatch_date, user_id, order_id, status) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerId);
            ps.setDate(2, dispatchDate);
            ps.setInt(3, userId);
            if (orderId != null) {
                ps.setInt(4, orderId);
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, status);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                throw new SQLException("Failed to get generated stockout_id");
            }
        }
    }

    public int insertStockOutItem(int stockOutId, int productId, int quantity, Date expireDate) {
        String sql = "INSERT INTO stock_out_contain (stockout_id, product_id, quantity, expiry_date) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, stockOutId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setDate(4, expireDate);

            int affectedRows = ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public List<StockOut> getStockOuts() throws SQLException {
        List<StockOut> stockOuts = new ArrayList<>();
        String sql = "SELECT s.stockout_id, s.customer_id, c.c_name, s.status, " +
                "s.dispatch_date, s.timestamp, s.user_id, s.order_id " +
                "FROM stock_out s " +
                "JOIN customer c ON s.customer_id = c.customer_id " +
                "ORDER BY s.timestamp DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StockOut stockOut = new StockOut();
                stockOut.setId(rs.getInt("stockout_id"));
                stockOut.setCustomerId(rs.getInt("customer_id"));
                stockOut.setCustomerName(rs.getString("c_name"));
                stockOut.setDispatchDate(rs.getDate("dispatch_date"));
                stockOut.setStatus(rs.getString("status"));
                stockOut.setCreatedDate(rs.getDate("timestamp"));
                stockOut.setUserId(rs.getInt("user_id"));
                stockOut.setOrderId(rs.getInt("order_id"));
                stockOuts.add(stockOut);
            }
        }
        return stockOuts;
    }

    public StockOut getStockOutById(int stockOutId) throws SQLException {
        String sql = "SELECT s.stockout_id, s.customer_id, c.c_name, " +
                "s.dispatch_date, s.timestamp, s.user_id, s.order_id, s.status " +
                "FROM stock_out s " +
                "JOIN customer c ON s.customer_id = c.customer_id " +
                "WHERE s.stockout_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockOutId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                StockOut stockOut = new StockOut();
                stockOut.setId(rs.getInt("stockout_id"));
                stockOut.setCustomerId(rs.getInt("customer_id"));
                stockOut.setCustomerName(rs.getString("c_name"));
                stockOut.setDispatchDate(rs.getDate("dispatch_date"));
                stockOut.setCreatedDate(rs.getDate("timestamp"));
                stockOut.setUserId(rs.getInt("user_id"));
                stockOut.setOrderId(rs.getInt("order_id"));
                stockOut.setStatus(rs.getString("status"));
                stockOut.setItems(getStockOutItems(stockOutId));
                return stockOut;
            }
        }
        return null;
    }

    private List<StockOutItem> getStockOutItems(int stockOutId) throws SQLException {
        List<StockOutItem> items = new ArrayList<>();
        String sql = "SELECT " +
                "    sci.stockout_contain_id, " +
                "    sci.stockout_id, " +
                "    sci.product_id, " +
                "    p.product_name, " +
                "    p.category_id, " +
                "    p.weight_id, " +
                "    sci.quantity, " +
                "    sci.expiry_date, " +
                "    i.zone_id, " +
                "    z.zone_name, " +
                "    i.rack_id, " +
                "    r.rack_name " +
                "FROM " +
                "    stock_out_contain sci " +
                "JOIN " +
                "    products p ON sci.product_id = p.product_id " +
                "JOIN " +
                "    inventory i ON sci.product_id = i.product_id " +
                "JOIN " +
                "    zones z ON i.zone_id = z.zone_id " +
                "JOIN " +
                "    racks r ON i.rack_id = r.rack_id " +
                "WHERE " +
                "    sci.stockout_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockOutId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StockOutItem item = new StockOutItem();
                item.setId(rs.getInt("stockout_contain_id"));
                item.setStockOutId(rs.getInt("stockout_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setCategoryId(rs.getInt("category_id"));
                item.setWeightId(rs.getInt("weight_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setExpireDate(rs.getDate("expiry_date"));
                item.setZoneId(rs.getInt("zone_id"));
                item.setZoneName(rs.getString("zone_name"));
                item.setRackId(rs.getInt("rack_id"));
                item.setRackName(rs.getString("rack_name"));


                List<Inventory> locations = getInventoryLocations(item.getProductId());
                item.setLocations(locations);

                items.add(item);
            }
        }
        return items;
    }

    public boolean updateStockOutStatus(int stockOutId, String status) throws SQLException {
        String sql = "UPDATE stock_out SET status = ? WHERE stockout_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, stockOutId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean checkStockAvailability(int stockOutId) throws SQLException {
        String sql = "SELECT sci.product_id, sci.quantity, " +
                "SUM(i.quantity) AS available_quantity " +
                "FROM stock_out_contain sci " +
                "JOIN inventory i ON sci.product_id = i.product_id " +
                "WHERE sci.stockout_id = ? " +
                "GROUP BY sci.product_id, sci.quantity";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockOutId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int requestedQuantity = rs.getInt("quantity");
                int availableQuantity = rs.getInt("available_quantity");

                if (availableQuantity < requestedQuantity) {
                    return false;
                }
            }
        }
        return true;
    }

    public boolean updateInventoryOnDispatch(int stockOutId) throws SQLException {
        conn.setAutoCommit(false); // Start transaction
        try {
            List<StockOutItem> items = getStockOutItems(stockOutId);

            // First verify all products exist and have sufficient stock
            for (StockOutItem item : items) {
                int productId = item.getProductId();
                int requestedQty = item.getQuantity();

                // Verify product exists and get weight ID
                int weightId = getWeightIdForProduct(productId);
                String productName = getProductName(productId);

                // Get actual available quantity
                int availableQty = getAvailableQuantity(productId);

                System.out.printf("Verifying: %s (ID:%d) | Req:%d | Avail:%d | Weight:%d%n",
                        productName, productId, requestedQty, availableQty, weightId);

                if (availableQty < requestedQty) {
                    throw new SQLException(String.format(
                            "Insufficient stock for %s (ID:%d). Requested: %d, Available: %d",
                            productName, productId, requestedQty, availableQty));
                }
            }

            // Process each item for actual dispatch
            for (StockOutItem item : items) {
                int productId = item.getProductId();
                int remainingQty = item.getQuantity();
                int weightId = getWeightIdForProduct(productId);

                System.out.printf("[STOCK] remain earlier Qty: %d%n", remainingQty );

                System.out.printf("\nDispatching: Product ID:%d | Total Qty:%d | Weight ID:%d%n",
                        productId, item.getQuantity(), weightId);

                // Get batches in FIFO order with lock
                String sql = "SELECT inventory_id, quantity, zone_id, rack_id " +
                        "FROM inventory " +
                        "WHERE product_id = ? AND quantity > 0 " +
                        "ORDER BY expiry_date ASC " +
                        "FOR UPDATE";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, productId);
                    ResultSet rs = ps.executeQuery();

                    int batchCount = 0;
                    while (rs.next() && remainingQty > 0) {
                        batchCount++;
                        int inventoryId = rs.getInt("inventory_id");
                        int batchQty = rs.getInt("quantity");
                        int zoneId = rs.getInt("zone_id");
                        int rackId = rs.getInt("rack_id");

                        int deductQty = Math.min(batchQty, remainingQty);

                        System.out.printf("Batch %d: ID:%d | Qty:%d | Deduct:%d | Zone:%d | Rack:%d%n",
                                batchCount, inventoryId, batchQty, deductQty, zoneId, rackId);

                        // 1. Update inventory
                        updateInventory(inventoryId, deductQty);

                        // 2. Update capacity
                        updateCapacity(zoneId, rackId, deductQty, weightId);

                        remainingQty -= deductQty;
                        System.out.printf("[STOCK] Available Qty: %d%n", remainingQty );


                        // 3. Clean up if empty
                        if (batchQty - deductQty == 0) {
                            deleteInventoryRecord(inventoryId);
                            System.out.println("  -> Batch emptied and deleted");
                        }
                    }

                    if (remainingQty > 0) {
                        // This should never happen due to our initial check
                        throw new SQLException("CRITICAL: Stock verification failed");
                    }
                }
            }

            conn.commit();
            System.out.println("\nSUCCESS: Dispatch completed for all items");
            return true;

        } catch (SQLException e) {
            conn.rollback();
            System.out.println("ERROR: " + e.getMessage());
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

// Helper Methods

    private int getWeightIdForProduct(int productId) throws SQLException {
        String sql = "SELECT weight_id FROM products WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                throw new SQLException("Product ID " + productId + " not found");
            }
            return rs.getInt("weight_id");
        }
    }

    private String getProductName(int productId) throws SQLException {
        String sql = "SELECT product_name FROM products WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getString("product_name") : "[Unknown Product]";
        }
    }

    private int getAvailableQuantity(int productId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM inventory WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private void updateInventory(int inventoryId, int deductQty) throws SQLException {
        String sql = "UPDATE inventory SET quantity = quantity - ? " +
                "WHERE inventory_id = ? AND quantity >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deductQty);
            ps.setInt(2, inventoryId);
            ps.setInt(3, deductQty);
            int updated = ps.executeUpdate();
            if (updated != 1) {
                throw new SQLException("Failed to update inventory ID: " + inventoryId);
            }
        }
    }

    private void updateCapacity(int zoneId, int rackId, int quantity, int weightId)
            throws SQLException {
        double weight = getWeightValue(weightId);
        double capacityChange = quantity * weight;

        // Update rack
        String rackSql = "UPDATE racks SET used_capacity = used_capacity - ? WHERE rack_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(rackSql)) {
            ps.setDouble(1, capacityChange);
            ps.setInt(2, rackId);
            ps.executeUpdate();
        }

        // Update zone
        String zoneSql = "UPDATE zones SET used_capacity = used_capacity - ? WHERE zone_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(zoneSql)) {
            ps.setDouble(1, capacityChange);
            ps.setInt(2, zoneId);
            ps.executeUpdate();
        }
    }

    private double getWeightValue(int weightId) throws SQLException {
        String sql = "SELECT weight FROM weights WHERE weight_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, weightId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                throw new SQLException("Invalid weight ID: " + weightId);
            }
            return rs.getDouble("weight");
        }
    }

    private void deleteInventoryRecord(int inventoryId) throws SQLException {
        String sql = "DELETE FROM inventory WHERE inventory_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inventoryId);
            ps.executeUpdate();
        }
    }



    public List<StockOut> getStockOutsByStatus(String status) throws SQLException {
        List<StockOut> stockOuts = new ArrayList<>();
        String sql = "SELECT s.stockout_id, s.customer_id, c.c_name, s.status, " +
                "s.dispatch_date, s.timestamp, s.user_id, s.order_id " +
                "FROM stock_out s " +
                "JOIN customer c ON s.customer_id = c.customer_id " +
                "WHERE s.status = ? " +
                "ORDER BY s.timestamp DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StockOut stockOut = new StockOut();
                stockOut.setId(rs.getInt("stockout_id"));
                stockOut.setCustomerId(rs.getInt("customer_id"));
                stockOut.setCustomerName(rs.getString("c_name"));
                stockOut.setDispatchDate(rs.getDate("dispatch_date"));
                stockOut.setStatus(rs.getString("status"));
                stockOut.setCreatedDate(rs.getDate("timestamp"));
                stockOut.setUserId(rs.getInt("user_id"));
                stockOut.setOrderId(rs.getInt("order_id"));
                stockOut.setItems(getStockOutItems(stockOut.getId()));
                stockOuts.add(stockOut);
            }
        }
        return stockOuts;
    }

    public boolean deleteStockOutItems(int stockOutId) throws SQLException {
        String sql = "DELETE FROM stock_out_contain WHERE stockout_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stockOutId);
            return ps.executeUpdate() > 0;
        }
    }

    // Add this method to your StockOutDAO class
    public boolean updateStockOutDetails(int stockOutId, int customerId, Date dispatchDate) throws SQLException {
        String sql = "UPDATE stock_out SET customer_id = ?, dispatch_date = ? WHERE stockout_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setDate(2, dispatchDate);
            ps.setInt(3, stockOutId);
            return ps.executeUpdate() > 0;
        }
    }

    private List<Inventory> getInventoryLocations(int productId) throws SQLException {
        List<Inventory> locations = new ArrayList<>();
        String sql = "SELECT i.inventory_id, i.quantity, i.expiry_date, " +
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
                inv.setProductId(productId);
                inv.setQuantity(rs.getInt("quantity"));
                inv.setExpiryDate(rs.getDate("expiry_date"));
                inv.setZoneId(rs.getInt("zone_id"));
                inv.setZoneName(rs.getString("zone_name"));
                inv.setRackId(rs.getInt("rack_id"));
                inv.setRackName(rs.getString("rack_name"));
                locations.add(inv);
            }
        }
        return locations;
    }


}