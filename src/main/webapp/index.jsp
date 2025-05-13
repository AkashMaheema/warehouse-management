<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.warehouse.config.DBConnection" %>
<%@ page import="java.util.*" %>
<%
    Connection conn = DBConnection.getConnection();
    int productCount = 0, lowStockCount = 0;
    try {
        Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM products");
        if (rs1.next()) productCount = rs1.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body class="container mt-4">
    <div class="container-fluid">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h2 class="mb-4">📦 Araliya Warehouse Dashboard</h2>
        </div>
        <div class="row">
            <div class="col-md-4">
                <div class="card text-white bg-primary mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Total Products</h5>
                        <p class="card-text fs-3"><%= productCount %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
        </div>
        <div class="mt-4">
            <h4>Quick Links</h4>
            <ul class="list-group">
                <li class="list-group-item"><a class="text-decoration-none" href="manageCategory">➕ Manage Category</a></li>
                <li class="list-group-item"><a class="text-decoration-none" href="manageWeights">➕ Manage Weight</a></li>
                <li class="list-group-item"><a class="text-decoration-none" href="manageProduct">➕ Manage Product</a></li>
                <li class="list-group-item"><a class="text-decoration-none" href="manageSupplier">➕ Manage Supplier</a></li>
                <li class="list-group-item"><a class="text-decoration-none" href="manageRacks">➕ Manage Racks</a></li>
                <li class="list-group-item"><a class="text-decoration-none" href="manageZone">➕ Manage Zone</a></li>
                <li class="list-group-item"><a class="text-decoration-none" href="Stocks">➕ Manage Stock</a></li>
                <li class="list-group-item"><a class="text-decoration-none" href="Inventory">➕ Inventory</a></li>
            </ul>
        </div>
    </div>
</body>
</html>
