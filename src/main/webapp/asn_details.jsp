<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="asn_management" />
    <jsp:param name="activePage" value="asn_management" />
    <jsp:param name="content" value="asn_management" />
</jsp:include>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ASN Details</title>
    <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .status-pending {
            color: #f6c23e;
            font-weight: 500;
        }
        .status-approved {
            color: #1cc88a;
            font-weight: 500;
        }
        .status-rejected {
            color: #e74a3b;
            font-weight: 500;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1100;
        }
        .incident-card {
            border-left: 4px solid #dc3545;
            margin-top: 20px;
        }
        .incident-item {
            background-color: #fff3f3;
        }
        .incident-type-selector {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .incident-quantity-input {
            display: none;
            margin-left: 10px;
        }
        .table-danger { background-color: #fff5f5 !important; }
        .table-warning { background-color: #fffbf0 !important; }
        .card-header h5 { font-weight: 600; }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="card">
            <div class="card-header" style="color:white; background:#156082;">
                <div class="d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">ASN Details - ASN-${asn.asnId}</h4>
                    <a href="ASNManagement" class="btn btn-light btn-sm">Back to List</a>
                </div>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card h-100">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">Basic Information</h5>
                            </div>
                            <div class="card-body">
                                <dl class="row">
                                    <dt class="col-sm-4">Status:</dt>
                                    <dd class="col-sm-8 status-${asn.status.toLowerCase()}">${asn.status}</dd>

                                    <dt class="col-sm-4">Supplier:</dt>
                                    <dd class="col-sm-8">${asn.supplier != null ? asn.supplier.name : 'N/A'}</dd>

                                    <dt class="col-sm-4">Reference Number:</dt>
                                    <dd class="col-sm-8">${asn.referenceNumber}</dd>

                                    <dt class="col-sm-4">Expected Arrival:</dt>
                                    <dd class="col-sm-8"><fmt:formatDate value="${asn.expectedArrivalDate}" pattern="yyyy-MM-dd" /></dd>

                                    <dt class="col-sm-4">Created Date:</dt>
                                    <dd class="col-sm-8"><fmt:formatDate value="${asn.createdAt}" pattern="yyyy-MM-dd HH:mm" /></dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card h-100">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">Actions</h5>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <button class="btn btn-primary mb-2" data-bs-toggle="modal" data-bs-target="#editASNModal">
                                    Edit ASN
                                </button>
                                <c:if test="${asn.status == 'pending'}">
                                    <button class="btn btn-success mb-2" onclick="approveASN(${asn.asnId})">
                                        Approve ASN
                                    </button>
                                    <button class="btn btn-danger" onclick="rejectASN(${asn.asnId})">
                                        Reject ASN
                                    </button>
                                </c:if>
                                <c:if test="${asn.status == 'approved'}">
                                    <button class="btn btn-info mb-2" onclick="sendToStock(${asn.asnId})">
                                        Send To Stock Operation
                                    </button>
                                </c:if>
                                <c:if test="${asn.status != 'pending'}">
                                    <div class="alert alert-info">
                                        This ASN has been ${asn.status.toLowerCase()}. No further actions available.
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">ASN Items (${asn.items.size()})</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Category</th>
                                        <th>Product</th>
                                        <th>Weight</th>
                                        <th>Quantity</th>
                                        <th>Expire Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${asn.items}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                                        <td>
                                                            <c:forEach var="cat" items="${categoryList}">
                                                                <c:if test="${cat.categoryId == item.categoryId}">
                                                                    ${cat.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </td>
                                            <td>${item.product != null ? item.product.productName : 'N/A'}</td>
                                            <td>${item.weight != null ? item.weight.weightValue : 'N/A'} Kg</td>
                                            <td>${item.expectedQuantity}</td>
                                            <td>
                                                <fmt:formatDate value="${item.expiryDate}" pattern="yyyy-MM-dd" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <!-- Incident Report Card -->
                <c:if test="${not empty incidentItems}">
                <div class="card border-danger mb-4 mt-4">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Incident Report (${fn:length(incidentItems)})
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Product</th>
                                        <th>Type</th>
                                        <th>Qty Affected</th>
                                        <th>Remaining</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="incident" items="${incidentItems}" varStatus="loop">
                                        <tr class="${incident.incidentType == 'damaged' ? 'table-danger' : 'table-warning'}">
                                            <td>${loop.index + 1}</td>
                                            <td>${incident.asnItem.product.productName}</td>
                                            <td>
                                                <span class="badge ${incident.incidentType == 'damaged' ? 'bg-danger' : 'bg-warning'}">
                                                    <c:choose>
                                                        <c:when test="${incident.incidentType == 'damaged'}">Damaged</c:when>
                                                        <c:otherwise>Missing</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>${incident.incidentQuantity}</td>
                                            <td>${incident.asnItem.expectedQuantity}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer bg-light">
                        <small class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            Damaged items marked in red, missing items in yellow
                        </small>
                    </div>
                </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Edit ASN Modal -->
    <div class="modal fade" id="editASNModal" tabindex="-1" aria-labelledby="editASNModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editASNModalLabel">Edit ASN - ASN-${asn.asnId}</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editASNForm">
                        <input type="hidden" name="asnId" value="${asn.asnId}">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="supplierId" class="form-label">Supplier</label>
                                <select class="form-select" id="supplierId" name="supplierId" required>
                                    <c:forEach var="supplier" items="${supplierList}">
                                        <option value="${supplier.supplierId}" ${supplier.supplierId == asn.supplierId ? 'selected' : ''}>
                                            ${supplier.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="referenceNumber" class="form-label">Reference Number</label>
                                <input type="text" class="form-control" id="referenceNumber" name="referenceNumber"
                                       value="${asn.referenceNumber}" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="expectedArrivalDate" class="form-label">Expected Arrival Date</label>
                                <input type="date" class="form-control" id="expectedArrivalDate" name="expectedArrivalDate"
                                       value="<fmt:formatDate value="${asn.expectedArrivalDate}" pattern="yyyy-MM-dd" />" required>
                            </div>
                        </div>

                        <div class="card mb-3">
                            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">ASN Items</h5>
                                <button type="button" class="btn btn-sm btn-primary" onclick="addNewItemRow()">
                                    <i class="bi bi-plus"></i> Add Item
                                </button>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table" id="itemsTable">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Category</th>
                                                <th>Product</th>
                                                <th>Weight (Kg)</th>
                                                <th>Quantity</th>
                                                <th>Product Expiry Date</th>
                                                <th>Inspection Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${asn.items}">
                                                <tr data-item-id="${item.asnItemId}">
                                                    <td>
                                                        <select class="form-select category-select" name="categoryId" required>
                                                            <c:forEach var="category" items="${categoryList}">
                                                                <option value="${category.categoryId}" ${category.categoryId == item.categoryId ? 'selected' : ''}>
                                                                    ${category.name}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select class="form-select product-select" name="productId" required>
                                                            <c:forEach var="product" items="${productList}">
                                                                <option value="${product.productId}" ${product.productId == item.productId ? 'selected' : ''}>
                                                                    ${product.productName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select class="form-select weight-select" name="weightId" required>
                                                            <c:forEach var="weight" items="${weightList}">
                                                                <option value="${weight.weightId}" ${weight.weightId == item.weightId ? 'selected' : ''}>
                                                                    ${weight.weightValue}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <input type="number" class="form-control quantity-input"
                                                               name="expectedQuantity" value="${item.expectedQuantity}" min="1" required>
                                                    </td>
                                                   <td>
                                                       <input type="date" class="form-control expiry-date-input"
                                                              name="expiryDate" value="<fmt:formatDate value="${item.expiryDate}" pattern="yyyy-MM-dd" />" required>
                                                    </td>
                                                    <td>
                                                          <div class="incident-options" data-expected-qty="${item.expectedQuantity}" data-item-id="${item.asnItemId}">
                                                            <label><input type="radio" name="issue_${item.asnItemId}" value="none" checked> None</label><br>
                                                            <label><input type="radio" name="issue_${item.asnItemId}" value="damaged"> Damaged</label><br>
                                                            <label><input type="radio" name="issue_${item.asnItemId}" value="missing"> Missing</label>

                                                            <input type="number"
                                                                   class="incident-qty-input form-control"
                                                                   name="incidentQty_${item.asnItemId}"
                                                                   placeholder="Qty"
                                                                   style="display: none; width: 80px; margin-top: 5px;"
                                                                   min="1">
                                                          </div>
                                                    </td>
                                                    <td>
                                                    <button type="button" class="btn btn-sm btn-danger" onclick="removeItemRow(this)">Delete</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveASNChanges()">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>

$(document).on('change', 'input[type="radio"][name^="issue_"]', function () {
    const $container = $(this).closest('.incident-options');
    const selectedValue = $(this).val();
    const $qtyInput = $container.find('.incident-qty-input');
    const maxQty = $container.data('expected-qty');

    if (selectedValue === 'none') {
        $qtyInput.hide().val('');
    } else {
        $qtyInput.show().attr('max', maxQty);
    }
});


        function approveASN(asnId) {
            Swal.fire({
                title: 'Approve ASN',
                text: 'Are you sure you want to approve this ASN?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, approve it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.post('ASNManagement', {
                        action: 'approve',
                        asnId: asnId
                    }).done(function() {
                        Swal.fire({
                            icon: 'success',
                            title: 'Approved!',
                            text: 'ASN has been approved successfully',
                            timer: 1500,
                            showConfirmButton: false
                        }).then(() => {
                            location.reload();
                        });
                    }).fail(function() {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Failed to approve ASN'
                        });
                    });
                }
            });
        }

        function rejectASN(asnId) {
            Swal.fire({
                title: 'Reject ASN',
                text: 'Are you sure you want to reject this ASN?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, reject it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.post('ASNManagement', {
                        action: 'reject',
                        asnId: asnId
                    }).done(function() {
                        Swal.fire({
                            icon: 'success',
                            title: 'Rejected!',
                            text: 'ASN has been rejected successfully',
                            timer: 1500,
                            showConfirmButton: false
                        }).then(() => {
                            location.reload();
                        });
                    }).fail(function() {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Failed to reject ASN'
                        });
                    });
                }
            });
        }

        function addNewItemRow() {
            const tableBody = document.querySelector('#itemsTable tbody');
            const newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td>
                    <select class="form-select category-select" name="categoryId" required>
                        <c:forEach var="category" items="${categoryList}">
                            <option value="${category.categoryId}">${category.name}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <select class="form-select product-select" name="productId" required>
                        <c:forEach var="product" items="${productList}">
                            <option value="${product.productId}">${product.productName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <select class="form-select weight-select" name="weightId" required>
                        <c:forEach var="weight" items="${weightList}">
                            <option value="${weight.weightId}">${weight.weightValue}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <input type="number" class="form-control quantity-input"
                           name="expectedQuantity" value="1" min="1" required>
                </td>
                <td>
                    <input type="date" class="form-control expiry-date-input"
                           name="expiryDate" value="<fmt:formatDate value="${item.expiryDate}" pattern="yyyy-MM-dd" />" required>
                </td>
                <td>
                    <div class="incident-options" data-expected-qty="1">
                        <label><input type="radio" name="issue_new" value="none" checked> None</label><br>
                        <label><input type="radio" name="issue_new" value="damaged"> Damaged</label><br>
                        <label><input type="radio" name="issue_new" value="missing"> Missing</label>
                        <input type="number"
                               class="incident-qty-input form-control"
                               name="incidentQty_new"
                               placeholder="Qty"
                               style="display: none; width: 80px; margin-top: 5px;"
                               min="1">
                    </div>
                </td>
                <td>
                    <button type="button" class="btn btn-sm btn-danger" onclick="removeItemRow(this)">Delete</button>
                </td>
            `;
            tableBody.appendChild(newRow);
        }

       function removeItemRow(button) {
           const row = button.closest('tr');
           row.remove();
       }

function saveASNChanges() {
    const form = document.getElementById('editASNForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    // Create form data with proper parameter names
    const params = new URLSearchParams();
    params.append('action', 'update');
    params.append('asnId', form.querySelector('input[name="asnId"]').value);
    params.append('supplierId', form.querySelector('#supplierId').value);
    params.append('referenceNumber', form.querySelector('#referenceNumber').value);
    params.append('expectedArrivalDate', form.querySelector('#expectedArrivalDate').value);

    // Collect all rows data for UI update
    const rows = document.querySelectorAll('#itemsTable tbody tr');

    // Add items to form data
    rows.forEach((row, index) => {
        params.append(`items[${index}].asnItemId`, row.dataset.itemId || '0');
        params.append(`items[${index}].categoryId`, row.querySelector('.category-select').value);
        params.append(`items[${index}].productId`, row.querySelector('.product-select').value);
        params.append(`items[${index}].weightId`, row.querySelector('.weight-select').value);
        params.append(`items[${index}].expectedQuantity`, row.querySelector('.quantity-input').value);
        params.append(`items[${index}].expiryDate`, row.querySelector('.expiry-date-input').value);

        const incidentOptions = row.querySelector('.incident-options');
                const incidentType = incidentOptions.querySelector('input[type="radio"]:checked').value;
                const incidentQtyInput = incidentOptions.querySelector('.incident-qty-input');

                if (incidentType !== 'none' && incidentQtyInput.value) {
                    params.append(`incidents[].asnItemId`, row.dataset.itemId);
                    params.append(`incidents[].incidentType`, incidentType);
                    params.append(`incidents[].incidentQuantity`, incidentQtyInput.value);
                }
    });

    // Show loading alert
    Swal.fire({
        title: 'Saving Changes',
        text: 'Please wait while we save your changes...',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    // Send POST request
    fetch('ASNManagement', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.text();
    })
    .then(() => {

        Swal.fire({
            icon: 'success',
            title: 'Success',
            text: 'ASN updated successfully',
            timer: 1500,
            showConfirmButton: false
        }).then(() => {
            $('#editASNModal').modal('hide');
            location.reload();

        });
    })
    .catch(error => {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to update ASN: ' + (error.message || 'Unknown error')
        });
        console.error('Error:', error);
    });
}

function updateUIAfterSave(supplierName, referenceNumber, expectedArrivalDate, rows) {
    try {
        // 1. Update Basic Information
        document.querySelector('dl.row dd:nth-of-type(2)').textContent = supplierName;
        document.querySelector('dl.row dd:nth-of-type(3)').textContent = referenceNumber;
        document.querySelector('dl.row dd:nth-of-type(4)').textContent = expectedArrivalDate;

        // 2. Update Items Table
        const itemsTableBody = document.querySelector('.table-responsive table tbody');
        if (itemsTableBody) {
            itemsTableBody.innerHTML = '';

            // Create lookup maps for category/product/weight names from the modal
            const categoryMap = {};
            document.querySelectorAll('.category-select option').forEach(opt => {
                categoryMap[opt.value] = opt.textContent;
            });

            const productMap = {};
            document.querySelectorAll('.product-select option').forEach(opt => {
                productMap[opt.value] = opt.textContent;
            });

            const weightMap = {};
            document.querySelectorAll('.weight-select option').forEach(opt => {
                weightMap[opt.value] = opt.textContent;
            });

            // Corrected part of updateUIAfterSave function:
            rows.forEach((row, index) => {
                const categoryId = row.querySelector('.category-select').value;
                const productId = row.querySelector('.product-select').value;
                const weightId = row.querySelector('.weight-select').value;
                const quantity = row.querySelector('.quantity-input').value;
                const expiryDate = row.querySelector('.expiry-date-input').value;

                const newRow = document.createElement('tr');
                newRow.innerHTML = `
                    <td>${index + 1}</td>
                    <td>${categoryMap[categoryId] || 'N/A'}</td>
                    <td>${productMap[productId] || 'N/A'}</td>
                    <td>${weightMap[weightId] || 'N/A'}${weightMap[weightId] ? ' Kg' : ''}</td>
                    <td>${quantity}</td>
                    <td>${expiryDate}</td>
                `;
                itemsTableBody.appendChild(newRow);
            });


            // Update the items count in the card header
            const itemsCountElement = document.querySelector('.card-header h5.mb-0');
            if (itemsCountElement) {
                itemsCountElement.textContent = `ASN Items (${rows.length})`;
            }
        }
    } catch (error) {
        console.error('Error updating UI:', error);
        Swal.fire({
            icon: 'warning',
            title: 'Display Update Incomplete',
            text: 'Changes were saved successfully, but some display elements might not update. Please refresh if needed.',
            timer: 3000
        });
    }
}
function sendToStock(asnId) {
    Swal.fire({
        title: 'Send to Stock',
        text: 'Are you sure you want to send these items to stock?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, send to stock'
    }).then((result) => {
        if (result.isConfirmed) {
            $.post('ASNManagement', {
                action: 'sendToStock',
                asnId: asnId
            }).done(function(response) {
                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Items have been sent to stock',
                    timer: 1500,
                    showConfirmButton: false
                }).then(() => {
                    location.reload();
                });
            }).fail(function(xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseText || 'Failed to send items to stock'
                });
            });
        }
    });
}



    </script>
</body>
</html>