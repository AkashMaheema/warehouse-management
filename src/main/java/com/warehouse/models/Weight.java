package com.warehouse.models;

public class Weight {
    private int weightId;
    private double weightValue;

    public Weight(int weightId, double weightValue) {
        this.weightId = weightId;
        this.weightValue = weightValue;
    }

    // Getters and Setters
    public int getWeightId() {
        return weightId;
    }

    public void setWeightId(int weightId) {
        this.weightId = weightId;
    }

    public double getWeightValue() {
        return weightValue;
    }

    public void setWeightValue(double weightValue) {
        this.weightValue = weightValue;
    }
}
