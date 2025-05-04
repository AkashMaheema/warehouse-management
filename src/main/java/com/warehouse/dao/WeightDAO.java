package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.model.Weight;

import java.sql.*;
import java.util.*;

public class WeightDAO {
    private final Connection conn;
    {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Add a new weight
    public boolean add(double weightValue) {
        String sql = "INSERT INTO weights(weight_value) VALUES(?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, weightValue);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update weight
    public boolean update(int weightId, double weightValue) {
        String sql = "UPDATE weights SET weight_value=? WHERE weight_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, weightValue);
            ps.setInt(2, weightId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete weight
    public boolean delete(int weightId) {
        String sql = "DELETE FROM weights WHERE weight_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, weightId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all weights
    public List<Weight> getAll() {
        List<Weight> list = new ArrayList<>();
        String sql = "SELECT * FROM weights ORDER BY weight_id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Weight weight = new Weight(
                        rs.getInt("weight_id"),
                        rs.getDouble("weight_value")
                );
                list.add(weight);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
