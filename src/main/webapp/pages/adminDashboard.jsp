<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .sidebar {
            width: 250px;
            transition: all 0.3s;
        }
        .main-content {
            margin-left: 250px;
            transition: all 0.3s;
        }
        .sidebar.collapsed {
            width: 70px;
        }
        .main-content.expanded {
            margin-left: 70px;
        }
    </style>
</head>
<body class="bg-gray-100">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <div class="sidebar bg-white shadow-lg">
            <div class="p-4">
                <h1 class="text-2xl font-bold text-blue-600">MediCare</h1>
                <p class="text-gray-500 text-sm">Admin Panel</p>
            </div>
            <nav class="mt-4">
                <a href="${pageContext.request.contextPath}/user-management/list" class="flex items-center px-4 py-3 text-gray-700 bg-gray-100 border-l-4 border-blue-500">
                    <i class="fas fa-users mr-3"></i>
                    <span>User Management</span>
                </a>
                <a href="#" class="flex items-center px-4 py-3 text-gray-600 hover:bg-gray-100">
                    <i class="fas fa-pills mr-3"></i>
                    <span>Products</span>
                </a>
                <a href="#" class="flex items-center px-4 py-3 text-gray-600 hover:bg-gray-100">
                    <i class="fas fa-shopping-cart mr-3"></i>
                    <span>Orders</span>
                </a>
                <a href="#" class="flex items-center px-4 py-3 text-gray-600 hover:bg-gray-100">
                    <i class="fas fa-chart-bar mr-3"></i>
                    <span>Analytics</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-4 py-3 text-gray-600 hover:bg-gray-100">
                    <i class="fas fa-sign-out-alt mr-3"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content flex-1 p-8">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold text-gray-800">User Management</h2>
                <button onclick="showAddUserModal()" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
                    <i class="fas fa-plus mr-2"></i>Add New User
                </button>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline">${error}</span>
                </div>
            </c:if>

            <!-- User List -->
            <div class="bg-white rounded-lg shadow-md">
                <div class="p-4">
                    <div class="flex justify-between items-center mb-4">
                        <div class="flex space-x-4">
                            <input type="text" id="searchInput" placeholder="Search users..." class="px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400">
                            <select id="roleFilter" class="px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400">
                                <option value="all">All Roles</option>
                                <option value="admin">Admin</option>
                                <option value="user">User</option>
                            </select>
                        </div>
                    </div>
                    <table class="w-full">
                        <thead>
                            <tr class="text-left border-b">
                                <th class="pb-3">Username</th>
                                <th class="pb-3">Role</th>
                                <th class="pb-3">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${users}" var="user">
                                <tr class="border-b">
                                    <td class="py-3">${user.username}</td>
                                    <td>${user.role}</td>
                                    <td>
                                        <button onclick="showEditUserModal('${user.username}', '${user.role}')" class="text-blue-600 hover:text-blue-800 mr-2">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button onclick="showDeleteUserModal('${user.username}')" class="text-red-600 hover:text-red-800">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div id="addUserModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3">
                <h3 class="text-lg font-medium text-gray-900 mb-4">Add New User</h3>
                <form action="${pageContext.request.contextPath}/user-management/add" method="POST">
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="username">
                            Username
                        </label>
                        <input type="text" id="username" name="username" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="password">
                            Password
                        </label>
                        <input type="password" id="password" name="password" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="role">
                            Role
                        </label>
                        <select id="role" name="role" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
                            <option value="user">User</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="hideAddUserModal()" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-400">
                            Cancel
                        </button>
                        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
                            Add User
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3">
                <h3 class="text-lg font-medium text-gray-900 mb-4">Edit User</h3>
                <form action="${pageContext.request.contextPath}/user-management/update" method="POST">
                    <input type="hidden" id="editUsername" name="username">
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="editPassword">
                            New Password
                        </label>
                        <input type="password" id="editPassword" name="password" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="editRole">
                            Role
                        </label>
                        <select id="editRole" name="role" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
                            <option value="user">User</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="hideEditUserModal()" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-400">
                            Cancel
                        </button>
                        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
                            Update User
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete User Modal -->
    <div id="deleteUserModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3">
                <h3 class="text-lg font-medium text-gray-900 mb-4">Delete User</h3>
                <p class="text-gray-600 mb-4">Are you sure you want to delete this user?</p>
                <form action="${pageContext.request.contextPath}/user-management/delete" method="POST">
                    <input type="hidden" id="deleteUsername" name="username">
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="hideDeleteUserModal()" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-400">
                            Cancel
                        </button>
                        <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700">
                            Delete User
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Modal functions
        function showAddUserModal() {
            document.getElementById('addUserModal').classList.remove('hidden');
        }

        function hideAddUserModal() {
            document.getElementById('addUserModal').classList.add('hidden');
        }

        function showEditUserModal(username, role) {
            document.getElementById('editUsername').value = username;
            document.getElementById('editRole').value = role;
            document.getElementById('editUserModal').classList.remove('hidden');
        }

        function hideEditUserModal() {
            document.getElementById('editUserModal').classList.add('hidden');
        }

        function showDeleteUserModal(username) {
            document.getElementById('deleteUsername').value = username;
            document.getElementById('deleteUserModal').classList.remove('hidden');
        }

        function hideDeleteUserModal() {
            document.getElementById('deleteUserModal').classList.add('hidden');
        }

        // Search and filter functionality
        document.getElementById('searchInput').addEventListener('input', filterUsers);
        document.getElementById('roleFilter').addEventListener('change', filterUsers);

        function filterUsers() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const roleFilter = document.getElementById('roleFilter').value;
            const rows = document.querySelectorAll('tbody tr');

            rows.forEach(row => {
                const username = row.cells[0].textContent.toLowerCase();
                const role = row.cells[1].textContent.toLowerCase();
                const matchesSearch = username.includes(searchText);
                const matchesRole = roleFilter === 'all' || role === roleFilter;
                row.style.display = matchesSearch && matchesRole ? '' : 'none';
            });
        }
    </script>
</body>
</html>