<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - My Account</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
<div class="min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white shadow sticky top-0 z-40">
        <div class="max-w-7xl mx-auto px-4 py-4 flex items-center justify-between">
            <a href="#" class="text-2xl font-bold text-blue-600 flex items-center gap-2">
                <i class="fas fa-heartbeat"></i> MediCare
            </a>
            <nav class="flex gap-6 text-gray-700">
                <a href="#" class="hover:text-blue-600 flex items-center gap-1"><i class="fas fa-home"></i> Home</a>
                <a href="#" class="hover:text-blue-600 flex items-center gap-1"><i class="fas fa-pills"></i> Shop</a>
                <a href="#" class="hover:text-blue-600 flex items-center gap-1"><i class="fas fa-prescription-bottle-alt"></i> Prescriptions</a>
                <a href="#" class="hover:text-blue-600 flex items-center gap-1"><i class="fas fa-question-circle"></i> Help</a>
                <a href="${pageContext.request.contextPath}/logout" class="hover:text-blue-600 flex items-center gap-1"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </nav>
            <div class="flex items-center gap-4">
                <div class="relative">
                    <input type="text" placeholder="Search medicines..." class="w-48 px-4 py-2 rounded-full border focus:outline-none focus:ring-2 focus:ring-blue-400">
                    <i class="fas fa-search absolute right-3 top-3 text-gray-400"></i>
                </div>
                <a href="#" class="relative">
                    <i class="fas fa-shopping-cart text-gray-600 text-xl"></i>
                    <span class="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">3</span>
                </a>
                <div class="flex items-center gap-2">
                    <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="User" class="w-8 h-8 rounded-full border-2 border-blue-600">
                    <span class="font-semibold text-gray-700">John Doe</span>
                </div>
            </div>
        </div>
    </header>

    <main class="flex-1 max-w-7xl mx-auto w-full px-4 py-8 flex flex-col lg:flex-row gap-8">
        <!-- Sidebar -->
        <aside class="w-full lg:w-1/4 bg-white rounded-xl shadow p-6 mb-8 lg:mb-0">
            <div class="flex flex-col items-center">
                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="User" class="w-20 h-20 rounded-full border-4 border-blue-500 mb-3">
                <h3 class="text-xl font-bold text-gray-800">John Doe</h3>
                <p class="text-gray-500 text-sm mb-4">Member since: Jan 2022</p>
            </div>
            <ul class="space-y-2 mt-6">
                <li><a href="#" class="flex items-center gap-2 px-4 py-2 rounded-lg hover:bg-blue-50 text-blue-600 font-semibold"><i class="fas fa-user"></i> My Profile</a></li>
                <li><a href="#" class="flex items-center gap-2 px-4 py-2 rounded-lg hover:bg-blue-50"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
                <li><a href="#" class="flex items-center gap-2 px-4 py-2 rounded-lg hover:bg-blue-50"><i class="fas fa-prescription-bottle-alt"></i> My Prescriptions</a></li>
                <li><a href="#" class="flex items-center gap-2 px-4 py-2 rounded-lg hover:bg-blue-50"><i class="fas fa-heart"></i> My Wishlist</a></li>
                <li><a href="#" class="flex items-center gap-2 px-4 py-2 rounded-lg hover:bg-blue-50"><i class="fas fa-map-marker-alt"></i> Address Book</a></li>
                <li><a href="#" class="flex items-center gap-2 px-4 py-2 rounded-lg hover:bg-blue-50"><i class="fas fa-bell"></i> Notifications</a></li>
                <li><a href="#" class="flex items-center gap-2 px-4 py-2 rounded-lg hover:bg-blue-50"><i class="fas fa-cog"></i> Settings</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2 px-4 py-2 rounded-lg hover:bg-red-50 text-red-600"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </aside>

        <!-- Main Dashboard Content -->
        <section class="flex-1 flex flex-col gap-8">
            <!-- Welcome Banner -->
            <div class="bg-gradient-to-r from-blue-500 to-green-400 text-white rounded-xl p-8 shadow flex flex-col md:flex-row md:items-center md:justify-between">
                <div>
                    <h1 class="text-3xl font-bold mb-2">Welcome back, John!</h1>
                    <p class="text-lg">Here's what's happening with your account today.</p>
                </div>
                <div class="flex gap-4 mt-4 md:mt-0">
                    <a href="#" class="bg-white text-blue-600 px-4 py-2 rounded-full font-semibold hover:bg-gray-100 transition">Shop Now</a>
                    <a href="#" class="bg-white text-green-600 px-4 py-2 rounded-full font-semibold hover:bg-gray-100 transition">Order History</a>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="bg-white rounded-xl shadow p-6 flex items-center gap-4">
                    <div class="bg-blue-100 text-blue-600 rounded-full p-3 text-2xl"><i class="fas fa-shopping-bag"></i></div>
                    <div>
                        <h3 class="text-2xl font-bold">5</h3>
                        <p class="text-gray-500">Active Orders</p>
                    </div>
                </div>
                <div class="bg-white rounded-xl shadow p-6 flex items-center gap-4">
                    <div class="bg-green-100 text-green-600 rounded-full p-3 text-2xl"><i class="fas fa-check-circle"></i></div>
                    <div>
                        <h3 class="text-2xl font-bold">12</h3>
                        <p class="text-gray-500">Completed Orders</p>
                    </div>
                </div>
                <div class="bg-white rounded-xl shadow p-6 flex items-center gap-4">
                    <div class="bg-pink-100 text-pink-600 rounded-full p-3 text-2xl"><i class="fas fa-heart"></i></div>
                    <div>
                        <h3 class="text-2xl font-bold">8</h3>
                        <p class="text-gray-500">Wishlist Items</p>
                    </div>
                </div>
                <div class="bg-white rounded-xl shadow p-6 flex items-center gap-4">
                    <div class="bg-yellow-100 text-yellow-600 rounded-full p-3 text-2xl"><i class="fas fa-prescription-bottle-alt"></i></div>
                    <div>
                        <h3 class="text-2xl font-bold">3</h3>
                        <p class="text-gray-500">Active Prescriptions</p>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="bg-white rounded-xl shadow p-6">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-xl font-bold text-gray-800">Recent Orders</h2>
                    <a href="#" class="text-blue-600 hover:underline">View All</a>
                </div>
                <div class="divide-y divide-gray-200">
                    <div class="flex items-center justify-between py-4">
                        <div>
                            <h4 class="font-semibold">Order #MED78945</h4>
                            <p class="text-gray-500 text-sm">Placed on May 10, 2023</p>
                            <span class="inline-flex items-center px-2 py-1 bg-blue-100 text-blue-600 rounded text-xs mt-1"><i class="fas fa-truck mr-1"></i> Shipped</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <img src="https://via.placeholder.com/40" class="rounded" alt="Product">
                            <img src="https://via.placeholder.com/40" class="rounded" alt="Product">
                            <span class="text-gray-400 text-xs">+2 more</span>
                        </div>
                        <div class="text-right">
                            <h4 class="font-bold">$87.50</h4>
                            <a href="#" class="text-blue-600 hover:underline text-sm">Track Order</a>
                        </div>
                    </div>
                    <div class="flex items-center justify-between py-4">
                        <div>
                            <h4 class="font-semibold">Order #MED78944</h4>
                            <p class="text-gray-500 text-sm">Placed on May 5, 2023</p>
                            <span class="inline-flex items-center px-2 py-1 bg-green-100 text-green-600 rounded text-xs mt-1"><i class="fas fa-check-circle mr-1"></i> Delivered</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <img src="https://via.placeholder.com/40" class="rounded" alt="Product">
                            <img src="https://via.placeholder.com/40" class="rounded" alt="Product">
                        </div>
                        <div class="text-right">
                            <h4 class="font-bold">$42.99</h4>
                            <a href="#" class="text-blue-600 hover:underline text-sm">Reorder</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Health Reminders -->
            <div class="bg-white rounded-xl shadow p-6">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-xl font-bold text-gray-800">Health Reminders</h2>
                    <a href="#" class="text-blue-600 hover:underline">Manage</a>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="flex items-center gap-4 bg-blue-50 rounded-lg p-4">
                        <div class="bg-blue-200 text-blue-700 rounded-full p-3 text-xl"><i class="fas fa-pills"></i></div>
                        <div>
                            <h4 class="font-semibold">Vitamin D3</h4>
                            <p class="text-gray-500 text-sm">Take 1 capsule daily with breakfast</p>
                            <div class="flex items-center gap-1 text-xs text-gray-400 mt-1"><i class="fas fa-clock"></i> 8:00 AM (Daily)</div>
                        </div>
                        <button class="ml-auto bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700">Taken</button>
                    </div>
                    <div class="flex items-center gap-4 bg-green-50 rounded-lg p-4">
                        <div class="bg-green-200 text-green-700 rounded-full p-3 text-xl"><i class="fas fa-prescription-bottle-alt"></i></div>
                        <div>
                            <h4 class="font-semibold">Amoxicillin</h4>
                            <p class="text-gray-500 text-sm">Take 1 tablet every 8 hours (3 times daily)</p>
                            <div class="flex items-center gap-1 text-xs text-gray-400 mt-1"><i class="fas fa-clock"></i> Next dose at 2:00 PM</div>
                        </div>
                        <button class="ml-auto bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700">Taken</button>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-8 mt-8">
        <div class="max-w-7xl mx-auto px-4 text-center">
            <p class="text-gray-400">© 2025 MediCare. All rights reserved.</p>
        </div>
    </footer>
</div>
</body>
</html>
