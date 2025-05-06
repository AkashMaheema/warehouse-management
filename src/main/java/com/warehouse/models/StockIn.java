package com.warehouse.models;

import java.sql.Date;
import java.util.List;

public class StockIn {
    private int id;
    private int supplierId;
    private Date arrivalDate;
    private List<StockItem> items;

    // Default constructor
    public StockIn() {
    }

    // Getters
    public int getId() {
        return id;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public Date getArrivalDate() {
        return arrivalDate;
    }

    public List<StockItem> getItems() {
        return items;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public void setArrivalDate(Date arrivalDate) {
        this.arrivalDate = arrivalDate;
    }

    public void setItems(List<StockItem> items) {
        this.items = items;
    }
}