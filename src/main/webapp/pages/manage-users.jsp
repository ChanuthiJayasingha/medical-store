<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MediCare - Manage Users</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Inter', sans-serif;
    }
    h1, h2, h3, h4, h5, h6 {
      font-family: 'Poppins', sans-serif;
    }
    .sidebar {
      transition: width 0.3s ease;
    }
    .sidebar-collapsed {
      width: 80px;
    }
    .sidebar-expanded {
      width: 250px;
    }
    .sidebar-link {
      display: flex;
      align-items: center;
      padding: 12px 16px;
      color: #4b5563;
      transition: background-color 0.2s, color 0.2s;
    }
    .sidebar-link:hover, .sidebar-link.active {
      background-color: #2563eb;
      color: white;
    }
    .sidebar-link i {
      margin-right: 12px;
      width: 20px;
      text-align: center;
    }
    .content {
      transition: margin-left 0.3s ease;
    }
    .table-hover tr:hover {
      background-color: #f1f5f9;
    }
    .modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.5);
      z-index: 1000;
    }
    .modal-content {
      background-color: white;
      margin: 10% auto;
      padding: 24px;
      border-radius: 12px;
      width: 90%;
      max-width: 600px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    }
    .notification {
      animation: fadeOut 5s forwards;
    }
    @keyframes fadeOut {
      0% { opacity: 1; }
      80% { opacity: 1; }
      100% { opacity: 0; display: none; }
    }
    input:invalid, select:invalid {
      border-color: #ef4444;
    }
    .tab {
      cursor: pointer;
      padding: 10px 20px;
      margin-right: 10px;
      border-radius: 8px;
      transition: background-color 0.3s;
    }
    .tab.active {
      background-color: #2563eb;
      color: white;
    }
    .tab-content {
      display: none;
    }
    .tab-content.active {
      display: block;
    }
  </style>
</head>
<body class="bg-gray-100">
<c:if test="${empty sessionScope.username}">
  <c:redirect url="${pageContext.request.contextPath}/pages/login.jsp"/>
</c:if>

<div class="flex min-h-screen">
  <aside id="sidebar" class="sidebar sidebar-expanded bg-white shadow-lg fixed top-0 left-0 h-full z-50">
    <div class="flex items-center justify-between h-16 px-4 border-b">
      <a href="${pageContext.request.contextPath}/pages/index.jsp" class="text-2xl font-bold text-blue-600">MediCare</a>
      <button id="toggleSidebar" class="text-gray-600 focus:outline-none">
        <i class="fas fa-bars text-xl"></i>
      </button>
    </div>
    <nav class="mt-6">
      <ul>
        <li>
          <a href="${pageContext.request.contextPath}/AdminServlet" class="sidebar-link">
            <i class="fas fa-tachometer-alt"></i>
            <span class="sidebar-text">Dashboard</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/ManageProductsServlet" class="sidebar-link">
            <i class="fas fa-pills"></i>
            <span class="sidebar-text">Manage Products</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/ManageOrdersServlet" class="sidebar-link">
            <i class="fas fa-clipboard-list"></i>
            <span class="sidebar-text">Manage Orders</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="sidebar-link active">
            <i class="fas fa-users"></i>
            <span class="sidebar-text">Manage Users</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/ManageFeedbackServlet" class="sidebar-link">
            <i class="fas fa-comment-dots"></i>
            <span class="sidebar-text">Manage Feedback</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/ManageAuditServlet" class="sidebar-link">
            <i class="fas fa-file-alt"></i>
            <span class="sidebar-text">Audit Logs</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/logout" class="sidebar-link">
            <i class="fas fa-sign-out-alt"></i>
            <span class="sidebar-text">Logout</span>
          </a>
        </li>
      </ul>
    </nav>
  </aside>

  <main class="flex-1 content ml-[250px] p-6">
    <nav class="bg-white shadow-lg rounded-lg p-4 mb-6">
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-semibold text-gray-800">Welcome, <c:out value="${sessionScope.username}"/></h2>
        <a href="${pageContext.request.contextPath}/logout" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Logout</a>
      </div>
    </nav>

    <section class="bg-white p-6 rounded-lg shadow-lg">
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-2xl font-bold text-gray-800">Manage Users</h1>
        <button onclick="openModal('addUserModal')" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Add User</button>
      </div>

      <c:if test="${not empty sessionScope.notification}">
        <div class="notification mb-4 p-4 rounded-lg <c:out value='${sessionScope.notificationType == "success" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}'/>">
          <c:out value="${sessionScope.notification}"/>
        </div>
        <c:remove var="notification" scope="session"/>
        <c:remove var="notificationType" scope="session"/>
      </c:if>

      <div class="flex mb-6">
        <div class="tab active" onclick="showTab('admins')">Admins</div>
        <div class="tab" onclick="showTab('users')">Users</div>
      </div>

      <div id="admins" class="tab-content active">
        <c:choose>
          <c:when test="${not empty userList}">
            <div class="overflow-x-auto">
              <table class="w-full table-auto border-collapse">
                <thead>
                <tr class="bg-gray-200">
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Username</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Full Name</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Role</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Email</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Contact No</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Birthday</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Gender</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Actions</th>
                </tr>
                </thead>
                <tbody class="table-hover">
                <c:forEach var="user" items="${userList}">
                  <c:if test="${user.role == 'Admin'}">
                    <tr>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.username}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.fullName}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.role}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.email}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.contactNo}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.gender}"/></td>
                      <td class="border px-4 py-3">
                        <button onclick="openEditModal('<c:out value="${user.username}"/>', '<c:out value="${user.fullName}"/>', '<c:out value="${user.role}"/>', '<c:out value="${user.email}"/>', '<c:out value="${user.contactNo}"/>', '<c:out value="${user.address}"/>', '<fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd"/>', '<c:out value="${user.gender}"/>')" class="text-blue-600 hover:text-blue-800 mr-2">
                          <i class="fas fa-edit"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/ManageUsersServlet?action=delete&username=<c:out value="${user.username}"/>&csrfToken=<c:out value="${sessionScope.csrfToken}"/>" class="text-red-600 hover:text-red-800" onclick="return confirm('Are you sure you want to delete this admin?')">
                          <i class="fas fa-trash"></i>
                        </a>
                      </td>
                    </tr>
                  </c:if>
                </c:forEach>
                </tbody>
              </table>
            </div>
          </c:when>
          <c:otherwise>
            <p class="text-gray-600 text-center py-4">No admins available.</p>
          </c:otherwise>
        </c:choose>
      </div>

      <div id="users" class="tab-content">
        <c:choose>
          <c:when test="${not empty userList}">
            <div class="overflow-x-auto">
              <table class="w-full table-auto border-collapse">
                <thead>
                <tr class="bg-gray-200">
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Username</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Full Name</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Role</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Email</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Contact No</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Birthday</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Gender</th>
                  <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Actions</th>
                </tr>
                </thead>
                <tbody class="table-hover">
                <c:forEach var="user" items="${userList}">
                  <c:if test="${user.role == 'Customer'}">
                    <tr>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.username}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.fullName}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.role}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.email}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.contactNo}"/></td>
                      <td class="border px-4 py-3 text-gray-600"><fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd"/></td>
                      <td class="border px-4 py-3 text-gray-600"><c:out value="${user.gender}"/></td>
                      <td class="border px-4 py-3">
                        <button onclick="openEditModal('<c:out value="${user.username}"/>', '<c:out value="${user.fullName}"/>', '<c:out value="${user.role}"/>', '<c:out value="${user.email}"/>', '<c:out value="${user.contactNo}"/>', '<c:out value="${user.address}"/>', '<fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd"/>', '<c:out value="${user.gender}"/>')" class="text-blue-600 hover:text-blue-800 mr-2">
                          <i class="fas fa-edit"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/ManageUsersServlet?action=delete&username=<c:out value="${user.username}"/>&csrfToken=<c:out value="${sessionScope.csrfToken}"/>" class="text-red-600 hover:text-red-800" onclick="return confirm('Are you sure you want to delete this user?')">
                          <i class="fas fa-trash"></i>
                        </a>
                      </td>
                    </tr>
                  </c:if>
                </c:forEach>
                </tbody>
              </table>
            </div>
          </c:when>
          <c:otherwise>
            <p class="text-gray-600 text-center py-4">No users available.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </section>

    <!-- Add User Modal -->
    <div id="addUserModal" class="modal">
      <div class="modal-content">
        <h2 class="text-xl font-bold mb-6 text-gray-800">Add User</h2>
        <form id="addUserForm" action="${pageContext.request.contextPath}/ManageUsersServlet" method="post" onsubmit="return validateUserForm('addUserForm')">
          <input type="hidden" name="action" value="add">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Full Name</label>
            <input type="text" name="fullName" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" maxlength="100">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Username</label>
            <input type="text" name="username" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" maxlength="50" pattern="[a-zA-Z0-9_]+">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Password</label>
            <input type="password" name="password" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" minlength="6">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Role</label>
            <select name="role" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="Admin">Admin</option>
              <option value="Customer">Customer</option>
            </select>
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Email</label>
            <input type="email" name="email" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" maxlength="100">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Contact Number</label>
            <input type="text" name="contactNo" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" pattern="\+?\d{10,15}">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Address</label>
            <input type="text" name="address" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" maxlength="200">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Birthday</label>
            <input type="date" name="birthday" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" max="<%= java.time.LocalDate.now().minusDays(1) %>">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Gender</label>
            <select name="gender" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div class="flex justify-end">
            <button type="button" onclick="closeModal('addUserModal')" class="bg-gray-500 text-white px-4 py-2 rounded-full hover:bg-gray-600 transition mr-2">Cancel</button>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Add User</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
      <div class="modal-content">
        <h2 class="text-xl font-bold mb-6 text-gray-800">Edit User</h2>
        <form id="editUserForm" action="${pageContext.request.contextPath}/ManageUsersServlet" method="post" onsubmit="return validateUserForm('editUserForm')">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <input type="hidden" name="username" id="editUsername">
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Full Name</label>
            <input type="text" name="fullName" id="editFullName" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" maxlength="100">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Password</label>
            <input type="password" name="password" id="editPassword" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" minlength="6">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Role</label>
            <select name="role" id="editRole" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="Admin">Admin</option>
              <option value="Customer">Customer</option>
            </select>
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Email</label>
            <input type="email" name="email" id="editEmail" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" maxlength="100">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Contact Number</label>
            <input type="text" name="contactNo" id="editContactNo" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" pattern="\+?\d{10,15}">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Address</label>
            <input type="text" name="address" id="editAddress" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" maxlength="200">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Birthday</label>
            <input type="date" name="birthday" id="editBirthday" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" max="<%= java.time.LocalDate.now().minusDays(1) %>">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Gender</label>
            <select name="gender" id="editGender" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div class="flex justify-end">
            <button type="button" onclick="closeModal('editUserModal')" class="bg-gray-500 text-white px-4 py-2 rounded-full hover:bg-gray-600 transition mr-2">Cancel</button>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Update User</button>
          </div>
        </form>
      </div>
    </div>
  </main>
</div>

<footer class="bg-gray-800 text-white py-8 mt-6">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="text-center">
      <p class="text-gray-400">© <%= java.time.Year.now().getValue() %> MediCare. All rights reserved.</p>
    </div>
  </div>
</footer>

<script>
  const sidebar = document.getElementById('sidebar');
  const toggleSidebar = document.getElementById('toggleSidebar');
  const content = document.querySelector('.content');
  const sidebarTexts = document.querySelectorAll('.sidebar-text');

  toggleSidebar.addEventListener('click', () => {
    sidebar.classList.toggle('sidebar-expanded');
    sidebar.classList.toggle('sidebar-collapsed');
    if (sidebar.classList.contains('sidebar-collapsed')) {
      content.style.marginLeft = '80px';
      sidebarTexts.forEach(text => text.style.display = 'none');
    } else {
      content.style.marginLeft = '250px';
      sidebarTexts.forEach(text => text.style.display = 'inline');
    }
  });

  function openModal(modalId) {
    document.getElementById(modalId).style.display = 'block';
  }

  function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
  }

  function openEditModal(username, fullName, role, email, contactNo, address, birthday, gender) {
    document.getElementById('editUsername').value = username;
    document.getElementById('editFullName').value = fullName;
    document.getElementById('editRole').value = role;
    document.getElementById('editEmail').value = email;
    document.getElementById('editContactNo').value = contactNo;
    document.getElementById('editAddress').value = address;
    document.getElementById('editBirthday').value = birthday;
    document.getElementById('editGender').value = gender;
    openModal('editUserModal');
  }

  function validateUserForm(formId) {
    const form = document.getElementById(formId);
    const username = form.querySelector('input[name="username"]').value;
    const password = form.querySelector('input[name="password"]') ? form.querySelector('input[name="password"]').value : '';
    const contactNo = form.querySelector('input[name="contactNo"]').value;
    const email = form.querySelector('input[name="email"]').value;

    if (!/^[a-zA-Z0-9_]+$/.test(username)) {
      alert('Username can only contain letters, numbers, and underscores.');
      return false;
    }
    if (password && password.length < 6) {
      alert('Password must be at least 6 characters long.');
      return false;
    }
    if (!/\+?\d{10,15}/.test(contactNo)) {
      alert('Contact number must be 10-15 digits, optionally starting with +.');
      return false;
    }
    if (!/^[A-Za-z0-9+_.-]+@(.+)$/.test(email)) {
      alert('Invalid email format.');
      return false;
    }
    return true;
  }

  function showTab(tabId) {
    document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
    document.querySelector(`.tab[onclick="showTab('${tabId}')"]`).classList.add('active');
    document.getElementById(tabId).classList.add('active');
  }
</script>
</body>
</html>