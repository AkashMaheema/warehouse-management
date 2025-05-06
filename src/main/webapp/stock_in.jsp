<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock In - Rice</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">



</head>
<body>
<div class="container mt-5">
    <h3>New Rice Stock Entry</h3>
    <form action="StockInServlet" method="post">
        <div class="form-row mb-3">
            <div class="col-md-4">
                <label for="supplier_id">Supplier</label>
                <select name="supplierid" class="form-control" required>
                     <option value="">Select</option>
                         <c:forEach var="s" items="${supplierList}">
                         <option value="${s.supplierid}">${s.supplier}</option>
                     </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <label for="arrival_date">Arrival Date</label>
                <input type="date" name="arrival_date" class="form-control" required>
            </div>
        </div>

        <div class="form-row mb-3">
                    <div class="col-md-4">
                        <button type="button" class="btn btn-info" onclick="addRow()">Add New Stock </button>
                    </div>
                    <div class="col-md-4 offset-md-4 text-end">
                        <button type="button" class="btn btn-info" >Add New Product </button>
                        <button type="button" class="btn btn-info" >Add New Supplier </button>
                    </div>
        </div>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Product Category</th>
                    <th>Product Name</th>
                    <th>Product Weight (Single Unit)</th>
                    <th>Quantity</th>
                    <th>Product Expiry Date</th>
                    <th>Zone</th>
                    <th>Rack</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="stockTableBody">
                <tr>
                    <td>
                            <select name="categoryId[]" class="form-control category-select" required>
                              <option value="">Select</option>
                              <c:forEach var="c" items="${categoryList}">
                                <option value="${c.categoryId}">${c.name}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td>
                            <select name="productId[]" class="form-control product-select" required>
                              <option value="">Select</option>
                              <c:forEach var="p" items="${productList}">
                                <option value="${p.productId}">${p.productName}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td>
                            <select name="weightId[]" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="w" items="${weightList}">
                                <option value="${w. weightId}">${w.weightValue} Kg</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td><input type="number" name="quantity[]" class="form-control" min="0" required /></td>

                    <td><input type="date" name="expire_date[]" class="form-control" required /></td>

                    <td>
                        <input type="hidden" name="zoneid[]" class="zone-id">
                        <input type="text" class="form-control zone-name" readonly>
                        <button type="button" class="btn btn-sm btn-outline-primary mt-1 btn-select-zone">Select Zone</button>
                    </td>

                    <td>
                        <input type="hidden" name="rackid[]" class="rack-id">
                        <input type="text" class="form-control rack-name" readonly>
                        <button type="button" class="btn btn-sm btn-outline-secondary mt-1 btn-select-rack">Select Rack</button>
                    </td>

                    <td><button type="button" class="btn btn-danger" onclick="removeRow(this)">Remove</button></td>
                </tr>
            </tbody>
        </table>


                <button type="submit" class="btn btn-success">Submit All Stocks</button>
            </form>
        </div>

    <!-- Zone Modal -->
    <div class="modal fade" id="zoneModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Select Zone</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Zone</th>
                                <th>Available Capacity (Kg)</th>
                                <th>Select</th>
                            </tr>
                        </thead>
                        <tbody id="zoneTableBody">
                            <!-- Will be populated by AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Rack Modal -->
    <div class="modal fade" id="rackModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Select Rack</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Rack</th>
                                <th>Available Space (Kg)</th>
                                <th>Select</th>
                            </tr>
                        </thead>
                        <tbody id="rackTableBody">
                            <!-- Will be populated by AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
    <script src="js/stock_in_script.js"></script>
</body>
</html>
