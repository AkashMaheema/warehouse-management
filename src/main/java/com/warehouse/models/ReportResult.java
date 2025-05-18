package models;

import java.util.Date;

public class ReportResult {
    private String productName;
    private String categoryName;
    private double weight;
    private int quantity;
    private Date expiryDate;
    private Date arrivalDate;
    private int stockIn;
    private int stockOut;

    // Constructors
    public ReportResult() {
    }

    // Constructor for inventory report
    public ReportResult(String productName, String categoryName, double weight, int quantity, Date expiryDate, Date arrivalDate) {
        this.productName = productName;
        this.categoryName = categoryName;
        this.weight = weight;
        this.quantity = quantity;
        this.expiryDate = expiryDate;
        this.arrivalDate = arrivalDate;
    }

    // Constructor for stock movement report
    public ReportResult(String productName, String categoryName, int stockIn, int stockOut) {
        this.productName = productName;
        this.categoryName = categoryName;
        this.stockIn = stockIn;
        this.stockOut = stockOut;
    }

    // Getters and Setters
    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public Date getArrivalDate() {
        return arrivalDate;
    }

    public void setArrivalDate(Date arrivalDate) {
        this.arrivalDate = arrivalDate;
    }

    public int getStockIn() {
        return stockIn;
    }

    public void setStockIn(int stockIn) {
        this.stockIn = stockIn;
    }

    public int getStockOut() {
        return stockOut;
    }

    public void setStockOut(int stockOut) {
        this.stockOut = stockOut;
    }

    // Helper method to format date for display
    public String getFormattedExpiryDate() {
        if (expiryDate != null) {
            return new java.text.SimpleDateFormat("yyyy-MM-dd").format(expiryDate);
        }
        return "";
    }

    public String getFormattedArrivalDate() {
        if (arrivalDate != null) {
            return new java.text.SimpleDateFormat("yyyy-MM-dd").format(arrivalDate);
        }
        return "";
    }
}