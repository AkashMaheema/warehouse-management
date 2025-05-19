<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="manageUser" />
    <jsp:param name="activePage" value="manageUser" />
    <jsp:param name="content" value="manageUser" />
</jsp:include>

<html>
<head>
    <title>Araliya Warehouse - Manage Users</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container">
    <h2 class="category-heading"><i class="fas fa-users me-2"></i>User Management</h2>

    <!-- Notification Modal -->


    <!-- User Form -->
    <div class="card mb-4">
        <div class="card-header">
            <h5><i class="fas fa-user-plus me-2"></i>User Form</h5>
        </div>
        <div class="card-body">
            <form action="manageUser" method="post">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="id" id="userId" value="">

                <div class="row">
                    <!-- Username -->
                    <div class="mb-3 col-md-4">
                        <label for="username" class="form-label">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="mb-3 col-md-4">
                        <label for="email" class="form-label">Email</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                    </div>

                    <!-- Role -->
                    <div class="mb-3 col-md-4">
                        <label for="role" class="form-label">Role</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                            <select class="form-select" id="role" name="role" required>
                                <option value="">Select Role</option>
                                <option value="Admin">Admin</option>
                                <option value="Staff">Staff</option>
                            </select>
                        </div>
                    </div>
                </div>
            </form>

                <div class="d-flex justify-content-end">
                    <button type="button" class="btn btn-secondary me-2 action-btn" onclick="resetForm()">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="submit" class="btn btn-primary action-btn" id="submitBtn">
                        <i class="fas fa-plus-circle me-1"></i>Create User
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- User Table -->
    <div class="card">
        <div class="card-header">
            <h5><i class="fas fa-table me-2"></i>All Users</h5>
        </div>
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${userList}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td>${user.username}</td>
                            <td>${user.email}</td>
                            <td>${user.role}</td>
                            <td class="action-buttons">
                                <button class="btn btn-sm btn-warning" onclick="editUser(${user.id}, '${user.username}', '${user.email}', '${user.role}')">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <form action="manageUser" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${user.id}">
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">
                                        <i class="fas fa-trash-alt"></i> Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function editUser(id, username, email, role) {
        document.getElementById('formAction').value = 'update';
        document.getElementById('userId').value = id;
        document.getElementById('username').value = username;
        document.getElementById('email').value = email;
        document.getElementById('role').value = role;
        document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save me-1"></i>Update User';
    }

    function resetForm() {
        document.getElementById('formAction').value = 'create';
        document.getElementById('userId').value = '';
        document.getElementById('username').value = '';
        document.getElementById('email').value = '';
        document.getElementById('role').value = '';
        document.getElementById('submitBtn').innerHTML = '<i class="fas fa-plus-circle me-1"></i>Create User';
    }
</script>
</body>
</html>
