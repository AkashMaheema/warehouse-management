<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.warehouse.model.Product" %>
<%@ page import="com.warehouse.dao.ProductDAO" %>

<html>
<head>
    <title>Manage Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container mt-4">
    <h2>Product Management</h2>
    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">Add Product</button>

    <table class="table table-bordered">
        <thead>
            <tr><th>ID</th><th>Name</th><th>Category</th><th>Weight</th><th>Reorder Level</th><th>Actions</th></tr>
        </thead>
        <tbody id="productTable">
            <c:forEach var="product" items="${products}">
                <tr>
                    <td>${product.productId}</td>
                    <td>${product.productName}</td>
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

    <!-- Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <form id="addForm" class="modal-content">
                <div class="modal-header"><h5>Add Product</h5></div>
                <div class="modal-body">
                    <input type="text" name="productName" class="form-control" placeholder="Product Name" required/>
                    <!-- Category Selector -->
                    <select name="categoryId" class="form-control mt-2" required>
                        <option value="">Select Category</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}">${category.name}</option>
                        </c:forEach>
                    </select>
                    <!-- Weight Selector -->
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
                <div class="modal-header"><h5>Edit Product</h5></div>
                <div class="modal-body">
                    <input type="hidden" name="productId" id="editProductId"/>
                    <input type="text" name="productName" id="editProductName" class="form-control" placeholder="Product Name" required/>

                    <!-- Category -->
                    <select name="categoryId" id="editCategoryId" class="form-control mt-2" required>
                        <option value="">Select Category</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}">${category.name}</option>
                        </c:forEach>
                    </select>

                    <!-- Weight -->
                    <select name="weightId" id="editWeightId" class="form-control mt-2" required>
                        <option value="">Select Weight</option>
                        <c:forEach var="weight" items="${weights}">
                            <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                        </c:forEach>
                    </select>

                    <input type="number" name="reorderLevel" id="editReorderLevel" class="form-control mt-2" placeholder="Reorder Level" required/>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-warning">Update</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $('#addForm').submit(function(e) {
            e.preventDefault();
            $.post('manageProduct', {
                action: 'create',
                productName: $(this).find('[name=productName]').val(),
                categoryId: $(this).find('[name=categoryId]').val(),
                weightId: $(this).find('[name=weightId]').val(),
                reorderLevel: $(this).find('[name=reorderLevel]').val()
            }, function() {
                location.reload(); // Refresh the page after adding the product
            });
        });


        // Populate Edit Modal with product data
        $('#editModal').on('show.bs.modal', function (event) {
            const button = $(event.relatedTarget);
            const row = button.closest('tr');

            $('#editProductId').val(button.data('id'));
            $('#editProductName').val(row.find('td:eq(1)').text());
            $('#editCategoryId option').filter(function() {
                return $(this).text() === row.find('td:eq(2)').text();
            }).prop('selected', true);
            $('#editWeightId option').filter(function() {
                return $(this).text() === row.find('td:eq(3)').text();
            }).prop('selected', true);
            $('#editReorderLevel').val(row.find('td:eq(4)').text());
        });

        // Handle form submit
        $('#editForm').submit(function(e) {
            e.preventDefault();

            // Log the values being submitted
            console.log({
                action: 'edit',
                productId: $('#editProductId').val(),
                productName: $('#editProductName').val(),
                categoryId: $('#editCategoryId').val(),
                weightId: $('#editWeightId').val(),
                reorderLevel: $('#editReorderLevel').val()
            });

            $.post('manageProduct', {
                action: 'update',
                productId: $('#editProductId').val(),
                productName: $('#editProductName').val(),
                categoryId: $('#editCategoryId').val(),
                weightId: $('#editWeightId').val(),
                reorderLevel: $('#editReorderLevel').val()
            }, function() {
                location.reload(); // Refresh after update
            });
        });
        function deleteProduct(productId) {
                    if (confirm("Are you sure you want to delete this product?")) {
                        $.post('manageProduct', {
                            action: 'delete',
                            productId: productId
                        }, function() {
                            location.reload(); // Refresh the page after deleting the product
                        });
            }
        }
    </script>
</body>
</html>
