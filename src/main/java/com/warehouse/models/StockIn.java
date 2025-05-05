package com.warehouse.models;

import java.sql.Date;

public class StockIn {
    private String supplier;
    private String productName;
    private String category;
    private double weight;
    private int quantity;
    private Date expireDate;
    private String zone;
    private String rack;
    private Date arrivalDate;

    // Getters and Setters
    public String getSupplier() { return supplier; }
    public void setSupplier(String supplier) { this.supplier = supplier; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getExpireDate() { return expireDate; }
    public void setExpireDate(Date expireDate) { this.expireDate = expireDate; }

    public String getZone() { return zone; }
    public void setZone(String zone) { this.zone = zone; }

    public String getRack() { return rack; }
    public void setRack(String rack) { this.rack = rack; }

    public Date getArrivalDate() { return arrivalDate; }
    public void setArrivalDate(Date arrivalDate) { this.arrivalDate = arrivalDate; }


}
