<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Araliya Warehouse - Manage Users</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            padding: 20px;
            background-color: #f8f9fa;
        }
        .header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            background-color: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .header img {
            margin-right: 15px;
        }
        .header h1 {
            font-size: 2em;
            margin: 0;
            color: #343a40;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .card {
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border: none;
            margin-bottom: 25px;
        }
        .card-header {
            background-color: #f1f3f5;
            border-bottom: 1px solid #dee2e6;
        }
        .btn-primary {
            background-color: #4361ee;
            border-color: #4361ee;
        }
        .btn-primary:hover {
            background-color: #3a56d4;
            border-color: #3a56d4;
        }
        .btn-danger {
            background-color: #e63946;
            border-color: #e63946;
        }
        .btn-danger:hover {
            background-color: #d32f2f;
            border-color: #d32f2f;
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        /* Custom notification modal */
        .notification-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s, visibility 0.3s;
        }
        .notification-modal.show {
            opacity: 1;
            visibility: visible;
        }
        .notification-content {
            width: 350px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            overflow: hidden;
            transform: translateY(-20px);
            transition: transform 0.3s;
        }
        .notification-modal.show .notification-content {
            transform: translateY(0);
        }
        .notification-header {
            padding: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: white;
        }
        .notification-header.success {
            background-color: #28a745;
        }
        .notification-header.error {
            background-color: #dc3545;
        }
        .notification-header.info {
            background-color: #17a2b8;
        }
        .notification-body {
            padding: 20px;
            font-size: 16px;
        }
        .notification-icon {
            font-size: 24px;
            margin-right: 10px;
        }
        .notification-progress {
            height: 4px;
            background: #e9ecef;
            width: 100%;
        }
        .notification-progress-bar {
            height: 100%;
            width: 100%;
            transition: width 5s linear;
        }
        .success .notification-progress-bar {
            background-color: #28a745;
        }
        .error .notification-progress-bar {
            background-color: #dc3545;
        }
        .info .notification-progress-bar {
            background-color: #17a2b8;
        }

        /* Button styles with icons */
        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .action-btn i {
            margin-right: 5px;
        }

        /* Table enhancements */
        .table {
            border-collapse: separate;
            border-spacing: 0;
        }
        .table th {
            background-color: #f8f9fa;
            color: #495057;
            font-weight: 600;
        }
        .role-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            color: white;
        }
        .role-admin {
            background-color: #4361ee;
        }
        .role-stock_manager {
            background-color: #3cb371;
        }
        .role-viewer {
            background-color: #6c757d;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header" style="background-color: #5cb85c; color: white;">
        <h1><i class="fas fa-warehouse me-2"></i>Araliya Warehouse Dashboard</h1>
    </div>

    <h2 class="mb-4">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary me-3"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        <i class="fas fa-users me-2"></i>Manage Users
    </h2>

    <!-- Notification Modal -->
    <div id="notificationModal" class="notification-modal">
        <div class="notification-content">
            <div id="notificationHeader" class="notification-header">
                <div class="d-flex align-items-center">
                    <span id="notificationIcon" class="notification-icon"></span>
                    <strong id="notificationTitle">Notification</strong>
                </div>
                <button type="button" class="btn-close btn-close-white" onclick="closeNotification()"></button>
            </div>
            <div id="notificationBody" class="notification-body">
                Message content here
            </div>
            <div class="notification-progress">
                <div id="notificationProgressBar" class="notification-progress-bar"></div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            <h5><i class="fas fa-user-plus me-2"></i>User Form</h5>
        </div>
        <div class="card-body">
            <form action="manageUser" method="post">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="id" id="userId" value="">

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="username" class="form-label">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <small class="form-text text-muted">Username must be 3-20 characters and cannot be only numbers</small>
                    </div>

                    <div class="col-md-4">
                        <label for="password" class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label for="role" class="form-label">Role</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                            <select class="form-select" id="role" name="role" required>
                                <option value="admin">Admin</option>
                                <option value="stock_manager">Stock Manager</option>
                                <option value="viewer">Viewer</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end">
                    <button type="button" class="btn btn-secondary me-2 action-btn" onclick="resetForm()">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="submit" id="submitBtn" class="btn btn-primary action-btn">
                        <i class="fas fa-plus-circle me-1"></i>Create User
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h5><i class="fas fa-list me-2"></i>User List</h5>
        </div>
        <div class="card-body">
            <table class="table table-hover">
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
                        <td><i class="fas fa-user me-2"></i>${user.username}</td>
                        <td>
                            <span class="role-badge role-${user.role}">
                                <c:choose>
                                    <c:when test="${user.role == 'admin'}">
                                        <i class="fas fa-user-shield me-1"></i>
                                    </c:when>
                                    <c:when test="${user.role == 'stock_manager'}">
                                        <i class="fas fa-boxes me-1"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-eye me-1"></i>
                                    </c:otherwise>
                                </c:choose>
                                ${user.role}
                            </span>
                        </td>
                        <td class="action-buttons">
                            <button class="btn btn-sm btn-primary action-btn"
                                    onclick="editUser(${user.userId}, '${user.username}', '${user.password}', '${user.role}')">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn btn-sm btn-danger action-btn"
                                    onclick="deleteUser(${user.userId})">
                                <i class="fas fa-trash-alt"></i> Delete
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
    // Show notification modal with appropriate styling and auto-timeout
    function showNotification(type, message) {
        const modal = document.getElementById('notificationModal');
        const header = document.getElementById('notificationHeader');
        const icon = document.getElementById('notificationIcon');
        const title = document.getElementById('notificationTitle');
        const body = document.getElementById('notificationBody');
        const progressBar = document.getElementById('notificationProgressBar');

        // Reset classes
        header.className = 'notification-header';

        // Set type-specific styles and content
        if (type === 'success') {
            header.classList.add('success');
            icon.innerHTML = '<i class="fas fa-check-circle"></i>';
            title.textContent = 'Success';
            progressBar.className = 'notification-progress-bar';
            progressBar.classList.add('success');
        } else if (type === 'error') {
            header.classList.add('error');
            icon.innerHTML = '<i class="fas fa-exclamation-circle"></i>';
            title.textContent = 'Error';
            progressBar.className = 'notification-progress-bar';
            progressBar.classList.add('error');
        } else {
            header.classList.add('info');
            icon.innerHTML = '<i class="fas fa-info-circle"></i>';
            title.textContent = 'Information';
            progressBar.className = 'notification-progress-bar';
            progressBar.classList.add('info');
        }

        // Set message
        body.textContent = message;

        // Show modal
        modal.classList.add('show');

        // Reset and start progress bar animation
        progressBar.style.width = '100%';
        setTimeout(() => {
            progressBar.style.width = '0%';
        }, 50);

        // Auto close after 5 seconds
        setTimeout(() => {
            closeNotification();
        }, 5000);
    }

    function closeNotification() {
        const modal = document.getElementById('notificationModal');
        modal.classList.remove('show');
    }

    function editUser(id, username, password, role) {
        document.getElementById('formAction').value = 'update';
        document.getElementById('userId').value = id;
        document.getElementById('username').value = username;
        document.getElementById('password').value = '';
        document.getElementById('password').required = true;
        document.getElementById('role').value = role;

        // Update button text and icon
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.innerHTML = '<i class="fas fa-save me-1"></i>Update User';
        submitBtn.classList.remove('btn-primary');
        submitBtn.classList.add('btn-success');

        // Scroll to the form
        document.querySelector('.card-header').scrollIntoView({behavior: 'smooth'});
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
        document.getElementById('password').required = true;
        document.getElementById('password').placeholder = '';
        document.getElementById('role').value = 'admin';

        // Reset button text and icon
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.innerHTML = '<i class="fas fa-plus-circle me-1"></i>Create User';
        submitBtn.classList.remove('btn-success');
        submitBtn.classList.add('btn-primary');
    }

    // Check for messages on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Check for success message
        const successMessage = "${successMessage}";
        if (successMessage && successMessage.trim() !== "") {
            showNotification('success', successMessage);
        }

        // Check for error message
        const errorMessage = "${errorMessage}";
        if (errorMessage && errorMessage.trim() !== "") {
            showNotification('error', errorMessage);
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>