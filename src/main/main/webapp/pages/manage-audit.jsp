<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="MediCare - Manage Audit Logs for administrative actions.">
    <meta name="keywords" content="MediCare, audit logs, admin, medical store">
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
                    <a href="${pageContext.request.contextPath}/AdminServlet" class="sidebar-link">
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
                    <a href="${pageContext.request.contextPath}/ManageAuditServlet" class="sidebar-link active" aria-current="page">
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

        <section class="bg-white p-6 rounded-lg shadow-lg">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Audit Logs</h1>
                <div class="flex space-x-4">
                    <form action="${pageContext.request.contextPath}/ManageAuditServlet" method="post">
                        <input type="hidden" name="action" value="backup">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition focus:outline-none focus:ring-2 focus:ring-blue-600">
                            <i class="fas fa-download mr-2"></i>Create Backup
                        </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/ManageAuditServlet" method="post">
                        <input type="hidden" name="action" value="clearLogs">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-full hover:bg-red-700 transition focus:outline-none focus:ring-2 focus:ring-red-600" onclick="return confirm('Are you sure you want to clear all audit logs?')">
                            <i class="fas fa-trash mr-2"></i>Clear Audit Logs
                        </button>
                    </form>
                </div>
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
                            <tr class="bg-gray-200 sticky top-0">
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Audit ID</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Username</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Action</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Timestamp</th>
                            </tr>
                            </thead>
                            <tbody class="table-hover">
                            <c:forEach var="log" items="${auditLogs}" varStatus="status">
                                <c:set var="parts" value="${fn:split(log, ',')}"/>
                                <tr class="${status.index % 2 == 0 ? 'bg-white' : 'bg-gray-50'}">
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${parts[0]}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${parts[1]}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${parts[2]}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${parts[3]}"/></td>
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