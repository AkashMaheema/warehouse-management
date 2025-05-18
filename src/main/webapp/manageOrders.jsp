<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageOrders" />
    <jsp:param name="activePage" value="manageOrders" />
    <jsp:param name="content" value="manageOrders" />
</jsp:include>

<html>
<head>
    <title>Manage Orders</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>

<body>
    <div class="container">
        <h2 class="category-heading">Order Management</h2>

        <!-- Add Order Button -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-primary custom-add-btn" data-bs-toggle="modal" data-bs-target="#addOrderModal">Add New Order</button>
        </div>

        <!-- Tab Buttons -->
        <div class="mb-4 text-center">
            <button class="tab-btn me-2" data-tab="pending" onclick="showTab('pending')">Pending</button>
            <button class="tab-btn me-2" data-tab="picking" onclick="showTab('picking')">Picking</button>
            <button class="tab-btn me-2" data-tab="packing" onclick="showTab('packing')">Packing</button>
            <button class="tab-btn" data-tab="delivered" onclick="showTab('delivered')">Delivered</button>
        </div>



        <!-- Order Tables -->
        <div class="table-container">
            <!-- Pending -->
            <div id="pending" class="order-table">
                <table class="table table-bordered">
                    <thead>
                        <tr><th>Product</th><th>Weight</th><th>Quantity</th><th>Supplier</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${pendingOrders}">
                            <tr>
                                <td>${order.product}</td>
                                <td>${order.weight}</td>
                                <td>${order.quantity}</td>
                                <td>${order.supplier}</td>
                                <td><button class="btn btn-sm btn-success" onclick="updateOrder('${order.id}', 'picking')">Pick</button></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Picking -->
            <div id="picking" class="order-table d-none">
                <table class="table table-bordered">
                    <thead>
                        <tr><th>Product</th><th>Weight</th><th>Quantity</th><th>Supplier</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${pickingOrders}">
                            <tr>
                                <td>${order.product}</td>
                                <td>${order.weight}</td>
                                <td>${order.quantity}</td>
                                <td>${order.supplier}</td>
                                <td><button class="btn btn-sm btn-warning" onclick="updateOrder('${order.id}', 'packing')">Move to Packing</button></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Packing -->
            <div id="packing" class="order-table d-none">
                <table class="table table-bordered">
                    <thead>
                        <tr><th>Product</th><th>Weight</th><th>Quantity</th><th>Supplier</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${packingOrders}">
                            <tr>
                                <td>${order.product}</td>
                                <td>${order.weight}</td>
                                <td>${order.quantity}</td>
                                <td>${order.supplier}</td>
                                <td><button class="btn btn-sm btn-info" onclick="updateOrder('${order.id}', 'delivered')">Mark as Delivered</button></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Delivered -->
            <div id="delivered" class="order-table d-none">
                <table class="table table-bordered">
                    <thead>
                        <tr><th>Product</th><th>Weight</th><th>Quantity</th><th>Supplier</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${deliveredOrders}">
                            <tr>
                                <td>${order.product}</td>
                                <td>${order.weight}</td>
                                <td>${order.quantity}</td>
                                <td>${order.supplier}</td>
                                <td>Delivered</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Add Order Modal -->
        <div class="modal fade" id="addOrderModal" tabindex="-1">
            <div class="modal-dialog">
                <form id="addOrderForm" class="modal-content">
                    <div class="modal-header"><h5>Add New Order</h5></div>
                    <div class="modal-body">
                        <input type="text" name="product" class="form-control mb-2" placeholder="Product" required/>
                        <input type="text" name="weight" class="form-control mb-2" placeholder="Weight" required/>
                        <input type="number" name="quantity" class="form-control mb-2" placeholder="Quantity" required/>
                        <input type="text" name="supplier" class="form-control mb-2" placeholder="Supplier" required/>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- JS Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showTab(tabId) {
            $('.tab-btn').removeClass('active');
            $('.order-table').addClass('d-none');
            $('#' + tabId).removeClass('d-none');
            $(`.tab-btn:contains(${tabId.charAt(0).toUpperCase() + tabId.slice(1)})`).addClass('active');
        }

        $('#addOrderForm').submit(function(e) {
            e.preventDefault();
            $.post('manageOrders', {
                action: 'create',
                product: this.product.value,
                weight: this.weight.value,
                quantity: this.quantity.value,
                supplier: this.supplier.value
            }, function() {
                location.reload();
            });
        });

        function updateOrder(id, nextStatus) {
            $.post('manageOrders', {
                action: 'updateStatus',
                id: id,
                status: nextStatus
            }, function() {
                location.reload();
            });
        }
    </script>
    <script src="js/script.js"></script>

</body>
</html>
