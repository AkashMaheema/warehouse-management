<%@ page import="java.util.List" %>
<%@ page import="com.warehouse.models.ReorderItem" %>
<%@ page import="com.warehouse.dao.ProductDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<ReorderItem> reorderList = (List<ReorderItem>) request.getAttribute("reorderList");
    ProductDAO productDAO = new ProductDAO();
%>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageReorder" />
    <jsp:param name="activePage" value="manageReorder" />
    <jsp:param name="content" value="manageReorder" />
</jsp:include>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Reorders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="container">
    <h2 class="category-heading">Reorder Management</h2>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Reorder ID</th>
                    <th>Product Name</th>
                    <th>Quantity</th>
                    <th>Reorder Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (ReorderItem item : reorderList) {
                    String productName = productDAO.getProductById(item.getProductId()).getProductName();
                %>
                <tr data-id="<%= item.getReorderId() %>">
                    <td><%= item.getReorderId() %></td>
                    <td><%= productName %></td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= item.getReorderDate() %></td>
                    <td class="status"><%= item.getStatus() %></td>
                    <td>
                        <button class="btn btn-sm btn-warning updateBtn"
                                data-id="<%= item.getReorderId() %>"
                                data-status="<%= item.getStatus() %>">
                            <i class="bi bi-pencil-square"></i> Update
                        </button>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Update Modal -->
    <div class="modal fade" id="updateModal" tabindex="-1">
        <div class="modal-dialog">
            <form method="post" action="Reorder" class="modal-content">
                <input type="hidden" name="reorderId" id="reorderId">
                <div class="modal-header">
                    <h5 class="modal-title">Update Reorder Status</h5>
                </div>
                <div class="modal-body">
                    <label for="status" class="form-label">Status</label>
                    <select name="status" id="status" class="form-select" required>
                        <option value="pending">Pending</option>
                        <option value="approved">Approved</option>
                        <option value="delivered">Delivered</option>
                    </select>
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
    $(document).ready(function () {
        $('.updateBtn').click(function () {
            const id = $(this).data('id');
            const status = $(this).data('status');
            $('#reorderId').val(id);
            $('#status').val(status);
            new bootstrap.Modal(document.getElementById('updateModal')).show();
        });
    });
</script>
</body>
</html>
