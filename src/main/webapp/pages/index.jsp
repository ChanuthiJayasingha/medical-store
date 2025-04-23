<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Online Medical Store</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* Custom Styles */
        .hero-bg {
            background: linear-gradient(to right, #3b82f6, #10b981);
        }
        .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }
        .cart-count {
            top: -10px;
            right: -10px;
        }
    </style>
</head>
<body class="bg-gray-100 font-sans">
<!-- Navbar -->
<nav class="bg-white shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <a href="index.jsp" class="text-2xl font-bold text-blue-600">MediCare</a>
            </div>
            <div class="flex items-center space-x-4">
                <div class="relative">
                    <input type="text" placeholder="Search medicines..."
                           class="w-64 px-4 py-2 rounded-full border focus:outline-none focus:ring-2 focus:ring-blue-400">
                    <i class="fas fa-search absolute right-3 top-3 text-gray-400"></i>
                </div>
                <a href="cart.jsp" class="relative">
                    <i class="fas fa-shopping-cart text-gray-600 text-xl"></i>
                    <span class="absolute cart-count bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">0</span>
                </a>
                <button onclick="document.getElementById('loginModal').classList.remove('hidden')" class="text-gray-600 hover:text-blue-600">Login</button>
                <a href="signup.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700">Sign Up</a>
            </div>
        </div>
    </div>
</nav>

<!-- Login Modal -->
<div id="loginModal" class="hidden fixed inset-0 bg-gray-800 bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
        <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center">Login</h2>
        <form action="LoginServlet" method="POST">
            <div class="mb-4">
                <label for="username" class="block text-gray-600 mb-2">Username</label>
                <input type="text" id="username" name="username" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400" required>
            </div>
            <div class="mb-4">
                <label for="password" class="block text-gray-600 mb-2">Password</label>
                <input type="password" id="password" name="password" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400" required>
            </div>
            <div class="mb-6">
                <label for="role" class="block text-gray-600 mb-2">Role</label>
                <select id="role" name="role" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400" required>
                    <option value="User">User</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>
            <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700">Login</button>
        </form>
        <button onclick="document.getElementById('loginModal').classList.add('hidden')" class="mt-4 w-full text-gray-600 hover:text-blue-600">Close</button>
    </div>
</div>

<!-- Hero Section -->
<section class="hero-bg text-white py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center">
        <div class="w-1/2">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">Your Trusted Online Pharmacy</h1>
            <p class="text-lg mb-6">Order medicines, health products, and wellness essentials with ease and get them delivered to your doorstep.</p>
            <a href="#shop" class="bg-white text-blue-600 px-6 py-3 rounded-full font-semibold hover:bg-gray-100">Shop Now</a>
        </div>
        <div class="w-1/2">
            <img src="https://via.placeholder.com/500" alt="Medicines" class="rounded-lg shadow-lg">
        </div>
    </div>
</section>

<!-- Categories Section -->
<section id="categories" class="py-16 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold text-gray-800 mb-8 text-center">Shop by Category</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <a href="category.jsp?cat=medicines" class="card-hover bg-gray-50 p-6 rounded-lg text-center transition duration-300">
                <i class="fas fa-pills text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-800">Medicines</h3>
                <p class="text-gray-600">Prescription & OTC Drugs</p>
            </a>
            <a href="category.jsp?cat=wellness" class="card-hover bg-gray-50 p-6 rounded-lg text-center transition duration-300">
                <i class="fas fa-heartbeat text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-800">Wellness</h3>
                <p class="text-gray-600">Vitamins & Supplements</p>
            </a>
            <a href="category.jsp?cat=devices" class="card-hover bg-gray-50 p-6 rounded-lg text-center transition duration-300">
                <i class="fas fa-stethoscope text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-800">Devices</h3>
                <p class="text-gray-600">Health Monitoring Devices</p>
            </a>
            <a href="category.jsp?cat=personalcare" class="card-hover bg-gray-50 p-6 rounded-lg text-center transition duration-300">
                <i class="fas fa-spa text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-800">Personal Care</h3>
                <p class="text-gray-600">Skincare & Hygiene</p>
            </a>
        </div>
    </div>
</section>

<!-- Featured Products Section -->
<section id="shop" class="py-16 bg-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold text-gray-800 mb-8 text-center">Featured Products</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="card-hover bg-white p-6 rounded-lg shadow-md transition duration-300">
                <img src="https://via.placeholder.com/200" alt="Product" class="w-full h-40 object-cover rounded-lg mb-4">
                <h3 class="text-lg font-semibold text-gray-800">Paracetamol 500mg</h3>
                <p class="text-gray-600">$5.99</p>
                <button class="mt-4 w-full bg-blue-600 text-white py-2 rounded-full hover:bg-blue-700">Add to Cart</button>
            </div>
            <div class="card-hover bg-white p-6 rounded-lg shadow-md transition duration-300">
                <img src="https://via.placeholder.com/200" alt="Product" class="w-full h-40 object-cover rounded-lg mb-4">
                <h3 class="text-lg font-semibold text-gray-800">Vitamin C 1000mg</h3>
                <p class="text-gray-600">$12.99</p>
                <button class="mt-4 w-full bg-blue-600 text-white py-2 rounded-full hover:bg-blue-700">Add to Cart</button>
            </div>
            <div class="card-hover bg-white p-6 rounded-lg shadow-md transition duration-300">
                <img src="https://via.placeholder.com/200" alt="Product" class="w-full h-40 object-cover rounded-lg mb-4">
                <h3 class="text-lg font-semibold text-gray-800">Blood Pressure Monitor</h3>
                <p class="text-gray-600">$49.99</p>
                <button class="mt-4 w-full bg-blue-600 text-white py-2 rounded-full hover:bg-blue-700">Add to Cart</button>
            </div>
            <div class="card-hover bg-white p-6 rounded-lg shadow-md transition duration-300">
                <img src="https://via.placeholder.com/200" alt="Product" class="w-full h-40 object-cover rounded-lg mb-4">
                <h3 class="text-lg font-semibold text-gray-800">Face Wash</h3>
                <p class="text-gray-600">$9.99</p>
                <button class="mt-4 w-full bg-blue-600 text-white py-2 rounded-full hover:bg-blue-700">Add to Cart</button>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-gray-800 text-white py-10">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
                <h3 class="text-lg font-semibold mb-4">MediCare</h3>
                <p class="text-gray-400">Your one-stop online pharmacy for all your healthcare needs.</p>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Quick Links</h3>
                <ul class="space-y-2">
                    <li><a href="about.jsp" class="text-gray-400 hover:text-white">About Us</a></li>
                    <li><a href="contact.jsp" class="text-gray-400 hover:text-white">Contact Us</a></li>
                    <li><a href="faq.jsp" class="text-gray-400 hover:text-white">FAQ</a></li>
                </ul>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Customer Service</h3>
                <ul class="space-y-2">
                    <li><a href="returns.jsp" class="text-gray-400 hover:text-white">Returns</a></li>
                    <li><a href="shipping.jsp" class="text-gray-400 hover:text-white">Shipping</a></li>
                    <li><a href="terms.jsp" class="text-gray-400 hover:text-white">Terms & Conditions</a></li>
                </ul>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Connect With Us</h3>
                <div class="flex space-x-4">
                    <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <div class="mt-8 border-t border-gray-700 pt-4 text-center">
            <p class="text-gray-400">© 2025 MediCare. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- JavaScript for Interactivity -->
<script>
    // Add to Cart Functionality (Placeholder)
    document.querySelectorAll('.bg-blue-600').forEach(button => {
        button.addEventListener('click', () => {
            let cartCount = document.querySelector('.cart-count');
            cartCount.textContent = parseInt(cartCount.textContent) + 1;
            alert('Item added to cart!');
        });
    });
</script>
</body>
</html>