<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.warehouse.models.Product" %>
<%@ page import="com.warehouse.dao.ProductDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageProduct" />
    <jsp:param name="activePage" value="manageProduct" />
    <jsp:param name="content" value="manageProduct" />
</jsp:include>

<html>
<head>
    <title>Manage Products</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>

<body class="container mt-4">
    <h2 class="product-heading">Product Management</h2>
   <div class="d-flex justify-content-end mb-3">
           <input type="text" id="searchInput" class="form-control" style="width: 250px;" placeholder="Search by product name...">
       </div>


    <button class="custom-add-btn mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Product</button>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Weight</th>
                    <th>Reorder Level</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="productTable">
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.productId}</td>
                        <td class="product-name">${product.productName}</td> <!-- Add class here -->
                        <td>${product.categoryName}</td>
                        <td>${product.weightValue} Kg</td>
                        <td>${product.reorderLevel}</td>
                        <td>
                            <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal" data-id="${product.productId}">Edit</button>
                            <button class="btn btn-danger btn-sm" onclick="deleteProduct(${product.productId})">Delete</button>
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
                <div class="modal-header"><h5>Add Product</h5></div>
                <div class="modal-body">
                    <input type="text" name="productName" class="form-control" placeholder="Product Name" required/>
                    <select name="categoryId" class="form-control mt-2" required>
                        <option value="">Select Category</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}">${category.name}</option>
                        </c:forEach>
                    </select>
                    <select name="weightId" class="form-control mt-2" required>
                        <option value="">Select Weight</option>
                        <c:forEach var="weight" items="${weights}">
                            <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                        </c:forEach>
                    </select>
                    <input type="number" name="reorderLevel" class="form-control mt-2" placeholder="Reorder Level" required/>
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
                <!-- Add dynamic content via JS if needed -->
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $('#addForm').submit(function(e) {
            e.preventDefault();
            $.post('manageProduct', $(this).serialize(), function() {
                location.reload();
            });
        });

        function deleteProduct(id) {
            if (confirm("Are you sure?")) {
                $.post('manageProduct', { action: 'delete', productId: id }, function() {
                    location.reload();
                });
            }
        }
    </script>
    <script src="js/script.js"></script>

</body>
</html>
