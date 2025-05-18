<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Customer" %>
<%@ page import="com.warehouse.dao.CustomerDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Manage Customers</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container mt-4">
    <h2>Customer Management</h2>

    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Customer</button>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Contact Number</th>
                <th>Email</th>
                <th>Address</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="customerTable">
            <c:forEach var="c" items="${customers}">
                <tr data-id="${c.customerId}">
                    <td>${c.customerId}</td>
                    <td class="name">${c.name}</td>
                    <td class="contact">${c.contactNumber}</td>
                    <td class="email">${c.email}</td>
                    <td class="address">${c.address}</td>
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
                <div class="modal-header"><h5>Add Customer</h5></div>
                <div class="modal-body">
                    <input type="text" name="name" class="form-control mb-2" placeholder="Customer Name" required/>
                    <input type="text" name="contactNumber" class="form-control mb-2" placeholder="Contact Number" required/>
                    <input type="email" name="email" class="form-control mb-2" placeholder="Email" required/>
                    <textarea name="address" class="form-control mb-2" placeholder="Address" required></textarea>
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
                <div class="modal-header"><h5>Edit Customer</h5></div>
                <div class="modal-body">
                    <input type="text" name="name" class="form-control mb-2" required/>
                    <input type="text" name="contactNumber" class="form-control mb-2" required/>
                    <input type="email" name="email" class="form-control mb-2" required/>
                    <textarea name="address" class="form-control mb-2" required></textarea>
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
            $.post('manageCustomer', {
                action: 'create',
                name: $(this).find('[name=name]').val(),
                contactNumber: $(this).find('[name=contactNumber]').val(),
                email: $(this).find('[name=email]').val(),
                address: $(this).find('[name=address]').val()
            }, function() {
                location.reload();
            });
        });

        $('.editBtn').click(function() {
            const row = $(this).closest('tr');
            $('#editForm [name=id]').val(row.data('id'));
            $('#editForm [name=name]').val(row.find('.name').text());
            $('#editForm [name=contactNumber]').val(row.find('.contact').text());
            $('#editForm [name=email]').val(row.find('.email').text());
            $('#editForm [name=address]').val(row.find('.address').text());
            new bootstrap.Modal(document.getElementById('editModal')).show();
        });

        $('#editForm').submit(function(e) {
            e.preventDefault();
            $.post('manageCustomer', {
                action: 'update',
                id: $(this).find('[name=id]').val(),
                name: $(this).find('[name=name]').val(),
                contactNumber: $(this).find('[name=contactNumber]').val(),
                email: $(this).find('[name=email]').val(),
                address: $(this).find('[name=address]').val()
            }, function() {
                location.reload();
            });
        });

        $('.deleteBtn').click(function() {
            if (confirm("Are you sure you want to delete this customer?")) {
                const id = $(this).closest('tr').data('id');
                $.post('manageCustomer', {
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