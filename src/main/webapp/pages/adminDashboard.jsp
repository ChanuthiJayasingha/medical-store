<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        h1, h2, h3, h4, h5, h6 {
            font-family: 'Poppins', sans-serif;
        }
        .admin-bg {
            background: linear-gradient(to right, #1e3a8a, #3b82f6);
        }
        .sidebar {
            transition: width 0.3s ease;
        }
        .sidebar-collapsed {
            width: 80px;
        }
        .sidebar-expanded {
            width: 250px;
        }
        .dashboard-card, .card-hover {
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .dashboard-card:hover, .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }
        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: #4b5563;
            transition: background-color 0.2s, color 0.2s;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background-color: #2563eb;
            color: white;
        }
        .sidebar-link i {
            margin-right: 12px;
        }
        .content {
            transition: margin-left 0.3s ease;
        }
    </style>
</head>
<body class="bg-gray-100">
<c:if test="${empty sessionScope.username}">
    <c:redirect url="${pageContext.request.contextPath}/pages/login.jsp"/>
</c:if>

<div class="flex min-h-screen">
    <aside id="sidebar" class="sidebar sidebar-expanded bg-white shadow-lg fixed top-0 left-0 h-full z-50">
        <div class="flex items-center justify-between h-16 px-4 border-b">
            <a href="${pageContext.request.contextPath}/pages/index.jsp" class="text-2xl font-bold text-blue-600">MediCare</a>
            <button id="toggleSidebar" class="text-gray-600 focus:outline-none">
                <i class="fas fa-bars text-xl"></i>
            </button>
        </div>
        <nav class="mt-6">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/AdminServlet" class="sidebar-link active">
                        <i class="fas fa-tachometer-alt"></i>
                        <span class="sidebar-text">Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageProductsServlet" class="sidebar-link">
                        <i class="fas fa-pills"></i>
                        <span class="sidebar-text">Manage Products</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageOrdersServlet" class="sidebar-link">
                        <i class="fas fa-clipboard-list"></i>
                        <span class="sidebar-text">Manage Orders</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="sidebar-link">
                        <i class="fas fa-users"></i>
                        <span class="sidebar-text">Manage Users</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="sidebar-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span class="sidebar-text">Logout</span>
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="flex-1 content ml-[250px] p-6">
        <nav class="bg-white shadow-lg rounded-lg p-4 mb-6">
            <div class="flex justify-between items-center">
                <h2 class="text-xl font-semibold text-gray-800">Welcome, <c:out value="${sessionScope.username}"/></h2>
                <a href="${pageContext.request.contextPath}/logout" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Logout</a>
            </div>
        </nav>

        <section class="admin-bg text-white py-12 rounded-lg mb-12">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h1 class="text-3xl font-bold mb-8 text-center">Dashboard Overview</h1>
                <div class="dashboard-grid grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" onclick="window.location.href='${pageContext.request.contextPath}/AdminServlet'">
                        <i class="fas fa-pills text-4xl text-blue-600 mb-4" aria-label="Products Icon"></i>
                        <h3 class="text-xl font-semibold mb-2">Total Products</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${totalProducts}"/></p>
                    </div>
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" onclick="window.location.href='${pageContext.request.contextPath}/ManageOrdersServlet'">
                        <i class="fas fa-clipboard-list text-4xl text-blue-600 mb-4" aria-label="Orders Icon"></i>
                        <h3 class="text-xl font-semibold mb-2">Total Orders</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${totalOrders}"/></p>
                    </div>
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" onclick="window.location.href='${pageContext.request.contextPath}/ManageUsersServlet'">
                        <i class="fas fa-users text-4xl text-blue-600 mb-4" aria-label="Users Icon"></i>
                        <h3 class="text-xl font-semibold mb-2">Active Users</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${activeUsers}"/></p>
                    </div>
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" onclick="alert('Pending Orders: ${pendingOrders}')">
                        <i class="fas fa-exclamation-triangle text-4xl text-blue-600 mb-4" aria-label="Pending Orders Icon"></i>
                        <h3 class="text-xl font-semibold mb-2">Pending Orders</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${pendingOrders}"/></p>
                    </div>
                </div>
            </div>
        </section>

        <section class="admin-bg text-white py-12 rounded-lg">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h1 class="text-3xl font-bold mb-8 text-center">Admin Dashboard</h1>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                        <i class="fas fa-pills text-4xl text-blue-600 mb-4" aria-label="Products Icon"></i>
                        <h3 class="text-xl font-semibold mb-2">Manage Products</h3>
                        <p class="text-gray-600 mb-4">Add, update, or remove products from the store.</p>
                        <a href="${pageContext.request.contextPath}/pages/manage-products.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Go to Products</a>
                    </div>
                    <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                        <i class="fas fa-clipboard-list text-4xl text-blue-600 mb-4" aria-label="Orders Icon"></i>
                        <h3 class="text-xl font-semibold mb-2">View Orders</h3>
                        <p class="text-gray-600 mb-4">Check and manage customer orders.</p>
                        <a href="${pageContext.request.contextPath}/pages/view-orders.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Go to Orders</a>
                    </div>
                    <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                        <i class="fas fa-users text-4xl text-blue-600 mb-4" aria-label="Users Icon"></i>
                        <h3 class="text-xl font-semibold mb-2">Manage Users</h3>
                        <p class="text-gray-600 mb-4">View and manage user accounts.</p>
                        <a href="${pageContext.request.contextPath}/pages/manage-users.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Go to Users</a>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>

<footer class="bg-gray-800 text-white py-8 mt-6">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center">
            <p class="text-gray-400">© <%= java.time.Year.now().getValue() %> MediCare. All rights reserved.</p>
        </div>
    </div>
</footer>

<script>
    const sidebar = document.getElementById('sidebar');
    const toggleSidebar = document.getElementById('toggleSidebar');
    const content = document.querySelector('.content');
    const sidebarTexts = document.querySelectorAll('.sidebar-text');

    toggleSidebar.addEventListener('click', () => {
        sidebar.classList.toggle('sidebar-expanded');
        sidebar.classList.toggle('sidebar-collapsed');

        if (sidebar.classList.contains('sidebar-collapsed')) {
            content.style.marginLeft = '80px';
            sidebarTexts.forEach(text => text.style.display = 'none');
        } else {
            content.style.marginLeft = '250px';
            sidebarTexts.forEach(text => text.style.display = 'inline');
        }
    });
</script>
</body>
</html>