package com.warehouse.models;

import java.sql.Date;
import java.util.List;

public class StockIn {
    private int id;
    private Date arrivalDate;
    private List<StockItem> items;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    private String status;

    // Default constructor
    public StockIn() {
    }

    // Getters
    public int getId() {
        return id;
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


    public void setArrivalDate(Date arrivalDate) {
        this.arrivalDate = arrivalDate;
    }

    public void setItems(List<StockItem> items) {
        this.items = items;
    }
}