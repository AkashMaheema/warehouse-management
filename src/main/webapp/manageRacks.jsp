<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Rack" %>
<%@ page import="com.warehouse.dao.RacksDAO" %>
<%@ page import="com.warehouse.models.Zone" %>
<%@ page import="com.warehouse.dao.ZoneDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<Zone> sortedZones = new ArrayList<>((List<Zone>) request.getAttribute("zones"));
    sortedZones.sort(Comparator.comparing(Zone::getZoneName));
    request.setAttribute("sortedZones", sortedZones);
%>

<html>
<head>
    <title>Manage Racks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container mt-4">
<h2>Rack Management</h2>

<c:if test="${not empty warning}">
    <div class="alert alert-warning">${warning}</div>
</c:if>

<button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Rack</button>

<table class="table table-bordered">
    <thead>
    <tr><th>Rack Name</th><th>Zone</th><th>Capacity</th><th>Used Capacity</th><th>Actions</th></tr>
    </thead>
    <tbody id="rackTable">
    <%
        // Prepare grouped and sorted racks in Java
        List<Zone> zones = (List<Zone>) request.getAttribute("zones");
        List<Rack> allRacks = (List<Rack>) request.getAttribute("racks");

        Map<Integer, List<Rack>> zoneRackMap = new LinkedHashMap<>();

        zones.sort(Comparator.comparing(Zone::getZoneName)); // sort zones alphabetically

        for (Zone z : zones) {
            List<Rack> racksInZone = new ArrayList<>();
            for (Rack r : allRacks) {
                if (r.getZoneId() == z.getZoneId()) {
                    racksInZone.add(r);
                }
            }
            racksInZone.sort(Comparator.comparing(Rack::getRackName)); // sort racks alphabetically
            zoneRackMap.put(z.getZoneId(), racksInZone);
        }

        request.setAttribute("zoneRackMap", zoneRackMap);
        request.setAttribute("sortedZones", zones); // in case needed elsewhere
    %>

    <c:forEach var="zone" items="${sortedZones}">
        <tr>
            <td colspan="5" class="table-secondary fw-bold">
                Zone: ${zone.zoneName} (ID: ${zone.zoneId})
            </td>
        </tr>
        <c:forEach var="r" items="${zoneRackMap[zone.zoneId]}">
            <tr data-id="${r.rackId}" data-zone-id="${r.zoneId}">
                <td class="name">${r.rackName}</td>
                <td>${zone.zoneName} </td>
                <td>${r.rackCapacity}</td>
                <td>${r.usedCapacity}</td>
                <td>
                    <button class="btn btn-sm btn-warning editBtn" data-id="${r.rackId}">Edit</button>
                    <button class="btn btn-sm btn-danger deleteBtn" data-id="${r.rackId}">Delete</button>
                </td>
            </tr>
        </c:forEach>
        <tr><td colspan="5" class="bg-light"></td></tr> <!-- Spacer row between zones -->
    </c:forEach>

    </tbody>
</table>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <form id="addForm" class="modal-content">
            <div class="modal-header"><h5>Add Rack</h5></div>
            <div class="modal-body">
                <input type="text" name="rackName" class="form-control" placeholder="Rack Name" required/>

                <select name="zoneId" class="form-control mt-2" required>
                    <option value="" disabled selected>Select Zone</option>
                    <c:forEach var="zone" items="${sortedZones}">
                        <option value="${zone.zoneId}">${zone.zoneName} (ID: ${zone.zoneId})</option>
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
            <div class="modal-header">
                <h5 class="modal-title">Edit Rack</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Rack Name</label>
                    <input type="text" name="rackName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Zone</label>
                    <select name="zoneId" class="form-select" required>
                        <option value="" disabled>Select Zone</option>
                        <c:forEach var="zone" items="${sortedZones}">
                            <option value="${zone.zoneId}">${zone.zoneName} (ID: ${zone.zoneId})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Rack Capacity</label>
                    <input type="number" name="rackCapacity" class="form-control" min="1" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Used Capacity</label>
                    <input type="number" name="usedCapacity" class="form-control" min="0" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
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

    // Edit Button Click Handler
    $('.editBtn').click(function() {
        const row = $(this).closest('tr');
        $('#editForm [name=id]').val(row.data('id'));
        $('#editForm [name=rackName]').val(row.find('.name').text());
        $('#editForm [name=zoneId]').val(row.data('zone-id'));
        $('#editForm [name=rackCapacity]').val(row.find('td:nth-child(3)').text().trim());
        $('#editForm [name=usedCapacity]').val(row.find('td:nth-child(4)').text().trim());
        new bootstrap.Modal(document.getElementById('editModal')).show();
    });

    // Edit Form Submission Handler
    $('#editForm').submit(function(e) {
        e.preventDefault();

        const btn = $(this).find('button[type="submit"]');
        btn.prop('disabled', true);
        btn.html('<span class="spinner-border spinner-border-sm"></span> Updating...');

        $.ajax({
            url: 'manageRacks',
            type: 'POST',
            data: $(this).serialize() + '&action=update',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Close modal and refresh
                    $('#editModal').modal('hide');
                    showSuccessAlert(response.message || 'Rack updated successfully');
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showErrorAlert(response.message || 'Update failed');
                }
            },
            error: function(xhr) {
                let message = 'Error communicating with server';
                try {
                    const response = JSON.parse(xhr.responseText);
                    message = response.message || message;
                } catch (e) {}
                showErrorAlert(message);
            },
            complete: function() {
                btn.prop('disabled', false);
                btn.html('Update');
            }
        });
    });

    // Helper functions for alerts
    function showSuccessAlert(message) {
        const alert = `<div class="alert alert-success alert-dismissible fade show position-fixed top-0 end-0 m-3">
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>`;
        $('body').append(alert);
        setTimeout(() => $('.alert-success').alert('close'), 3000);
    }

    function showErrorAlert(message) {
        const alert = `<div class="alert alert-danger alert-dismissible fade show position-fixed top-0 end-0 m-3">
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>`;
        $('body').append(alert);
        setTimeout(() => $('.alert-danger').alert('close'), 5000);
    }


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
