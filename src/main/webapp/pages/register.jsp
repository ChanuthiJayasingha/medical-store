<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Register</title>
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
        .register-theme {
            background: linear-gradient(135deg, #3b82f6, #93c5fd);
        }
        .form-container {
            transition: all 0.5s ease;
            border-radius: 1.5rem;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.25);
            animation: revealForm 0.7s ease-out;
            max-width: 600px;
            position: relative;
            overflow: hidden;
        }
        @keyframes revealForm {
            from { opacity: 0; transform: scale(0.9) translateY(40px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        .form-field {
            opacity: 0;
            transform: translateY(20px);
            animation: slideField 0.5s ease-out forwards;
        }
        .form-field:nth-child(1) { animation-delay: 0.1s; }
        .form-field:nth-child(2) { animation-delay: 0.2s; }
        .form-field:nth-child(3) { animation-delay: 0.3s; }
        .form-field:nth-child(4) { animation-delay: 0.4s; }
        .form-field:nth-child(5) { animation-delay: 0.5s; }
        .form-field:nth-child(6) { animation-delay: 0.6s; }
        .form-field:nth-child(7) { animation-delay: 0.7s; }
        .form-field:nth-child(8) { animation-delay: 0.8s; }
        @keyframes slideField {
            to { opacity: 1; transform: translateY(0); }
        }
        .form-input, .form-textarea, .form-select {
            transition: all 0.3s ease;
            border: 2px solid #dbeafe;
            background: #ffffff;
            border-radius: 0.5rem;
            padding: 0.875rem 2.75rem 0.875rem 0.875rem;
            width: 100%;
            color: #1e293b;
        }
        .form-textarea {
            padding: 0.875rem;
            resize: vertical;
            min-height: 120px;
        }
        .form-input:focus, .form-textarea:focus, .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.25);
            transform: scale(1.03);
            outline: none;
        }
        .input-icon {
            transition: all 0.3s ease;
        }
        .form-input:focus + .input-icon, .form-textarea:focus + .input-icon, .form-select:focus + .input-icon {
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
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
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
            width: 300px;
            height: 300px;
        }
        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        .spinner {
            display: none;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top: 4px solid white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            animation: spin 0.8s linear infinite;
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
            padding: 1rem;
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
            transform: translateX(4px);
        }
        .toggle-password {
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        .toggle-password:hover {
            transform: scale(1.3);
        }
        .password-strength {
            height: 6px;
            border-radius: 3px;
            margin-top: 0.5rem;
            transition: all 0.3s ease;
        }
        .strength-weak { background: #ef4444; width: 33%; }
        .strength-medium { background: #f59e0b; width: 66%; }
        .strength-strong { background: #22c55e; width: 100%; }
        .strength-text {
            font-size: 0.75rem;
            color: #e2e8f0;
            margin-top: 0.25rem;
        }
        .invalid-field {
            border-color: #ef4444;
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.2);
        }
        @media (max-width: 640px) {
            .form-container {
                margin: 1.5rem;
                padding: 1.75rem;
                max-width: 100%;
            }
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen bg-gray-100">
<div class="form-container w-full max-w-lg p-8 rounded-lg shadow-lg text-white register-theme">
    <div class="text-center mb-6">
        <a href="${pageContext.request.contextPath}/pages/index.jsp" class="text-4xl font-extrabold tracking-tight">MediCare</a>
    </div>
    <h2 class="text-2xl font-bold mb-6 text-center">Register</h2>
    <%-- Display error message if present --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message mb-4"><%= request.getAttribute("errorMessage") %></div>
    <% } %>
    <form id="registerForm" action="${pageContext.request.contextPath}/register" method="POST" aria-label="User Registration Form">
        <input type="hidden" name="role" value="User">
        <div class="mb-4 form-field">
            <label for="fullName" class="block mb-2 text-sm font-medium">Full Name</label>
            <div class="relative">
                <input type="text" id="fullName" name="fullName" class="form-input" placeholder="Enter your full name" required aria-required="true">
                <i class="fas fa-user input-icon absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600"></i>
            </div>
        </div>
        <div class="mb-4 form-field">
            <label for="username" class="block mb-2 text-sm font-medium">Username</label>
            <div class="relative">
                <input type="text" id="username" name="username" class="form-input" placeholder="Enter your username" required aria-required="true">
                <i class="fas fa-user input-icon absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600"></i>
            </div>
        </div>
        <div class="mb-4 form-field">
            <label for="password" class="block mb-2 text-sm font-medium">Password</label>
            <div class="relative">
                <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required aria-required="true">
                <i class="fas fa-eye input-icon toggle-password absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600" id="togglePassword" aria-label="Toggle password visibility"></i>
            </div>
            <div id="passwordStrength" class="password-strength"></div>
            <div id="strengthText" class="strength-text"></div>
        </div>
        <div class="mb-4 form-field">
            <label for="contactNo" class="block mb-2 text-sm font-medium">Contact Number</label>
            <div class="relative">
                <input type="text" id="contactNo" name="contactNo" class="form-input" placeholder="Enter 10-digit number" required aria-required="true">
                <i class="fas fa-phone input-icon absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600"></i>
            </div>
        </div>
        <div class="mb-4 form-field">
            <label for="email" class="block mb-2 text-sm font-medium">Email</label>
            <div class="relative">
                <input type="email" id="email" name="email" class="form-input" placeholder="Enter your email" required aria-required="true">
                <i class="fas fa-envelope input-icon absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600"></i>
            </div>
        </div>
        <div class="mb-4 form-field">
            <label for="address" class="block mb-2 text-sm font-medium">Address</label>
            <div class="relative">
                <textarea id="address" name="address" class="form-textarea" placeholder="Enter your address" required aria-required="true"></textarea>
            </div>
        </div>
        <div class="mb-4 form-field">
            <label for="birthday" class="block mb-2 text-sm font-medium">Birthday</label>
            <div class="relative">
                <input type="date" id="birthday" name="birthday" class="form-input" required aria-required="true">
                <i class="fas fa-calendar-alt input-icon absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600"></i>
            </div>
        </div>
        <div class="mb-6 form-field">
            <label for="gender" class="block mb-2 text-sm font-medium">Gender</label>
            <div class="relative">
                <select id="gender" name="gender" class="form-select" required aria-required="true">
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
                <i class="fas fa-venus-mars input-icon absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-600"></i>
            </div>
        </div>
        <button type="submit" id="registerButton" class="btn-primary relative">
            <span id="buttonText">Register</span>
            <span id="spinner" class="spinner"></span>
        </button>
    </form>
    <div class="mt-4 text-center text-sm">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/pages/login.jsp?role=User" class="link underline">Login</a></p>
        <p><a href="${pageContext.request.contextPath}/pages/index.jsp" class="link underline">Back to Home</a></p>
    </div>
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

        // Password strength indicator
        const passwordStrength = document.getElementById('passwordStrength');
        const strengthText = document.getElementById('strengthText');
        passwordInput.addEventListener('input', () => {
            const value = passwordInput.value;
            let strength = 'weak';
            if (value.length >= 8 && /[A-Z]/.test(value) && /[0-9]/.test(value)) {
                strength = 'strong';
            } else if (value.length >= 6) {
                strength = 'medium';
            }
            passwordStrength.className = `password-strength strength-${strength}`;
            strengthText.textContent = `Password Strength: ${strength.charAt(0).toUpperCase() + strength.slice(1)}`;
        });

        // Input validation feedback
        const inputs = document.querySelectorAll('.form-input, .form-textarea, .form-select');
        inputs.forEach(input => {
            input.addEventListener('input', () => {
                if (input.checkValidity()) {
                    input.classList.remove('invalid-field');
                } else {
                    input.classList.add('invalid-field');
                }
            });
        });

        // Loading spinner on form submit
        const form = document.getElementById('registerForm');
        const registerButton = document.getElementById('registerButton');
        form.addEventListener('submit', () => {
            if (form.checkValidity()) {
                registerButton.disabled = true;
                registerButton.querySelector('#buttonText').style.opacity = '0';
                registerButton.querySelector('#spinner').style.display = 'inline-block';
            }
        });
    });
</script>
</body>
</html>