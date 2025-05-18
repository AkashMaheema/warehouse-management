package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import models.ReportCriteria;
import com.warehouse.config.DBConnection;

public class ReportDAO {
    public List<Object[]> generateInventoryReport(ReportCriteria criteria) throws SQLException {
        List<Object[]> results = new ArrayList<>();
        String query = "SELECT p.product_name, c.category_name, w.weight, i.quantity, i.expiry_date, i.arrival_date " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "JOIN categories c ON p.category_id = c.category_id " +
                "JOIN weights w ON p.weight_id = w.weight_id " +
                "WHERE i.arrival_date BETWEEN ? AND ?";

        if (criteria.getCategoryId() != null) {
            query += " AND p.category_id = ?";
        }
        if (criteria.getProductId() != null) {
            query += " AND p.product_id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setDate(1, new java.sql.Date(criteria.getStartDate().getTime()));
            stmt.setDate(2, new java.sql.Date(criteria.getEndDate().getTime()));

            int paramIndex = 3;
            if (criteria.getCategoryId() != null) {
                stmt.setInt(paramIndex++, criteria.getCategoryId());
            }
            if (criteria.getProductId() != null) {
                stmt.setInt(paramIndex++, criteria.getProductId());
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] row = new Object[6];
                    row[0] = rs.getString("product_name");
                    row[1] = rs.getString("category_name");
                    row[2] = rs.getBigDecimal("weight");
                    row[3] = rs.getInt("quantity");
                    row[4] = rs.getDate("expiry_date");
                    row[5] = rs.getDate("arrival_date");
                    results.add(row);
                }
            }
        }
        return results;
    }

    public List<Object[]> generateStockMovementReport(ReportCriteria criteria) throws SQLException {
        List<Object[]> results = new ArrayList<>();
        String query = "SELECT p.product_name, c.category_name, " +
                "SUM(CASE WHEN si.status = 'approved' THEN sci.quantity ELSE 0 END) as stock_in, " +
                "SUM(CASE WHEN so.stockout_id IS NOT NULL THEN so.quantity ELSE 0 END) as stock_out " +
                "FROM products p " +
                "JOIN categories c ON p.category_id = c.category_id " +
                "LEFT JOIN stock_contain_items sci ON p.product_id = sci.product_id " +
                "LEFT JOIN stock_in si ON sci.stockin_id = si.stockin_id AND si.arrival_date BETWEEN ? AND ? " +
                "LEFT JOIN stock_out so ON p.product_id = so.product_id AND so.date_out BETWEEN ? AND ? " +
                "GROUP BY p.product_id, p.product_name, c.category_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setDate(1, new java.sql.Date(criteria.getStartDate().getTime()));
            stmt.setDate(2, new java.sql.Date(criteria.getEndDate().getTime()));
            stmt.setDate(3, new java.sql.Date(criteria.getStartDate().getTime()));
            stmt.setDate(4, new java.sql.Date(criteria.getEndDate().getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] row = new Object[4];
                    row[0] = rs.getString("product_name");
                    row[1] = rs.getString("category_name");
                    row[2] = rs.getInt("stock_in");
                    row[3] = rs.getInt("stock_out");
                    results.add(row);
                }
            }
        }
        return results;
    }
}