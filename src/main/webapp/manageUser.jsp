<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Araliya Warehouse - Manage Users</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            padding: 20px;
        }
        .header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }
        .header img {
            margin-right: 15px;
        }
        .header h1 {
            font-size: 2em;
            margin: 0;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .plus-icon {
            color: #6c5ce7;
            margin-right: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">

        <h1>Araliya Warehouse Dashboard</h1>
    </div>

    <h2>Manage Users</h2>

    <div class="card mb-4">
        <div class="card-header">
            <h5>User Form</h5>
        </div>
        <div class="card-body">
            <form action="manageUser" method="post">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="id" id="userId" value="">

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>

                    <div class="col-md-4">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>

                    <div class="col-md-4">
                        <label for="role" class="form-label">Role</label>
                        <select class="form-select" id="role" name="role" required>
                            <option value="admin">Admin</option>
                            <option value="stock_manager">Stock Manager</option>
                            <option value="viewer">Viewer</option>
                        </select>
                    </div>
                </div>

                <div class="d-flex justify-content-end">
                    <button type="button" class="btn btn-secondary me-2" onclick="resetForm()">Cancel</button>
                    <button type="submit" id="submitBtn" class="btn btn-primary">Create User</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h5>User List</h5>
        </div>
        <div class="card-body">
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.userId}</td>
                        <td>${user.username}</td>
                        <td>${user.role}</td>
                        <td class="action-buttons">
                            <button class="btn btn-sm btn-primary"
                                    onclick="editUser(${user.userId}, '${user.username}', '${user.password}', '${user.role}')">
                                Edit
                            </button>
                            <button class="btn btn-sm btn-danger"
                                    onclick="deleteUser(${user.userId})">
                                Delete
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Delete Confirmation Form -->
    <form id="deleteForm" action="manageUser" method="post" style="display: none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="id" id="deleteUserId">
    </form>
</div>

<script>
    function editUser(id, username, password, role) {
        document.getElementById('formAction').value = 'update';
        document.getElementById('userId').value = id;
        document.getElementById('username').value = username;
        document.getElementById('password').value = password;
        document.getElementById('role').value = role;
        document.getElementById('submitBtn').textContent = 'Update User';

        // Scroll to the form
        document.querySelector('.card-header').scrollIntoView();
    }

    function deleteUser(id) {
        if (confirm('Are you sure you want to delete this user?')) {
            document.getElementById('deleteUserId').value = id;
            document.getElementById('deleteForm').submit();
        }
    }

    function resetForm() {
        document.getElementById('formAction').value = 'create';
        document.getElementById('userId').value = '';
        document.getElementById('username').value = '';
        document.getElementById('password').value = '';
        document.getElementById('role').value = 'admin';
        document.getElementById('submitBtn').textContent = 'Create User';
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>