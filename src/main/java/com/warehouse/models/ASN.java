package com.warehouse.models;

import java.util.Date;
import java.util.List;

public class ASN {
    private int asnId;
    private int supplierId;
    private Supplier supplier;
    private String referenceNumber;
    private Date expectedArrivalDate;
    private String status; // pending, approved, rejected
    private Date createdAt;
    private List<ASNItem> items;

    // Constructors
    public ASN() {
    }

    public ASN(int supplierId, String referenceNumber, Date expectedArrivalDate, String status) {
        this.supplierId = supplierId;
        this.referenceNumber = referenceNumber;
        this.expectedArrivalDate = expectedArrivalDate;
        this.status = status;
    }

    // Getters and Setters
    public int getAsnId() {
        return asnId;
    }

    public void setAsnId(int asnId) {
        this.asnId = asnId;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public String getReferenceNumber() {
        return referenceNumber;
    }

    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }

    public Date getExpectedArrivalDate() {
        return expectedArrivalDate;
    }

    public void setExpectedArrivalDate(Date expectedArrivalDate) {
        this.expectedArrivalDate = expectedArrivalDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public List<ASNItem> getItems() {
        return items;
    }

    public void setItems(List<ASNItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "ASN{" +
                "asnId=" + asnId +
                ", supplierId=" + supplierId +
                ", referenceNumber='" + referenceNumber + '\'' +
                ", expectedArrivalDate=" + expectedArrivalDate +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", itemsCount=" + (items != null ? items.size() : 0) +
                '}';
    }
}