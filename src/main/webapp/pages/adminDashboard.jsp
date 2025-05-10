<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="dashboard-container">
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="logo">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Admin</span>
        </div>
        <ul class="sidebar-menu">
            <li class="active">
                <a href="#">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="fas fa-pills"></i>
                    <span>Products</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Orders</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="fas fa-users"></i>
                    <span>Customers</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="fas fa-chart-bar"></i>
                    <span>Analytics</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="fas fa-tags"></i>
                    <span>Categories</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="fas fa-comment-alt"></i>
                    <span>Reviews</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="fas fa-cog"></i>
                    <span>Settings</span>
                </a>
            </li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Top Navigation -->
        <div class="top-nav">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search...">
            </div>
            <div class="user-info">
                <div class="notifications">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">3</span>
                </div>
                <div class="user-profile">
                    <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Admin">
                    <span>Admin</span>
                    <i class="fas fa-chevron-down"></i>
                </div>
            </div>
        </div>

        <!-- Dashboard Content -->
        <div class="dashboard-content">
            <h2>Dashboard Overview</h2>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="card">
                    <div class="card-icon bg-blue">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="card-info">
                        <h3>245</h3>
                        <p>Total Orders</p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-icon bg-green">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="card-info">
                        <h3>$12,345</h3>
                        <p>Total Revenue</p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-icon bg-orange">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="card-info">
                        <h3>1,234</h3>
                        <p>Customers</p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-icon bg-red">
                        <i class="fas fa-pills"></i>
                    </div>
                    <div class="card-info">
                        <h3>567</h3>
                        <p>Products</p>
                    </div>
                </div>
            </div>

            <!-- Charts and Tables -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="chart-container">
                        <div class="chart-header">
                            <h4>Sales Overview</h4>
                            <select>
                                <option>Last 7 Days</option>
                                <option>Last Month</option>
                                <option>Last Year</option>
                            </select>
                        </div>
                        <canvas id="salesChart"></canvas>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="chart-container">
                        <div class="chart-header">
                            <h4>Top Categories</h4>
                        </div>
                        <canvas id="categoryChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="table-container">
                <div class="table-header">
                    <h4>Recent Orders</h4>
                    <a href="#" class="view-all">View All</a>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>#MED12345</td>
                        <td>John Doe</td>
                        <td>12 May 2023</td>
                        <td>$125.00</td>
                        <td><span class="status delivered">Delivered</span></td>
                        <td><a href="#" class="action-btn"><i class="fas fa-eye"></i></a></td>
                    </tr>
                    <tr>
                        <td>#MED12344</td>
                        <td>Jane Smith</td>
                        <td>11 May 2023</td>
                        <td>$89.50</td>
                        <td><span class="status shipped">Shipped</span></td>
                        <td><a href="#" class="action-btn"><i class="fas fa-eye"></i></a></td>
                    </tr>
                    <tr>
                        <td>#MED12343</td>
                        <td>Robert Johnson</td>
                        <td>10 May 2023</td>
                        <td>$156.75</td>
                        <td><span class="status processing">Processing</span></td>
                        <td><a href="#" class="action-btn"><i class="fas fa-eye"></i></a></td>
                    </tr>
                    <tr>
                        <td>#MED12342</td>
                        <td>Emily Davis</td>
                        <td>9 May 2023</td>
                        <td>$210.00</td>
                        <td><span class="status pending">Pending</span></td>
                        <td><a href="#" class="action-btn"><i class="fas fa-eye"></i></a></td>
                    </tr>
                    <tr>
                        <td>#MED12341</td>
                        <td>Michael Wilson</td>
                        <td>8 May 2023</td>
                        <td>$75.25</td>
                        <td><span class="status cancelled">Cancelled</span></td>
                        <td><a href="#" class="action-btn"><i class="fas fa-eye"></i></a></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="script.js"></script>
</body>
</html>