<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="MediCare Register - Create your account to shop medicines and wellness products securely.">
    <meta name="keywords" content="MediCare, register, online pharmacy, medical store, user account">
    <title>MediCare - Register</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <!-- Remix Icons CDN -->
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/container/remixicon.css" rel="stylesheet">
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1580281658626-ee379f5cce93?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') no-repeat center center fixed;
            background-size: cover;
        }

        .form-container {
            width: 100%;
            max-width: 480px;
            padding: 40px;
            border-radius: 20px;
            backdrop-filter: blur(12px);
            background: linear-gradient(to bottom, #047857, #6ee7b7);
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.25);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: #f3f4f6;
            transition: transform 0.4s ease, box-shadow 0.4s ease;
        }

        .form-container:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.35);
        }

        .logo {
            font-size: 2.25rem;
            font-weight: 700;
            color: #ffffff;
            text-decoration: none;
            display: block;
            text-align: center;
            margin-bottom: 28px;
            letter-spacing: 1px;
        }

        h2 {
            font-size: 1.75rem;
            font-weight: 600;
            text-align: center;
            margin-bottom: 28px;
            letter-spacing: 0.5px;
        }

        .error-message {
            background: linear-gradient(to right, #b91c1c, #ef4444);
            color: #ffffff;
            padding: 14px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            animation: slideIn 0.5s ease;
            font-size: 0.875rem;
        }

        .form-group {
            margin-bottom: 24px;
            position: relative;
        }

        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 10px;
            color: #f3f4f6;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 14px 48px 14px 16px;
            background: rgba(255, 255, 255, 0.95);
            color: #1f2937;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 500;
            transition: box-shadow 0.3s ease, transform 0.3s ease;
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .form-group select {
            appearance: none;
            cursor: pointer;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.4);
            transform: scale(1.03);
        }

        .form-group input:invalid:not(:placeholder-shown),
        .form-group input.invalid {
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.4);
        }

        .form-group i {
            position: absolute;
            right: 16px;
            top: 58%;
            transform: translateY(-50%);
            color: #4b5563;
            font-size: 1.5rem;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .form-group i:hover {
            color: #1f2937;
        }

        .form-group select + i {
            top: 50%;
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background: #ffffff;
            color: #047857;
            font-size: 1.1rem;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.3s ease, opacity 0.3s ease;
        }

        .submit-btn:hover {
            background: #e5e7eb;
            transform: translateY(-3px);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .submit-btn.loading {
            opacity: 0.7;
            cursor: not-allowed;
            position: relative;
        }

        .submit-btn.loading::after {
            content: '';
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 2px solid #4b5563;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
        }

        .links {
            margin-top: 20px;
            text-align: center;
        }

        .links p {
            margin-bottom: 10px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .links a {
            color: #f3f4f6;
            text-decoration: underline;
            transition: color 0.2s ease;
        }

        .links a:hover {
            color: #ffffff;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-12px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        @media (max-width: 640px) {
            .form-container {
                padding: 28px;
                max-width: 95%;
            }

            .logo {
                font-size: 2rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            .form-group input,
            .form-group textarea,
            .form-group select {
                padding: 12px 44px 12px 14px;
            }

            .submit-btn {
                padding: 12px;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
<div class="form-container">
    <a href="${pageContext.request.contextPath}/pages/index.jsp" class="logo">MediCare</a>
    <h2>Register</h2>
    <%-- Display error message if present --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
    <% } %>
    <form id="registerForm" action="${pageContext.request.contextPath}/register" method="POST">
        <input type="hidden" name="role" value="User">
        <div class="form-group">
            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" required>
            <i class="ri-user-line"></i>
        </div>
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>
            <i class="ri-user-line"></i>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required minlength="8">
            <i class="ri-lock-line toggle-password"></i>
        </div>
        <div class="form-group">
            <label for="contactNo">Contact Number</label>
            <input type="tel" id="contactNo" name="contactNo" required pattern="[0-9]{10}" placeholder="10-digit number">
            <i class="ri-phone-line"></i>
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
            <i class="ri-mail-line"></i>
        </div>
        <div class="form-group">
            <label for="address">Address</label>
            <textarea id="address" name="address" required></textarea>
            <i class="ri-home-line"></i>
        </div>
        <div class="form-group">
            <label for="birthday">Birthday</label>
            <input type="date" id="birthday" name="birthday" required>
            <i class="ri-cake-2-line"></i>
        </div>
        <div class="form-group">
            <label for="gender">Gender</label>
            <select id="gender" name="gender" required>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>
            <i class="ri-user-3-line"></i>
        </div>
        <button type="submit" class="submit-btn">Register</button>
    </form>
    <div class="links">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/pages/login.jsp?role=User">Login</a></p>
        <p><a href="${pageContext.request.contextPath}/pages/index.jsp">Back to Home</a></p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Password visibility toggle
        const passwordInput = document.getElementById('password');
        const togglePassword = document.querySelector('.toggle-password');

        togglePassword.addEventListener('click', () => {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            togglePassword.classList.toggle('ri-eye-line');
            togglePassword.classList.toggle('ri-eye-off-line');
        });

        // Form validation and loading state
        const form = document.getElementById('registerForm');
        const contactNoInput = document.getElementById('contactNo');
        const emailInput = document.getElementById('email');
        const submitBtn = form.querySelector('.submit-btn');

        form.addEventListener('submit', (e) => {
            let isValid = true;

            // Validate contact number (10 digits)
            if (!/^[0-9]{10}$/.test(contactNoInput.value)) {
                contactNoInput.classList.add('invalid');
                isValid = false;
            } else {
                contactNoInput.classList.remove('invalid');
            }

            // Validate email
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInput.value)) {
                emailInput.classList.add('invalid');
                isValid = false;
            } else {
                emailInput.classList.remove('invalid');
            }

            if (!isValid) {
                e.preventDefault();
                return;
            }

            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
        });

        // Real-time validation
        contactNoInput.addEventListener('input', () => {
            if (/^[0-9]{10}$/.test(contactNoInput.value)) {
                contactNoInput.classList.remove('invalid');
            }
        });

        emailInput.addEventListener('input', () => {
            if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInput.value)) {
                emailInput.classList.remove('invalid');
            }
        });
    });
</script>
</body>
</html>