package com.warehouse.models;

public class IncidentItem {
    private int id;
    private int asnItemId;
    private String incidentType; // "damaged" or "missing"
    private int incidentQuantity;
    private ASNItem asnItem; // Reference to the original ASN item

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getAsnItemId() { return asnItemId; }
    public void setAsnItemId(int asnItemId) { this.asnItemId = asnItemId; }
    public String getIncidentType() { return incidentType; }
    public void setIncidentType(String incidentType) { this.incidentType = incidentType; }
    public int getIncidentQuantity() { return incidentQuantity; }
    public void setIncidentQuantity(int incidentQuantity) { this.incidentQuantity = incidentQuantity; }
    public ASNItem getAsnItem() { return asnItem; }
    public void setAsnItem(ASNItem asnItem) { this.asnItem = asnItem; }
}