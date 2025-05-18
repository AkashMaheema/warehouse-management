<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock Out Requests</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .badge-pending { background-color: #ffc107; color: #000; }
        .badge-approved { background-color: #007bff; color: #fff; }
        .badge-dispatched { background-color: #28a745; color: #fff; }
        .badge-rejected { background-color: #dc3545; color: #fff; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3>Stock Out Requests</h3>
            <a href="StockOut?action=new" class="btn btn-primary">Create New Request</a>
            <a href="StockOut?action=pending" class="btn btn-info">
                <i class="fas fa-clipboard-check"></i> Pending Approvals
            </a>
        </div>

        <table class="table table-bordered table-hover">
            <thead class="thead-light">
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Dispatch Date</th>
                    <th>Status</th>
                    <th>Items</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="stockOut" items="${stockOutList}">
                    <tr>
                        <td>${stockOut.id}</td>
                        <td>${stockOut.customerName}</td>
                        <td>${stockOut.dispatchDate}</td>
                        <td>
                            <span class="badge badge-${stockOut.status}">
                                ${stockOut.status}
                            </span>
                        </td>
                        <td>
                            <ul class="mb-0">
                                <c:forEach var="item" items="${stockOut.items}">
                                    <li>${item.productName} (${item.quantity})</li>
                                </c:forEach>
                            </ul>
                        </td>
                        <td>
                            <a href="StockOut?action=view&id=${stockOut.id}"
                               class="btn btn-sm btn-info">View</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>