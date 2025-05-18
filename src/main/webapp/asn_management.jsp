<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.ASN" %>
<%@ page import="com.warehouse.dao.ASNDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="asn_management" />
    <jsp:param name="activePage" value="asn_management" />
    <jsp:param name="content" value="asn_management" />
</jsp:include>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ASN Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
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
        </style>
</head>
<body>
    <div class="toast-container">
        <c:if test="${not empty successMessage}">
            <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header bg-success text-white">
                    <strong class="me-auto">Success</strong>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    ${successMessage}
                    <% session.removeAttribute("successMessage"); %>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header bg-danger text-white">
                    <strong class="me-auto">Error</strong>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    ${errorMessage}
                    <% session.removeAttribute("errorMessage"); %>
                </div>
            </div>
        </c:if>
    </div>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">Advanced Shipping Notices (ASN)</h2>
            <button class="custom-add-btn" data-bs-toggle="modal" data-bs-target="#createASNModal">
                Create New ASN
            </button>
        </div>

        <div class="card">
            <div class="card-header " style="color:white; background:#311F10;">
                <h4 class="mb-0">ASN List</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>ASN ID</th>
                                <th>Supplier</th>
                                <th>Reference</th>
                                <th>Expected Arrival</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="asn" items="${asnList}">
                                <tr>
                                    <td>ASN-${asn.asnId}</td>
                                    <td>${asn.supplier != null ? asn.supplier.name : 'N/A'}</td>
                                    <td>${asn.referenceNumber}</td>
                                    <td><fmt:formatDate value="${asn.expectedArrivalDate}" pattern="yyyy-MM-dd" /></td>
                                    <td class="status-${asn.status.toLowerCase()} text-uppercase">${asn.status}</td>
                                    <td>
                                        <button class="btn btn-sm btn-info" onclick="viewASNDetails(${asn.asnId})">
                                            View
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Create ASN Modal -->
    <div class="modal fade" id="createASNModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create New ASN</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="createASNForm" action="ASNManagement" method="POST">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Supplier</label>
                                <select name="supplierId" class="form-select" required>
                                    <option value="">Select Supplier</option>
                                    <c:forEach var="supplier" items="${suppliers}">
                                        <option value="${supplier.supplierId}">${supplier.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Reference Number</label>
                                <input type="text" name="referenceNumber" class="form-control" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Expected Arrival Date</label>
                                <input type="date" name="expectedArrivalDate" class="form-control" required>
                            </div>
                            <div class="col-md-6 mt-4">
                                <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addModalProduct" >Add New Product </button>
                                <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addModalSupplier">Add New Supplier </button>
                            </div>

                        </div>

                        <h5 class="mt-4">ASN Items</h5>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Product</th>
                                    <th>Weight</th>
                                    <th>Quantity</th>
                                    <th>Product Expiry Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="asnItemsTable">
                                <tr>
                                    <td>
                                        <select name="categoryId" class="form-select" required>
                                            <option value="">Select Product</option>
                                            <c:forEach var="categories" items="${categoryList}">
                                                <option value="${categories.categoryId}">${categories.name}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td>
                                        <select name="productId" class="form-select" required>
                                            <option value="">Select Product</option>
                                            <c:forEach var="product" items="${products}">
                                                <option value="${product.productId}">${product.productName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td>
                                        <select name="weightId" class="form-select" required>
                                            <option value="">Select Weight</option>
                                            <c:forEach var="weight" items="${weights}">
                                                <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="number" name="quantity" class="form-control" min="1" value="1" required>
                                    </td>
                                    <td>
                                        <input type="date" name="expiryDate" class="form-select" required>

                                        </select>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-danger btn-sm" onclick="removeASNItem(this)">
                                            Remove
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="button" class="btn btn-info btn-sm" onclick="addASNItem()">
                            Add Item
                        </button>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Create ASN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- View ASN Details Modal -->
    <div class="modal fade" id="viewASNModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">ASN Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="asnDetailsContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function() {
            setTimeout(function() {
                $('.toast').toast('hide');
            }, 5000);
        });

        function addASNItem() {
            const row = `
                <tr>
                    <td>
                        <select name="categoryId" class="form-select" required>
                            <option value="">Select Category</option>
                            <c:forEach var="category" items="${categoryList}">
                                <option value="${category.categoryId}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="productId" class="form-select" required>
                            <option value="">Select Product</option>
                            <c:forEach var="product" items="${products}">
                                <option value="${product.productId}">${product.productName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="weightId" class="form-select" required>
                            <option value="">Select Weight</option>
                            <c:forEach var="weight" items="${weights}">
                                <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <input type="number" name="quantity" class="form-control" min="1" value="1" required>
                    </td>
                    <td>
                        <input type="date" name="expiryDate" class="form-control" required>
                    </td>
                    <td>
                        <button type="button" class="btn btn-danger btn-sm" onclick="removeASNItem(this)">
                            Remove
                        </button>
                    </td>
                </tr>
            `;
            $('#asnItemsTable').append(row);
        }

        function removeASNItem(button) {
            if ($('#asnItemsTable tr').length > 1) {
                $(button).closest('tr').remove();
            } else {
                Swal.fire({
                    icon: 'warning',
                    title: 'Cannot remove',
                    text: 'You must have at least one item in the ASN'
                });
            }
        }

function viewASNDetails(asnId) {
    window.location.href = 'ASNManagement?action=view&asnId=' + asnId;
}



        $('#createASNForm').submit(function(e) {
            e.preventDefault();

            if ($('#asnItemsTable tr').length === 0) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Please add at least one item to the ASN'
                });
                return;
            }

            this.submit();
        });
    </script>
</body>
</html>