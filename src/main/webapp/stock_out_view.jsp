<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Stock Out</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
</head>
<body>
    <div class="container mt-5">
        <h3>Stock Out Request #${stockOut.id}</h3>

        <div class="card mb-4">
            <div class="card-header">
                <h5>Request Details</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <p><strong>Customer:</strong> ${stockOut.customerName}</p>
                    </div>
                    <div class="col-md-4">
                        <p><strong>Dispatch Date:</strong> ${stockOut.dispatchDate}</p>
                    </div>
                    <div class="col-md-4">
                        <p><strong>Status:</strong>
                            <span class="badge ${stockOut.status == 'pending' ? 'badge-warning' :
                                              stockOut.status == 'approved' ? 'badge-primary' :
                                              'badge-success'}">
                                ${stockOut.status}
                            </span>
                        </p>
                    </div>
                </div>
                <c:if test="${not empty stockOut.orderId}">
                    <div class="row">
                        <div class="col-md-4">
                            <p><strong>Order ID:</strong> ${stockOut.orderId}</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header">
                <h5>Items</h5>
            </div>
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Weight</th>
                            <th>Quantity</th>
                            <th>Expiry Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${stockOut.items}">
                            <tr>
                                <td>${productMap[item.productId].productName}</td>
                                <td>${weightMap[item.weightId].weightValue} Kg</td>
                                <td>${item.quantity}</td>
                                <td>${item.expireDate}</td>
                                <td>
                                    <a href="StockOut?action=locations&id=${stockOut.id}&productId=${item.productId}"
                                       class="btn btn-sm btn-info">
                                        View Locations
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="text-center mb-4">
            <c:if test="${stockOut.status == 'pending' && !disableUpdate}">
                <form action="StockOut" method="post" style="display: inline-block;">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="stockOutId" value="${stockOut.id}">
                    <button type="submit" class="btn btn-success">Approve</button>
                </form>
            </c:if>
            <c:if test="${stockOut.status == 'approved' && !disableUpdate}">
                <button onclick="dispatchStockOut(${stockOut.id})" class="btn btn-primary">
                    Mark as Dispatched
                </button>
            </c:if>
            <a href="StockOut" class="btn btn-secondary">Back to List</a>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
        function dispatchStockOut(stockOutId) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, dispatch it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: 'StockOut',
                        type: 'POST',
                        data: {
                            action: 'dispatch',
                            stockOutId: stockOutId
                        },
                        success: function(response) {
                            if (response.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Success',
                                    text: response.message
                                }).then(() => {
                                    location.reload();
                                });
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Dispatch Failed',
                                    text: response.message
                                });
                            }
                        },
                        error: function(xhr) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'An error occurred while processing your request'
                            });
                        }
                    });
                }
            });
        }
        </script>
</body>
</html>