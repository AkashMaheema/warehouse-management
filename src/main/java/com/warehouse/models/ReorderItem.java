package com.warehouse.models;

import java.sql.Timestamp;

public class ReorderItem {
    private int reorderId;
    private int productId;
    private int quantity;
    private String status;
    private Timestamp reorderDate;

    public ReorderItem(int productId, int quantity) {
        this.productId = productId;
        this.quantity = quantity;
    }

    public ReorderItem() {

    }

    public int getProductId() {
        return productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getReorderId() {
        return reorderId;
    }

    public void setReorderId(int reorderId) {
        this.reorderId = reorderId;
    }

    public void setReorderDate(Timestamp reorderDate) {
        this.reorderDate = reorderDate;
    }

    public Timestamp getReorderDate() {
        return reorderDate;
    }
}

