package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.model.Product;

import java.sql.*;
import java.util.*;

public class ProductDAO {
    private final Connection conn;

    public ProductDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Add a new product
    public boolean add(Product product) {
        String sql = "INSERT INTO products(product_name, category_id, weight_id, reorder_level) VALUES(?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setInt(2, product.getCategoryId());
            ps.setInt(3, product.getWeightId());
            ps.setInt(4, product.getReorderLevel());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update product
    public boolean update(Product product) {
        String sql = "UPDATE products SET product_name=?, category_id=?, weight_id=?, reorder_level=? WHERE product_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setInt(2, product.getCategoryId());
            ps.setInt(3, product.getWeightId());
            ps.setInt(4, product.getReorderLevel());
            ps.setInt(5, product.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete product
    public boolean delete(int productId) {
        String sql = "DELETE FROM products WHERE product_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, c.name as category_name, " +
                "w.weight_value, p.reorder_level " +
                "FROM products p " +
                "JOIN categories c ON p.category_id = c.category_id " +
                "JOIN weights w ON p.weight_id = w.weight_id " +
                "ORDER BY p.product_id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategoryName(rs.getString("category_name"));
                product.setWeightValue(rs.getDouble("weight_value"));
                product.setReorderLevel(rs.getInt("reorder_level"));
                list.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
