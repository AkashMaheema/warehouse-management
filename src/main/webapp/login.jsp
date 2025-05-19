<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Araliya Warehouse - Login</title>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
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


        .form-label {
            font-weight: 500;
        }

        h3 {
            font-weight: bold;
        }
        .text-muted {
            color: white !important;
        }

    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card shadow-lg">
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <h3>Araliya Warehouse</h3>
                            <p class="text-muted" >Warehouse Management System</p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-primary">Login</button>
                            </div>
                            <div class="text-center mt-3">
                                <p>Don't have an account? <a href="register.jsp" class="text-decoration-none">Register as viewer</a></p>
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
