package com.warehouse.models;

// Zone.java
public class Zone {
    private int zoneid;
    private String zone;

    public Zone(int zoneid, String zone) {
        this.zoneid = zoneid;
        this.zone = zone;
    }

    public int getZoneid() { return zoneid; }
    public String getZone() { return zone; }
}

