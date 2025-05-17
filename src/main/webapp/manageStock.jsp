<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Category" %>
<%@ page import="com.warehouse.dao.CategoryDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageStock" />
    <jsp:param name="activePage" value="manageStock" />
    <jsp:param name="content" value="manageStock" />
</jsp:include>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Stock Approvals</title>
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
     <link rel="stylesheet" href="css/style.css">
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
    <div class="container">
            <h2 class="category-heading">Stock Approvals</h2>

     <a class="btn btn-primary mb-3 text-decoration-none" href="StockIn">Add Stock</a>


        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>
        <div class="table-container">
        <table class="table table-bordered table-hover">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Supplier</th>
                    <th>Arrival Date</th>
                    <th>Created Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${Stocks}" var="stock">
                    <tr>
                        <td>${stock.id}</td>
                        <td>${stock.supplierName}</td>
                        <td>${stock.arrivalDate}</td>
                        <td>${stock.createdDate}</td>
                        <td>${stock.status}</td>

                        <td class="action-btns">
                            <!-- Always show View button, using POST -->
                                <form action="StockIn" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="view">
                                    <input type="hidden" name="id" value="${stock.id}">
                                    <input type="hidden" name="disableUpdate" value="${stock.status != 'pending'}">
                                    <button type="submit" class="btn btn-sm btn-primary">View</button>
                                </form>

                            <!-- Show Approve and Reject buttons only if status is 'pending' -->
                            <c:if test="${stock.status == 'pending'}">
                                <form action="Stocks" method="post" style="display: inline;">
                                    <input type="hidden" name="stockInId" value="${stock.id}">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                </form>

                                <form action="Stocks" method="post" style="display: inline;">
                                    <input type="hidden" name="stockInId" value="${stock.id}">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>