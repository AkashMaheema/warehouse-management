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
    <h3>Create Reorder Request</h3>

    <form action="ReorderServlet" method="post">
        <div class="mb-3">
            <label for="supplierId" class="form-label">Select Supplier</label>
            <select name="supplierId" id="supplierId" class="form-select" required>
                <c:forEach var="s" items="${suppliers}">
                    <option value="${s.supplierId}">${s.name}</option>
                </c:forEach>
            </select>
        </div>

        <h5>Selected Product (Auto-filled)</h5>
        <table class="table">
            <thead>
            <tr><th>Product</th><th>Current Stock</th><th>Reorder Qty</th></tr>
            </thead>
            <tbody>
            <tr>
                <td><input type="hidden" name="productIds" value="${selectedProduct.productId}" />${selectedProduct.productName}</td>
                <td>${selectedProduct.currentStock}</td>
                <td><input type="number" name="quantities" class="form-control" value="${selectedProduct.reorderLevel}" required /></td>
            </tr>
            </tbody>
        </table>

        <h5 class="mt-4">Other Low Stock Products</h5>
        <table class="table table-striped">
            <thead>
            <tr><th>Add</th><th>Product</th><th>Stock</th><th>Reorder Qty</th></tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${lowStockProducts}">
                <c:if test="${p.productId != selectedProduct.productId}">
                    <tr>
                        <td>
                            <input type="checkbox" name="addProduct" value="${p.productId}" class="form-check-input" />
                        </td>
                        <td>${p.productName}</td>
                        <td>${p.currentStock}</td>
                        <td>
                            <input type="number" name="qty_${p.productId}" class="form-control" value="${p.reorderLevel}" />
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
            </tbody>
        </table>

        <button type="submit" class="btn btn-primary">Send Reorder Request</button>
    </form>
</div>
</body>
</html>
