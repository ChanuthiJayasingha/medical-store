<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="MediCare Admin Dashboard for managing products, orders, users, feedback, and audits.">
    <title>MediCare - Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        h1, h2, h3, h4, h5, h6 {
            font-family: 'Poppins', sans-serif;
        }
        .admin-bg {
            background: linear-gradient(135deg, #1e3a8a, #3b82f6);
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
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .dashboard-card:hover, .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
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
            min-width: 24px;
        }
        .content {
            transition: margin-left 0.3s ease;
        }
        .notification {
            transition: opacity 0.5s ease;
        }
        @media (max-width: 768px) {
            .sidebar-expanded {
                width: 200px;
            }
            .sidebar-collapsed {
                width: 60px;
            }
            .content {
                margin-left: 60px;
            }
            .sidebar-expanded .content {
                margin-left: 200px;
            }
        }
    </style>
</head>
<body class="bg-gray-100">
<c:if test="${empty sessionScope.username}">
    <c:redirect url="${pageContext.request.contextPath}/pages/login.jsp"/>
</c:if>

<div class="flex min-h-screen">
    <aside id="sidebar" class="sidebar sidebar-expanded bg-white shadow-lg fixed top-0 left-0 h-full z-50" aria-label="Sidebar Navigation">
        <div class="flex items-center justify-between h-16 px-4 border-b">
            <a href="${pageContext.request.contextPath}/pages/index.jsp" class="text-2xl font-bold text-blue-600">MediCare</a>
            <button id="toggleSidebar" class="text-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-600 rounded" aria-label="Toggle Sidebar">
                <i class="fas fa-bars text-xl"></i>
            </button>
        </div>
        <nav class="mt-6" aria-label="Main Navigation">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/AdminServlet" class="sidebar-link active" aria-current="page">
                        <i class="fas fa-tachometer-alt" aria-hidden="true"></i>
                        <span class="sidebar-text">Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageProductsServlet" class="sidebar-link">
                        <i class="fas fa-pills" aria-hidden="true"></i>
                        <span class="sidebar-text">Manage Products</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageOrdersServlet" class="sidebar-link">
                        <i class="fas fa-clipboard-list" aria-hidden="true"></i>
                        <span class="sidebar-text">Manage Orders</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="sidebar-link">
                        <i class="fas fa-users" aria-hidden="true"></i>
                        <span class="sidebar-text">Manage Users</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageFeedbackServlet" class="sidebar-link">
                        <i class="fas fa-comment-dots" aria-hidden="true"></i>
                        <span class="sidebar-text">Manage Feedback</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageAuditServlet" class="sidebar-link">
                        <i class="fas fa-file-alt" aria-hidden="true"></i>
                        <span class="sidebar-text">Audit Logs</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="sidebar-link">
                        <i class="fas fa-sign-out-alt" aria-hidden="true"></i>
                        <span class="sidebar-text">Logout</span>
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="flex-1 content ml-[250px] p-6" aria-label="Main Content">
        <nav class="bg-white shadow-lg rounded-lg p-4 mb-6">
            <div class="flex justify-between items-center">
                <h2 class="text-xl font-semibold text-gray-800">Welcome, <c:out value="${fn:escapeXml(sessionScope.username)}"/></h2>
                <div class="flex items-center space-x-4">
                    <span id="notification" class="text-sm text-green-600 hidden" role="alert"></span>
                    <a href="${pageContext.request.contextPath}/logout" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition focus:outline-none focus:ring-2 focus:ring-blue-600">Logout</a>
                </div>
            </div>
        </nav>

        <section class="admin-bg text-white py-12 rounded-lg mb-12">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h1 class="text-3xl font-bold mb-8 text-center">Dashboard Overview</h1>
                <div class="dashboard-grid grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6">
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" role="button" tabindex="0" onclick="window.location.href='${pageContext.request.contextPath}/ManageProductsServlet'" onkeydown="if(event.key === 'Enter') window.location.href='${pageContext.request.contextPath}/ManageProductsServlet'">
                        <i class="fas fa-pills text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Total Products</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${totalProducts}" default="0"/></p>
                    </div>
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" role="button" tabindex="0" onclick="window.location.href='${pageContext.request.contextPath}/ManageOrdersServlet'" onkeydown="if(event.key === 'Enter') window.location.href='${pageContext.request.contextPath}/ManageOrdersServlet'">
                        <i class="fas fa-clipboard-list text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Total Orders</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${totalOrders}" default="0"/></p>
                    </div>
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" role="button" tabindex="0" onclick="window.location.href='${pageContext.request.contextPath}/ManageUsersServlet'" onkeydown="if(event.key === 'Enter') window.location.href='${pageContext.request.contextPath}/ManageUsersServlet'">
                        <i class="fas fa-users text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Active Users</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${activeUsers}" default="0"/></p>
                    </div>
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" role="button" tabindex="0" onclick="alert('Pending Orders: ${fn:escapeXml(pendingOrders)}')" onkeydown="if(event.key === 'Enter') alert('Pending Orders: ${fn:escapeXml(pendingOrders)}')">
                        <i class="fas fa-exclamation-triangle text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Pending Orders</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${pendingOrders}" default="0"/></p>
                    </div>
                    <div class="dashboard-card bg-white text-gray-800 p-6 rounded-lg shadow-md text-center" role="button" tabindex="0" onclick="window.location.href='${pageContext.request.contextPath}/ManageFeedbackServlet'" onkeydown="if(event.key === 'Enter') window.location.href='${pageContext.request.contextPath}/ManageFeedbackServlet'">
                        <i class="fas fa-comment-dots text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Total Feedback</h3>
                        <p class="text-2xl font-bold text-gray-600"><c:out value="${totalFeedback}" default="0"/></p>
                    </div>
                </div>
            </div>
        </section>

        <section class="admin-bg text-white py-12 rounded-lg">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h1 class="text-3xl font-bold mb-8 text-center">Admin Dashboard</h1>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6">
                    <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                        <i class="fas fa-pills text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Manage Products</h3>
                        <p class="text-gray-600 mb-4">Add, update, or remove products from the store.</p>
                        <a href="${pageContext.request.contextPath}/ManageProductsServlet" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition focus:outline-none focus:ring-2 focus:ring-blue-600">Go to Products</a>
                    </div>
                    <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                        <i class="fas fa-clipboard-list text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">View Orders</h3>
                        <p class="text-gray-600 mb-4">Check and manage customer orders.</p>
                        <a href="${pageContext.request.contextPath}/ManageOrdersServlet" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition focus:outline-none focus:ring-2 focus:ring-blue-600">Go to Orders</a>
                    </div>
                    <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                        <i class="fas fa-users text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Manage Users</h3>
                        <p class="text-gray-600 mb-4">View and manage user accounts.</p>
                        <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition focus:outline-none focus:ring-2 focus:ring-blue-600">Go to Users</a>
                    </div>
                    <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                        <i class="fas fa-comment-dots text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Manage Feedback</h3>
                        <p class="text-gray-600 mb-4">Review and respond to customer feedback.</p>
                        <a href="${pageContext.request.contextPath}/ManageFeedbackServlet" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition focus:outline-none focus:ring-2 focus:ring-blue-600">Go to Feedback</a>
                    </div>
                    <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                        <i class="fas fa-file-alt text-4xl text-blue-600 mb-4" aria-hidden="true"></i>
                        <h3 class="text-xl font-semibold mb-2">Audit Logs</h3>
                        <p class="text-gray-600 mb-4">View system activity and audit logs.</p>
                        <a href="${pageContext.request.contextPath}/ManageAuditServlet" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition focus:outline-none focus:ring-2 focus:ring-blue-600">Go to Audits</a>
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
    (function () {
        const sidebar = document.getElementById('sidebar');
        const toggleSidebar = document.getElementById('toggleSidebar');
        const content = document.querySelector('.content');
        const sidebarTexts = document.querySelectorAll('.sidebar-text');
        const notification = document.getElementById('notification');

        // Toggle sidebar
        toggleSidebar.addEventListener('click', () => {
            sidebar.classList.toggle('sidebar-expanded');
            sidebar.classList.toggle('sidebar-collapsed');
            updateSidebar();
        });

        function updateSidebar() {
            if (sidebar.classList.contains('sidebar-collapsed')) {
                content.style.marginLeft = '80px';
                sidebarTexts.forEach(text => text.style.display = 'none');
            } else {
                content.style.marginLeft = '250px';
                sidebarTexts.forEach(text => text.style.display = 'inline');
            }
        }

        // Show notification
        function showNotification(message, type = 'success') {
            notification.textContent = message;
            notification.className = `text-sm ${type == 'success' ? 'text-green-600' : 'text-red-600'} hidden`;
            notification.classList.remove('hidden');
            setTimeout(() => {
                notification.classList.add('opacity-0');
                setTimeout(() => notification.classList.add('hidden'), 500);
            }, 3000);
        }

        // Initialize sidebar state
        updateSidebar();

        // Expose showNotification to global scope for server-side calls
        window.showNotification = showNotification;
    })();
</script>
</body>
</html>