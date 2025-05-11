<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <style>
        body { font-family: Arial; background-color: #fef3f3; color: #d8000c; padding: 20px; }
        .error-box {
            border: 1px solid #d8000c;
            background-color: #ffd2d2;
            padding: 20px;
            border-radius: 8px;
            max-width: 600px;
            margin: auto;
        }
    </style>
</head>
<body>
    <div class="error-box">
        <h2>Error Occurred</h2>
        <p>${sessionScope.errorMessage}</p>
        <a href="StockIn">Go back to stock page</a>
    </div>
    <c:remove var="errorMessage" scope="session"/>

    <h2>Something went wrong:</h2>
    <p>${errorMessage}</p>
    <pre style="background:#f8f8f8; padding:1em;">${errorStack}</pre>

</body>
</html>
