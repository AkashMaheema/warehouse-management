<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Category" %>
<%@ page import="com.warehouse.dao.CategoryDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageCategory" />
    <jsp:param name="activePage" value="manageCategory" />
    <jsp:param name="content" value="manageCategory" />
</jsp:include>

<html>
<head>
    <title>Manage Categories</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>

<body>
    <div class="container">
        <h2 class="category-heading">Category Management</h2>

        <div class="d-flex justify-content-end mb-3">
            <input type="text" id="searchInput" class="form-control" style="width: 250px;" placeholder="Search by category name...">
        </div>

        <button class="btn btn-primary mb-3 custom-add-btn" data-bs-toggle="modal" data-bs-target="#addModal">Add Category</button>

        <div class="table-container">
            <table class="table table-bordered">
                <thead>
                    <tr><th>ID</th><th>Name</th><th>Actions</th></tr>
                </thead>
                <tbody id="categoryTable">
                    <c:forEach var="c" items="${categories}">
                        <tr data-id="${c.categoryId}">
                            <td>${c.categoryId}</td>
                            <td class="name">${c.name}</td>
                            <td>
                                <button class="btn btn-sm btn-warning editBtn" data-id="${c.categoryId}">Edit</button>
                                <button class="btn btn-sm btn-danger deleteBtn" data-id="${c.categoryId}">Delete</button>
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
                    <div class="modal-header"><h5>Add Category</h5></div>
                    <div class="modal-body">
                        <input type="text" name="name" class="form-control" placeholder="Category Name" required/>
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
                    <div class="modal-header"><h5>Edit Category</h5></div>
                    <div class="modal-body">
                        <input type="text" name="name" class="form-control" required/>
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
            $.post('manageCategory', {
                action: 'create',
                name: $(this).find('[name=name]').val()
            }, function() {
                location.reload();
            });
        });

        $('.editBtn').click(function() {
            const row = $(this).closest('tr');
            $('#editForm [name=id]').val(row.data('id'));
            $('#editForm [name=name]').val(row.find('.name').text());
            new bootstrap.Modal(document.getElementById('editModal')).show();
        });

        $('#editForm').submit(function(e) {
            e.preventDefault();
            $.post('manageCategory', {
                action: 'update',
                id: $(this).find('[name=id]').val(),
                name: $(this).find('[name=name]').val()
            }, function() {
                location.reload();
            });
        });

        $('.deleteBtn').click(function() {
            if (confirm("Are you sure?")) {
                const id = $(this).closest('tr').data('id');
                $.post('manageCategory', {
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
