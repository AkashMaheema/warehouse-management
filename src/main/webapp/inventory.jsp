<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>



<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="inventory" />
    <jsp:param name="activePage" value="inventory" />
    <jsp:param name="content" value="inventory" />
</jsp:include>

<html>
<head>
    <title>Manage Inventory</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>

<body>
    <div class="container">
        <h2 class="mt-4">Inventory Management</h2>

        <div class="d-flex justify-content-end mb-3">
            <input type="text" id="searchInput" class="form-control" style="width: 250px;" placeholder="Search by rice type...">
        </div>

        <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Inventory</button>

        <div class="table-responsive">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Rice Type</th>
                        <th>Quantity (kg)</th>
                        <th>Warehouse Location</th>
                        <th>Last Updated</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="inventoryTable">
                    <c:forEach var="inv" items="${inventoryList}">
                        <tr data-id="${inv.id}">
                            <td>${inv.id}</td>
                            <td class="type">${inv.riceType}</td>
                            <td class="qty">${inv.quantity}</td>
                            <td class="loc">${inv.location}</td>
                            <td>${inv.lastUpdated}</td>
                            <td>
                                <button class="btn btn-sm btn-warning editBtn">Edit</button>
                                <button class="btn btn-sm btn-danger deleteBtn">Delete</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Add Inventory Modal -->
        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog">
                <form id="addForm" class="modal-content">
                    <div class="modal-header"><h5>Add Inventory</h5></div>
                    <div class="modal-body">
                        <input type="text" name="riceType" class="form-control mb-2" placeholder="Rice Type" required>
                        <input type="number" name="quantity" class="form-control mb-2" placeholder="Quantity (kg)" required>
                        <input type="text" name="location" class="form-control" placeholder="Warehouse Location" required>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Save</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit Inventory Modal -->
        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog">
                <form id="editForm" class="modal-content">
                    <input type="hidden" name="id"/>
                    <div class="modal-header"><h5>Edit Inventory</h5></div>
                    <div class="modal-body">
                        <input type="text" name="riceType" class="form-control mb-2" required>
                        <input type="number" name="quantity" class="form-control mb-2" required>
                        <input type="text" name="location" class="form-control" required>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        $('#addForm').submit(function(e) {
            e.preventDefault();
            $.post('manageInventory', {
                action: 'create',
                riceType: $(this).find('[name=riceType]').val(),
                quantity: $(this).find('[name=quantity]').val(),
                location: $(this).find('[name=location]').val()
            }, function() {
                location.reload();
            });
        });

        $('.editBtn').click(function() {
            const row = $(this).closest('tr');
            $('#editForm [name=id]').val(row.data('id'));
            $('#editForm [name=riceType]').val(row.find('.type').text());
            $('#editForm [name=quantity]').val(row.find('.qty').text());
            $('#editForm [name=location]').val(row.find('.loc').text());
            new bootstrap.Modal(document.getElementById('editModal')).show();
        });

        $('#editForm').submit(function(e) {
            e.preventDefault();
            $.post('manageInventory', {
                action: 'update',
                id: $(this).find('[name=id]').val(),
                riceType: $(this).find('[name=riceType]').val(),
                quantity: $(this).find('[name=quantity]').val(),
                location: $(this).find('[name=location]').val()
            }, function() {
                location.reload();
            });
        });

        $('.deleteBtn').click(function() {
            if (confirm("Are you sure you want to delete this inventory item?")) {
                const id = $(this).closest('tr').data('id');
                $.post('manageInventory', {
                    action: 'delete',
                    id: id
                }, function() {
                    location.reload();
                });
            }
        });
    </script>

    <script src="js/script.js"></script>
</body>
</html>
