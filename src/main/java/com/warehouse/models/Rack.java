package com.warehouse.models;

// Rack.java
public class Rack {
    private int rackid;
    private String rack;

    public Rack(int rackid, String rack) {
        this.rackid = rackid;
        this.rack = rack;
    }

    public int getRackid() { return rackid; }
    public String getRack() { return rack; }
}

