<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.RequestDispatcher" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><%= request.getParameter("title") != null ? request.getParameter("title") : "Warehouse Management" %></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

  <style>
    :root {
      --sidebar-width: 220px;
      --header-height: 60px;
      --sidebar-bg: #156082;
      --sidebar-active-bg: #D9B98E;
    }

     body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;

        }

    #sidebar {
      position: fixed;
      top: 0;
      left: 0;
      width: var(--sidebar-width);
      height: 100vh;
      background-color: var(--sidebar-bg);
      overflow-y: auto;
      z-index: 1001; /* Must be higher than the header's z-index */
    }

    #sidebar .sidebar-header {
      color: white;
      padding: 10px;
    }

    #sidebar ul {
      list-style: none;
      padding-left: 0;
    }

    #sidebar ul li a {
      display: block;
      color: white;
      padding: 12px 20px;
      text-decoration: none;
    }

    #sidebar ul li a:hover {
      color: #D9B98E;
    }

    #sidebar ul li.active > a {
      color: white;
      background-color: var(--sidebar-active-bg);
    }

    #header {
      position: fixed;
      top: 30px;
      left: 230px;
      height: var(--header-height);
      width: calc(100% - 240px);
      background: #156082;
      display: flex;
      justify-content: flex-end;
      align-items: center;
      padding: 0 20px;
      z-index: 1000;
      color: white;
      border-top-right-radius: 30px;
      border-bottom-right-radius: 30px;
      border-top-left-radius: 30px;
      border-bottom-left-radius: 30px;
    }


    #content {
      position: absolute;
      top: var(--header-height);
      left: var(--sidebar-width);
      width: calc(100% - var(--sidebar-width));
      height: calc(100vh - var(--header-height));
      overflow-y: auto;
      padding: 20px;
      scrollbar-width: none; /* Firefox */
    }

    .sidebar-header {
      position: relative;
      height: 200px; /* adjust height as needed */
      background-image: url('images/logo6.png'); /* your logo path */
      background-size: cover;       /* make the image cover the entire div */
      background-position: center;  /* center the image */
      background-repeat: no-repeat;
      color: white;                 /* text color for visibility */
      display: flex;
      flex-direction: column;
      justify-content: center;      /* vertically center text */
      align-items: center;          /* horizontally center text */
      text-shadow: 0 0 5px rgba(0,0,0,0.7); /* optional for text readability */
    }

    .user-profile {
      display: flex;
      align-items: center;
    }

    .user-profile img {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      margin-right: 10px;
    }

    .user-profile span {
      color: white;
    }

    .logout-btn {
      margin: 20px;
    }
  </style>
</head>
<body>

<!-- Header -->
<nav id="header">
  <div class="user-profile">
    <div class="text-muted me-3"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %></div>
    <img src="https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff" alt="User">
    <span>Admin</span>
  </div>
</nav>

<!-- Sidebar -->
<div id="sidebar">
  <div class="sidebar-header">

    <p class="mb-0"></p>
  </div>


  <ul class="components">
    <li class="<%= "dashboard".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="dashboard.jsp"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
    </li>
    <li class="<%= "inventory".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="Inventory"><i class="bi bi-box-seam me-2"></i> Inventory</a>
    </li>
    <li class="<%= "supply".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="Stocks"><i class="bi bi-truck me-2"></i> Supply</a>
    </li>
    <li class="<%= "orders".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="manageOrders.jsp"><i class="bi bi-cart me-2"></i> Orders</a>
    </li>
    <li class="<%= "orders".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="ASNManagement"><i class="bi bi-file-earmark-text me-2"></i> ASN Management</a>
    </li>
    <li>
      <a href="#moreSubmenu" data-bs-toggle="collapse" class="dropdown-toggle">
        <i class="bi bi-gear me-2"></i> More
      </a>
      <ul class="collapse list-unstyled" id="moreSubmenu">
        <li class="<%= "manageCategory".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageCategory"><i class="bi bi-tags me-2"></i> Manage Category</a>
        </li>
        <li class="<%= "manageProduct".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageProduct"><i class="bi bi-box me-2"></i> Manage Product</a>
        </li>
        <li class="<%= "manageSupplier".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageSupplier"><i class="bi bi-people me-2"></i> Manage Supplier</a>
        </li>
        <li class="<%= "manageWeights".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageWeights"><i class="bi bi-speedometer me-2"></i> Manage Weights</a>
        </li>
        <li class="<%= "manageZone".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageZone"><i class="bi bi-geo-alt"></i> Manage Zone</a>
        </li>
        <li class="<%= "manageRacks".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageRacks"><i class="bi bi-hdd-stack me-2"></i> Manage Rack</a>
        </li>
        <li class="<%= "manageUser".equals(request.getParameter("activePage")) ? "active" : "" %>">
           <a href="manageUser.jsp"><i class="fas fa-users me-2"></i> Manage Users</a>
        </li>
      </ul>
    </li>
    <li class="<%= "reports".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="reports.jsp"><i class="bi bi-graph-up me-2"></i> Reports</a>
    </li>
    <li class="logout-btn">
      <a href="login.jsp" class="btn btn-danger w-100"><i class="bi bi-box-arrow-left me-2"></i> Logout</a>
    </li>
  </ul>
</div>

<!-- Page Content -->

<div id="content">
  <!-- Header -->
  <nav id="header" class="navbar navbar-expand">
    <div class="container-fluid justify-content-end">
      <div class="d-flex align-items-center">

        <!-- Current Date and Time -->
        <div class="text-muted" style="color: white !important; margin: 10px;">
          <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %>
        </div>

        <!-- User Profile Dropdown -->
        <div class="dropdown">
          <a class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" href="#" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
            <img src="https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff" alt="User" class="rounded-circle me-2" style="width: 32px; height: 32px;">
            <span><%= session.getAttribute("role") != null ? session.getAttribute("role") : "User" %></span>
          </a>

          <!-- Dropdown Menu -->
          <ul class="dropdown-menu dropdown-menu-end text-small shadow" aria-labelledby="userDropdown" style="min-width: 300px;">
            <li class="px-3 py-2">
              <h6 class="mb-2"><i class="bi bi-person-circle"></i> User Information</h6>
              <div class="d-flex align-items-center mb-2">
                <i class="bi bi-person me-2"></i>
                <span>Logged in as: <strong><%= session.getAttribute("role") %></strong></span>
              </div>
              <div class="d-flex align-items-center mb-2">
                <i class="bi bi-clock-history me-2"></i>
                <span>Last Login: <strong><%= session.getAttribute("lastLogin") != null ? session.getAttribute("lastLogin") : "N/A" %></strong></span>
              </div>
              <div class="d-flex justify-content-between mt-3">
                <a href="settings.jsp" class="btn btn-outline-primary btn-sm"><i class="bi bi-gear"></i> Settings</a>
                <a href="login.jsp" class="btn btn-danger btn-sm"><i class="bi bi-box-arrow-right"></i> Logout</a>
              </div>
            </li>
          </ul>
        </div>

      </div>
    </div>
  </nav>


  <!-- Main Content -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Real-time clock
    function updateClock() {
        const now = new Date();
        const timeString = now.toLocaleTimeString();
        const dateString = now.toLocaleDateString('en-US', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        document.getElementById('real-time-clock').textContent = ${dateString} | ${timeString};
    }

    // Update clock every second
    updateClock();
    setInterval(updateClock, 1000);
</script>


<%--<div class="main-content">--%>
<%--  <jsp:include page="<%= request.getParameter(\"content\") != null ? request.getParameter(\"content\") + \".jsp\" : \"\" %>" />--%>
<%--</div>--%>

</body>
</html>
