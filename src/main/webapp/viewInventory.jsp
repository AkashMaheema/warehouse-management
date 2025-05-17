<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.warehouse.models.Inventory" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageCategory" />
    <jsp:param name="activePage" value="manageCategory" />
    <jsp:param name="content" value="manageCategory" />
</jsp:include>

<!DOCTYPE html>
<html>
<head>
    <title>Inventory List</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container">
        <h2 class="category-heading">Inventory List</h2>
    <c:if test="${not empty param.success}">
        <div class="alert alert-success">${param.success}</div>
    </c:if>
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
    <h4 class="mt-5">Stock Level Summary</h4>
    <table class="table table-bordered table-striped">
        <thead class="table-secondary">
            <tr>
                <th>#</th>
                <th>Product</th>
                <th>Total Quantity</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="entry" items="${stockLevels}" varStatus="loop">
            <tr>
                <td>${loop.index + 1}</td>
                <td>${entry.key}</td>
                <td>${entry.value}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <h4 class="mt-5 text-danger">Reorder Notifications</h4>
    <c:if test="${not empty reorderList}">
        <table class="table table-bordered table-warning">
            <thead class="table-danger">
                <tr>
                    <th>#</th>
                    <th>Product</th>
                    <th>Reorder Level</th>
                    <th>Current Stock</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="product" items="${reorderList}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td>${product.productName}</td>
                    <td>${product.reorderLevel}</td>
                    <td>
                        <c:out value="${stockLevels[product.productName]}" default="0"/>
                    </td>
                    <td><span class="badge bg-danger">Reorder Needed</span></td>
                    <td>
                        <form action="ReorderServlet" method="get">
                            <input type="hidden" name="productId" value="${product.productId}" />
                            <button type="submit" class="btn btn-sm btn-danger">Reorder</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty reorderList}">
        <div class="alert alert-success">No products need reordering.</div>
    </c:if>
</div>
</body>
</html>
