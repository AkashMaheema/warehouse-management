package com.warehouse.models;

public class Rack {
    private int rackId;
    private int zoneId;
    private String rackName;
    private int rackCapacity;
    private int usedCapacity;

    public Rack(int rackId, int zoneId, String rackName, int rackCapacity, int usedCapacity) {
        this.rackId = rackId;
        this.zoneId = zoneId;
        this.rackName = rackName;
        this.rackCapacity = rackCapacity;
        this.usedCapacity = usedCapacity;
    }

    // Getters and Setters
    public int getRackId() {
        return rackId;
    }

    public void setRackId(int rackId) {
        this.rackId = rackId;
    }

    public int getZoneId() {
        return zoneId;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public String getRackName() {
        return rackName;
    }

    public void setRackName(String rackName) {
        this.rackName = rackName;
    }

    public int getRackCapacity() {
        return rackCapacity;
    }

    public void setRackCapacity(int rackCapacity) {
        this.rackCapacity = rackCapacity;
    }

    public int getUsedCapacity() {
        return usedCapacity;
    }

    public void setUsedCapacity(int usedCapacity) {
        this.usedCapacity = usedCapacity;
    }
}
