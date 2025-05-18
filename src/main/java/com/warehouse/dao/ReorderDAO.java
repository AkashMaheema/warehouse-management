package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.ReorderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReorderDAO {
    private final Connection conn;

    public ReorderDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void saveReorder(int productId, int quantity, int supplierId) {
        String sql = "INSERT INTO reorders (product_id, quantity, supplier_id) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, quantity);
            ps.setInt(3, supplierId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ReorderItem> getAllReorders() {
        List<ReorderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM reorders ORDER BY reorder_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ReorderItem item = new ReorderItem();
                item.setReorderId(rs.getInt("reorder_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setReorderDate(rs.getTimestamp("reorder_date"));
                item.setStatus(rs.getString("status"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int reorderId, String status) {
        String sql = "UPDATE reorders SET status = ? WHERE reorder_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reorderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
