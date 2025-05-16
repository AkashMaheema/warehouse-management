<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Category" %>
<%@ page import="com.warehouse.dao.CategoryDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageRacks" />
    <jsp:param name="activePage" value="manageRacks" />
    <jsp:param name="content" value="manageRacks" />
</jsp:include>

<html>
<head>
    <title>Manage Racks</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<div class="container">
        <h2 class="category-heading">Rack Management</h2>
<button class="btn btn-primary mb-3 custom-add-btn" data-bs-toggle="modal" data-bs-target="#addModal">Add Rack</button>

<div class="table-container">
<table class="table table-bordered">
    <thead>
    <tr><th>ID</th><th>Rack Name</th><th>Zone</th><th>Capacity</th><th>Used Capacity</th><th>Actions</th></tr>
    </thead>
    <tbody id="rackTable">
    <c:forEach var="r" items="${racks}">
        <tr data-id="${r.rackId}">
            <td>${r.rackId}</td>
            <td class="name">${r.rackName}</td>
            <td>${r.zoneId}</td>
            <td>${r.rackCapacity}</td>
            <td>${r.usedCapacity}</td>
            <td>
                <button class="btn btn-sm btn-warning editBtn" data-id="${r.rackId}">Edit</button>
                <button class="btn btn-sm btn-danger deleteBtn" data-id="${r.rackId}">Delete</button>
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
            <div class="modal-header"><h5>Add Rack</h5></div>
            <div class="modal-body">
                <input type="text" name="rackName" class="form-control" placeholder="Rack Name" required/>

                <!-- Zone Dropdown -->
                <select name="zoneId" class="form-control mt-2" required>
                    <option value="" disabled selected>Select Zone</option>
                    <c:forEach var="zone" items="${zones}">
                        <option value="${zone.zoneId}">${zone.zoneName}</option>
                    </c:forEach>
                </select>

                <input type="number" name="rackCapacity" class="form-control mt-2" placeholder="Rack Capacity" required/>
                <input type="number" name="usedCapacity" class="form-control mt-2" placeholder="Used Capacity" required/>
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
            <div class="modal-header"><h5>Edit Rack</h5></div>
            <div class="modal-body">
                <input type="text" name="rackName" class="form-control" required/>

                <!-- Zone Dropdown -->
                <select name="zoneId" class="form-control mt-2" required>
                    <option value="" disabled>Select Zone</option>
                    <c:forEach var="zone" items="${zones}">
                        <option value="${zone.zoneId}">${zone.zoneName}</option>
                    </c:forEach>
                </select>

                <input type="number" name="rackCapacity" class="form-control mt-2" required/>
                <input type="number" name="usedCapacity" class="form-control mt-2" required/>
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
        $.post('manageRacks', {
            action: 'create',
            rackName: $(this).find('[name=rackName]').val(),
            zoneId: $(this).find('[name=zoneId]').val(),
            rackCapacity: $(this).find('[name=rackCapacity]').val(),
            usedCapacity: $(this).find('[name=usedCapacity]').val()
        }, function() {
            location.reload();
        });
    });

    $('.editBtn').click(function() {
        const row = $(this).closest('tr');
        $('#editForm [name=id]').val(row.data('id'));
        $('#editForm [name=rackName]').val(row.find('.name').text());
        $('#editForm [name=zoneId]').val(row.find('td:nth-child(3)').text());
        $('#editForm [name=rackCapacity]').val(row.find('td:nth-child(4)').text());
        $('#editForm [name=usedCapacity]').val(row.find('td:nth-child(5)').text());
        new bootstrap.Modal(document.getElementById('editModal')).show();
    });

    $('#editForm').submit(function(e) {
        e.preventDefault();
        $.post('manageRacks', {
            action: 'update',
            id: $(this).find('[name=id]').val(),
            rackName: $(this).find('[name=rackName]').val(),
            zoneId: $(this).find('[name=zoneId]').val(),
            rackCapacity: $(this).find('[name=rackCapacity]').val(),
            usedCapacity: $(this).find('[name=usedCapacity]').val()
        }, function() {
            location.reload();
        });
    });

    $('.deleteBtn').click(function() {
        if (confirm("Are you sure?")) {
            const id = $(this).closest('tr').data('id');
            $.post('manageRacks', {
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
