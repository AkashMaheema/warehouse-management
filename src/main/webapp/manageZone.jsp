<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Zone" %>
<%@ page import="com.warehouse.dao.ZoneDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Manage Zones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container mt-4">
<h2>Zone Management</h2>

<button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Zone</button>

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
<script src="js/manage_zone_script.js"></script>


</body>
</html>