<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.warehouse.models.Inventory" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Inventory List</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">Inventory List</h2>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
    </c:if>
    <table class="table table-bordered table-hover">
        <thead class="table-dark">
        <tr>
            <th>#</th>
            <th>Product</th>
            <th>Zone</th>
            <th>Rack</th>
            <th>Quantity</th>
            <th>Expiry Date</th>
            <th>Arrival Date</th>
            <th>Holding Time (days)</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="inv" items="${inventoryList}" varStatus="loop">
            <tr>
                <td>${loop.index + 1}</td>
                <td>${inv.productName}</td>
                <td>${inv.zoneName}</td>
                <td>${inv.rackName}</td>
                <td>${inv.quantity}</td>
                <td>${inv.expiryDate}</td>
                <td>${inv.arrivalDate}</td>
                <td>${inv.holdingTime}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
