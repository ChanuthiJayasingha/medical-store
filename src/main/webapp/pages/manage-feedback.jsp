<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Manage Feedback</title>
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
                    <a href="${pageContext.request.contextPath}/ManageFeedbackServlet" class="sidebar-link active">
                        <i class="fas fa-comment-dots"></i>
                        <span class="sidebar-text">Manage Feedback</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageAuditServlet" class="sidebar-link">
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
                <h1 class="text-2xl font-bold text-gray-800">Manage Feedback</h1>
                <button onclick="openModal('addFeedbackModal')" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Add Feedback</button>
            </div>

            <c:if test="${not empty sessionScope.notification}">
                <div class="notification mb-4 p-4 rounded-lg <c:out value='${sessionScope.notificationType == "success" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}'/>">
                    <c:out value="${sessionScope.notification}"/>
                </div>
                <c:remove var="notification" scope="session"/>
                <c:remove var="notificationType" scope="session"/>
            </c:if>

            <c:choose>
                <c:when test="${not empty feedbackList}">
                    <div class="overflow-x-auto">
                        <table class="w-full table-auto border-collapse">
                            <thead>
                            <tr class="bg-gray-200">
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Feedback ID</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Username</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Comment</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Rating</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Submission Date</th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="table-hover">
                            <c:forEach var="feedback" items="${feedbackList}">
                                <tr>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${feedback.feedbackId}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${feedback.username}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${feedback.comment}"/></td>
                                    <td class="border px-4 py-3 text-gray-600"><c:out value="${feedback.rating}"/></td>
                                    <td class="border px-4 py-3 text-gray-600">
                                        <c:choose>
                                            <c:when test="${not empty feedback.submissionDate}">
                                                <c:out value="${feedback.submissionDate}"/>
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="border px-4 py-3">
                                        <a href="${pageContext.request.contextPath}/ManageFeedbackServlet?action=delete&feedbackId=<c:out value="${feedback.feedbackId}"/>&csrfToken=<c:out value="${sessionScope.csrfToken}"/>" class="text-red-600 hover:text-red-800" onclick="return confirm('Are you sure you want to delete this feedback?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-600 text-center py-4">No feedback available.</p>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Add Feedback Modal -->
        <div id="addFeedbackModal" class="modal">
            <div class="modal-content">
                <h2 class="text-xl font-bold mb-6 text-gray-800">Add Feedback</h2>
                <form id="addFeedbackForm" action="${pageContext.request.contextPath}/ManageFeedbackServlet" method="post" onsubmit="return validateFeedbackForm('addFeedbackForm')">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <div class="mb-5">
                        <label class="block text-gray-700 font-medium mb-1">Username</label>
                        <input type="text" name="username" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" maxlength="50" pattern="[a-zA-Z0-9_]+">
                    </div>
                    <div class="mb-5">
                        <label class="block text-gray-700 font-medium mb-1">Comment</label>
                        <textarea name="comment" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" rows="4" maxlength="500"></textarea>
                    </div>
                    <div class="mb-5">
                        <label class="block text-gray-700 font-medium mb-1">Rating</label>
                        <input type="number" name="rating" min="1" max="5" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div class="mb-5">
                        <label class="block text-gray-700 font-medium mb-1">Submission Date</label>
                        <input type="date" name="submissionDate" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" max="<%= java.time.LocalDate.now() %>">
                    </div>
                    <div class="flex justify-end">
                        <button type="button" onclick="closeModal('addFeedbackModal')" class="bg-gray-500 text-white px-4 py-2 rounded-full hover:bg-gray-600 transition mr-2">Cancel</button>
                        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Add Feedback</button>
                    </div>
                </form>
            </div>
        </div>
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

    function openModal(modalId) {
        document.getElementById(modalId).style.display = 'block';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    function validateFeedbackForm(formId) {
        const form = document.getElementById(formId);
        const rating = form.querySelector('input[name="rating"]').value;
        const username = form.querySelector('input[name="username"]').value;
        const comment = form.querySelector('textarea[name="comment"]').value;

        if (!/^[a-zA-Z0-9_]+$/.test(username)) {
            alert('Username can only contain letters, numbers, and underscores.');
            return false;
        }
        if (comment.trim().length === 0 || comment.length > 500) {
            alert('Comment must be between 1 and 500 characters.');
            return false;
        }
        if (rating < 1 || rating > 5) {
            alert('Rating must be between 1 and 5.');
            return false;
        }
        return true;
    }
</script>
</body>
</html>