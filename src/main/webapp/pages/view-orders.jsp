<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MediCare - Manage Orders</title>
  <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/manageOperations.css">
</head>
<body>
<c:if test="${empty sessionScope.username}">
  <c:redirect url="${pageContext.request.contextPath}/pages/login.jsp"/>
</c:if>

<div class="container">
  <div class="header">
    <h1><i class="ri-clipboard-line"></i> Manage Orders</h1>
    <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
      <i class="ri-arrow-left-line"></i> Back to Dashboard
    </a>
  </div>

  <div class="main-content">
    <div>
      <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-${sessionScope.messageType}">
          <c:out value="${sessionScope.message}"/>
        </div>
        <c:remove var="message" scope="session"/>
        <c:remove var="messageType" scope="session"/>
      </c:if>

      <div class="card">
        <button class="btn btn-primary" onclick="openAddModal()">
          <i class="ri-add-line"></i> Add New Order
        </button>
      </div>

      <div class="search-container">
        <input type="text" class="search-input" id="searchInput" placeholder="Search orders..." onkeyup="searchTable()">
        <button class="btn btn-primary" onclick="sortTable()">
          <i class="ri-sort-desc"></i> Sort (Newest First)
        </button>
      </div>

      <div class="card">
        <h2><i class="ri-pie-chart-line"></i> Order Status Distribution</h2>
        <div class="chart-container">
          <canvas id="statusChart"></canvas>
        </div>
      </div>

      <div class="table-container">
        <table id="ordersTable">
          <thead>
          <tr>
            <th>Order ID</th>
            <th>Username</th>
            <th>Product ID</th>
            <th>Quantity</th>
            <th>Status</th>
            <th>Order Date</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody id="ordersBody">
          <c:forEach var="order" items="${orders}">
            <tr>
              <td><c:out value="${order.split(',')[0]}"/></td>
              <td><c:out value="${order.split(',')[1]}"/></td>
              <td><c:out value="${order.split(',')[2]}"/></td>
              <td><c:out value="${order.split(',')[3]}"/></td>
              <td><c:out value="${order.split(',')[4]}"/></td>
              <td><c:out value="${order.split(',')[5]}"/></td>
              <td>
                <button class="btn btn-edit" onclick="openEditModal(
                        '<c:out value="${order.split(',')[0]}"/>',
                        '<c:out value="${order.split(',')[1]}"/>',
                        '<c:out value="${order.split(',')[2]}"/>',
                        '<c:out value="${order.split(',')[3]}"/>',
                        '<c:out value="${order.split(',')[4]}"/>',
                        '<c:out value="${order.split(',')[5]}"/>'
                        )"><i class="ri-edit-line"></i> Edit</button>
                <button class="btn btn-danger" onclick="openRemoveModal('<c:out value="${order.split(',')[0]}"/>')">
                  <i class="ri-delete-bin-line"></i> Remove
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

<!-- Add Order Modal -->
<div class="modal" id="addModal">
  <div class="modal-content">
    <div class="modal-header">
      <h2><i class="ri-add-line"></i> Add New Order</h2>
      <button class="modal-close" onclick="closeAddModal()">×</button>
    </div>
    <div class="modal-body">
      <form action="<%=request.getContextPath()%>/ManageOrdersServlet" method="post" onsubmit="return validateAddForm()">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <div class="form-group">
          <i class="ri-user-line"></i>
          <label>Username</label>
          <input type="text" name="username" id="addUsername" required>
        </div>
        <div class="form-group">
          <i class="ri-box-3-line"></i>
          <label>Product ID</label>
          <input type="text" name="productId" id="addProductId" required>
        </div>
        <div class="form-group">
          <i class="ri-number-1"></i>
          <label>Quantity</label>
          <input type="number" name="quantity" id="addQuantity" min="1" required>
        </div>
        <div class="form-group">
          <i class="ri-checkbox-circle-line"></i>
          <label>Status</label>
          <select name="status" id="addStatus" required>
            <option value="Pending">Pending</option>
            <option value="Shipped">Shipped</option>
            <option value="Delivered">Delivered</option>
          </select>
        </div>
        <div class="form-group">
          <i class="ri-calendar-line"></i>
          <label>Order Date</label>
          <input type="date" name="orderDate" id="addOrderDate" required>
        </div>
        <button type="submit" class="btn btn-primary">
          <i class="ri-add-line"></i> Add Order
        </button>
      </form>
    </div>
  </div>
</div>

<!-- Edit Order Modal -->
<div class="modal" id="editModal">
  <div class="modal-content">
    <div class="modal-header">
      <h2><i class="ri-edit-line"></i> Edit Order</h2>
      <button class="modal-close" onclick="closeEditModal()">×</button>
    </div>
    <div class="modal-body">
      <form action="<%=request.getContextPath()%>/ManageOrdersServlet" method="post" onsubmit="return validateEditForm()">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="orderId" id="editOrderId">
        <div class="form-group">
          <i class="ri-user-line"></i>
          <label>Username</label>
          <input type="text" name="username" id="editUsername" required>
        </div>
        <div class="form-group">
          <i class="ri-box-3-line"></i>
          <label>Product ID</label>
          <input type="text" name="productId" id="editProductId" required>
        </div>
        <div class="form-group">
          <i class="ri-number-1"></i>
          <label>Quantity</label>
          <input type="number" name="quantity" id="editQuantity" min="1" required>
        </div>
        <div class="form-group">
          <i class="ri-checkbox-circle-line"></i>
          <label>Status</label>
          <select name="status" id="editStatus" required>
            <option value="Pending">Pending</option>
            <option value="Shipped">Shipped</option>
            <option value="Delivered">Delivered</option>
          </select>
        </div>
        <div class="form-group">
          <i class="ri-calendar-line"></i>
          <label>Order Date</label>
          <input type="date" name="orderDate" id="editOrderDate" required>
        </div>
        <button type="submit" class="btn btn-primary">
          <i class="ri-save-line"></i> Save Changes
        </button>
      </form>
    </div>
  </div>
</div>

<!-- Remove Order Modal -->
<div class="modal" id="removeModal">
  <div class="modal-content">
    <div class="modal-header">
      <h2><i class="ri-delete-bin-line"></i> Confirm Delete</h2>
      <button class="modal-close" onclick="closeRemoveModal()">×</button>
    </div>
    <div class="modal-body">
      <p>Are you sure you want to delete this order?</p>
      <form action="<%=request.getContextPath()%>/ManageOrdersServlet" method="post">
        <input type="hidden" name="action" value="remove">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="orderId" id="removeOrderId">
        <button type="submit" class="btn btn-danger">
          <i class="ri-delete-bin-line"></i> Delete
        </button>
        <button type="button" class="btn btn-secondary" onclick="closeRemoveModal()">
          <i class="ri-close-line"></i> Cancel
        </button>
      </form>
    </div>
  </div>
</div>

<script>
  // Add Modal functions
  function openAddModal() {
    document.getElementById('addModal').style.display = 'flex';
  }

  function closeAddModal() {
    document.getElementById('addModal').style.display = 'none';
  }

  // Edit Modal functions
  function openEditModal(orderId, username, productId, quantity, status, orderDate) {
    document.getElementById('editOrderId').value = orderId;
    document.getElementById('editUsername').value = username;
    document.getElementById('editProductId').value = productId;
    document.getElementById('editQuantity').value = quantity;
    document.getElementById('editStatus').value = status;
    document.getElementById('editOrderDate').value = orderDate;
    document.getElementById('editModal').style.display = 'flex';
  }

  function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
  }

  // Remove Modal functions
  function openRemoveModal(orderId) {
    document.getElementById('removeOrderId').value = orderId;
    document.getElementById('removeModal').style.display = 'flex';
  }

  function closeRemoveModal() {
    document.getElementById('removeModal').style.display = 'none';
  }

  // Search function
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

  // Sort function (by order date, newest first)
  function sortTable() {
    const table = document.getElementById('ordersTable');
    const tbody = document.getElementById('ordersBody');
    const rows = Array.from(tbody.getElementsByTagName('tr'));

    rows.sort((a, b) => {
      const dateA = a.cells[5].textContent;
      const dateB = b.cells[5].textContent;
      return new Date(dateB) - new Date(dateA); // Newest first
    });

    while (tbody.firstChild) {
      tbody.removeChild(tbody.firstChild);
    }
    rows.forEach(row => tbody.appendChild(row));
  }

  // Status Pie Chart
  const ordersData = [
    <c:forEach var="order" items="${orders}">
    '<c:out value="${order.split(',')[4]}"/>',
    </c:forEach>
  ];

  const statusCount = ordersData.reduce((acc, curr) => {
    acc[curr] = (acc[curr] || 0) + 1;
    return acc;
  }, {});

  const ctx = document.getElementById('statusChart').getContext('2d');
  new Chart(ctx, {
    type: 'pie',
    data: {
      labels: Object.keys(statusCount),
      datasets: [{
        data: Object.values(statusCount),
        backgroundColor: [
          'rgba(74, 144, 226, 0.8)',
          'rgba(38, 166, 154, 0.8)',
          'rgba(239, 83, 80, 0.8)'
        ],
        borderWidth: 2,
        borderColor: '#FFFFFF'
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            padding: 20,
            font: { size: 12 }
          }
        },
        tooltip: {
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          padding: 10,
          cornerRadius: 8
        },
        title: {
          display: true,
          text: 'Orders by Status',
          font: { size: 16 }
        }
      }
    }
  });

  // Form validation
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
  }
</script>
</body>
</html>