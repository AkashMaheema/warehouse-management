package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.ASN;
import com.warehouse.models.ASNItem;
import com.warehouse.models.Supplier;
import com.warehouse.models.Product;
import com.warehouse.models.Weight;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ASNDAO {
    // Don't hold a long-lived connection instance
    public ASNDAO() {
        // No initialization needed here
    }

    // Helper method to get and manage connections
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    public int createASN(ASN asn) throws SQLException {
        String sql = "INSERT INTO asn (supplier_id, reference_number, expected_arrival_date, status) VALUES (?, ?, ?, ?)";
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, asn.getSupplierId());
            stmt.setString(2, asn.getReferenceNumber());
            stmt.setDate(3, new java.sql.Date(asn.getExpectedArrivalDate().getTime()));
            stmt.setString(4, "pending");

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating ASN failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating ASN failed, no ID obtained.");
                }
            }
        }
    }

    public boolean addASNItem(ASNItem item) throws SQLException {
        String sql = "INSERT INTO asn_items (asn_id, product_id, weight_id, expected_quantity) VALUES (?, ?, ?, ?)";
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, item.getAsnId());
            stmt.setInt(2, item.getProductId());
            stmt.setInt(3, item.getWeightId());
            stmt.setInt(4, item.getExpectedQuantity());

            return stmt.executeUpdate() > 0;
        }
    }

    public List<ASN> getPendingASNs() throws SQLException {
        List<ASN> asnList = new ArrayList<>();
        String sql = "SELECT a.*, s.supplier_id, s.name, s.contact_person, s.phone, s.email " +
                "FROM asn a JOIN suppliers s ON a.supplier_id = s.supplier_id " +
                "WHERE a.status = 'pending'";

        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ASN asn = mapASNFromResultSet(rs);
                asn.setItems(getASNItems(asn.getAsnId()));
                asnList.add(asn);
            }
        }
        return asnList;
    }

    public ASN getASNById(int asnId) throws SQLException {
        String sql = "SELECT a.*, s.supplier_id, s.name, s.contact_person, s.phone, s.email " +
                "FROM asn a JOIN suppliers s ON a.supplier_id = s.supplier_id " +
                "WHERE a.asn_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, asnId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ASN asn = mapASNFromResultSet(rs);
                    asn.setItems(getASNItems(asnId));
                    return asn;
                }
            }
        }
        return null;
    }

    public List<ASNItem> getASNItems(int asnId) throws SQLException {
        List<ASNItem> items = new ArrayList<>();
        String sql = "SELECT ai.asn_item_id, ai.asn_id, ai.product_id, ai.weight_id, ai.expected_quantity, " +
                "p.product_name, w.weight " +
                "FROM asn_items ai " +
                "JOIN products p ON ai.product_id = p.product_id " +
                "JOIN weights w ON ai.weight_id = w.weight_id " +
                "WHERE ai.asn_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, asnId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ASNItem item = new ASNItem();
                    item.setAsnItemId(rs.getInt("asn_item_id"));
                    item.setAsnId(rs.getInt("asn_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setWeightId(rs.getInt("weight_id"));
                    item.setExpectedQuantity(rs.getInt("expected_quantity"));

                    Product product = new Product();
                    product.setProductName(rs.getString("product_name"));
                    item.setProduct(product);

                    Weight weight = new Weight(
                            rs.getInt("weight_id"),
                            rs.getDouble("weight")
                    );
                    item.setWeight(weight);

                    items.add(item);
                }
            }
        }
        return items;
    }

    public boolean approveASN(int asnId) throws SQLException {
        String sql = "UPDATE asn SET status = 'approved' WHERE asn_id = ?";
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, asnId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean rejectASN(int asnId) throws SQLException {
        String sql = "UPDATE asn SET status = 'rejected' WHERE asn_id = ?";
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, asnId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<ASN> getAllASNs() throws SQLException {
        List<ASN> asnList = new ArrayList<>();
        String sql = "SELECT a.*, s.supplier_id, s.name, s.contact_person, s.phone, s.email " +
                "FROM asn a JOIN suppliers s ON a.supplier_id = s.supplier_id " +
                "ORDER BY a.created_at DESC";

        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ASN asn = mapASNFromResultSet(rs);
                asnList.add(asn);
            }
        }
        return asnList;
    }

    public boolean createASNWithItems(ASN asn, List<ASNItem> items) throws SQLException {
        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            // Create ASN
            int asnId = createASNWithConnection(asn, connection);
            if (asnId == -1) {
                connection.rollback();
                return false;
            }

            // Add ASN items
            for (ASNItem item : items) {
                item.setAsnId(asnId);
                if (!addASNItemWithConnection(item, connection)) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    // Log error
                }
            }
        }
    }

    // Private versions that use an existing connection for transaction management
    private int createASNWithConnection(ASN asn, Connection connection) throws SQLException {
        String sql = "INSERT INTO asn (supplier_id, reference_number, expected_arrival_date, status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, asn.getSupplierId());
            stmt.setString(2, asn.getReferenceNumber());
            stmt.setDate(3, new java.sql.Date(asn.getExpectedArrivalDate().getTime()));
            stmt.setString(4, "pending");

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        }
    }

    private boolean addASNItemWithConnection(ASNItem item, Connection connection) throws SQLException {
        String sql = "INSERT INTO asn_items (asn_id, product_id, weight_id, expected_quantity) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, item.getAsnId());
            stmt.setInt(2, item.getProductId());
            stmt.setInt(3, item.getWeightId());
            stmt.setInt(4, item.getExpectedQuantity());

            return stmt.executeUpdate() > 0;
        }
    }

    private ASN mapASNFromResultSet(ResultSet rs) throws SQLException {
        ASN asn = new ASN();
        asn.setAsnId(rs.getInt("asn_id"));
        asn.setSupplierId(rs.getInt("supplier_id"));
        asn.setReferenceNumber(rs.getString("reference_number"));
        asn.setExpectedArrivalDate(rs.getDate("expected_arrival_date"));
        asn.setStatus(rs.getString("status"));
        asn.setCreatedAt(rs.getTimestamp("created_at"));

        Supplier supplier = new Supplier(
                rs.getInt("supplier_id"),
                rs.getString("name"),
                rs.getString("contact_person"),
                rs.getString("phone"),
                rs.getString("email")
        );
        asn.setSupplier(supplier);

        return asn;
    }

    public boolean updateASN(ASN asn) throws SQLException {
        String sql = "UPDATE asn SET supplier_id = ?, reference_number = ?, expected_arrival_date = ? WHERE asn_id = ?";
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, asn.getSupplierId());
            stmt.setString(2, asn.getReferenceNumber());
            stmt.setDate(3, new java.sql.Date(asn.getExpectedArrivalDate().getTime()));
            stmt.setInt(4, asn.getAsnId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateASNItem(ASNItem item) throws SQLException {
        String sql = "UPDATE asn_items SET product_id = ?, weight_id = ?, expected_quantity = ? WHERE asn_item_id = ?";
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, item.getProductId());
            stmt.setInt(2, item.getWeightId());
            stmt.setInt(3, item.getExpectedQuantity());
            stmt.setInt(4, item.getAsnItemId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteASNItem(int asnItemId) throws SQLException {
        String sql = "DELETE FROM asn_items WHERE asn_item_id = ?";
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, asnItemId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateASNWithItems(ASN asn, List<ASNItem> items) throws SQLException {
        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            // Update ASN
            if (!updateASNWithConnection(asn, connection)) {
                connection.rollback();
                return false;
            }

            // Update/Add/Delete ASN items
            for (ASNItem item : items) {
                if (item.getAsnItemId() > 0) {
                    // Existing item - update
                    if (!updateASNItemWithConnection(item, connection)) {
                        connection.rollback();
                        return false;
                    }
                } else {
                    // New item - add
                    item.setAsnId(asn.getAsnId());
                    if (!addASNItemWithConnection(item, connection)) {
                        connection.rollback();
                        return false;
                    }
                }
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    // Log error
                }
            }
        }
    }

    private boolean updateASNWithConnection(ASN asn, Connection connection) throws SQLException {
        String sql = "UPDATE asn SET supplier_id = ?, reference_number = ?, expected_arrival_date = ? WHERE asn_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, asn.getSupplierId());
            stmt.setString(2, asn.getReferenceNumber());
            stmt.setDate(3, new java.sql.Date(asn.getExpectedArrivalDate().getTime()));
            stmt.setInt(4, asn.getAsnId());

            return stmt.executeUpdate() > 0;
        }
    }

    private boolean updateASNItemWithConnection(ASNItem item, Connection connection) throws SQLException {
        String sql = "UPDATE asn_items SET product_id = ?, weight_id = ?, expected_quantity = ? WHERE asn_item_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, item.getProductId());
            stmt.setInt(2, item.getWeightId());
            stmt.setInt(3, item.getExpectedQuantity());
            stmt.setInt(4, item.getAsnItemId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Remove the close() method as it's no longer needed
}