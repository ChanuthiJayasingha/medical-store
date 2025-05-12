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
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- Google Fonts: Inter & Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS (Replacing Tailwind for consistency with previous pages) -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1512678080530-7760d81faba6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') no-repeat center center fixed;
            background-size: cover;
            color: #1f2937;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Poppins', sans-serif;
        }

        .flex-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            transition: width 0.3s ease;
            z-index: 50;
        }

        .sidebar-collapsed {
            width: 80px;
        }

        .sidebar-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            padding: 0 16px;
            border-bottom: 1px solid #e5e7eb;
        }

        .sidebar-header a {
            font-size: 1.75rem;
            font-weight: 700;
            color: #2563eb;
            text-decoration: none;
        }

        .sidebar-header button {
            background: none;
            border: none;
            color: #4b5563;
            font-size: 1.25rem;
            cursor: pointer;
        }

        .sidebar-nav {
            margin-top: 24px;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: #4b5563;
            text-decoration: none;
            transition: background 0.2s, color 0.2s;
        }

        .sidebar-link:hover, .sidebar-link.active {
            background: #2563eb;
            color: #ffffff;
        }

        .sidebar-link i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.25rem;
        }

        .sidebar-text {
            font-size: 0.95rem;
            font-weight: 500;
        }

        .content {
            flex: 1;
            margin-left: 250px;
            padding: 24px;
            transition: margin-left 0.3s ease;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 16px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
        }

        .logout-btn {
            background: #2563eb;
            color: #ffffff;
            padding: 8px 16px;
            border-radius: 9999px;
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 500;
            transition: background 0.2s;
        }

        .logout-btn:hover {
            background: #1e40af;
        }

        .section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .section-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1f2937;
        }

        .action-buttons {
            display: flex;
            gap: 16px;
        }

        .action-btn {
            display: flex;
            align-items: center;
            padding: 8px 16px;
            border: none;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }

        .backup-btn {
            background: #2563eb;
            color: #ffffff;
        }

        .clear-btn {
            background: #dc2626;
            color: #ffffff;
        }

        .action-btn:hover {
            transform: translateY(-2px);
        }

        .backup-btn:hover {
            background: #1e40af;
        }

        .clear-btn:hover {
            background: #b91c1c;
        }

        .action-btn i {
            margin-right: 8px;
        }

        .notification {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            animation: fadeOut 5s forwards;
            font-size: 0.95rem;
        }

        .notification.success {
            background: #dcfce7;
            color: #166534;
        }

        .notification.error {
            background: #fee2e2;
            color: #991b1b;
        }

        @keyframes fadeOut {
            0% { opacity: 1; }
            80% { opacity: 1; }
            100% { opacity: 0; display: none; }
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
            font-size: 0.9rem;
            border-bottom: 1px solid #e5e7eb;
        }

        th {
            background: #f3f4f6;
            color: #1f2937;
            font-weight: 600;
        }

        td {
            color: #4b5563;
        }

        tr:hover {
            background: #f1f5f9;
        }

        .no-data {
            text-align: center;
            padding: 24px;
            color: #4b5563;
            font-size: 1rem;
        }

        footer {
            background: rgba(31, 41, 55, 0.95);
            color: #f3f4f6;
            padding: 32px;
            margin-top: 24px;
            text-align: center;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 80px;
            }

            .sidebar-expanded {
                width: 200px;
            }

            .sidebar-collapsed .sidebar-text {
                display: none;
            }

            .content {
                margin-left: 80px;
            }

            .section-header {
                flex-direction: column;
                gap: 16px;
            }

            .action-buttons {
                flex-direction: column;
                width: 100%;
            }

            .action-btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<c:if test="${empty sessionScope.username}">
    <c:redirect url="${pageContext.request.contextPath}/pages/login.jsp"/>
</c:if>

<div class="flex-container">
    <aside id="sidebar" class="sidebar sidebar-expanded">
        <div class="sidebar-header">
            <a href="${pageContext.request.contextPath}/pages/index.jsp">MediCare</a>
            <button id="toggleSidebar">
                <i class="fas fa-bars"></i>
            </button>
        </div>
        <nav class="sidebar-nav">
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

    <main class="content">
        <nav class="navbar">
            <h2>Welcome, <c:out value="${sessionScope.username}"/></h2>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </nav>

        <section class="section">
            <div class="section-header">
                <h1>Audit Logs</h1>
                <div class="action-buttons">
                    <form action="${pageContext.request.contextPath}/ManageAuditServlet" method="post">
                        <input type="hidden" name="action" value="backup">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <button type="submit" class="action-btn backup-btn">
                            <i class="fas fa-download"></i>Create Backup
                        </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/ManageAuditServlet" method="post">
                        <input type="hidden" name="action" value="clearLogs">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <button type="submit" class="action-btn clear-btn" onclick="return confirm('Are you sure you want to clear all audit logs?')">
                            <i class="fas fa-trash"></i>Clear Audit Logs
                        </button>
                    </form>
                </div>
            </div>

            <c:if test="${not empty sessionScope.notification}">
                <div class="notification ${sessionScope.notificationType == 'success' ? 'success' : 'error'}">
                    <c:out value="${sessionScope.notification}"/>
                </div>
                <c:remove var="notification" scope="session"/>
                <c:remove var="notificationType" scope="session"/>
            </c:if>

            <c:choose>
                <c:when test="${not empty auditLogs}">
                    <div class="table-container">
                        <table>
                            <thead>
                            <tr>
                                <th>Audit ID</th>
                                <th>Username</th>
                                <th>Action</th>
                                <th>Timestamp</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="log" items="${auditLogs}">
                                <c:set var="parts" value="${fn:split(log, ',')}"/>
                                <tr>
                                    <td><c:out value="${parts[0]}"/></td>
                                    <td><c:out value="${parts[1]}"/></td>
                                    <td><c:out value="${parts[2]}"/></td>
                                    <td><c:out value="${parts[3]}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="no-data">No audit logs available.</p>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>

<footer>
    <div>© <%= java.time.Year.now().getValue() %> MediCare. All rights reserved.</div>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', () => {
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
    });
</script>
</body>
</html>