<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Supplier" %>
<%@ page import="com.warehouse.dao.SupplierDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Manage Suppliers</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container mt-4">
    <h2>Supplier Management</h2>

    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Supplier</button>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th><th>Name</th><th>Contact Person</th><th>Phone</th><th>Email</th><th>Actions</th>
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
    <script>
        $('#addForm').submit(function(e) {
            e.preventDefault();
            $.post('manageSupplier', {
                action: 'create',
                name: $(this).find('[name=name]').val(),
                contactPerson: $(this).find('[name=contactPerson]').val(),
                phone: $(this).find('[name=phone]').val(),
                email: $(this).find('[name=email]').val()
            }, function() {
                location.reload();
            });
        });

        $('.editBtn').click(function() {
            const row = $(this).closest('tr');
            $('#editForm [name=id]').val(row.data('id'));
            $('#editForm [name=name]').val(row.find('.name').text());
            $('#editForm [name=contactPerson]').val(row.find('.contact').text());
            $('#editForm [name=phone]').val(row.find('.phone').text());
            $('#editForm [name=email]').val(row.find('.email').text());
            new bootstrap.Modal(document.getElementById('editModal')).show();
        });

        $('#editForm').submit(function(e) {
            e.preventDefault();
            $.post('manageSupplier', {
                action: 'update',
                id: $(this).find('[name=id]').val(),
                name: $(this).find('[name=name]').val(),
                contactPerson: $(this).find('[name=contactPerson]').val(),
                phone: $(this).find('[name=phone]').val(),
                email: $(this).find('[name=email]').val()
            }, function() {
                location.reload();
            });
        });

        $('.deleteBtn').click(function() {
            if (confirm("Are you sure?")) {
                const id = $(this).closest('tr').data('id');
                $.post('manageSupplier', {
                    action: 'delete',
                    id: id
                }, function() {
                    location.reload();
                });
            }
        });
    </script>
</body>
</html>
