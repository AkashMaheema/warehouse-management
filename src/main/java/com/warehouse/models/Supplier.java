package com.warehouse.models;

// Supplier.java
public class Supplier {
    private int supplierid;
    private String supplier;

    public Supplier(int supplierid, String supplier) {
        this.supplierid = supplierid;
        this.supplier = supplier;
    }

    public int getSupplierid() { return supplierid; }
    public String getSupplier() { return supplier; }
}

