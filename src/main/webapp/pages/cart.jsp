<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Product" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="MediCare: View and manage your shopping cart with medicines, wellness products, and more.">
  <meta name="keywords" content="MediCare, cart, online pharmacy, medicines, checkout">
  <title>MediCare - Shopping Cart</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Inter', Arial, sans-serif; background-color: #f7fafc; margin: 0; }
    .container { max-width: 1280px; margin: 0 auto; padding: 16px; }
    .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
    .card-hover:hover { transform: translateY(-5px); box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15); }
    .cart-item { background: white; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); padding: 16px; display: flex; align-items: center; gap: 16px; margin-bottom: 16px; }
    .error-message { background: #fef2f2; color: #dc2626; padding: 16px; border-radius: 8px; margin-bottom: 24px; }
    .empty-cart { text-align: center; color: #4b5563; margin: 32px 0; font-size: 18px; }
    .quantity-input { width: 80px; text-align: center; border: 1px solid #d1d5db; border-radius: 8px; padding: 4px; }
    .subtotal-card { background: white; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); padding: 24px; }
    .fade-in { animation: fadeIn 0.5s ease-in; }
    .cart-item-image { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; }
    .cart-item-details { flex: 1; }
    .cart-item-actions { display: flex; align-items: center; gap: 8px; }
    .quantity-control { display: flex; align-items: center; gap: 8px; }
    .quantity-btn { background: #e5e7eb; color: #1f2937; padding: 4px 8px; border-radius: 4px; cursor: pointer; }
    .quantity-btn:hover { background: #d1d5db; }
    .remove-btn { background: #dc2626; color: white; padding: 8px 16px; border-radius: 8px; font-size: 14px; }
    .remove-btn:hover { background: #b91c1c; }
    .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; }
    .modal-content { background: white; margin: 10% auto; padding: 24px; border-radius: 12px; max-width: 500px; width: 90%; }
    .modal-close { position: absolute; top: 16px; right: 16px; cursor: pointer; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    @media (max-width: 640px) {
      .cart-item { flex-direction: column; align-items: flex-start; }
      .cart-item-image { width: 100%; height: auto; }
      .subtotal-card { position: static; width: 100%; }
      .cart-item-actions { width: 100%; justify-content: space-between; }
    }
  </style>
</head>
<body class="bg-gray-50">
<!-- Navigation (unchanged) -->
<nav class="bg-white shadow-lg sticky top-0 z-50">
  <div class="container flex justify-between items-center py-4">
    <a href="${pageContext.request.contextPath}/home" class="text-3xl font-bold text-blue-600">MediCare</a>
    <div class="hidden md:flex items-center space-x-6">
      <div class="relative">
        <input type="text" id="searchInput" placeholder="Search medicines..." class="w-80 px-4 py-2 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500" aria-label="Search products">
        <i class="fas fa-search absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
      </div>
      <a href="${pageContext.request.contextPath}/cart" class="relative">
        <i class="fas fa-shopping-cart text-gray-600 text-xl"></i>
        <%
          List<Product> cart = null;
          int cartSize = 0;
          try {
            Object cartObj = session.getAttribute("cart");
            if (cartObj instanceof List) {
              cart = (List<Product>) cartObj;
              cartSize = (cart != null) ? cart.size() : 0;
            }
          } catch (ClassCastException e) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
          }
        %>
        <span class="cart-count top-[-8px] right-[-8px] bg-red-500 text-white rounded-full h-5 w-5 flex items-center justify-center text-xs"><%= cartSize %></span>
      </a>
      <c:choose>
        <c:when test="${not empty sessionScope.username}">
          <div class="flex items-center space-x-4">
            <span class="text-gray-600 font-medium">Welcome, ${sessionScope.username} (${sessionScope.role})</span>
            <c:if test="${sessionScope.role == 'User'}">
              <a href="${pageContext.request.contextPath}/pages/profile.jsp" class="text-gray-600 hover:text-blue-600 font-medium">Profile</a>
            </c:if>
            <c:if test="${sessionScope.role == 'Admin'}">
              <a href="${pageContext.request.contextPath}/ManageProductsServlet" class="text-gray-600 hover:text-blue-600 font-medium">Manage Products</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/logout" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Logout</a>
          </div>
        </c:when>
        <c:otherwise>
          <div class="login-dropdown relative">
            <button class="text-gray-600 hover:text-blue-600 font-semibold">Login</button>
            <div class="login-dropdown-content hidden absolute top-full right-0 bg-white shadow-lg rounded-lg z-20 min-w-[160px]">
              <a href="${pageContext.request.contextPath}/pages/login.jsp?role=Admin" class="block px-6 py-3 text-gray-700 font-medium hover:bg-gray-100 hover:text-blue-600">Admin Login</a>
              <a href="${pageContext.request.contextPath}/pages/login.jsp?role=User" class="block px-6 py-3 text-gray-700 font-medium hover:bg-gray-100 hover:text-blue-600">User Login</a>
            </div>
          </div>
          <a href="${pageContext.request.contextPath}/pages/register.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Sign Up</a>
        </c:otherwise>
      </c:choose>
    </div>
    <button id="mobileMenuToggle" class="md:hidden text-gray-600 focus:outline-none">
      <i class="fas fa-bars text-2xl"></i>
    </button>
  </div>
  <div id="mobileMenu" class="mobile-menu md:hidden bg-white shadow-lg px-4 py-4 hidden">
    <div class="relative mb-4">
      <input type="text" id="mobileSearchInput" placeholder="Search medicines..." class="w-full px-4 py-2 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500" aria-label="Search products">
      <i class="fas fa-search absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
    </div>
    <c:choose>
      <c:when test="${not empty sessionScope.username}">
        <div class="flex flex-col space-y-2">
          <span class="text-gray-600 font-medium">Welcome, ${sessionScope.username} (${sessionScope.role})</span>
          <c:if test="${sessionScope.role == 'User'}">
            <a href="${pageContext.request.contextPath}/pages/profile.jsp" class="text-gray-600 hover:text-blue-600">Profile</a>
          </c:if>
          <c:if test="${sessionScope.role == 'Admin'}">
            <a href="${pageContext.request.contextPath}/ManageProductsServlet" class="text-gray-600 hover:text-blue-600">Manage Products</a>
          </c:if>
          <a href="${pageContext.request.contextPath}/logout" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 text-center">Logout</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="flex flex-col space-y-2">
          <a href="${pageContext.request.contextPath}/pages/login.jsp?role=User" class="text-gray-600 hover:text-blue-600">User Login</a>
          <a href="${pageContext.request.contextPath}/pages/login.jsp?role=Admin" class="text-gray-600 hover:text-blue-600">Admin Login</a>
          <a href="${pageContext.request.contextPath}/pages/register.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 text-center">Sign Up</a>
        </div>
      </c:otherwise>
    </c:choose>
    <a href="${pageContext.request.contextPath}/cart" class="flex items-center mt-4 text-gray-600 hover:text-blue-600">
      <i class="fas fa-shopping-cart mr-2"></i> Cart <span class="cart-count ml-2"><%= cartSize %></span>
    </a>
    <div class="mt-4">
      <a href="${pageContext.request.contextPath}/home" class="text-gray-600 hover:text-blue-600">Home</a>
    </div>
  </div>
</nav>

<section class="py-16 bg-gray-50">
  <div class="container">
    <h2 class="text-3xl font-bold text-gray-800 mb-8">Your Shopping Cart</h2>
    <c:if test="${not empty error}">
      <div class="error-message flex items-center">
        <i class="fas fa-exclamation-circle mr-2"></i>${error}
      </div>
    </c:if>
    <div class="flex flex-col lg:flex-row gap-8">
      <div class="lg:w-2/3">
        <%
          List<Product> cartItems = null;
          try {
            Object cartObj = session.getAttribute("cart");
            if (cartObj instanceof List) {
              cartItems = (List<Product>) cartObj;
            }
          } catch (ClassCastException e) {
            cartItems = new ArrayList<>();
            session.setAttribute("cart", cartItems);
          }
          if (cartItems != null && !cartItems.isEmpty()) {
            java.util.Map<String, Integer> quantities = (java.util.Map<String, Integer>) session.getAttribute("cartQuantities");
            if (quantities == null) {
              quantities = new java.util.HashMap<>();
              session.setAttribute("cartQuantities", quantities);
            }
            for (Product product : cartItems) {
              int quantity = quantities.getOrDefault(product.getProductId(), 1);
              String imageUrl = product.getImageUrl() != null && !product.getImageUrl().isEmpty() ? product.getImageUrl() : "${pageContext.request.contextPath}/images/product-placeholder.jpg";
        %>
        <div class="cart-item card-hover fade-in" data-product-id="<%= product.getProductId() %>">
          <img src="<%= imageUrl %>" alt="<%= product.getName() %>" class="cart-item-image">
          <div class="cart-item-details">
            <h3 class="text-lg font-semibold text-gray-800"><%= product.getName() %></h3>
            <p class="text-sm text-gray-500">Product ID: <%= product.getProductId() %></p>
            <p class="text-lg font-medium text-blue-600">$<%= String.format("%.2f", product.getPrice()) %></p>
          </div>
          <div class="cart-item-actions">
            <div class="quantity-control">
              <button class="quantity-btn minus-btn" data-product-id="<%= product.getProductId() %>" data-price="<%= product.getPrice() %>">-</button>
              <input type="number" class="quantity-input" value="<%= quantity %>" min="1" readonly>
              <button class="quantity-btn plus-btn" data-product-id="<%= product.getProductId() %>" data-price="<%= product.getPrice() %>">+</button>
            </div>
            <form action="<%= request.getContextPath() %>/cart" method="post">
              <input type="hidden" name="productId" value="<%= product.getProductId() %>">
              <input type="hidden" name="action" value="delete">
              <button type="submit" class="remove-btn">Remove</button>
            </form>
          </div>
        </div>
        <%
          }
        } else {
        %>
        <p class="empty-cart">Your cart is empty.</p>
        <%
          }
        %>
      </div>
      <% if (cartItems != null && !cartItems.isEmpty()) { %>
      <div class="lg:w-1/3">
        <div class="subtotal-card card-hover sticky top-24">
          <h3 class="text-xl font-semibold text-gray-800 mb-6">Order Summary</h3>
          <div class="flex justify-between mb-4">
            <span class="text-gray-600">Subtotal</span>
            <span class="text-gray-800 font-medium subtotal-amount">
              $<c:out value="${cartTotal != null ? String.format('%.2f', cartTotal) : '0.00'}" />
            </span>
          </div>
          <div class="flex justify-between mb-4">
            <span class="text-gray-600">Shipping</span>
            <span class="text-gray-800 font-medium">Calculated at checkout</span>
          </div>
          <div class="flex justify-between mb-6">
            <span class="text-gray-800 font-semibold">Total</span>
            <span class="text-blue-600 font-bold total-amount">
              $<c:out value="${cartTotal != null ? String.format('%.2f', cartTotal) : '0.00'}" />
            </span>
          </div>
          <button id="checkoutBtn" class="block w-full bg-blue-600 text-white py-3 rounded-full text-center font-semibold hover:bg-blue-700 transition">
            Proceed to Checkout
          </button>
        </div>
      </div>
      <% } %>
    </div>
  </div>
</section>

<!-- Checkout Modal -->
<div id="checkoutModal" class="modal">
  <div class="modal-content relative">
    <span class="modal-close" id="closeCheckoutModal">&times;</span>
    <h3 class="text-xl font-semibold text-gray-800 mb-4">Checkout</h3>
    <div class="mb-4">
      <h4 class="text-lg font-medium text-gray-700">Order Summary</h4>
      <div class="mt-2">
        <%
          double total = 0.0;
          if (cartItems != null) {
            java.util.Map<String, Integer> quantities = (java.util.Map<String, Integer>) session.getAttribute("cartQuantities");
            for (Product product : cartItems) {
              int qty = quantities.getOrDefault(product.getProductId(), 1);
              total += product.getPrice() * qty;
        %>
        <div class="flex justify-between text-sm text-gray-600">
          <span><%= product.getName() %> (x<%= qty %>)</span>
          <span>$<%= String.format("%.2f", product.getPrice() * qty) %></span>
        </div>
        <% } } %>
        <div class="flex justify-between font-semibold text-gray-800 mt-2">
          <span>Total</span>
          <span>$<%= String.format("%.2f", total) %></span>
        </div>
      </div>
    </div>
    <div class="mb-4">
      <h4 class="text-lg font-medium text-gray-700">Select Payment Method</h4>
      <div class="mt-2 space-y-2">
        <label class="flex items-center">
          <input type="radio" name="paymentMethod" value="Card" class="mr-2" checked> Card
        </label>
        <label class="flex items-center">
          <input type="radio" name="paymentMethod" value="Cash" class="mr-2"> Cash
        </label>
        <label class="flex items-center">
          <input type="radio" name="paymentMethod" value="Cash on Delivery" class="mr-2"> Cash on Delivery
        </label>
      </div>
    </div>
    <button id="proceedBtn" class="w-full bg-blue-600 text-white py-2 rounded-full hover:bg-blue-700">Proceed</button>
  </div>
</div>

<!-- Success Modal -->
<div id="successModal" class="modal">
  <div class="modal-content relative">
    <span class="modal-close" id="closeSuccessModal">&times;</span>
    <h3 class="text-xl font-semibold text-green-600 mb-4">Order Placed Successfully!</h3>
    <p class="text-gray-600">Thank you for your order. Please wait for your order to be processed and delivered.</p>
    <button id="closeSuccessBtn" class="w-full bg-blue-600 text-white py-2 rounded-full hover:bg-blue-700 mt-4">Close</button>
  </div>
</div>

<!-- Footer (unchanged) -->
<footer class="bg-gray-900 text-white py-12">
  <div class="container grid grid-cols-1 md:grid-cols-4 gap-8">
    <div>
      <h3 class="text-lg font-semibold mb-4">MediCare</h3>
      <p class="text-gray-300 text-sm">Your one-stop online pharmacy for all your healthcare needs, delivering quality products to your doorstep.</p>
    </div>
    <div>
      <h3 class="text-lg font-semibold mb-4">Quick Links</h3>
      <ul class="space-y-2">
        <li><a href="${pageContext.request.contextPath}/pages/about.jsp" class="text-gray-300 hover:text-white text-sm">About Us</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/contact.jsp" class="text-gray-300 hover:text-white text-sm">Contact Us</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/faq.jsp" class="text-gray-300 hover:text-white text-sm">FAQ</a></li>
      </ul>
    </div>
    <div>
      <h3 class="text-lg font-semibold mb-4">Customer Service</h3>
      <ul class="space-y-2">
        <li><a href="${pageContext.request.contextPath}/pages/returns.jsp" class="text-gray-300 hover:text-white text-sm">Returns</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/shipping.jsp" class="text-gray-300 hover:text-white text-sm">Shipping</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/terms.jsp" class="text-gray-300 hover:text-white text-sm">Terms & Conditions</a></li>
      </ul>
    </div>
    <div>
      <h3 class="text-lg font-semibold mb-4">Connect With Us</h3>
      <div class="flex space-x-4">
        <a href="#" class="text-gray-300 hover:text-white text-lg"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="text-gray-300 hover:text-white text-lg"><i class="fab fa-twitter"></i></a>
        <a href="#" class="text-gray-300 hover:text-white text-lg"><i class="fab fa-instagram"></i></a>
      </div>
    </div>
  </div>
  <div class="mt-8 border-t border-gray-700 pt-4 text-center text-gray-300 text-sm">
    <p>© 2025 MediCare. All rights reserved.</p>
  </div>
</footer>

<script>
  // Mobile menu toggle
  const mobileMenuToggle = document.getElementById('mobileMenuToggle');
  const mobileMenu = document.getElementById('mobileMenu');
  if (mobileMenuToggle && mobileMenu) {
    mobileMenuToggle.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });
  }

  // Login dropdown
  const loginDropdown = document.querySelector('.login-dropdown');
  if (loginDropdown) {
    loginDropdown.addEventListener('mouseenter', () => {
      loginDropdown.querySelector('.login-dropdown-content').classList.remove('hidden');
    });
    loginDropdown.addEventListener('mouseleave', () => {
      loginDropdown.querySelector('.login-dropdown-content').classList.add('hidden');
    });
  }

  // Quantity update function
  function updateQuantity(productId, change) {
    const cartItem = document.querySelector(`.cart-item[data-product-id="${productId}"]`);
    const input = cartItem.querySelector('.quantity-input');
    let quantity = parseInt(input.value) + change;
    if (quantity < 1) quantity = 1;
    input.value = quantity;

    // Update server via AJAX
    fetch('<%= request.getContextPath() %>/cart', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: `action=update&productId=${productId}&quantity=${quantity}`
    })
            .then(response => response.json())
            .then(data => {
              if (data.success) {
                // Update subtotal and total
                const subtotalElement = document.querySelector('.subtotal-amount');
                const totalElement = document.querySelector('.total-amount');
                subtotalElement.textContent = `$${data.cartTotal.toFixed(2)}`;
                totalElement.textContent = `$${data.cartTotal.toFixed(2)}`;

                // Update cart count
                const cartCounts = document.querySelectorAll('.cart-count');
                cartCounts.forEach(count => {
                  count.textContent = data.cartSize;
                });
              } else {
                alert('Failed to update quantity. Please try again.');
                input.value = parseInt(input.value) - change; // Revert on failure
              }
            })
            .catch(error => {
              console.error('Error updating quantity:', error);
              alert('An error occurred. Please try again.');
              input.value = parseInt(input.value) - change; // Revert on failure
            });
  }

  // Attach event listeners to quantity buttons
  document.querySelectorAll('.minus-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const productId = btn.dataset.productId;
      updateQuantity(productId, -1);
    });
  });

  document.querySelectorAll('.plus-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const productId = btn.dataset.productId;
      updateQuantity(productId, 1);
    });
  });

  // Remove button confirmation
  document.querySelectorAll('.remove-btn').forEach(button => {
    button.addEventListener('click', (e) => {
      if (!confirm('Are you sure you want to remove this item from your cart?')) {
        e.preventDefault();
      }
    });
  });

  // Modal handling
  const checkoutBtn = document.getElementById('checkoutBtn');
  const checkoutModal = document.getElementById('checkoutModal');
  const closeCheckoutModal = document.getElementById('closeCheckoutModal');
  const proceedBtn = document.getElementById('proceedBtn');
  const successModal = document.getElementById('successModal');
  const closeSuccessModal = document.getElementById('closeSuccessModal');
  const closeSuccessBtn = document.getElementById('closeSuccessBtn');

  if (checkoutBtn && checkoutModal) {
    checkoutBtn.addEventListener('click', () => {
      checkoutModal.style.display = 'block';
    });
  }

  if (closeCheckoutModal && checkoutModal) {
    closeCheckoutModal.addEventListener('click', () => {
      checkoutModal.style.display = 'none';
    });
  }

  if (proceedBtn && successModal) {
    proceedBtn.addEventListener('click', () => {
      checkoutModal.style.display = 'none';
      successModal.style.display = 'block';
    });
  }

  if (closeSuccessModal && successModal) {
    closeSuccessModal.addEventListener('click', () => {
      successModal.style.display = 'none';
    });
  }

  if (closeSuccessBtn && successModal) {
    closeSuccessBtn.addEventListener('click', () => {
      successModal.style.display = 'none';
      window.location.href = '<%= request.getContextPath() %>/home'; // Redirect to home
    });
  }

  // Close modals when clicking outside
  window.addEventListener('click', (e) => {
    if (e.target === checkoutModal) {
      checkoutModal.style.display = 'none';
    }
    if (e.target === successModal) {
      successModal.style.display = 'none';
    }
  });
</script>
</body>
</html>