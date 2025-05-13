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
    <link rel="stylesheet" href="../Css/Login.css">
</head>
<body>
<div id="formContainer" class="form-container <%= "Admin".equals(request.getParameter("role")) ? "admin-theme" : "user-theme" %>">
    <div class="form-header">
        <div class="logo">MediCare</div>
        <div class="form-title"><%= "Admin".equals(request.getParameter("role")) ? "Admin Login" : "User Login" %></div>
    </div>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message" role="alert">
        <i class="fas fa-exclamation-circle mr-2"></i><%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST">
        <input type="hidden" name="role" value="<%= "Admin".equals(request.getParameter("role")) ? "Admin" : "User" %>">

        <div class="mb-4">
            <label for="username" class="block mb-2 text-sm font-medium text-gray-700">Username</label>
            <div class="relative">
                <input type="text" id="username" name="username" class="form-input pl-10" placeholder="Enter your username" required>
                <i class="fas fa-user input-icon absolute left-3 top-1/2 transform -translate-y-1/2"></i>
            </div>
        </div>

        <div class="mb-6">
            <label for="password" class="block mb-2 text-sm font-medium text-gray-700">Password</label>
            <div class="relative">
                <input type="password" id="password" name="password" class="form-input pl-10" placeholder="Enter your password" required>
                <i class="fas fa-lock input-icon absolute left-3 top-1/2 transform -translate-y-1/2"></i>
                <i class="fas fa-eye toggle-password absolute right-3 top-1/2 transform -translate-y-1/2" id="togglePassword"></i>
            </div>
        </div>

        <button type="submit" id="loginButton" class="btn-primary flex items-center justify-center gap-2">
            <span id="buttonText">Sign In</span>
            <span id="spinner" class="spinner"></span>
        </button>

        <div class="mt-4 text-center text-sm text-gray-600">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/pages/register.jsp" class="link">Register</a></p>
            <p class="mt-1">Forgot password? <a href="#" class="link">Reset</a></p>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Password visibility toggle
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');

        togglePassword.addEventListener('click', () => {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            togglePassword.classList.toggle('fa-eye');
            togglePassword.classList.toggle('fa-eye-slash');
        });

        // Form submission handler
        const form = document.getElementById('loginForm');
        const loginButton = document.getElementById('loginButton');
        const buttonText = document.getElementById('buttonText');
        const spinner = document.getElementById('spinner');

        form.addEventListener('submit', () => {
            loginButton.disabled = true;
            buttonText.textContent = 'Signing in...';
            spinner.style.display = 'inline-block';
        });

        // Focus first input field
        document.getElementById('username').focus();
    });
</script>
</body>
</html>