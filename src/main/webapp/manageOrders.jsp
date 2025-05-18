<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageOrders" />
    <jsp:param name="activePage" value="manageOrders" />
    <jsp:param name="content" value="manageOrders" />
</jsp:include>
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
    <div class="container">
            <h2 class="category-heading">Order Management</h2>

            <!-- Add Order Button -->
            <div class="d-flex justify-content-end mb-3">
                <a class="btn btn-primary mb-3 mr-2 custom-add-btn" href="StockOut?action=new">Add New Order</a>
                <a class="btn btn-primary mb-3 custom-add-btn" href="StockOut?action=pending">Add New Order</a>
            </div>

            <!-- Tab Buttons -->
            <div class="mb-4 text-center">
                <button class="tab-btn me-2" data-tab="pending" onclick="showTab('pending')">Pending</button>
                <button class="tab-btn me-2" data-tab="picking" onclick="showTab('picking')">Picking</button>
                <button class="tab-btn me-2" data-tab="packing" onclick="showTab('packing')">Packing</button>
                <button class="tab-btn" data-tab="delivered" onclick="showTab('delivered')">Delivered</button>
            </div>

        <table class="table table-bordered table-hover">
            <thead class="thead-light">
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Dispatch Date</th>
                    <th>Status</th>
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