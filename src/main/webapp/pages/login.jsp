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
        body {
            background: linear-gradient(to bottom, #e0f2fe, #bae6fd);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }
        .admin-theme, .user-theme {
            background: linear-gradient(135deg, #3b82f6, #93c5fd);
        }
        .form-container {
            transition: all 0.5s ease;
            border-radius: 1.25rem;
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
            animation: revealForm 0.6s ease-out;
            max-width: 450px;
        }
        @keyframes revealForm {
            from { opacity: 0; transform: scale(0.95) translateY(30px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        .form-input {
            transition: all 0.3s ease;
            border: 2px solid #dbeafe;
            background: #ffffff;
            border-radius: 0.5rem;
            padding: 0.875rem 2.75rem 0.875rem 0.875rem;
            width: 100%;
            color: #1e293b;
        }
        .form-input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2);
            transform: scale(1.02);
            outline: none;
        }
        .input-icon {
            transition: all 0.3s ease;
        }
        .form-input:focus + .input-icon {
            color: #3b82f6;
        }
        .btn-primary {
            transition: all 0.3s ease;
            background: #2563eb;
            color: white;
            border-radius: 0.5rem;
            font-weight: 600;
            padding: 0.875rem;
            width: 100%;
            position: relative;
            overflow: hidden;
        }
        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.25);
        }
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.5s ease, height 0.5s ease;
        }
        .btn-primary:hover::before {
            width: 250px;
            height: 250px;
        }
        .btn-primary:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }
        .spinner {
            display: none;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-top: 3px solid white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
        }
        @keyframes spin {
            0% { transform: translateY(-50%) rotate(0deg); }
            100% { transform: translateY(-50%) rotate(360deg); }
        }
        .error-message {
            background: rgba(239, 68, 68, 0.95);
            color: white;
            padding: 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            text-align: center;
            animation: slideIn 0.4s ease-out;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .link {
            color: #bfdbfe;
            transition: all 0.3s ease;
        }
        .link:hover {
            color: #eff6ff;
            transform: translateX(3px);
        }
        .toggle-password {
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        .toggle-password:hover {
            transform: scale(1.2);
        }
        @media (max-width: 640px) {
            .form-container {
                margin: 1.5rem;
                padding: 1.75rem;
            }
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen bg-gray-100">
<div id="formContainer" class="form-container w-full max-w-md p-8 rounded-lg shadow-lg text-white <%= "Admin".equals(request.getParameter("role")) ? "admin-theme" : "user-theme" %>">
    <div class="text-center mb-6">
        <a href="${pageContext.request.contextPath}/pages/index.jsp" class="text-4xl font-extrabold tracking-tight">MediCare</a>
    </div>
    <h2 id="formTitle" class="text-2xl font-bold mb-6 text-center"><%= "Admin".equals(request.getParameter("role")) ? "Admin Login" : "User Login" %></h2>
    <%-- Display error message if present --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message mb-4"><%= request.getAttribute("errorMessage") %></div>
    <% } %>
    <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST" aria-label="<%= "Admin".equals(request.getParameter("role")) ? "Admin Login Form" : "User Login Form" %>">
        <input type="hidden" name="role" value="<%= "Admin".equals(request.getParameter("role")) ? "Admin" : "User" %>">
        <div class="mb-4">
            <label for="username" class="block mb-2 text-sm font-medium">Username</label>
            <div class="relative">
                <input type="text" id="username" name="username" class="form-input" placeholder="Enter your username" required aria-required="true">
                <i class="fas fa-user input-icon absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600"></i>
            </div>
        </div>
        <div class="mb-6">
            <label for="password" class="block mb-2 text-sm font-medium">Password</label>
            <div class="relative">
                <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required aria-required="true">
                <i class="fas fa-eye input-icon toggle-password absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600" id="togglePassword" aria-label="Toggle password visibility"></i>
            </div>
        </div>
        <button type="submit" id="loginButton" class="btn-primary relative">
            <span id="buttonText"><%= "Admin".equals(request.getParameter("role")) ? "Login as Admin" : "Login as User" %></span>
            <span id="spinner" class="spinner"></span>
        </button>
    </form>
    <div class="mt-4 text-center text-sm">
        <p>Don't have an account? <a href="${pageContext.request.contextPath}/pages/register.jsp" class="link underline">Sign Up</a></p>
        <p><a href="${pageContext.request.contextPath}/pages/index.jsp" class="link underline">Back to Home</a></p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const role = '<%= "Admin".equals(request.getParameter("role")) ? "Admin" : "User" %>';
        const formContainer = document.getElementById('formContainer');
        const formTitle = document.getElementById('formTitle');
        const loginButton = document.getElementById('loginButton');

        if (role === 'Admin') {
            formContainer.classList.add('admin-theme');
            formTitle.textContent = 'Admin Login';
            loginButton.querySelector('#buttonText').textContent = 'Login as Admin';
        } else {
            formContainer.classList.add('user-theme');
            formTitle.textContent = 'User Login';
            loginButton.querySelector('#buttonText').textContent = 'Login as User';
        }

        // Password visibility toggle
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');
        togglePassword.addEventListener('click', () => {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            togglePassword.classList.toggle('fa-eye');
            togglePassword.classList.toggle('fa-eye-slash');
        });

        // Loading spinner on form submit
        const form = document.getElementById('loginForm');
        form.addEventListener('submit', () => {
            loginButton.disabled = true;
            loginButton.querySelector('#buttonText').style.opacity = '0';
            loginButton.querySelector('#spinner').style.display = 'inline-block';
        });
    });
</script>
</body>
</html>