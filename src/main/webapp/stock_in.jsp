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
        <meta charset="UTF-8">
        <title>Stock In - Rice</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/style.css">

    </head>
    <body>
    <%
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
    %>
        <div class="d-flex justify-content-center mt-3">
            <div class="alert alert-success alert-dismissible fade show text-center shadow-sm rounded px-4 py-2" role="alert" style="width: 320px;">
                ✅ Stored successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    <%
            session.removeAttribute("successMessage");
        }
    %>



    <div class="container">
            <h2 class="category-heading">New Rice Stock Entry</h2>
        <form action="StockIn" method="post">
        <c:choose>
            <c:when test="${not empty stockIn}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="stockInId" value="${stockIn.id}">
            </c:when>
            <c:otherwise>
                <input type="hidden" name="action" value="add">
            </c:otherwise>
        </c:choose> 
            <div class="form-row mb-3">
                <div class="col-md-4">
                    <label for="supplier_id">Supplier</label>
                    <select name="supplierId" class="form-control supplier-select" required>
                        <option value="">Select</option>
                        <c:forEach var="s" items="${supplierList}">
                            <option value="${s.supplierId}" ${stockIn.supplierId == s.supplierId ? 'selected' : ''}>${s.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="arrival_date">Arrival Date</label>
                    <input type="date" name="arrival_date" class="form-control" value="${stockIn.arrivalDate}" required>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
                <button type="button" class="btn btn-info me-2" onclick="addRow()">Add New Stock</button>

                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addModalProduct">Add New Product</button>
                    <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addModalSupplier">Add New Supplier</button>
                </div>
            </div>

                                <div class="table-container">
                                <table class="table table-bordered">
                                    <thead class="thead-light" style="font-size:12px;">
                                        <tr>
                                            <th>Product Category</th>
                                            <th>Product Name</th>
                                            <th>Product Weight</th>
                                            <th>Quantity</th>
                                            <th>Expiry Date</th>
                                            <th>Zone</th>
                                            <th>Rack</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="stockTableBody">
                                        <c:choose>
                                            <c:when test="${not empty stockIn && not empty stockIn.items}">
                                                <c:forEach var="item" items="${stockIn.items}">
                                                    <tr>
                                                        <td>
                                                            <select name="categoryId[]" class="form-control category-select" required>
                                                                <option value="">Select</option>
                                                                <c:forEach var="c" items="${categoryList}">
                                                                    <option value="${c.categoryId}"
                                                                        ${item.categoryId == c.categoryId ? 'selected' : ''}>
                                                                        ${c.name}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <select name="productId[]" class="form-control product-select" required>
                                                                <option value="">Select</option>
                                                                <c:forEach var="p" items="${productList}">
                                                                    <option value="${p.productId}"
                                                                        ${item.productId == p.productId ? 'selected' : ''}>
                                                                        ${p.productName}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <select name="weightId[]" class="form-control weight-select" required>
                                                                <option value="">Select</option>
                                                                <c:forEach var="w" items="${weightList}">
                                                                    <option value="${w.weightId}"
                                                                        ${item.weightId == w.weightId ? 'selected' : ''}>
                                                                        ${w.weightValue} Kg
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <input type="number" name="quantity[]" class="form-control"
                                                                value="${item.quantity}" min="1" required>
                                                        </td>
                                                        <td>
                                                            <input type="date" name="expire_date[]" class="form-control"
                                                                value="${item.expireDate}" required>
                                                        </td>
                                                        <td>
                                                            <input type="hidden" name="zoneid[]" class="zone-id" value="${item.zoneId}">
                                                            <input type="text" class="form-control zone-name"
                                                                value="${zoneMap[item.zoneId].zoneName}" readonly>
                                                            <button type="button" class="btn btn-sm btn-outline-primary mt-1 btn-select-zone">
                                                                Select Zone
                                                            </button>
                                                        </td>
                                                        <td>
                                                            <input type="hidden" name="rackid[]" class="rack-id" value="${item.rackId}">
                                                            <input type="text" class="form-control rack-name"
                                                                value="${rackMap[item.rackId].rackName}" readonly>
                                                            <button type="button" class="btn btn-sm btn-outline-secondary mt-1 btn-select-rack">
                                                                Select Rack
                                                            </button>
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">
                                                                Remove
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td>
                                                        <select name="categoryId[]" class="form-control category-select" required>
                                                            <option value="">Select</option>
                                                            <c:forEach var="c" items="${categoryList}">
                                                                <option value="${c.categoryId}">${c.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select name="productId[]" class="form-control product-select" required>
                                                            <option value="">Select</option>
                                                            <c:forEach var="p" items="${productList}">
                                                                <option value="${p.productId}">${p.productName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select name="weightId[]" class="form-control weight-select" required>
                                                            <option value="">Select</option>
                                                            <c:forEach var="w" items="${weightList}">
                                                                <option value="${w.weightId}">${w.weightValue} Kg</option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <input type="number" name="quantity[]" class="form-control" min="1" required>
                                                    </td>
                                                    <td>
                                                        <input type="date" name="expire_date[]" class="form-control" required>
                                                    </td>
                                                    <td>
                                                        <input type="hidden" name="zoneid[]" class="zone-id">
                                                        <input type="text" class="form-control zone-name" readonly>
                                                        <button type="button" class="btn btn-sm btn-outline-primary mt-1 btn-select-zone">
                                                            Select Zone
                                                        </button>
                                                    </td>
                                                    <td>
                                                        <input type="hidden" name="rackid[]" class="rack-id">
                                                        <input type="text" class="form-control rack-name" readonly>
                                                        <button type="button" class="btn btn-sm btn-outline-secondary mt-1 btn-select-rack">
                                                            Select Rack
                                                        </button>
                                                    </td>
                                                    <td>
                                                        <button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                                </div>
                            </div>
                        </div>
                        <div class="text-center mb-4">
                            <button
                                type="submit"
                                class="btn btn-primary btn-lg"
                                <c:if test="${disableUpdate}">disabled</c:if>>
                                <c:choose>
                                    <c:when test="${not empty stockIn}">
                                        Update Stock
                                    </c:when>
                                    <c:otherwise>
                                        Submit Stock
                                    </c:otherwise>
                                </c:choose>
                            </button>
                            <a href="StockIn" class="btn btn-secondary btn-lg ml-2">Cancel</a>
                        </div>
                    </form>
                </div>

        <!-- Zone Modal -->
        <div class="modal fade" id="zoneModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Select Zone</h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Zone</th>
                                    <th>Available Capacity (Kg)</th>
                                    <th>Select</th>
                                </tr>
                            </thead>
                            <tbody id="zoneTableBody">
                                <!-- Will be populated by AJAX -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Rack Modal -->
        <div class="modal fade" id="rackModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Select Rack</h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Rack</th>
                                    <th>Available Space (Kg)</th>
                                    <th>Select</th>
                                </tr>
                            </thead>
                            <tbody id="rackTableBody">
                                <!-- Will be populated by AJAX -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Modal -->
            <div class="modal fade" id="addModalProduct" tabindex="-1">
                <div class="modal-dialog">
                    <form id="addFormProduct" class="modal-content">
                        <div class="modal-header"><h5>Add Product</h5></div>
                        <div class="modal-body">
                            <input type="text" name="productName" class="form-control" placeholder="Product Name" required/>
                            <!-- Category Selector -->
                            <select name="categoryId" class="form-control mt-2" required>
                                <option value="">Select Category</option>
                                <c:forEach var="category" items="${categoryList}">
                                    <option value="${category.categoryId}">${category.name}</option>
                                </c:forEach>
                            </select>
                            <!-- Weight Selector -->
                            <select name="weightId" class="form-control mt-2" required>
                                <option value="">Select Weight</option>
                                <c:forEach var="weight" items="${weightList}">
                                    <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                                </c:forEach>
                            </select>
                            <input type="number" name="reorderLevel" class="form-control mt-2" placeholder="Reorder Level" required/>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-success">Save</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Add Supplier Modal -->
                <div class="modal fade" id="addModalSupplier" tabindex="-1">
                    <div class="modal-dialog">
                        <form id="addFormSupplier" class="modal-content">
                            <div class="modal-header"><h5>Add Supplier</h5></div>
                            <div class="modal-body">
                                <input type="text" id="supplierName" name="name" class="form-control mb-2" placeholder="Supplier Name" required/>
                                <input type="text" id="contactPerson" name="contactPerson" class="form-control mb-2" placeholder="Contact Person" required/>
                                <input type="text" id="phone" name="phone" class="form-control mb-2" placeholder="Phone" required/>
                                <input type="email" id="email" name="email" class="form-control mb-2" placeholder="Email" required/>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-success">Save</button>
                            </div>
                        </form>
                    </div>
                </div>


        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
        <script src="js/stock_in_script.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>
    </html>
