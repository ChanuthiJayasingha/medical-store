<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="MediCare Login - Secure access for Admin and User accounts to manage your medical store needs.">
    <meta name="keywords" content="MediCare, login, online pharmacy, medical store, admin, user">
    <title>MediCare - Secure Login</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">

</head>
<body class="<%= "Admin".equals(request.getParameter("role")) ? "admin-theme" : "user-theme" %>">
<div id="formContainer" class="form-container">
    <a href="${pageContext.request.contextPath}/pages/index.jsp" class="logo">MediCare</a>
    <h2 id="formTitle"><%= "Admin".equals(request.getParameter("role")) ? "Admin Login" : "User Login" %></h2>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
    <% } %>
    <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST">
        <input type="hidden" name="role" value="<%= "Admin".equals(request.getParameter("role")) ? "Admin" : "User" %>">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>
            <i class="ri-user-line"></i>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
            <i class="ri-lock-line toggle-password"></i>
        </div>
        <button type="submit" id="loginButton" class="submit-btn"><%= "Admin".equals(request.getParameter("role")) ? "Login as Admin" : "Login as User" %></button>
    </form>
    <div class="links">
        <p>Don't have an account? <a href="${pageContext.request.contextPath}/pages/register.jsp">Sign Up</a></p>
        <p><a href="${pageContext.request.contextPath}/pages/index.jsp">Back to Home</a></p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Set initial theme based on role
        const role = '<%= "Admin".equals(request.getParameter("role")) ? "Admin" : "User" %>';
        const formContainer = document.getElementById('formContainer');
        const formTitle = document.getElementById('formTitle');
        const loginButton = document.getElementById('loginButton');
        const body = document.body;

        if (role === 'Admin') {
            body.classList.add('admin-theme');
            formContainer.classList.add('admin-theme');
            formTitle.textContent = 'Admin Login';
            loginButton.textContent = 'Login as Admin';
        } else {
            body.classList.add('user-theme');
            formContainer.classList.add('user-theme');
            formTitle.textContent = 'User Login';
            loginButton.textContent = 'Login as User';
        }

        // Password visibility toggle
        const passwordInput = document.getElementById('password');
        const togglePassword = document.querySelector('.toggle-password');

        togglePassword.addEventListener('click', () => {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            togglePassword.classList.toggle('ri-eye-line');
            togglePassword.classList.toggle('ri-eye-off-line');
        });

        // Loading state for form submission
        const form = document.getElementById('loginForm');
        form.addEventListener('submit', () => {
            loginButton.classList.add('loading');
            loginButton.disabled = true;
        });
    });
</script>
</body>
</html>