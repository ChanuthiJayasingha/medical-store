<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Audit Logs</title>
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
        .sidebar {
            transition: width 0.3s ease;
        }
        .sidebar-collapsed {
            width: 80px;
        }
        .sidebar-expanded {
            width: 250px;
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
            width: 20px;
            text-align: center;
        }
        .content {
            transition: margin-left 0.3s ease;
        }
        .table-hover tr:hover {
            background-color: #f1f5f9;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
        }
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 24px;
            border-radius: 12px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .notification {
            animation: fadeOut 5s forwards;
        }
        @keyframes fadeOut {
            0% { opacity: 1; }
            80% { opacity: 1; }
            100% { opacity: 0; display: none; }
        }
        input:invalid, select:invalid {
            border-color: #ef4444;
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
                    <a href="${pageContext.request.contextPath}/AdminServlet" class="sidebar-link">
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
                    <a href="${pageContext.request.contextPath}/ManageFeedbackServlet" class="sidebar-link">
                        <i class="fas fa-comment-dots"></i>
                        <span class="sidebar-text">Manage Feedback</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageAuditServlet" class="sidebar-link active">
                        <i class="fas fa-file-alt"></i>
                        <span class="sidebar-text">Audit Logs</span>
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

        <section class="bg-white p-6 rounded-lg shadow-lg">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Audit Logs</h1>
            </div>

            <c:if test="${not empty sessionScope.notification}">
                <div class="notification mb-4 p-4 rounded-lg <c:out value='${sessionScope.notificationType == "success" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}'/>">
                    <c:out value="${sessionScope.notification}"/>
                </div>
                <c:remove var="notification" scope="session"/>
                <c:remove var="notificationType" scope="session"/>
            </c:if>

            <c:choose>
                <c:when test="${not empty auditLogs}">
                    <div class="overflow-x-auto">
                        <table class="w-full table-auto border-collapse">
                            <thead>
                            <tr class="bg-gray-200">
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Audit ID</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Username</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Action</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Description</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Timestamp</th>
                            </tr>
                            </thead>
                            <tbody class="table-hover">
                            <c:forEach var="audit" items="${auditLogs}">
                                <tr>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${audit.auditId}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${audit.username}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${audit.action}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${audit.description}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><fmt:formatDate value="${audit.timestamp}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-600 text-center py-4">No audit logs available.</p>
                </c:otherwise>
            </c:choose>
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