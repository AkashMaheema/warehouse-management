<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Category" %>
<%@ page import="com.warehouse.dao.CategoryDAO" %>
<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageZone" />
    <jsp:param name="activePage" value="manageZone" />
    <jsp:param name="content" value="manageZone" />
</jsp:include>

<html>
<head>
    <title>Manage Zones</title>
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
     <link rel="stylesheet" href="css/style.css">
</head>
<div class="container">
        <h2 class="category-heading">Category Zone</h2>

<button class="btn btn-primary mb-3 custom-add-btn" data-bs-toggle="modal" data-bs-target="#addModal">Add Zone</button>

<div class="table-container">
<table class="table table-bordered">
    <thead>
        <tr><th>ID</th><th>Name</th><th>Capacity</th><th>Used</th><th>Actions</th></tr>
    </thead>
    <tbody>
        <c:forEach var="z" items="${zones}">
            <tr data-id="${z.zoneId}">
                <td>${z.zoneId}</td>
                <td class="name">${z.zoneName}</td>
                <td class="capacity">${z.zoneCapacity}</td>
                <td class="used">${z.usedCapacity}</td>
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
            <div class="modal-header"><h5>Add Zone</h5></div>
            <div class="modal-body">
                <input type="text" name="name" class="form-control mb-2" placeholder="Zone Name" required/>
                <input type="number" name="capacity" class="form-control mb-2" placeholder="Total Capacity" required/>
                <input type="number" name="used" class="form-control" placeholder="Used Capacity" required/>
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
            <div class="modal-header"><h5>Edit Zone</h5></div>
            <div class="modal-body">
                <input type="text" name="name" class="form-control mb-2" required/>
                <input type="number" name="capacity" class="form-control mb-2" required/>
                <input type="number" name="used" class="form-control" required/>
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
        $.post('manageZone', {
            action: 'create',
            name: this.name.value,
            capacity: this.capacity.value,
            used: this.used.value
        }, () => location.reload());
    });

    $('.editBtn').click(function() {
        const row = $(this).closest('tr');
        $('#editForm [name=id]').val(row.data('id'));
        $('#editForm [name=name]').val(row.find('.name').text());
        $('#editForm [name=capacity]').val(row.find('.capacity').text());
        $('#editForm [name=used]').val(row.find('.used').text());
        new bootstrap.Modal(document.getElementById('editModal')).show();
    });

    $('#editForm').submit(function(e) {
        e.preventDefault();
        $.post('manageZone', {
            action: 'update',
            id: this.id.value,
            name: this.name.value,
            capacity: this.capacity.value,
            used: this.used.value
        }, () => location.reload());
    });

    $('.deleteBtn').click(function() {
        if (confirm("Are you sure?")) {
            const id = $(this).closest('tr').data('id');
            $.post('manageZone', {
                action: 'delete',
                id: id
            }, () => location.reload());
        }
    });
</script>
</body>
</html>