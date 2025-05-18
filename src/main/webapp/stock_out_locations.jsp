<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock Locations</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h3>Stock Locations for Request #${stockOut.id}</h3>

        <!-- Show which product we're viewing locations for -->
        <div class="alert alert-info mb-4">
            Viewing stock locations for:
            <c:forEach var="item" items="${stockOut.items}">
                <c:if test="${item.productId == productId}">
                    <strong>${item.productName}</strong> (Requested: ${item.quantity})
                </c:if>
            </c:forEach>
        </div>

        <div class="card mb-4">
            <div class="card-header">
                <h5>Available Stock Locations</h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty inventoryItems}">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Zone</th>
                                    <th>Rack</th>
                                    <th>Available Quantity</th>
                                    <th>Expiry Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${inventoryItems}">
                                    <tr>
                                        <td>${item.zoneName}</td>
                                        <td>${item.rackName}</td>
                                        <td>${item.quantity}</td>
                                        <td>${item.expiryDate}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning">
                            No stock available for this product in the warehouse.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="text-center mb-4">
            <a href="StockOut?action=view&id=${stockOut.id}" class="btn btn-secondary">Back to Request</a>
        </div>
    </div>
</body>
</html>