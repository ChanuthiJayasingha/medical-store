<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #eef2ff;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --danger: #f72585;
            --warning: #f8961e;
            --info: #4895ef;
            --dark: #212529;
            --light: #f8f9fa;
            --gray: #6c757d;
            --gray-light: #e9ecef;
            --white: #ffffff;
            --sidebar-width: 260px;
            --sidebar-collapsed-width: 80px;
            --top-nav-height: 70px;
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f7fb;
            color: var(--dark);
            overflow-x: hidden;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--white);
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            transition: var(--transition);
            position: fixed;
            height: 100vh;
            z-index: 100;
        }

        .sidebar.collapsed {
            width: var(--sidebar-collapsed-width);
        }

        .sidebar.collapsed .logo span,
        .sidebar.collapsed .sidebar-menu li span {
            display: none;
        }

        .sidebar.collapsed .sidebar-menu li a {
            justify-content: center;
        }

        .logo {
            display: flex;
            align-items: center;
            padding: 20px;
            height: var(--top-nav-height);
            border-bottom: 1px solid var(--gray-light);
        }

        .logo i {
            font-size: 24px;
            color: var(--primary);
            margin-right: 10px;
        }

        .logo span {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark);
        }

        .sidebar-menu {
            list-style: none;
            padding: 20px 0;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: var(--gray);
            text-decoration: none;
            transition: var(--transition);
            border-left: 3px solid transparent;
        }

        .sidebar-menu li a:hover {
            color: var(--primary);
            background-color: var(--primary-light);
            border-left: 3px solid var(--primary);
        }

        .sidebar-menu li a i {
            font-size: 18px;
            margin-right: 12px;
            width: 24px;
            text-align: center;
        }

        .sidebar-menu li.active a {
            color: var(--primary);
            background-color: var(--primary-light);
            border-left: 3px solid var(--primary);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            transition: var(--transition);
        }

        .sidebar.collapsed ~ .main-content {
            margin-left: var(--sidebar-collapsed-width);
        }

        /* Top Navigation */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
            height: var(--top-nav-height);
            background: var(--white);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 0;
            z-index: 90;
        }

        .search-box {
            display: flex;
            align-items: center;
            background: var(--light);
            border-radius: 8px;
            padding: 8px 15px;
            width: 350px;
        }

        .search-box i {
            color: var(--gray);
            margin-right: 10px;
        }

        .search-box input {
            border: none;
            background: transparent;
            outline: none;
            width: 100%;
            font-size: 14px;
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .notifications {
            position: relative;
            margin-right: 25px;
            cursor: pointer;
        }

        .notifications i {
            font-size: 20px;
            color: var(--gray);
        }

        .notification-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background: var(--danger);
            color: var(--white);
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 600;
        }

        .user-profile {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .user-profile img {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }

        .user-profile span {
            font-weight: 500;
            margin-right: 8px;
        }

        .user-profile i {
            font-size: 12px;
            color: var(--gray);
        }

        /* Dashboard Content */
        .dashboard-content {
            padding: 30px;
        }

        .dashboard-content h2 {
            font-size: 24px;
            margin-bottom: 25px;
            color: var(--dark);
            font-weight: 600;
        }

        /* Stats Cards */
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: var(--white);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.03);
            display: flex;
            align-items: center;
            transition: var(--transition);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.05);
        }

        .card-icon {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 24px;
            color: var(--white);
        }

        .bg-blue {
            background: linear-gradient(135deg, #4361ee, #3f37c9);
        }

        .bg-green {
            background: linear-gradient(135deg, #4cc9f0, #4895ef);
        }

        .bg-orange {
            background: linear-gradient(135deg, #f8961e, #f3722c);
        }

        .bg-red {
            background: linear-gradient(135deg, #f72585, #b5179e);
        }

        .card-info h3 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--dark);
        }

        .card-info p {
            font-size: 14px;
            color: var(--gray);
        }

        /* Charts and Tables */
        .row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .chart-container {
            background: var(--white);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.03);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .chart-header h4 {
            font-size: 16px;
            font-weight: 600;
            color: var(--dark);
        }

        .chart-header select {
            border: 1px solid var(--gray-light);
            border-radius: 6px;
            padding: 6px 12px;
            font-size: 14px;
            outline: none;
            background: var(--white);
            color: var(--gray);
            cursor: pointer;
        }

        canvas {
            width: 100% !important;
            height: 300px !important;
        }

        /* Recent Orders */
        .table-container {
            background: var(--white);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.03);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .table-header h4 {
            font-size: 16px;
            font-weight: 600;
            color: var(--dark);
        }

        .view-all {
            font-size: 14px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .view-all:hover {
            text-decoration: underline;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 12px 15px;
            font-size: 14px;
            font-weight: 500;
            color: var(--gray);
            border-bottom: 1px solid var(--gray-light);
        }

        td {
            padding: 12px 15px;
            font-size: 14px;
            border-bottom: 1px solid var(--gray-light);
        }

        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status.delivered {
            background: #e3f9ee;
            color: #28a745;
        }

        .status.shipped {
            background: #e3f2fd;
            color: #2196f3;
        }

        .status.processing {
            background: #fff8e1;
            color: #ffc107;
        }

        .status.pending {
            background: #f3e5f5;
            color: #9c27b0;
        }

        .status.cancelled {
            background: #ffebee;
            color: #f44336;
        }

        .action-btn {
            color: var(--gray);
            text-decoration: none;
            font-size: 16px;
            transition: var(--transition);
        }

        .action-btn:hover {
            color: var(--primary);
        }

        /* Toggle Button */
        .toggle-sidebar {
            position: fixed;
            bottom: 20px;
            left: 20px;
            background: var(--primary);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 110;
            box-shadow: 0 4px 10px rgba(67, 97, 238, 0.3);
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .row {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 992px) {
            .sidebar {
                transform: translateX(-100%);
            }
            .sidebar.show {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
            }
            .toggle-sidebar {
                display: flex;
            }
        }

        @media (max-width: 768px) {
            .search-box {
                width: 200px;
            }
            .stats-cards {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 576px) {
            .top-nav {
                padding: 0 15px;
            }
            .stats-cards {
                grid-template-columns: 1fr;
            }
            .user-profile span {
                display: none;
            }
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <!-- Sidebar -->
    <div class="sidebar" id="sidebar">
        <div class="logo">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare</span>
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
                <input type="text" placeholder="Search patients, medicines...">
            </div>
            <div class="user-info">
                <div class="notifications">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">3</span>
                </div>
                <div class="user-profile">
                    <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Admin">
                    <span>Dr. Smith</span>
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
                        <i class="fas fa-prescription-bottle-alt"></i>
                    </div>
                    <div class="card-info">
                        <h3>567</h3>
                        <p>Total Medicines</p>
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
                        <i class="fas fa-user-injured"></i>
                    </div>
                    <div class="card-info">
                        <h3>1,234</h3>
                        <p>Patients</p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-icon bg-red">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="card-info">
                        <h3>42</h3>
                        <p>Today's Appointments</p>
                    </div>
                </div>
            </div>

            <!-- Charts and Tables -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="chart-container">
                        <div class="chart-header">
                            <h4>Monthly Sales Report</h4>
                            <select>
                                <option>Last 7 Days</option>
                                <option selected>Last Month</option>
                                <option>Last Year</option>
                            </select>
                        </div>
                        <canvas id="salesChart"></canvas>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="chart-container">
                        <div class="chart-header">
                            <h4>Medicine Categories</h4>
                        </div>
                        <canvas id="categoryChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="table-container">
                <div class="table-header">
                    <h4>Recent Prescriptions</h4>
                    <a href="#" class="view-all">View All</a>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th>Prescription ID</th>
                        <th>Patient</th>
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
                        <td><span class="status delivered">Fulfilled</span></td>
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

    <!-- Toggle Sidebar Button (visible on mobile) -->
    <div class="toggle-sidebar" id="toggleSidebar">
        <i class="fas fa-bars"></i>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Toggle sidebar
    const sidebar = document.getElementById('sidebar');
    const toggleSidebar = document.getElementById('toggleSidebar');

    toggleSidebar.addEventListener('click', () => {
        sidebar.classList.toggle('show');
    });

    // Initialize charts
    document.addEventListener('DOMContentLoaded', function() {
        // Sales Chart
        const salesCtx = document.getElementById('salesChart').getContext('2d');
        const salesChart = new Chart(salesCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                datasets: [{
                    label: 'Sales',
                    data: [1200, 1900, 1700, 2100, 2300, 2500, 2200],
                    backgroundColor: 'rgba(67, 97, 238, 0.1)',
                    borderColor: '#4361ee',
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            drawBorder: false
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });

        // Category Chart
        const categoryCtx = document.getElementById('categoryChart').getContext('2d');
        const categoryChart = new Chart(categoryCtx, {
            type: 'doughnut',
            data: {
                labels: ['Antibiotics', 'Pain Relief', 'Vitamins', 'Antihistamines', 'Other'],
                datasets: [{
                    data: [35, 25, 20, 15, 5],
                    backgroundColor: [
                        '#4361ee',
                        '#4cc9f0',
                        '#f8961e',
                        '#f72585',
                        '#6c757d'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                },
                cutout: '70%'
            }
        });
    });
</script>
</body>
</html>