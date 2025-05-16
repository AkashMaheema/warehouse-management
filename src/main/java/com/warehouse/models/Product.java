package com.warehouse.models;

public class Product {
    private int productId;
    private String productName;
    private int categoryId;
    private int weightId;
    private int reorderLevel;
    private int CurrentStock;
    private String categoryName;
    private double weightValue;

    public Product() {

    }

    public Product(String productName, int categoryId, int weightId, int reorderLevel) {
        this.productName= productName;
        this.categoryId = categoryId;
        this.weightId= weightId;
        this.reorderLevel=reorderLevel;
    }

    public Product(int productId, String productName, int categoryId, int weightId, int reorderLevel) {
        this.productId = productId;
        this.productName = productName;
        this.categoryId = categoryId;
        this.weightId = weightId;
        this.reorderLevel = reorderLevel;
    }

    public int getReorderLevel() {
        return reorderLevel;
    }

    public void setReorderLevel(int reorderLevel) {
        this.reorderLevel = reorderLevel;
    }

    public int getWeightId() {
        return weightId;
    }

    public void setWeightId(int weightId) {
        this.weightId = weightId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public double getWeightValue() {
        return weightValue;
    }

    public void setWeightValue(double weightValue) {
        this.weightValue = weightValue;
    }

    public int getCurrentStock() {
        return CurrentStock;
    }

    public void setCurrentStock(int currentStock) {
        CurrentStock = currentStock;
    }
}

