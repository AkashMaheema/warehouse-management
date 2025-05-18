<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Category" %>
<%@ page import="com.warehouse.dao.CategoryDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageSupplier" />
    <jsp:param name="activePage" value="manageSupplier" />
    <jsp:param name="content" value="manageSupplier" />
</jsp:include>

<html>
<head>
    <title>Manage Suppliers</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="container mt-4">
    <h2 class="supplier-heading">Supplier Management</h2>
    <div class="d-flex justify-content-end mb-3">
         <input type="text" id="searchInput" class="form-control" style="width: 250px;" placeholder="Search by supplier name...">
    </div>

    <button class="custom-add-btn mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Supplier</button>

    <div class="table-container">
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Contact Person</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="supplierTable">
                <c:forEach var="s" items="${suppliers}">
                    <tr data-id="${s.supplierId}">
                        <td>${s.supplierId}</td>
                        <td class="name">${s.name}</td>
                        <td class="contact">${s.contactPerson}</td>
                        <td class="phone">${s.phone}</td>
                        <td class="email">${s.email}</td>
                        <td>
                            <button class="btn btn-sm btn-warning editBtn">Edit</button>
                            <button class="btn btn-sm btn-danger deleteBtn">Delete</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <form id="addForm" class="modal-content">
                <div class="modal-header"><h5>Add Supplier</h5></div>
                <div class="modal-body">
                    <input type="text" name="name" class="form-control mb-2" placeholder="Supplier Name" required/>
                    <input type="text" name="contactPerson" class="form-control mb-2" placeholder="Contact Person" required/>
                    <input type="text" name="phone" class="form-control mb-2" placeholder="Phone" required/>
                    <input type="email" name="email" class="form-control mb-2" placeholder="Email" required/>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Save</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <form id="editForm" class="modal-content">
                <input type="hidden" name="id"/>
                <div class="modal-header"><h5>Edit Supplier</h5></div>
                <div class="modal-body">
                    <input type="text" name="name" class="form-control mb-2" required/>
                    <input type="text" name="contactPerson" class="form-control mb-2" required/>
                    <input type="text" name="phone" class="form-control mb-2" required/>
                    <input type="email" name="email" class="form-control mb-2" required/>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Update</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/manage_supplier_script.js"></script>
</body>
</html>
