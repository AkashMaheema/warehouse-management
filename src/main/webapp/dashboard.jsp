<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.warehouse.config.DBConnection" %>
<%@ page import="java.util.*" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="dashboard" />
    <jsp:param name="activePage" value="index" />
    <jsp:param name="content" value="index" />
</jsp:include>
<%
    Connection conn = DBConnection.getConnection();
    int productCount = 0, lowStockCount = 0;
    try {
        Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM products");
        if (rs1.next()) productCount = rs1.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
   <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

   <style>
       :root {
           --primary-color: #3a7bd5;
           --secondary-color: #00d2ff;
           --success-color: #28a745;
           --warning-color: #ffc107;
           --danger-color: #dc3545;
           --info-color: #17a2b8;
       }

       body {
                   position: relative;
                   min-height: 100vh;
                   margin: 0;
                   padding: 0;
                   font-family: Arial, sans-serif;
               }

               body::before {
                   content: "";
                   position: fixed;
                   top: 0;
                   left: 0;
                   height: 100%;
                   width: 100%;
                   background-color:#F7EFE2;
                   background-size: cover;
                   background-repeat: no-repeat;
                   background-position: center;
                   background-attachment: fixed;
                   opacity: 0.3; /* Change this value to control transparency */
                   z-index: -1;
               }

       .dashboard {
           padding: 20px;
       }

       .section {
           background: transparency;
           border-radius: 10px;
           /*box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);*/
           padding: 20px;
           margin-bottom: 25px;
       }

       .card-stat {
           border-left: 4px solid;
           border-radius: 8px;
           transition: transform 0.3s;
       }

       .card-stat:hover {
           transform: translateY(-5px);
       }

       .card-stat.total { border-left-color: #311F10; }
       .card-stat.available { border-left-color: #311F10; }
       .card-stat.warning { border-left-color: #311F10; }
       .card-stat.danger { border-left-color: #311F10; }

       .action-btn {
           display: flex;
           flex-direction: column;
           align-items: center;
           justify-content: center;
           padding: 15px;
           text-align: center;
           background: white;
           border-radius: 8px;
           box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
           transition: all 0.3s;
           color: var(--primary-color);
           text-decoration: none;
           height: 100%;
       }

       .action-btn:hover {
           background: linear-gradient(135deg, #311F10, #D9B98E);
           color: white;
           transform: translateY(-3px);
           box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
       }

       .action-btn i {
           font-size: 1.5rem;
           margin-bottom: 10px;
       }

       .alert-item {
           border-left: 4px solid;
           padding: 10px 15px;
           margin-bottom: 8px;
           border-radius: 4px;
           background-color: rgba(255, 255, 255, 0.8);
       }

       .alert-item.warning {
           border-left-color: var(--warning-color);
           background-color: rgba(255, 193, 7, 0.1);
       }

       .alert-item.danger {
           border-left-color: var(--danger-color);
           background-color: rgba(220, 53, 69, 0.1);
       }

       .alert-item.info {
           border-left-color: var(--info-color);
           background-color: rgba(23, 162, 184, 0.1);
       }

       .chart-placeholder {
           background: #f8f9fa;
           border: 1px dashed #dee2e6;
           border-radius: 8px;
           padding: 40px 20px;
           text-align: center;
           color: #6c757d;
           margin-bottom: 15px;
       }

       .user-summary {
           background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
           color: white;
       }

       .user-summary strong {
           color: white;
       }

       .list-group-item {
           border-left: 0;
           border-right: 0;
       }

       .list-group-item:first-child {
           border-top: 0;
       }
   </style>

</head>
<body>
    <div class="dashboard container-fluid">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0 text-primary"><i class="bi bi-clipboard-data"></i> Araliya</h1>

        </div>

        <!-- Inventory Overview -->
        <div class="section">
            <h2 class="h4 mb-4"><i class="bi bi-box-seam"></i> Inventory Overview</h2>
            <div class="row">
                <div class="col-md-3 mb-3">
                    <div class="card card-stat total h-100">
                        <div class="card-body">
                            <h5 class="card-title text-muted">Total Rice Stock</h5>
                            <h3 class="card-text">12,500 kg</h3>
                            <p class="text-muted mb-0"><i class="bi bi-arrow-up text-success"></i> 5% from last month</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card card-stat available h-100">
                        <div class="card-body">
                            <h5 class="card-title text-muted">Available Stock</h5>
                            <h3 class="card-text">10,200 kg</h3>
                            <p class="text-muted mb-0">81.6% of total</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card card-stat warning h-100">
                        <div class="card-body">
                            <h5 class="card-title text-muted">Low Stock Items</h5>
                            <h3 class="card-text">2 types</h3>
                            <p class="text-muted mb-0">Needs replenishment</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card card-stat danger h-100">
                        <div class="card-body">
                            <h5 class="card-title text-muted">Damaged/Expired</h5>
                            <h3 class="card-text">150 kg</h3>
                            <p class="text-muted mb-0">1.2% of total</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
                <div class="section mb-3">
                    <h2 class="h4 mb-4"><i class="bi bi-lightning"></i> Quick Actions</h2>
                    <div class="row g-3">
                        <div class="col-md-2 col-4">
                            <a href="StockIn" class="action-btn">
                                <i class="bi bi-plus-circle"></i>
                                <span>Add Stock</span>
                            </a>
                        </div>
                        <div class="col-md-2 col-4">
                            <a href="manageOrders.jsp" class="action-btn">
                                <i class="bi bi-file-earmark-plus"></i>
                                <span>Create Order</span>
                            </a>
                        </div>
                        <div class="col-md-2 col-4">
                            <a href="Inventory" class="action-btn">
                                <i class="bi bi-search"></i>
                                <span>View Inventory</span>
                            </a>
                        </div>
                        <div class="col-md-2 col-4">
                            <a href="manageOrders.jsp" class="action-btn">
                                <i class="bi bi-cart-check"></i>
                                <span>View Orders</span>
                            </a>
                        </div>
                        <div class="col-md-2 col-4">
                            <a href="users.jsp" class="action-btn">
                                <i class="bi bi-people"></i>
                                <span>Manage Users</span>
                            </a>
                        </div>
                        <div class="col-md-2 col-4">
                            <a href="reports.jsp" class="action-btn">
                                <i class="bi bi-graph-up"></i>
                                <span>Generate Reports</span>
                            </a>
                        </div>
                    </div>
                </div>


        <div class="row">
          <!-- Warehouse Activity (50%) -->
          <div class="col-lg-6 mb-3">
            <div class="section h-100">
              <h2 class="h4 mb-4"><i class="bi bi-warehouse"></i> Warehouse Activity</h2>
              <div class="row">
                <div class="col-12 mb-3">
                  <div class="card">
                    <div class="card-header" style="background-color:#311F10; color: white;">
                      <h3 class="h6 mb-0"><i class="bi bi-box-arrow-in-down"></i> Recent Inbound</h3>
                    </div>
                    <ul class="list-group list-group-flush">
                      <li class="list-group-item d-flex justify-content-between align-items-center">
                        2025-05-10 - AgriCo <span class="badge bg-primary rounded-pill">1,000 kg</span>
                      </li>
                      <li class="list-group-item d-flex justify-content-between align-items-center">
                        2025-05-09 - RiceMart <span class="badge bg-primary rounded-pill">750 kg</span>
                      </li>
                      <li class="list-group-item d-flex justify-content-between align-items-center">
                        2025-05-08 - FarmFresh <span class="badge bg-primary rounded-pill">900 kg</span>
                      </li>
                    </ul>
                  </div>
                </div>
                <div class="col-12">
                  <div class="card">
                    <div class="card-header" style="background-color:#311F10; color: white;">
                      <h3 class="h6 mb-0"><i class="bi bi-box-arrow-up"></i> Recent Outbound</h3>
                    </div>
                    <ul class="list-group list-group-flush">
                      <li class="list-group-item d-flex justify-content-between align-items-center">
                        2025-05-11 - CityStore <span class="badge bg-success rounded-pill">500 kg</span>
                      </li>
                      <li class="list-group-item d-flex justify-content-between align-items-center">
                        2025-05-10 - LocalMart <span class="badge bg-success rounded-pill">850 kg</span>
                      </li>
                      <li class="list-group-item d-flex justify-content-between align-items-center">
                        2025-05-09 - QuickBuy <span class="badge bg-success rounded-pill">700 kg</span>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Orders Summary (50%) -->
          <div class="col-lg-6 mb-3">
            <div class="section h-100">
              <h2 class="h4 mb-4"><i class="bi bi-receipt"></i> Orders Summary</h2>
              <div class="row">
                <div class="col-md-3 col-6 mb-3">
                  <div class="card bg-light h-100">
                    <div class="card-body text-center">
                      <h5 class="text-muted">Total (May)</h5>
                      <h2 class="text-primary">35</h2>
                      <div class="progress mt-2" style="height: 5px;">
                        <div class="progress-bar bg-primary" style="width: 100%"></div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-3 col-6 mb-3">
                  <div class="card bg-light h-100">
                    <div class="card-body text-center">
                      <h5 class="text-muted">Pending</h5>
                      <h2 class="text-warning">5</h2>
                      <div class="progress mt-2" style="height: 5px;">
                        <div class="progress-bar bg-warning" style="width: 14%"></div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-3 col-6 mb-3">
                  <div class="card bg-light h-100">
                    <div class="card-body text-center">
                      <h5 class="text-muted">Done</h5>
                      <h2 class="text-success">28</h2>
                      <div class="progress mt-2" style="height: 5px;">
                        <div class="progress-bar bg-success" style="width: 80%"></div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-3 col-6 mb-3">
                  <div class="card bg-light h-100">
                    <div class="card-body text-center">
                      <h5 class="text-muted">Cancelled</h5>
                      <h2 class="text-danger">2</h2>
                      <div class="progress mt-2" style="height: 5px;">
                        <div class="progress-bar bg-danger" style="width: 6%"></div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="mt-3">
                <canvas id="ordersChart" height="120"></canvas>
              </div>
            </div>
          </div>
        </div>

        <div class="row">

            <!-- Notifications / Alerts -->
            <div class="mb-3 w-100">
                <div class="section h-100">
                    <h2 class="h4 mb-4"><i class="bi bi-bell"></i> Notifications & Alerts</h2>
                    <div class="alert-item warning">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-exclamation-triangle-fill me-2 text-warning"></i>
                            <strong>Warning:</strong> Jasmine Rice below 100 kg.
                        </div>
                        <small class="text-muted d-block mt-1">Replenishment needed by May 20</small>
                    </div>
                    <div class="alert-item danger">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-exclamation-octagon-fill me-2 text-danger"></i>
                            <strong>Alert:</strong> 50 kg of Basmati expired.
                        </div>
                        <small class="text-muted d-block mt-1">Mark for disposal</small>
                    </div>
                    <div class="alert-item info">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-info-circle-fill me-2 text-info"></i>
                            <strong>Reminder:</strong> Shipment scheduled for tomorrow.
                        </div>
                        <small class="text-muted d-block mt-1">1,200 kg from GlobalRice</small>
                    </div>
                    <div class="text-end mt-2">
                        <a href="#" class="btn btn-sm btn-outline-primary">View All Notifications</a>
                    </div>
                </div>
            </div>
        </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        // Sample chart initialization
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('ordersChart').getContext('2d');
            const ordersChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Completed', 'Pending', 'Cancelled'],
                    datasets: [{
                        label: 'Orders Status',
                        data: [28, 5, 2],
                        backgroundColor: [
                            '#28a745',
                            '#ffc107',
                            '#dc3545'
                        ],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        });
    </script>


</body>
</html>

