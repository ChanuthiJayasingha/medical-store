<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Admin Dashboard</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        .admin-bg {
            background: linear-gradient(to right, #1e3a8a, #3b82f6);
        }
        .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body class="bg-gray-100 font-sans">
<!-- Navbar -->
<nav class="bg-white shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/pages/index.jsp" class="text-2xl font-bold text-blue-600">MediCare</a>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-gray-600">Welcome, <%= session.getAttribute("username") %></span>
                <a href="${pageContext.request.contextPath}/logout" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700">Logout</a>
            </div>
        </div>
    </div>
</nav>

<!-- Admin Dashboard -->
<section class="admin-bg text-white py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-4xl font-bold mb-8 text-center">Admin Dashboard</h1>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                <i class="fas fa-pills text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold mb-2">Manage Products</h3>
                <p class="text-gray-600 mb-4">Add, update, or remove products from the store.</p>
                <a href="${pageContext.request.contextPath}/manage-products.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700">Go to Products</a>
            </div>
            <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                <i class="fas fa-clipboard-list text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold mb-2">View Orders</h3>
                <p class="text-gray-600 mb-4">Check and manage customer orders.</p>
                <a href="${pageContext.request.contextPath}/view-orders.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700">Go to Orders</a>
            </div>
            <div class="card-hover bg-white text-gray-800 p-6 rounded-lg shadow-md transition duration-300">
                <i class="fas fa-users text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold mb-2">Manage Users</h3>
                <p class="text-gray-600 mb-4">View and manage user accounts.</p>
                <a href="${pageContext.request.contextPath}/manage-users.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700">Go to Users</a>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-gray-800 text-white py-10">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="mt-8 border-t border-gray-700 pt-4 text-center">
            <p class="text-gray-400">© 2025 MediCare. All rights reserved.</p>
        </div>
    </div>
</footer>
</body>
</html>