<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Rack" %>
<%@ page import="com.warehouse.models.Zone" %>
<%@ page import="com.warehouse.dao.ZoneDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageRacks" />
    <jsp:param name="activePage" value="manageRacks" />
    <jsp:param name="content" value="manageRacks" />
</jsp:include>

<%
    List<Zone> sortedZones = new ArrayList<>((List<Zone>) request.getAttribute("zones"));
    sortedZones.sort(Comparator.comparing(Zone::getZoneName));
    request.setAttribute("sortedZones", sortedZones);
%>

<html>
<head>
    <title>Manage Racks</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="container mt-4">
<h2>Rack Management</h2>

<c:if test="${not empty warning}">
    <div class="alert alert-warning">${warning}</div>
</c:if>

<button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Rack</button>


<div class="table-container">
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
                Zone: ${zone.zoneName}
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
</div>

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
<script src="js/manage_racks_script.js"></script>

</body>
</html>
