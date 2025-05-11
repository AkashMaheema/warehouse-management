package com.warehouse.models;

public class ASNItem {
    private int asnItemId;
    private int asnId;
    private int productId;
    private Product product;
    private int weightId;
    private Weight weight;
    private int expectedQuantity;

    // Constructors
    public ASNItem() {
    }

    public ASNItem(int asnId, int productId, int weightId, int expectedQuantity) {
        this.asnId = asnId;
        this.productId = productId;
        this.weightId = weightId;
        this.expectedQuantity = expectedQuantity;
    }

    // Getters and Setters
    public int getAsnItemId() {
        return asnItemId;
    }

    public void setAsnItemId(int asnItemId) {
        this.asnItemId = asnItemId;
    }

    public int getAsnId() {
        return asnId;
    }

    public void setAsnId(int asnId) {
        this.asnId = asnId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getWeightId() {
        return weightId;
    }

    public void setWeightId(int weightId) {
        this.weightId = weightId;
    }

    public Weight getWeight() {
        return weight;
    }

    public void setWeight(Weight weight) {
        this.weight = weight;
    }

    public int getExpectedQuantity() {
        return expectedQuantity;
    }

    public void setExpectedQuantity(int expectedQuantity) {
        this.expectedQuantity = expectedQuantity;
    }

    @Override
    public String toString() {
        return "ASNItem{" +
                "asnItemId=" + asnItemId +
                ", asnId=" + asnId +
                ", productId=" + productId +
                ", weightId=" + weightId +
                ", expectedQuantity=" + expectedQuantity +
                '}';
    }
}