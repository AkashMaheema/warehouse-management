package com.warehouse.models;

public class Zone {
    private int zoneId;
    private String zoneName;
    private int zoneCapacity;
    private int usedCapacity;

    public Zone(int zoneId, String zoneName, int zoneCapacity, int usedCapacity) {
        this.zoneId = zoneId;
        this.zoneName = zoneName;
        this.zoneCapacity = zoneCapacity;
        this.usedCapacity = usedCapacity;
    }
    public Zone() {
        // Default constructor needed for JSP EL
    }

    // Getters and setters
    public int getZoneId() {
        return zoneId;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    public int getZoneCapacity() {
        return zoneCapacity;
    }

    public void setZoneCapacity(int zoneCapacity) {
        this.zoneCapacity = zoneCapacity;
    }

    public int getUsedCapacity() {
        return usedCapacity;
    }

    public void setUsedCapacity(int usedCapacity) {
        this.usedCapacity = usedCapacity;
    }
}

