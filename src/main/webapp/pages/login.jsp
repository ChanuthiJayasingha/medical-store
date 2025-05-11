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
        :root {
            --admin-primary: #4C51BF;  /* Indigo */
            --admin-hover: #4338CA;
            --user-primary: #047857;   /* Emerald */
            --user-hover: #065F46;
            --bg-gradient: linear-gradient(to bottom, #F3F4F6, #E5E7EB);
        }

        body {
            background: var(--bg-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }

        .form-container {
            width: 100%;
            max-width: 420px;
            padding: 2.5rem;
            border-radius: 1rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            animation: fadeIn 0.6s ease-out;
            background: white;
        }

        .admin-theme .form-header {
            background: linear-gradient(135deg, var(--admin-primary), #7C3AED);
        }

        .user-theme .form-header {
            background: linear-gradient(135deg, var(--user-primary), #10B981);
        }

        .admin-theme .btn-primary {
            background: var(--admin-primary);
        }

        .admin-theme .btn-primary:hover {
            background: var(--admin-hover);
        }

        .user-theme .btn-primary {
            background: var(--user-primary);
        }

        .user-theme .btn-primary:hover {
            background: var(--user-hover);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-input {
            transition: all 0.3s ease;
            border: 2px solid #e2e8f0;
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 0.875rem 1rem;
            width: 100%;
            color: #1e293b;
        }

        .form-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
            outline: none;
            background: white;
        }

        .input-icon {
            color: #64748b;
        }

        .btn-primary {
            transition: all 0.3s ease;
            color: white;
            border-radius: 0.5rem;
            font-weight: 600;
            padding: 0.875rem;
            width: 100%;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .btn-primary:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none !important;
        }

        .spinner {
            display: none;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-top: 3px solid white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .error-message {
            background: #fee2e2;
            color: #b91c1c;
            padding: 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            margin-bottom: 1rem;
            border-left: 4px solid #b91c1c;
        }

        .toggle-password {
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .toggle-password:hover {
            transform: scale(1.1);
            color: var(--primary-color);
        }

        .form-header {
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: center;
            color: white;
        }

        .logo {
            font-weight: 800;
            font-size: 1.75rem;
            letter-spacing: -0.025em;
        }

        .form-title {
            font-weight: 700;
            font-size: 1.5rem;
            margin-top: 0.5rem;
        }

        .link {
            color: var(--primary-color);
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .admin-theme .link {
            color: var(--admin-primary);
        }

        .user-theme .link {
            color: var(--user-primary);
        }

        .link:hover {
            text-decoration: underline;
        }

        .admin-theme .link:hover {
            color: var(--admin-hover);
        }

        .user-theme .link:hover {
            color: var(--user-hover);
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 1.5rem;
                margin: 1rem;
            }

            .form-header {
                padding: 1rem;
                margin-bottom: 1.5rem;
            }
        }
    </style>
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