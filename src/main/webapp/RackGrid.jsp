<%--
  Created by IntelliJ IDEA.
  User: USER
  Date: 5/18/2025
  Time: 12:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Rack Grid View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4cc9f0;
            --danger-color: #f72585;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --gray-color: #6c757d;
            --h2-color:#000000;
            --btn-color: #00bafd;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        body {
            background-color: #f5f7ff;
            color: var(--dark-color);
        }

        .container {
            max-width: 1140px;
        }

        .rack-container {
            margin-bottom: 24px;
            border: none;
            padding: 16px;
            border-radius: var(--border-radius);
            background-color: white;
            box-shadow: var(--box-shadow);
            transition: var(--transition);
        }

        .rack-container:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(67, 97, 238, 0.15);
        }

        .grid-container {
            display: flex;
            flex-wrap: wrap;
            gap: 3px;
            margin-top: 12px;
        }

        .grid-square {
            width: 14px;
            height: 14px;
            background-color: #e8eaf6;
            border-radius: 3px;
            transition: var(--transition);
        }

        .grid-square.used {
            background-color: var(--success-color);
            box-shadow: 0 1px 3px rgba(76, 201, 240, 0.3);
        }

        .rack-title {
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--h2-color);
        }

        .back-btn {
            margin-bottom: 20px;
            border-radius: var(--border-radius);
            padding: 8px 16px;
            font-weight: 500;
            background-color: var(--btn-color);
            border-color: var(--btn-color);
            transition: var(--transition);
        }

        .back-btn:hover {
            background-color: #332fb0;
            border-color: #332fb0;
            box-shadow: 0 4px 8px rgba(63, 55, 201, 0.2);
        }

        .capacity-text {
            font-size: 0.9rem;
            color: var(--gray-color);
            font-weight: 500;
        }

        .progress {
            height: 8px;
            margin-top: 10px;
            margin-bottom: 10px;
            border-radius: 6px;
            background-color: #e9ecef;
            overflow: hidden;
        }

        .progress-bar {
            transition: width 0.5s ease;
            border-radius: 6px;
        }

        /* Capacity color indicators */
        .progress-low .progress-bar {
            background: linear-gradient(90deg, var(--success-color), var(--primary-color));
        }

        .progress-medium .progress-bar {
            background-color: #7209b7;
        }

        .progress-high .progress-bar {
            background-color: var(--danger-color);
        }

        h2 {
            color: var(--h2-color);
            font-weight: 600;
            position: relative;
            padding-bottom: 10px;
        }

        h2:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background-color: var(--h2-color);
            border-radius: 2px;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .grid-square {
                width: 12px;
                height: 12px;
                border-radius: 2px;
            }

            .rack-container {
                padding: 12px;
            }
        }

        @media (max-width: 576px) {
            .grid-square {
                width: 10px;
                height: 10px;
                border-radius: 2px;
            }

            h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <button class="btn btn-secondary back-btn" onclick="window.history.back()">
        <i class="bi bi-arrow-left me-1"></i> Back to Zones
    </button>
    <h2 class="text-center mb-4">Racks in ${zoneName}</h2>
    <c:forEach items="${racks}" var="rack">
        <div class="rack-container">
            <div class="d-flex justify-content-between align-items-center">
                <span class="rack-title">${rack.rackName}</span>
                <span class="capacity-text">
                    <i class="bi bi-database me-1"></i>${rack.usedCapacity}kg / ${rack.rackCapacity}kg
                </span>
            </div>

            <!-- Progress bar representation with dynamic coloring -->
            <div class="progress ${(rack.usedCapacity / rack.rackCapacity) > 0.8 ? 'progress-high' : (rack.usedCapacity / rack.rackCapacity) > 0.5 ? 'progress-medium' : 'progress-low'}">
                <div class="progress-bar" role="progressbar"
                     style="width: ${(rack.usedCapacity / rack.rackCapacity) * 100}%"
                     aria-valuenow="${rack.usedCapacity}" aria-valuemin="0" aria-valuemax="${rack.rackCapacity}"></div>
            </div>

            <!-- Grid representation -->
            <div class="grid-container">
                <c:forEach begin="1" end="${rack.rackCapacity / 5}" varStatus="loop">
                    <div class="grid-square ${loop.index <= rack.usedCapacity / 5 ? 'used' : ''}"></div>
                </c:forEach>
            </div>
        </div>
    </c:forEach>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>