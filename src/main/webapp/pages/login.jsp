<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Login</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        .admin-theme {
            background: linear-gradient(to bottom, #1e3a8a, #3b82f6);
        }
        .user-theme {
            background: linear-gradient(to bottom, #10b981, #6ee7b7);
        }
        .form-container {
            transition: all 0.3s ease;
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen bg-gray-100">
<div id="formContainer" class="form-container w-full max-w-md p-8 rounded-lg shadow-lg text-white <%= "Admin".equals(request.getParameter("role")) ? "admin-theme" : "user-theme" %>">
    <div class="text-center mb-6">
        <a href="${pageContext.request.contextPath}/pages/index.jsp" class="text-3xl font-bold">MediCare</a>
    </div>
    <h2 id="formTitle" class="text-2xl font-bold mb-6 text-center"><%= "Admin".equals(request.getParameter("role")) ? "Admin Login" : "User Login" %></h2>
    <%-- Display error message if present --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="bg-red-500 text-white p-3 rounded-lg mb-4 text-center">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>
    <form action="${pageContext.request.contextPath}/login" method="POST">
        <input type="hidden" name="role" value="<%= "Admin".equals(request.getParameter("role")) ? "Admin" : "User" %>">
        <div class="mb-4">
            <label for="username" class="block mb-2">Username</label>
            <div class="relative">
                <input type="text" id="username" name="username" class="w-full px-4 py-2 bg-white text-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-white" required>
                <i class="fas fa-user absolute right-3 top-3 text-gray-400"></i>
            </div>
        </div>
        <div class="mb-4">
            <label for="password" class="block mb-2">Password</label>
            <div class="relative">
                <input type="password" id="password" name="password" class="w-full px-4 py-2 bg-white text-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-white" required>
                <i class="fas fa-lock absolute right-3 top-3 text-gray-400"></i>
            </div>
        </div>
        <button type="submit" id="loginButton" class="w-full bg-white <%= "Admin".equals(request.getParameter("role")) ? "text-blue-600" : "text-green-600" %> py-2 rounded-lg font-semibold hover:bg-gray-100"><%= "Admin".equals(request.getParameter("role")) ? "Login as Admin" : "Login as User" %></button>
    </form>
    <div class="mt-4 text-center">
        <p>Don't have an account? <a href="${pageContext.request.contextPath}/pages/register.jsp" class="underline hover:text-gray-200">Sign Up</a></p>
        <p><a href="${pageContext.request.contextPath}/pages/index.jsp" class="underline hover:text-gray-200">Back to Home</a></p>
    </div>
</div>

<script>
    // Set initial theme based on role
    document.addEventListener('DOMContentLoaded', () => {
        const role = '<%= "Admin".equals(request.getParameter("role")) ? "Admin" : "User" %>';
        const formContainer = document.getElementById('formContainer');
        const formTitle = document.getElementById('formTitle');
        const loginButton = document.getElementById('loginButton');

        if (role === 'Admin') {
            formContainer.classList.add('admin-theme');
            formTitle.textContent = 'Admin Login';
            loginButton.textContent = 'Login as Admin';
            loginButton.classList.add('text-blue-600');
        } else {
            formContainer.classList.add('user-theme');
            formTitle.textContent = 'User Login';
            loginButton.textContent = 'Login as User';
            loginButton.classList.add('text-green-600');
        }
    });
</script>
</body>
</html>