<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MediCare - Manage Products</title>
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
    .admin-bg {
      background: linear-gradient(to right, #1e3a8a, #3b82f6);
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
      margin: 15% auto;
      padding: 20px;
      border-radius: 8px;
      width: 90%;
      max-width: 500px;
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
          <a href="${pageContext.request.contextPath}/ManageProductsServlet" class="sidebar-link active">
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
          <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="sidebar-link">
            <i class="fas fa-users"></i>
            <span class="sidebar-text">Manage Users</span>
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
        <h1 class="text-2xl font-bold">Manage Products</h1>
        <button onclick="openModal('addProductModal')" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Add Product</button>
      </div>

      <c:if test="${not empty message}">
        <p class="text-green-600 mb-4"><c:out value="${message}"/></p>
      </c:if>
      <c:if test="${not empty error}">
        <p class="text-red-600 mb-4"><c:out value="${error}"/></p>
      </c:if>

      <c:choose>
        <c:when test="${not empty products}">
          <table class="w-full table-auto border-collapse">
            <thead>
            <tr class="bg-gray-200">
              <th class="px-4 py-2 text-left">Product ID</th>
              <th class="px-4 py-2 text-left">Name</th>
              <th class="px-4 py-2 text-left">Description</th>
              <th class="px-4 py-2 text-left">Price</th>
              <th class="px-4 py-2 text-left">Stock</th>
              <th class="px-4 py-2 text-left">Actions</th>
            </tr>
            </thead>
            <tbody class="table-hover">
            <c:forEach var="product" items="${products}">
              <tr>
                <td class="border px-4 py-2"><c:out value="${product.productId}"/></td>
                <td class="border px-4 py-2"><c:out value="${product.name}"/></td>
                <td class="border px-4 py-2"><c:out value="${product.description}"/></td>
                <td class="border px-4 py-2">$<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td class="border px-4 py-2"><c:out value="${product.stockQuantity}"/></td>
                <td class="border px-4 py-2">
                  <button onclick="openEditModal('<c:out value="${product.productId}"/>', '<c:out value="${product.name}"/>', '<c:out value="${product.description}"/>', '<c:out value="${product.price}"/>', '<c:out value="${product.stockQuantity}"/>')" class="text-blue-600 hover:text-blue-800 mr-2">
                    <i class="fas fa-edit"></i>
                  </button>
                  <a href="${pageContext.request.contextPath}/ManageProductsServlet?action=delete&productId=<c:out value="${product.productId}"/>&csrfToken=<c:out value="${sessionScope.csrfToken}"/>" class="text-red-600 hover:text-red-800" onclick="return confirm('Are you sure you want to delete this product?')">
                    <i class="fas fa-trash"></i>
                  </a>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </c:when>
        <c:otherwise>
          <p class="text-gray-600">No products available.</p>
        </c:otherwise>
      </c:choose>
    </section>

    <!-- Add Product Modal -->
    <div id="addProductModal" class="modal">
      <div class="modal-content">
        <h2 class="text-xl font-bold mb-4">Add Product</h2>
        <form action="${pageContext.request.contextPath}/ManageProductsServlet" method="post">
          <input type="hidden" name="action" value="add">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <div class="mb-4">
            <label class="block text-gray-700">Name</label>
            <input type="text" name="name" required class="w-full px-3 py-2 border rounded-lg">
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Description</label>
            <textarea name="description" class="w-full px-3 py-2 border rounded-lg"></textarea>
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Price</label>
            <input type="number" name="price" step="0.01" required class="w-full px-3 py-2 border rounded-lg">
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Stock Quantity</label>
            <input type="number" name="stockQuantity" required class="w-full px-3 py-2 border rounded-lg">
          </div>
          <div class="flex justify-end">
            <button type="button" onclick="closeModal('addProductModal')" class="bg-gray-500 text-white px-4 py-2 rounded-full mr-2">Cancel</button>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-full">Add</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Edit Product Modal -->
    <div id="editProductModal" class="modal">
      <div class="modal-content">
        <h2 class="text-xl font-bold mb-4">Edit Product</h2>
        <form action="${pageContext.request.contextPath}/ManageProductsServlet" method="post">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <input type="hidden" name="productId" id="editProductId">
          <div class="mb-4">
            <label class="block text-gray-700">Name</label>
            <input type="text" name="name" id="editName" required class="w-full px-3 py-2 border rounded-lg">
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Description</label>
            <textarea name="description" id="editDescription" class="w-full px-3 py-2 border rounded-lg"></textarea>
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Price</label>
            <input type="number" name="price" id="editPrice" step="0.01" required class="w-full px-3 py-2 border rounded-lg">
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Stock Quantity</label>
            <input type="number" name="stockQuantity" id="editStockQuantity" required class="w-full px-3 py-2 border rounded-lg">
          </div>
          <div class="flex justify-end">
            <button type="button" onclick="closeModal('editProductModal')" class="bg-gray-500 text-white px-4 py-2 rounded-full mr-2">Cancel</button>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-full">Update</button>
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

  function openEditModal(productId, name, description, price, stockQuantity) {
    document.getElementById('editProductId').value = productId;
    document.getElementById('editName').value = name;
    document.getElementById('editDescription').value = description;
    document.getElementById('editPrice').value = price;
    document.getElementById('editStockQuantity').value = stockQuantity;
    openModal('editProductModal');
  }
</script>
</body>
</html>