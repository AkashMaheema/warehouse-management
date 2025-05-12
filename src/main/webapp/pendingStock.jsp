<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Stock Approvals</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .table-hover tbody tr:hover {
            background-color: #f5f5f5;
        }
        .action-btns {
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h2>Pending Stock Approvals</h2>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <table class="table table-bordered table-hover">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Supplier</th>
                    <th>Arrival Date</th>
                    <th>Created Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${pendingStocks}" var="stock">
                    <tr>
                        <td>${stock.id}</td>
                        <td>${stock.supplierName}</td>
                        <td>${stock.arrivalDate}</td>
                        <td>${stock.createdDate}</td>
                        <td class="action-btns">
                            <a href="StockIn?action=view&id=${stock.id}" class="btn btn-sm btn-primary">View</a>
                            <form action="PendingStocks" method="post" style="display: inline;">
                                <input type="hidden" name="stockInId" value="${stock.id}">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="btn btn-sm btn-success">Approve</button>
                            </form>
                            <form action="PendingStocks" method="post" style="display: inline;">
                                <input type="hidden" name="stockInId" value="${stock.id}">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>