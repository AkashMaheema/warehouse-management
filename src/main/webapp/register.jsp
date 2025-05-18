<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Araliya Warehouse - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
                   background-image: url('https://img.freepik.com/premium-photo/sunset-rice-field-with-mountains-background_808092-2110.jpg');
                   background-size: cover;
                   background-position: center;
                   background-repeat: no-repeat;
                   background-attachment: fixed;
                   min-height: 100vh;
                   margin: 0;
                   display: flex;
                   align-items: center;
                   justify-content: center;
               }
        .card {
                  background-color: rgba(33, 33, 33, 0.8); /* dark gray with 80% opacity */
                  border-radius: 10px;
                  color:white;
              }
         .btn-primary {
             background-color: #267f37;
             border-color: #27873a;
             color: white;
         }

         .btn-primary:hover {
             background-color: #2ba432; /* slightly darker green */
             border-color: #2ba432;
             cursor: pointer;
         }

    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card shadow-lg">
                    <div class="card-body p-4">
                        <h3 class="card-title text-center mb-4">Register New Viewer</h3>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>

                        <form action="register" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Register</button>
                                <a href="login.jsp" class="btn btn-link">Already have an account? Login</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>