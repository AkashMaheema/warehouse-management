package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.Rack;

import java.sql.*;
import java.util.*;

public class RacksDAO {
    private final Connection conn;

    {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Add a new rack
    public boolean add(String rackName, int zoneId, int rackCapacity, int usedCapacity) {
        try {
            int zoneCapacity = 0;
            int totalInstalledRackCapacity = 0;

            // Step 1: Get zone's total capacity
            String zoneQuery = "SELECT zone_capacity FROM zones WHERE zone_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(zoneQuery)) {
                ps.setInt(1, zoneId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    zoneCapacity = rs.getInt("zone_capacity");
                }
            }

            // Step 2: Get total installed rack_capacity in the zone
            String capacitySumQuery = "SELECT SUM(rack_capacity) FROM racks WHERE zone_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(capacitySumQuery)) {
                ps.setInt(1, zoneId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    totalInstalledRackCapacity = rs.getInt(1);
                }
            }

            // Step 3: Check capacity before adding
            if ((totalInstalledRackCapacity + rackCapacity) > zoneCapacity) {
                System.out.println("Warning: Adding this rack will exceed the zone's total capacity!");
                return false;
            }

            // Step 4: Insert rack
            String sql = "INSERT INTO racks(rack_name, zone_id, rack_capacity, used_capacity) VALUES(?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, rackName);
                ps.setInt(2, zoneId);
                ps.setInt(3, rackCapacity);
                ps.setInt(4, usedCapacity);
                boolean success = ps.executeUpdate() > 0;

                if (success) {
                    new ZoneDAO().updateZoneUsedCapacity(zoneId);
                }

                return success;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    // Update rack
    public boolean update(int id, String rackName, int zoneId, int rackCapacity, int usedCapacity) {
        String sql = "UPDATE racks SET rack_name=?, zone_id=?, rack_capacity=?, used_capacity=? WHERE rack_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rackName);
            ps.setInt(2, zoneId);
            ps.setInt(3, rackCapacity);
            ps.setInt(4, usedCapacity);
            ps.setInt(5, id);
            boolean success = ps.executeUpdate() > 0;

            if (success) {
                new ZoneDAO().updateZoneUsedCapacity(zoneId);
            }

            return success;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    // Delete rack
    public boolean delete(int id) {
        int zoneId = -1;

        // Get the zoneId of the rack before deleting it
        String fetchSql = "SELECT zone_id FROM racks WHERE rack_id=?";
        try (PreparedStatement ps = conn.prepareStatement(fetchSql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                zoneId = rs.getInt("zone_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sql = "DELETE FROM racks WHERE rack_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            boolean success = ps.executeUpdate() > 0;

            if (success && zoneId != -1) {
                new ZoneDAO().updateZoneUsedCapacity(zoneId);
            }

            return success;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    // Get all racks
    public List<Rack> getAll() {
        List<Rack> list = new ArrayList<>();
        String sql = "SELECT * FROM racks ORDER BY rack_id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Rack rack = new Rack(
                        rs.getInt("rack_id"),
                        rs.getInt("zone_id"),
                        rs.getString("rack_name"),
                        rs.getInt("rack_capacity"),
                        rs.getInt("used_capacity")
                );
                list.add(rack);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get the zone ID of a rack
    public int getRackZoneId(int rackId) {
        String sql = "SELECT zone_id FROM racks WHERE rack_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rackId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("zone_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Method to update zone capacity after rack changes
    public void updateZoneCapacity(int zoneId) {
        int totalUsedCapacity = 0;
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT SUM(used_capacity) FROM racks WHERE zone_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, zoneId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    totalUsedCapacity = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try (Connection conn = DBConnection.getConnection()) {
            String updateQuery = "UPDATE zones SET used_capacity = ? WHERE zone_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateQuery)) {
                ps.setInt(1, totalUsedCapacity);
                ps.setInt(2, zoneId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getRackCapacity(int rackId) {
        int capacity = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT rack_capacity FROM racks WHERE rack_id = ?")) {
            stmt.setInt(1, rackId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                capacity = rs.getInt("rack_capacity");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return capacity;
    }

    public int getTotalRackCapacityInZone(int zoneId) {
        int total = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT SUM(rack_capacity) FROM racks WHERE zone_id = ?")) {
            stmt.setInt(1, zoneId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

}
