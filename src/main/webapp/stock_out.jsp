<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock Out</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        .loading-content {
            background: white;
            padding: 20px;
            border-radius: 5px;
        }
        .stock-error {
            color: red;
            font-size: 0.8rem;
            display: none;
        }
        .available-qty {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="loading">
        <div class="loading-content">
            <div class="spinner-border text-primary" role="status">
                <span class="sr-only">Loading...</span>
            </div>
            <p class="mt-2">Processing your request...</p>
        </div>
    </div>

    <div class="container mt-5">
        <h3>New Stock Out Request</h3>

        <!-- Success/Error Message Area -->
        <div id="messageArea" style="display: none;"></div>

        <form id="stockOutForm">
            <input type="hidden" name="action" value="create">

            <div class="form-row mb-3">
                <div class="col-md-4">
                    <label for="customer_id">Customer</label>
                    <select name="customerId" class="form-control" required>
                        <option value="">Select Customer</option>
                        <c:forEach var="customer" items="${customerList}">
                            <option value="${customer.customerId}">${customer.name}</option>
                        </c:forEach>
                    </select>
                    <div class="stock-error" id="customerError">Please select a customer</div>
                </div>
                <div class="col-md-4">
                    <label for="dispatch_date">Dispatch Date</label>
                    <input type="date" name="dispatch_date" class="form-control" required>
                    <div class="stock-error" id="dateError">Please select a dispatch date</div>
                </div>
                <div class="col-md-4">
                    <label for="order_id">Order ID (Optional)</label>
                    <input type="number" name="orderId" class="form-control">
                </div>
            </div>

            <div class="form-row mb-3">
                <div class="col-md-4">
                    <button type="button" class="btn btn-info" onclick="addRow()">Add New Item</button>
                </div>
            </div>

            <table class="table table-bordered">
                <thead class="thead-light">
                    <tr>
                        <th>Product Name</th>
                        <th>Product Weight</th>
                        <th>Available Qty</th>
                        <th>Request Qty</th>
                        <th>Expiry Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="stockTableBody">
                    <tr data-row-id="0">
                        <td>
                            <select name="productId" class="form-control product-select" required>
                                <option value="">Select Product</option>
                                <c:forEach var="product" items="${productList}">
                                    <option value="${product.productId}"
                                        data-weight="${product.weightId}">${product.productName}</option>
                                </c:forEach>
                            </select>
                            <div class="stock-error" id="productError_0">Please select a product</div>
                        </td>
                        <td>
                            <select name="weightId" class="form-control weight-select" required>
                                <option value="">Select Weight</option>
                                <c:forEach var="weight" items="${weightList}">
                                    <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                                </c:forEach>
                            </select>
                            <div class="stock-error" id="weightError_0">Please select a weight</div>
                        </td>
                        <td>
                            <span class="available-qty">0</span>
                        </td>
                        <td>
                            <input type="number" name="quantity" class="form-control qty-input" min="1" required>
                            <div class="stock-error" id="qtyError_0">Invalid quantity</div>
                        </td>
                        <td>
                            <input type="date" name="expire_date" class="form-control" required>
                            <div class="stock-error" id="expireError_0">Please select expiry date</div>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">
                                Remove
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="text-center mb-4">
                <button type="submit" class="btn btn-primary btn-lg">Submit Request</button>
                <a href="StockOut" class="btn btn-secondary btn-lg ml-2">Cancel</a>
            </div>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
    <script>
        // Global data
        const inventoryData = JSON.parse('${inventoryListJson}');
        const productWeightMap = {};
        let rowCount = 1;

        // Create product-weight mapping
        <c:forEach var="product" items="${productList}">
            productWeightMap[${product.productId}] = ${product.weightId};
        </c:forEach>

        $(document).ready(function() {
            // Auto-select weight when product is selected
            $(document).on('change', '.product-select', function() {
                const row = $(this).closest('tr');
                const productId = $(this).val();
                const weightSelect = row.find('.weight-select');
                const availableSpan = row.find('.available-qty');
                const qtyInput = row.find('.qty-input');

                // Reset fields
                weightSelect.val('');
                availableSpan.text('0');
                qtyInput.val('').removeAttr('max');

                if (productId) {
                    // Auto-select weight
                    const weightId = productWeightMap[productId];
                    if (weightId) {
                        weightSelect.val(weightId);
                    }

                    // Calculate available quantity for this product
                    let availableQty = 0;
                    inventoryData.forEach(item => {
                        if (item.productId == productId) {
                            availableQty += item.quantity;
                        }
                    });

                    availableSpan.text(availableQty);
                    if (availableQty > 0) {
                        qtyInput.attr('max', availableQty);
                    }
                }
            });

            // Handle form submission
            $('#stockOutForm').on('submit', function(e) {
                e.preventDefault();
                submitStockOutForm();
            });
        });

        function addRow() {
            const tableBody = $('#stockTableBody');
            const newRow = `
                <tr data-row-id="${rowCount}">
                    <td>
                        <select name="productId" class="form-control product-select" required>
                            <option value="">Select Product</option>
                            <c:forEach var="product" items="${productList}">
                                <option value="${product.productId}" data-weight="${product.weightId}">${product.productName}</option>
                            </c:forEach>
                        </select>
                        <div class="stock-error" id="productError_${rowCount}">Please select a product</div>
                    </td>
                    <td>
                        <select name="weightId" class="form-control weight-select" required>
                            <option value="">Select Weight</option>
                            <c:forEach var="weight" items="${weightList}">
                                <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                            </c:forEach>
                        </select>
                        <div class="stock-error" id="weightError_${rowCount}">Please select a weight</div>
                    </td>
                    <td>
                        <span class="available-qty">0</span>
                    </td>
                    <td>
                        <input type="number" name="quantity" class="form-control qty-input" min="1" required>
                        <div class="stock-error" id="qtyError_${rowCount}">Invalid quantity</div>
                    </td>
                    <td>
                        <input type="date" name="expire_date" class="form-control" required>
                        <div class="stock-error" id="expireError_${rowCount}">Please select expiry date</div>
                    </td>
                    <td>
                        <button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">
                            Remove
                        </button>
                    </td>
                </tr>
            `;

            tableBody.append(newRow);
            rowCount++;
        }

        function removeRow(button) {
            if ($('#stockTableBody tr').length > 1) {
                $(button).closest('tr').remove();
            } else {
                alert('At least one item is required');
            }
        }

        function validateForm() {
            let isValid = true;
            const today = new Date().toISOString().split('T')[0];

            // Reset all errors
            $('.stock-error').hide();

            // Validate customer
            if (!$('select[name="customerId"]').val()) {
                $('#customerError').show();
                isValid = false;
            }

            // Validate dispatch date
            const dispatchDate = $('input[name="dispatch_date"]').val();
            if (!dispatchDate) {
                $('#dateError').show();
                isValid = false;
            } else if (dispatchDate < today) {
                $('#dateError').text('Dispatch date cannot be in the past').show();
                isValid = false;
            }

            // Validate each row
            $('#stockTableBody tr').each(function(index) {
                const row = $(this);
                const productSelect = row.find('.product-select');
                const weightSelect = row.find('.weight-select');
                const qtyInput = row.find('.qty-input');
                const dateInput = row.find('input[name="expire_date"]');
                const availableQty = parseInt(row.find('.available-qty').text()) || 0;
                const requestedQty = parseInt(qtyInput.val()) || 0;

                // Validate product
                if (!productSelect.val()) {
                    row.find('#productError_' + index).show();
                    isValid = false;
                }

                // Validate weight
                if (!weightSelect.val()) {
                    row.find('#weightError_' + index).show();
                    isValid = false;
                }

                // Validate quantity
                if (!qtyInput.val() || requestedQty < 1) {
                    row.find('#qtyError_' + index).text('Quantity must be at least 1').show();
                    isValid = false;
                } else if (requestedQty > availableQty) {
                    row.find('#qtyError_' + index).text('Not enough stock available').show();
                    isValid = false;
                }

                // Validate date
                if (!dateInput.val()) {
                    row.find('#expireError_' + index).show();
                    isValid = false;
                }
            });

            return isValid;
        }

        function submitStockOutForm() {
            // Validate form first
            if (!validateForm()) {
                showMessage('Please correct the errors in the form', 'danger');
                return;
            }

            // Show loading indicator
            $('.loading').show();

            // Create URL-encoded form data string
            let formData = 'action=create';
            formData += '&customerId=' + encodeURIComponent($('select[name="customerId"]').val());
            formData += '&dispatch_date=' + encodeURIComponent($('input[name="dispatch_date"]').val());

            const orderId = $('input[name="orderId"]').val();
            if (orderId) {
                formData += '&orderId=' + encodeURIComponent(orderId);
            }

            // Collect all row data
            $('#stockTableBody tr').each(function(index) {
                formData += '&productId=' + encodeURIComponent($(this).find('select[name="productId"]').val());
                formData += '&weightId=' + encodeURIComponent($(this).find('select[name="weightId"]').val());
                formData += '&quantity=' + encodeURIComponent($(this).find('input[name="quantity"]').val());
                formData += '&expire_date=' + encodeURIComponent($(this).find('input[name="expire_date"]').val());
            });

            // Send AJAX request
            $.ajax({
                url: 'StockOut',
                type: 'POST',
                data: formData,
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                success: function(response) {
                    $('.loading').hide();

                    if (response.success) {
                        showMessage('Stock out request created successfully! Redirecting...', 'success');
                        // Redirect to view page after 2 seconds
                        setTimeout(function() {
                            window.location.href = 'StockOut?action=view&id=' + response.stockOutId;
                        }, 2000);
                    } else {
                        showMessage(response.message || 'Error processing request', 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    $('.loading').hide();
                    let errorMsg = 'Error processing request';
                    try {
                        const response = JSON.parse(xhr.responseText);
                        errorMsg = response.message || errorMsg;
                    } catch (e) {
                        errorMsg = xhr.statusText || errorMsg;
                    }
                    showMessage(errorMsg, 'danger');
                }
            });
        }

        function showMessage(message, type) {
            const messageArea = $('#messageArea');
            messageArea.html(`
                <div class="alert alert-${type} alert-dismissible fade show">
                    ${message}
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            `);
            messageArea.show();
        }
    </script>
</body>
</html>