<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports</title>
    <style>
        .report-form { margin: 20px; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .report-results { margin: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; }
    </style>
</head>
<body>


    <div class="report-form">
        <h2>Generate Report</h2>
        <form action="ReportServlet" method="post">
            <input type="hidden" name="action" value="generate">

            <div>
                <label>Report Type:</label>
                <select name="reportType" required>
                    <option value="inventory">Inventory Report</option>
                    <option value="stockMovement">Stock Movement Report</option>
                </select>
            </div>

            <div>
                <label>Start Date:</label>
                <input type="date" name="startDate" required>
            </div>

            <div>
                <label>End Date:</label>
                <input type="date" name="endDate" required>
            </div>

            <div>
                <label>Category (optional):</label>
                <select name="categoryId">
                    <option value="">All Categories</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.category_id}">${category.category_name}</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label>Product (optional):</label>
                <select name="productId">
                    <option value="">All Products</option>
                    <c:forEach items="${products}" var="product">
                        <option value="${product.product_id}">${product.product_name}</option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit">Generate Report</button>
        </form>
    </div>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <c:if test="${not empty reportData}">
        <div class="report-results">
            <h2>${reportTitle} (${startDate} to ${endDate})</h2>

            <c:choose>
                <c:when test="${reportTitle eq 'Inventory Report'}">
                    <table>
                        <thead>
                            <tr>
                                <th>Product Name</th>
                                <th>Category</th>
                                <th>Weight</th>
                                <th>Quantity</th>
                                <th>Expiry Date</th>
                                <th>Arrival Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${reportData}" var="row">
                                <tr>
                                    <td>${row[0]}</td>
                                    <td>${row[1]}</td>
                                    <td>${row[2]}</td>
                                    <td>${row[3]}</td>
                                    <td>${row[4]}</td>
                                    <td>${row[5]}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:when test="${reportTitle eq 'Stock Movement Report'}">
                    <table>
                        <thead>
                            <tr>
                                <th>Product Name</th>
                                <th>Category</th>
                                <th>Stock In</th>
                                <th>Stock Out</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${reportData}" var="row">
                                <tr>
                                    <td>${row[0]}</td>
                                    <td>${row[1]}</td>
                                    <td>${row[2]}</td>
                                    <td>${row[3]}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
            </c:choose>

            <form action="ReportServlet" method="post" style="margin-top: 20px;">
                <input type="hidden" name="action" value="export">
                <input type="hidden" name="reportType" value="${param.reportType}">
                <input type="hidden" name="startDate" value="${param.startDate}">
                <input type="hidden" name="endDate" value="${param.endDate}">
                <input type="hidden" name="categoryId" value="${param.categoryId}">
                <input type="hidden" name="productId" value="${param.productId}">
                <button type="submit">Export to CSV</button>
            </form>
        </div>
    </c:if>
</body>
</html>