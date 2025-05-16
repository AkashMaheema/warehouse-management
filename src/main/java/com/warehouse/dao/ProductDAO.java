package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.Product;

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
    public int add(Product product) {
        int generatedId = -1;
        String sql = "INSERT INTO products (product_name, category_id, weight_id, reorder_level) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, product.getProductName());
            stmt.setInt(2, product.getCategoryId());
            stmt.setInt(3, product.getWeightId());
            stmt.setInt(4, product.getReorderLevel());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                        product.setProductId(generatedId); // Set it in the object too if needed
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId; // -1 if failed
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
        String sql = "SELECT p.product_id, p.product_name, c.category_id, c.category_name, w.weight_id ," +
                "w.weight, p.reorder_level " +
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
                product.setCategoryId(rs.getInt("category_id"));
                product.setWeightValue(rs.getDouble("weight"));
                product.setWeightId(rs.getInt("weight_id"));
                product.setReorderLevel(rs.getInt("reorder_level"));
                list.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public Product getProductById(int id) {
        Product product = null;
        String sql = "SELECT p.product_id, p.product_name, c.category_id, c.category_name, " +
                "w.weight_id, w.weight, p.reorder_level " +
                "FROM products p " +
                "JOIN categories c ON p.category_id = c.category_id " +
                "JOIN weights w ON p.weight_id = w.weight_id " +
                "WHERE p.product_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    product = new Product();
                    product.setProductId(rs.getInt("product_id"));
                    product.setProductName(rs.getString("product_name"));
                    product.setCategoryId(rs.getInt("category_id"));
                    product.setCategoryName(rs.getString("category_name"));
                    product.setWeightId(rs.getInt("weight_id"));
                    product.setWeightValue(rs.getDouble("weight"));
                    product.setReorderLevel(rs.getInt("reorder_level"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }
    public List<Product> getLowStockProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, c.category_id, c.category_name, " +
                "w.weight_id, w.weight, p.reorder_level, COALESCE(SUM(i.quantity), 0) AS current_stock " +
                "FROM products p " +
                "JOIN categories c ON p.category_id = c.category_id " +
                "JOIN weights w ON p.weight_id = w.weight_id " +
                "LEFT JOIN inventory i ON i.product_id = p.product_id " +
                "WHERE p.product_id NOT IN ( " +
                "    SELECT product_id FROM reorders WHERE reorder_date >= NOW() - INTERVAL 3 DAY" +
                ") " +
                "GROUP BY p.product_id, p.product_name, c.category_id, c.category_name, " +
                "w.weight_id, w.weight, p.reorder_level " +
                "HAVING current_stock < p.reorder_level " +
                "ORDER BY current_stock ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCategoryName(rs.getString("category_name"));
                product.setWeightId(rs.getInt("weight_id"));
                product.setWeightValue(rs.getDouble("weight"));
                product.setReorderLevel(rs.getInt("reorder_level"));
                product.setCurrentStock(rs.getInt("current_stock"));
                list.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
