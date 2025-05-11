package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.Zone;

import java.sql.*;
import java.util.*;

public class ZoneDAO {
    private final Connection conn;

    public ZoneDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean add(String name, int capacity, int used) {
        String sql = "INSERT INTO zones (zone_name, zone_capacity, used_capacity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, capacity);
            ps.setInt(3, used);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(int id, String name, int capacity, int used) {
        String sql = "UPDATE zones SET zone_name=?, zone_capacity=?, used_capacity=? WHERE zone_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, capacity);
            ps.setInt(3, used);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM zones WHERE zone_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Zone> getAll() {
        List<Zone> list = new ArrayList<>();
        String sql = "SELECT * FROM zones ORDER BY zone_id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Zone z = new Zone(
                        rs.getInt("zone_id"),
                        rs.getString("zone_name"),
                        rs.getInt("zone_capacity"),
                        rs.getInt("used_capacity")
                );
                list.add(z);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}