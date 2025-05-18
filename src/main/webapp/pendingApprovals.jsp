<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Stock Out Approvals</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .badge-pending { background-color: #ffc107; color: #000; }
        .stock-warning { background-color: #fff3cd; }
        .card-item { margin-bottom: 10px; }
        .action-buttons .btn { margin-right: 5px; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3>Pending Stock Out Approvals</h3>
            <a href="StockOut?action=new" class="btn btn-primary">Create New Request</a>
        </div>

        <div class="row">
            <c:forEach var="request" items="${stockOutList}">
                <div class="col-md-6 mb-4">
                    <div class="card ${not empty availabilityMessages[request.id] ? 'border-warning' : ''}">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Request #${request.id}</h5>
                            <span class="badge badge-pending">Pending</span>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <h6 class="card-subtitle mb-2 text-muted">Customer</h6>
                                <p class="card-text">${request.customerName}</p>
                            </div>

                            <div class="mb-3">
                                <h6 class="card-subtitle mb-2 text-muted">Dispatch Date</h6>
                                <p class="card-text">${request.dispatchDate}</p>
                            </div>

                            <div class="mb-3">
                                <h6 class="card-subtitle mb-2 text-muted">Items</h6>
                                <div class="card-item">
                                    <c:forEach var="item" items="${request.items}">
                                        <div class="d-flex justify-content-between">
                                            <span>${item.productName}</span>
                                            <span class="font-weight-bold">${item.quantity}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <c:if test="${not empty availabilityMessages[request.id]}">
                                <div class="alert alert-warning mb-3">
                                    <i class="fas fa-exclamation-triangle"></i> ${availabilityMessages[request.id]}
                                </div>
                            </c:if>

                            <div class="action-buttons d-flex justify-content-end">
                                <a href="StockOut?action=view&id=${request.id}"
                                   class="btn btn-sm btn-info">View</a>
                                <button onclick="showEditModal(${request.id})"
                                    class="btn btn-sm btn-primary">Edit</button>
                                <button onclick="approveRequest(${request.id})"
                                    class="btn btn-sm btn-success"
                                    ${not empty availabilityMessages[request.id] ? 'disabled' : ''}>
                                    Approve
                                </button>
                                <button onclick="rejectRequest(${request.id})"
                                    class="btn btn-sm btn-danger">Reject</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Stock Out Request</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="editModalBody">
                    <!-- Content will be loaded via AJAX -->
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <script>
        function showEditModal(stockOutId) {
            $.get('StockOut?action=get&id=' + stockOutId, function(data) {
                // Build customer options using JSTL-style iteration
                let customerOptions = '';
                if(data.stockOut.customerList) {
                    data.stockOut.customerList.forEach(function(c) {
                        customerOptions += `<option value="\${c.customerId}" \${c.customerId == data.stockOut.customerId ? 'selected' : ''}>\${c.cName}</option>`;
                    });
                }

                // Build product options
                let productOptions = '';
                if(data.productList) {
                    data.productList.forEach(function(p) {
                        productOptions += `<option value="\${p.productId}">\${p.productName}</option>`;
                    });
                }

                // Build items rows
                let itemsRows = '';
                if(data.stockOut.items) {
                    data.stockOut.items.forEach(function(item) {
                        let selectedProductOptions = '';
                        if(data.productList) {
                            data.productList.forEach(function(p) {
                                selectedProductOptions += `<option value="\${p.productId}" \${p.productId == item.productId ? 'selected' : ''}>\${p.productName}</option>`;
                            });
                        }

                        itemsRows += `
                            <tr>
                                <td>
                                    <select name="productId" class="form-control" required>
                                        ${selectedProductOptions}
                                    </select>
                                </td>
                                <td>\${data.availableQuantities[item.productId] || 0}</td>
                                <td>
                                    <input type="number" name="quantity" class="form-control"
                                        value="\${item.quantity}" min="1" required>
                                </td>
                                <td>
                                    <input type="date" name="expire_date" class="form-control"
                                        value="\${item.expireDate}" required>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-danger"
                                        onclick="$(this).closest('tr').remove()">
                                        Remove
                                    </button>
                                </td>
                            </tr>
                        `;
                    });
                }

                $('#editModalBody').html(`
                    <form id="editStockOutForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="stockOutId" value="\${data.stockOut.id}">

                        <div class="form-group">
                            <label>Customer</label>
                            <select name="customerId" class="form-control" required>
                                ${customerOptions}
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Dispatch Date</label>
                            <input type="date" name="dispatch_date" class="form-control"
                                value="\${data.stockOut.dispatchDate}" required>
                        </div>

                        <h5>Items</h5>
                        <table class="table" id="editItemsTable">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Available</th>
                                    <th>Requested</th>
                                    <th>Expiry</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${itemsRows}
                            </tbody>
                        </table>
                        <button type="button" class="btn btn-primary" onclick="addEditRow()">Add Item</button>
                    </form>
                `);

                // Store product options for adding new rows
                $('#editModal').data('productOptions', productOptions);

                $('#editModal').modal('show');
            });
        }

        function addEditRow() {
            const productOptions = $('#editModal').data('productOptions');
            $('#editItemsTable tbody').append(`
                <tr>
                    <td>
                        <select name="productId" class="form-control" required>
                            <option value="">Select Product</option>
                            ${productOptions}
                        </select>
                    </td>
                    <td>0</td>
                    <td>
                        <input type="number" name="quantity" class="form-control" min="1" required>
                    </td>
                    <td>
                        <input type="date" name="expire_date" class="form-control" required>
                    </td>
                    <td>
                        <button type="button" class="btn btn-sm btn-danger"
                            onclick="$(this).closest('tr').remove()">
                            Remove
                        </button>
                    </td>
                </tr>
            `);
        }

        function approveRequest(stockOutId) {
            if (confirm('Are you sure you want to approve this request?')) {
                $.post('StockOut', {
                    action: 'approve',
                    stockOutId: stockOutId
                }, function(response) {
                    if (response.success) {
                        location.reload();
                    } else {
                        alert('Error: ' + response.message);
                    }
                });
            }
        }

        function rejectRequest(stockOutId) {
            if (confirm('Are you sure you want to reject this request?')) {
                $.post('StockOut', {
                    action: 'reject',
                    stockOutId: stockOutId
                }, function(response) {
                    if (response.success) {
                        location.reload();
                    } else {
                        alert('Error: ' + response.message);
                    }
                });
            }
        }

        // Handle edit form submission
        $(document).on('submit', '#editStockOutForm', function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            $.ajax({
                url: 'StockOut',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        $('#editModal').modal('hide');
                        location.reload();
                    } else {
                        alert('Error: ' + response.message);
                    }
                }
            });
        });
    </script>
</body>
</html>