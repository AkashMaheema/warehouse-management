<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.warehouse.config.DBConnection" %>
<%@ page import="java.util.*" %>
<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="dashboard" />
    <jsp:param name="activePage" value="index" />
    <jsp:param name="content" value="index" />
</jsp:include>
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
    <style>
         margin-top: var(--header-height);
         margin-left: var(--sidebar-width);
         padding: 20px;
    </style>
</head>
<body>
<div id="content">
<div class="container mt-4">
    <h2 class="mb-4">📦 Araliya Warehouse Dashboard</h2>
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
            <li class="list-group-item"><a class="text-decoration-none" href="StockIn">➕ Add Stock</a></li>
            <li class="list-group-item"><a class="text-decoration-none" href="Stocks">➕ Pending Stock</a></li>
        </ul>
    </div>
</div>
</div>
</body>
</html>

