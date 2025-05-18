package com.warehouse.models;

import java.sql.Date;
import java.util.List;


public class StockOutItem {
    private int id;
    private int stockOutId;
    private int productId;
    private String productName;
    private int categoryId;
    private int weightId;
    private int quantity;
    private Date expireDate;
    private int zoneId;
    private String zoneName;
    private int rackId;
    private String rackName;
    private List<Inventory> locations;

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStockOutId() {
        return stockOutId;
    }

    public void setStockOutId(int stockOutId) {
        this.stockOutId = stockOutId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getWeightId() {
        return weightId;
    }

    public void setWeightId(int weightId) {
        this.weightId = weightId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getExpireDate() {
        return expireDate;
    }

    public void setExpireDate(Date expireDate) {
        this.expireDate = expireDate;
    }

    public int getZoneId() {
        return zoneId;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    public int getRackId() {
        return rackId;
    }

    public void setRackId(int rackId) {
        this.rackId = rackId;
    }

    public String getRackName() {
        return rackName;
    }

    public void setRackName(String rackName) {
        this.rackName = rackName;
    }

    public List<Inventory> getLocations() {
        return locations;
    }

    public void setLocations(List<Inventory> locations) {
        this.locations = locations;
    }

}