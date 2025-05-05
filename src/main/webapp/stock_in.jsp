<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock In - Rice</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script>
        function addRow() {
            const table = document.getElementById("stockTableBody");
            const row = table.insertRow();

            row.innerHTML = `
                <td><input type="text" name="product_name" class="form-control" required /></td>
                <td><input type="text" name="category" class="form-control" required /></td>
                <td><input type="number" name="weight_single_unit" class="form-control" required /></td>
                <td><input type="number" name="quantity" class="form-control" required /></td>
                <td><input type="date" name="expire_date" class="form-control" required /></td>
                <td><input type="text" name="zone" class="form-control" required /></td>
                <td><input type="text" name="rack" class="form-control" required /></td>
                <td><button type="button" class="btn btn-danger" onclick="removeRow(this)">Remove</button></td>
            `;
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
    <form action="RiceStockInServlet" method="post">
        <div class="form-row mb-3">
            <div class="col-md-4">
                <label for="supplier_id">Supplier</label>
                <select name="supplier" class="form-control" required>
                     <option value="">Select</option>
                         <c:forEach var="s" items="${supplierList}">
                         <option value="${s}">${s}</option>
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
                        <button type="button" class="btn btn-info" onclick="">Add New Product </button>
                        <button type="button" class="btn btn-info" onclick="">Add New Client </button>
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
                            <select name="category" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="c" items="${categoryList}">
                                <option value="${c}">${c}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td>
                            <select name="product_name" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="p" items="${productList}">
                                <option value="${p}">${p}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td>
                            <select name="weight" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="w" items="${weightList}">
                                <option value="${w}">${w}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td><input type="number" name="quantity" class="form-control" min="0" required /></td>

                    <td><input type="date" name="expire_date" class="form-control" required /></td>

                    <td>
                            <select name="zone" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="z" items="${zoneList}">
                                <option value="${z}">${z}</option>
                              </c:forEach>
                            </select>
                    </td>

                    <td>
                            <select name="rack" class="form-control" required>
                              <option value="">Select</option>
                              <c:forEach var="r" items="${rackList}">
                                <option value="${r}">${r}</option>
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
