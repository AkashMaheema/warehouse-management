package com.warehouse.models;

public class Supplier {

    private int supplierId;
    private String name;
    private String contactPerson;
    private String phone;
    private String email;

    public Supplier(int supplierId, String name, String contactPerson, String phone, String email) {
        this.supplierId = supplierId;
        this.name = name;
        this.contactPerson = contactPerson;
        this.phone = phone;
        this.email = email;
    }

    // Getters and setters
    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}

