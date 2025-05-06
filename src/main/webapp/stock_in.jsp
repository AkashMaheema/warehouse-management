<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock In - Rice</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script>
        function addRow() {
            const table = document.getElementById("stockTableBody");
                const firstRow = table.rows[0];
                const newRow = firstRow.cloneNode(true);

                // Clear input values in the cloned row
                newRow.querySelectorAll("input, select").forEach(el => el.value = "");

                table.appendChild(newRow);
        }

        function removeRow(btn) {
            const row = btn.parentNode.parentNode;
            row.remove();
        }
    </script>
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
                            <select name="categoryId[]" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="c" items="${categoryList}">
                                <option value="${c.categoryId}">${c.name}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td>
                            <select name="productId[]" class="form-control" required>
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
                            <select name="zoneid[]" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="z" items="${zoneList}">
                                <option value="${z.zoneid}">${z.zone}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td>
                            <select name="rackid[]" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="r" items="${rackList}">
                                <option value="${r.rackid}">${r.rack}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td><button type="button" class="btn btn-danger" onclick="removeRow(this)">Remove</button></td>
                </tr>
            </tbody>
        </table>


        <button type="submit" class="btn btn-success">Submit All Stocks</button>
    </form>
</div>
</body>
</html>
