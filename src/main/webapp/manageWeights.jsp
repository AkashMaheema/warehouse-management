<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Weight" %>
<%@ page import="com.warehouse.dao.WeightDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Manage Weights</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container mt-4">
    <h2>Weight Management</h2>

    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Weight</button>

    <table class="table table-bordered">
        <thead>
            <tr><th>ID</th><th>Weight</th><th>Actions</th></tr>
        </thead>
        <tbody id="weightTable">
            <c:forEach var="w" items="${weights}">
                <tr data-id="${w.weightId}">
                    <td>${w.weightId}</td>
                    <td class="value">${w.weightValue} Kg</td>
                    <td>
                        <button class="btn btn-sm btn-warning editBtn" data-id="${w.weightId}">Edit</button>
                        <button class="btn btn-sm btn-danger deleteBtn" data-id="${w.weightId}">Delete</button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <form id="addForm" class="modal-content">
                <div class="modal-header"><h5>Add Weight</h5></div>
                <div class="modal-body">
                    <input type="number" step="0.01" name="weightValue" class="form-control" placeholder="Weight" required/>
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
                <div class="modal-header"><h5>Edit Weight</h5></div>
                <div class="modal-body">
                    <input type="number" step="0.01" name="weightValue" class="form-control" required/>
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
            $.post('manageWeights', {
                action: 'create',
                weightValue: $(this).find('[name=weightValue]').val()
            }, function() {
                location.reload();
            });
        });

        $('.editBtn').click(function() {
            const row = $(this).closest('tr');
            $('#editForm [name=id]').val(row.data('id'));
            $('#editForm [name=weightValue]').val(row.find('.value').text());
            new bootstrap.Modal(document.getElementById('editModal')).show();
        });

        $('#editForm').submit(function(e) {
            e.preventDefault();
            $.post('manageWeights', {
                action: 'update',
                id: $(this).find('[name=id]').val(),
                weightValue: $(this).find('[name=weightValue]').val()
            }, function() {
                location.reload();
            });
        });

        $('.deleteBtn').click(function() {
            if (confirm("Are you sure?")) {
                const id = $(this).closest('tr').data('id');
                $.post('manageWeights', {
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
