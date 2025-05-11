package com.warehouse.models;

import java.sql.Date;

public class StockItem {
    private int id;
    private int stockInId;
    private int productId;
    private int quantity;
    private int zoneId;
    private int rackId;
    private Date expireDate;

    // Default constructor
    public StockItem() {
    }

    // Getters
    public int getId() {
        return id;
    }

    public int getStockInId() {
        return stockInId;
    }

    public int getProductId() {
        return productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public int getZoneId() {
        return zoneId;
    }

    public int getRackId() {
        return rackId;
    }

    public Date getExpireDate() {
        return expireDate;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setStockInId(int stockInId) {
        this.stockInId = stockInId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public void setRackId(int rackId) {
        this.rackId = rackId;
    }

    public void setExpireDate(Date expireDate) {
        this.expireDate = expireDate;
    }
}