<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ASN Details</title>
    <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
        }
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
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="card">
            <div class="card-header bg-primary text-white">
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
                                        <th>Product</th>
                                        <th>Weight</th>
                                        <th>Quantity</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${asn.items}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>${item.product != null ? item.product.productName : 'N/A'}</td>
                                            <td>${item.weight != null ? item.weight.weightValue : 'N/A'} Kg</td>
                                            <td>${item.expectedQuantity}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit ASN Modal -->
    <div class="modal fade" id="editASNModal" tabindex="-1" aria-labelledby="editASNModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
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
                                    <c:forEach var="supplier" items="${suppliers}">
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
                                                <th>Product</th>
                                                <th>Weight (Kg)</th>
                                                <th>Quantity</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${asn.items}">
                                                <tr data-item-id="${item.asnItemId}">
                                                    <td>
                                                        <select class="form-select product-select" name="productId" required>
                                                            <c:forEach var="product" items="${products}">
                                                                <option value="${product.productId}" ${product.productId == item.productId ? 'selected' : ''}>
                                                                    ${product.productName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select class="form-select weight-select" name="weightId" required>
                                                            <c:forEach var="weight" items="${weights}">
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
                                                        <button type="button" class="btn btn-sm btn-danger" onclick="removeItemRow(this)">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
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
                   <select class="form-select product-select" name="productId" required>
                       <c:forEach var="product" items="${products}">
                           <option value="${product.productId}">${product.productName}</option>
                       </c:forEach>
                   </select>
               </td>
               <td>
                   <select class="form-select weight-select" name="weightId" required>
                       <c:forEach var="weight" items="${weights}">
                           <option value="${weight.weightId}">${weight.weightValue}</option>
                       </c:forEach>
                   </select>
               </td>
               <td>
                   <input type="number" class="form-control quantity-input"
                          name="expectedQuantity" value="1" min="1" required>
               </td>
               <td>
                   <button type="button" class="btn btn-sm btn-danger" onclick="removeItemRow(this)">
                       <i class="bi bi-trash"></i>
                   </button>
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

           // Create FormData object to collect all form data
           const formData = new FormData();
           formData.append('action', 'update');
           formData.append('asnId', form.querySelector('input[name="asnId"]').value);
           formData.append('supplierId', form.querySelector('#supplierId').value);
           formData.append('referenceNumber', form.querySelector('#referenceNumber').value);
           formData.append('expectedArrivalDate', form.querySelector('#expectedArrivalDate').value);

           // Collect items data
           const rows = document.querySelectorAll('#itemsTable tbody tr');
           rows.forEach((row, index) => {
               formData.append(`items[${index}].asnItemId`, row.dataset.itemId || '0'); // 0 for new items
               formData.append(`items[${index}].productId`, row.querySelector('.product-select').value);
               formData.append(`items[${index}].weightId`, row.querySelector('.weight-select').value);
               formData.append(`items[${index}].expectedQuantity`, row.querySelector('.quantity-input').value);
           });

           Swal.fire({
               title: 'Saving Changes',
               text: 'Please wait while we save your changes...',
               allowOutsideClick: false,
               didOpen: () => {
                   Swal.showLoading();
               }
           });

           $.ajax({
               url: 'ASNManagement',
               type: 'POST',
               data: formData,
               processData: false,
               contentType: false,
               success: function(response) {
                   Swal.fire({
                       icon: 'success',
                       title: 'Success',
                       text: 'ASN updated successfully',
                       timer: 1500,
                       showConfirmButton: false
                   }).then(() => {
                       $('#editASNModal').modal('hide');
                       // Update the page content without refresh
                       updateASNDetails(response);
                   });
               },
               error: function(xhr) {
                   Swal.fire({
                       icon: 'error',
                       title: 'Error',
                       text: 'Failed to update ASN: ' + (xhr.responseText || 'Unknown error')
                   });
               }
           });
       }

       function updateASNDetails(asnData) {
           // Update the basic ASN info
           document.querySelector('.card-header h4').textContent = `ASN Details - ASN-${asnData.asnId}`;
           document.querySelector('.status-pending, .status-approved, .status-rejected').className = `status-${asnData.status.toLowerCase()}`;
           document.querySelector('.status-pending, .status-approved, .status-rejected').textContent = asnData.status;
           document.querySelector('dd:nth-of-type(2)').textContent = asnData.supplierName;
           document.querySelector('dd:nth-of-type(3)').textContent = asnData.referenceNumber;
           document.querySelector('dd:nth-of-type(4)').textContent = asnData.expectedArrivalDate;

           // Update the items table
           const itemsTable = document.querySelector('.table-responsive table tbody');
           itemsTable.innerHTML = '';

           asnData.items.forEach((item, index) => {
               const row = document.createElement('tr');
               row.innerHTML = `
                   <td>${index + 1}</td>
                   <td>${item.productName}</td>
                   <td>${item.weightValue} Kg</td>
                   <td>${item.expectedQuantity}</td>
               `;
               itemsTable.appendChild(row);
           });
       }
    </script>
</body>
</html>