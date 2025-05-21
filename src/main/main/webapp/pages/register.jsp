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
        .register-theme {
            background: linear-gradient(to bottom, #10b981, #6ee7b7);
        }
        .form-container {
            transition: all 0.3s ease;
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen bg-gray-100">
<div class="form-container w-full max-w-lg p-8 rounded-lg shadow-lg text-white register-theme">
    <div class="text-center mb-6">
        <a href="${pageContext.request.contextPath}/pages/index.jsp" class="text-3xl font-bold">MediCare</a>
    </div>
    <h2 class="text-2xl font-bold mb-6 text-center">Register</h2>
    <%-- Display error message if present --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="bg-red-500 text-white p-3 rounded-lg mb-4 text-center">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>
    <form action="${pageContext.request.contextPath}/register" method="POST">
        <input type="hidden" name="role" value="User">
        <div class="mb-4">
            <label for="fullName" class="block mb-2">Full Name</label>
            <div class="relative">
                <input type="text" id="fullName" name="fullName" class="w-full px-4 py-2 bg-white text-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-white" required>
                <i class="fas fa-user absolute right-3 top-3 text-gray-400"></i>
            </div>
        </div>
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
        <div class="mb-4">
            <label for="contactNo" class="block mb-2">Contact Number</label>
            <div class="relative">
                <input type="text" id="contactNo" name="contactNo" class="w-full px-4 py-2 bg-white text-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-white" required placeholder="10-digit number">
                <i class="fas fa-phone absolute right-3 top-3 text-gray-400"></i>
            </div>
        </div>
        <div class="mb-4">
            <label for="email" class="block mb-2">Email</label>
            <div class="relative">
                <input type="email" id="email" name="email" class="w-full px-4 py-2 bg-white text-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-white" required>
                <i class="fas fa-envelope absolute right-3 top-3 text-gray-400"></i>
            </div>
        </div>
        <div class="mb-4">
            <label for="address" class="block mb-2">Address</label>
            <div class="relative">
                <textarea id="address" name="address" class="w-full px-4 py-2 bg-white text-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-white" required></textarea>
            </div>
        </div>
        <div class="mb-4">
            <label for="birthday" class="block mb-2">Birthday</label>
            <div class="relative">
                <input type="date" id="birthday" name="birthday" class="w-full px-4 py-2 bg-white text-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-white" required>
                <i class="fas fa-calendar-alt absolute right-3 top-3 text-gray-400"></i>
            </div>
        </div>
        <div class="mb-4">
            <label for="gender" class="block mb-2">Gender</label>
            <div class="relative">
                <select id="gender" name="gender" class="w-full px-4 py-2 bg-white text-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-white" required>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
                <i class="fas fa-venus-mars absolute right-3 top-3 text-gray-400"></i>
            </div>
        </div>
        <button type="submit" class="w-full bg-white text-green-600 py-2 rounded-lg font-semibold hover:bg-gray-100">Register</button>
    </form>
    <div class="mt-4 text-center">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/pages/login.jsp?role=User" class="underline hover:text-gray-200">Login</a></p>
        <p><a href="${pageContext.request.contextPath}/pages/index.jsp" class="underline hover:text-gray-200">Back to Home</a></p>
    </div>
</div>
</body>
</html>