<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MediCare - Manage Orders</title>
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
          <a href="${pageContext.request.contextPath}/ManageOrdersServlet" class="sidebar-link active">
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
        <h1 class="text-2xl font-bold text-gray-800">Manage Orders</h1>
        <button onclick="openAddModal()" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Add New Order</button>
      </div>

      <c:if test="${not empty sessionScope.message}">
        <div class="notification mb-4 p-4 rounded-lg <c:out value='${sessionScope.messageType == "success" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}'/>">
          <c:out value="${sessionScope.message}"/>
        </div>
        <c:remove var="message" scope="session"/>
        <c:remove var="messageType" scope="session"/>
      </c:if>

      <div class="flex justify-between items-center mb-6">
        <input type="text" id="searchInput" placeholder="Search orders..." onkeyup="searchTable()" class="px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
        <button onclick="sortTable()" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">
          <i class="fas fa-sort"></i> Sort (Newest First)
        </button>
      </div>

      <c:choose>
        <c:when test="${not empty orders}">
          <div class="overflow-x-auto">
            <table class="w-full table-auto border-collapse" id="ordersTable">
              <thead>
              <tr class="bg-gray-200">
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Order ID</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Username</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Product ID</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Quantity</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Status</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Order Date</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Actions</th>
              </tr>
              </thead>
              <tbody class="table-hover" id="ordersBody">
              <c:forEach var="order" items="${orders}">
                <tr>
                  <td class="border px-4 py-3 text-gray-600"><c:out value="${order.split(',')[0]}"/></td>
                  <td class="border px-4 py-3 text-gray-600"><c:out value="${order.split(',')[1]}"/></td>
                  <td class="border px-4 py-3 text-gray-600"><c:out value="${order.split(',')[2]}"/></td>
                  <td class="border px-4 py-3 text-gray-600"><c:out value="${order.split(',')[3]}"/></td>
                  <td class="border px-4 py-3 text-gray-600"><c:out value="${order.split(',')[4]}"/></td>
                  <td class="border px-4 py-3 text-gray-600"><c:out value="${order.split(',')[5]}"/></td>
                  <td class="border px-4 py-3">
                    <button onclick="openEditModal(
                            '<c:out value="${order.split(',')[0]}"/>',
                            '<c:out value="${order.split(',')[1]}"/>',
                            '<c:out value="${order.split(',')[2]}"/>',
                            '<c:out value="${order.split(',')[3]}"/>',
                            '<c:out value="${order.split(',')[4]}"/>',
                            '<c:out value="${order.split(',')[5]}"/>'
                            )" class="text-blue-600 hover:text-blue-800 mr-3">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button onclick="openRemoveModal('<c:out value="${order.split(',')[0]}"/>')" class="text-red-600 hover:text-red-800">
                      <i class="fas fa-trash"></i>
                    </button>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:when>
        <c:otherwise>
          <p class="text-gray-600 text-center py-4">No orders available.</p>
        </c:otherwise>
      </c:choose>
    </section>

    <!-- Add Order Modal -->
    <div id="addModal" class="modal">
      <div class="modal-content">
        <h2 class="text-xl font-bold mb-6 text-gray-800">Add New Order</h2>
        <form action="${pageContext.request.contextPath}/ManageOrdersServlet" method="post" onsubmit="return validateAddForm()">
          <input type="hidden" name="action" value="add">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Username</label>
            <input type="text" name="username" id="addUsername" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Product ID</label>
            <input type="text" name="productId" id="addProductId" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Quantity</label>
            <input type="number" name="quantity" id="addQuantity" min="1" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Status</label>
            <select name="status" id="addStatus" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="Pending">Pending</option>
              <option value="Shipped">Shipped</option>
              <option value="Delivered">Delivered</option>
            </select>
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Order Date</label>
            <input type="date" name="orderDate" id="addOrderDate" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
          </div>
          <div class="flex justify-end">
            <button type="button" onclick="closeAddModal()" class="bg-gray-500 text-white px-4 py-2 rounded-full hover:bg-gray-600 transition mr-2">Cancel</button>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Add Order</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Edit Order Modal -->
    <div id="editModal" class="modal">
      <div class="modal-content">
        <h2 class="text-xl font-bold mb-6 text-gray-800">Edit Order</h2>
        <form action="${pageContext.request.contextPath}/ManageOrdersServlet" method="post" onsubmit="return validateEditForm()">
          <input type="hidden" name="action" value="edit">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <input type="hidden" name="orderId" id="editOrderId">
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Username</label>
            <input type="text" name="username" id="editUsername" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Product ID</label>
            <input type="text" name="productId" id="editProductId" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Quantity</label>
            <input type="number" name="quantity" id="editQuantity" min="1" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Status</label>
            <select name="status" id="editStatus" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="Pending">Pending</option>
              <option value="Shipped">Shipped</option>
              <option value="Delivered">Delivered</option>
            </select>
          </div>
          <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-1">Order Date</label>
            <input type="date" name="orderDate" id="editOrderDate" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
          </div>
          <div class="flex justify-end">
            <button type="button" onclick="closeEditModal()" class="bg-gray-500 text-white px-4 py-2 rounded-full hover:bg-gray-600 transition mr-2">Cancel</button>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Save Changes</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Remove Order Modal -->
    <div id="removeModal" class="modal">
      <div class="modal-content">
        <h2 class="text-xl font-bold mb-6 text-gray-800">Confirm Delete</h2>
        <form action="${pageContext.request.contextPath}/ManageOrdersServlet" method="post">
          <input type="hidden" name="action" value="remove">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <input type="hidden" name="orderId" id="removeOrderId">
          <p class="mb-6 text-gray-600">Are you sure you want to delete this order?</p>
          <div class="flex justify-end">
            <button type="button" onclick="closeRemoveModal()" class="bg-gray-500 text-white px-4 py-2 rounded-full hover:bg-gray-600 transition mr-2">Cancel</button>
            <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-full hover:bg-red-700 transition">Delete</button>
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

  function openAddModal() {
    document.getElementById('addModal').style.display = 'block';
  }

  function closeAddModal() {
    document.getElementById('addModal').style.display = 'none';
  }

  function openEditModal(orderId, username, productId, quantity, status, orderDate) {
    document.getElementById('editOrderId').value = orderId;
    document.getElementById('editUsername').value = username;
    document.getElementById('editProductId').value = productId;
    document.getElementById('editQuantity').value = quantity;
    document.getElementById('editStatus').value = status;
    document.getElementById('editOrderDate').value = orderDate;
    document.getElementById('editModal').style.display = 'block';
  }

  function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
  }

  function openRemoveModal(orderId) {
    document.getElementById('removeOrderId').value = orderId;
    document.getElementById('removeModal').style.display = 'block';
  }

  function closeRemoveModal() {
    document.getElementById('removeModal').style.display = 'none';
  }

  function searchTable() {
    const input = document.getElementById('searchInput');
    const filter = input.value.toLowerCase();
    const table = document.getElementById('ordersTable');
    const tr = table.getElementsByTagName('tr');

    for (let i = 1; i < tr.length; i++) {
      let found = false;
      const td = tr[i].getElementsByTagName('td');
      for (let j = 0; j < td.length - 1; j++) {
        const cell = td[j];
        if (cell) {
          const txtValue = cell.textContent || cell.innerText;
          if (txtValue.toLowerCase().indexOf(filter) > -1) {
            found = true;
            break;
          }
        }
      }
      tr[i].style.display = found ? '' : 'none';
    }
  }

  function sortTable() {
    const table = document.getElementById('ordersTable');
    const tbody = document.getElementById('ordersBody');
    const rows = Array.from(tbody.getElementsByTagName('tr'));

    rows.sort((a, b) => {
      const dateA = a.cells[5].textContent;
      const dateB = b.cells[5].textContent;
      return new Date(dateB) - new Date(dateA);
    });

    while (tbody.firstChild) {
      tbody.removeChild(tbody.firstChild);
    }
    rows.forEach(row => tbody.appendChild(row));
  }

  function validateAddForm() {
    const quantity = document.getElementById('addQuantity').value;
    if (quantity < 1) {
      alert('Quantity must be at least 1.');
      return false;
    }
    return true;
  }

  function validateEditForm() {
    const quantity = document.getElementById('editQuantity').value;
    if (quantity < 1) {
      alert('Quantity must be at least 1.');
      return false;
    }
    return true;
  }

  window.onclick = function(event) {
    const addModal = document.getElementById('addModal');
    const editModal = document.getElementById('editModal');
    const removeModal = document.getElementById('removeModal');
    if (event.target === addModal) {
      closeAddModal();
    } else if (event.target === editModal) {
      closeEditModal();
    } else if (event.target === removeModal) {
      closeRemoveModal();
    }
  };
</script>
</body>
</html>