package com.warehouse.dao;

import com.warehouse.config.DBConnection;
import com.warehouse.models.StockIn;
import com.warehouse.models.Rack;
import com.warehouse.models.Zone;

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

    public List<Zone> getZoneList() {
        List<Zone> list = new ArrayList<>();
        String sql = "SELECT zone_id, zone_name FROM zones";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Zone(rs.getInt("zone_id"), rs.getString("zone_name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Rack> getRackList() {
        List<Rack> list = new ArrayList<>();
        String sql = "SELECT rack_id, rack_name FROM racks";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Rack(rs.getInt("rack_id"), rs.getString("rack_name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public List<String> getSupplierList() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT name FROM suppliers";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public boolean insertStockIn(StockIn stock) {
        String sqlMain = "INSERT INTO stock_in (supplier_id, arrival_date) VALUES (?, ?)";
        String sqlDetails = "INSERT INTO stock_contain_items (stock_in_id, product_id, quantity, zone_id, rack_id, expire_date) VALUES (?, ?, ?, ?, ?, ?)";

        try (
                PreparedStatement psMain = conn.prepareStatement(sqlMain, Statement.RETURN_GENERATED_KEYS);
                PreparedStatement psDetails = conn.prepareStatement(sqlDetails)
        ) {
            // Insert into main table
            psMain.setString(1, stock.getSupplier());
            psMain.setDate(2, stock.getArrivalDate());
            psMain.executeUpdate();

            // Get generated stock_in_id
            ResultSet rs = psMain.getGeneratedKeys();
            if (rs.next()) {
                int stockInId = rs.getInt(1);

                // Insert into details table
                psDetails.setInt(1, stockInId);
                psDetails.setString(2, stock.getProductName());  // Assume this is product_id
                psDetails.setInt(3, stock.getQuantity());
                psDetails.setString(4, stock.getZone());         // Assuming zone_id
                psDetails.setString(5, stock.getRack());         // Assuming rack_id
                psDetails.setDate(6, stock.getExpireDate());


                return psDetails.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
