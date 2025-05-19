<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="MediCare: Shop medicines, wellness products, medical devices, and personal care from your trusted online pharmacy.">
    <meta name="keywords" content="MediCare, online pharmacy, medicines, wellness, medical devices, personal care, health products">
    <title>MediCare - Your Trusted Online Pharmacy</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Fallback and Custom CSS -->
    <style>
        body { font-family: 'Inter', Arial, sans-serif; background-color: #f7fafc; margin: 0; }
        .container { max-width: 1280px; margin: 0 auto; padding: 16px; }
        .hero-bg { background: linear-gradient(135deg, #3b82f6 0%, #10b981 100%); }
        .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-hover:hover { transform: translateY(-5px); box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15); }
        .product-card { background: white; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); padding: 16px; }
        .error-message { background: #fef2f2; color: #dc2626; padding: 16px; border-radius: 8px; margin-bottom: 24px; }
        .no-products { text-align: center; color: #4b5563; margin: 32px 0; font-size: 18px; }
        .login-dropdown { position: relative; }
        .login-dropdown-content { display: none; position: absolute; top: 100%; right: 0; background: white; box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15); border-radius: 8px; z-index: 20; min-width: 160px; }
        .login-dropdown:hover .login-dropdown-content { display: block; }
        .login-dropdown-content a { display: block; padding: 12px 24px; color: #1f2937; font-weight: 500; transition: background-color 0.2s; }
        .login-dropdown-content a:hover { background-color: #f3f4f6; color: #2563eb; }
        .cart-count { top: -8px; right: -8px; background: #ef4444; color: white; border-radius: 50%; height: 20px; width: 20px; display: flex; align-items: center; justify-content: center; font-size: 12px; }
        .category-section { margin-bottom: 32px; }
        .category-header { cursor: pointer; transition: background-color 0.2s; }
        .category-header:hover { background-color: #e5e7eb; }
        .fade-in { animation: fadeIn 0.5s ease-in; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 640px) {
            .mobile-menu { display: none; }
            .mobile-menu.active { display: block; }
        }
    </style>
    <!-- Schema.org for SEO -->
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebPage",
            "name": "MediCare Online Pharmacy",
            "description": "Shop for medicines, wellness products, medical devices, and personal care items at MediCare.",
            "breadcrumb": {
                "@type": "BreadcrumbList",
                "itemListElement": [
                    {"@type": "ListItem", "position": 1, "name": "Home", "item": "${pageContext.request.contextPath}/home"}
                ]
            }
        }
    </script>
</head>
<body class="bg-gray-50">
<!-- Navbar -->
<nav class="bg-white shadow-lg sticky top-0 z-50">
    <div class="container flex justify-between items-center py-4">
        <a href="${pageContext.request.contextPath}/home" class="text-3xl font-bold text-blue-600">MediCare</a>
        <div class="hidden md:flex items-center space-x-6">
            <div class="relative">
                <input type="text" id="searchInput" placeholder="Search medicines..."
                       class="w-80 px-4 py-2 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       aria-label="Search products">
                <i class="fas fa-search absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
            <a href="${pageContext.request.contextPath}/cart" class="relative">
                <i class="fas fa-shopping-cart text-gray-600 text-xl"></i>
                <span class="cart-count">0</span>
            </a>
            <c:choose>
                <c:when test="${not empty sessionScope.username}">
                    <div class="flex items-center space-x-4">
                        <span class="text-gray-600 font-medium">
                            Welcome, ${sessionScope.username} (${sessionScope.role})
                        </span>
                        <c:if test="${sessionScope.role == 'User'}">
                            <a href="${pageContext.request.contextPath}/pages/profile.jsp"
                               class="text-gray-600 hover:text-blue-600 font-medium">Profile</a>
                        </c:if>
                        <c:if test="${sessionScope.role == 'Admin'}">
                            <a href="${pageContext.request.contextPath}/ManageProductsServlet"
                               class="text-gray-600 hover:text-blue-600 font-medium">Manage Products</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout"
                           class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Logout</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="login-dropdown">
                        <button class="text-gray-600 hover:text-blue-600 font-semibold">Login</button>
                        <div class="login-dropdown-content">
                            <a href="${pageContext.request.contextPath}/pages/login.jsp?role=Admin">Admin Login</a>
                            <a href="${pageContext.request.contextPath}/pages/login.jsp?role=User">User Login</a>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/pages/register.jsp"
                       class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 transition">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
        <!-- Mobile Menu Toggle -->
        <button id="mobileMenuToggle" class="md:hidden text-gray-600 focus:outline-none">
            <i class="fas fa-bars text-2xl"></i>
        </button>
    </div>
    <!-- Mobile Menu -->
    <div id="mobileMenu" class="mobile-menu md:hidden bg-white shadow-lg px-4 py-4">
        <div class="relative mb-4">
            <input type="text" id="mobileSearchInput" placeholder="Search medicines..."
                   class="w-full px-4 py-2 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                   aria-label="Search products">
            <i class="fas fa-search absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
        </div>
        <c:choose>
            <c:when test="${not empty sessionScope.username}">
                <div class="flex flex-col space-y-2">
                    <span class="text-gray-600 font-medium">
                        Welcome, ${sessionScope.username} (${sessionScope.role})
                    </span>
                    <c:if test="${sessionScope.role == 'User'}">
                        <a href="${pageContext.request.contextPath}/pages/profile.jsp"
                           class="text-gray-600 hover:text-blue-600">Profile</a>
                    </c:if>
                    <c:if test="${sessionScope.role == 'Admin'}">
                        <a href="${pageContext.request.contextPath}/ManageProductsServlet"
                           class="text-gray-600 hover:text-blue-600">Manage Products</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 text-center">Logout</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="flex flex-col space-y-2">
                    <a href="${pageContext.request.contextPath}/pages/login.jsp?role=User"
                       class="text-gray-600 hover:text-blue-600">User Login</a>
                    <a href="${pageContext.request.contextPath}/pages/login.jsp?role=Admin"
                       class="text-gray-600 hover:text-blue-600">Admin Login</a>
                    <a href="${pageContext.request.contextPath}/pages/register.jsp"
                       class="bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 text-center">Sign Up</a>
                </div>
            </c:otherwise>
        </c:choose>
        <a href="${pageContext.request.contextPath}/cart" class="flex items-center mt-4 text-gray-600 hover:text-blue-600">
            <i class="fas fa-shopping-cart mr-2"></i> Cart <span class="cart-count ml-2">0</span>
        </a>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero-bg text-white py-24">
    <div class="container flex flex-col md:flex-row items-center">
        <div class="md:w-1/2 mb-8 md:mb-0">
            <h1 class="text-4xl md:text-5xl font-bold mb-4 leading-tight">Your Trusted Online Pharmacy</h1>
            <p class="text-lg md:text-xl mb-6 text-gray-100">Discover medicines, wellness essentials, and medical devices delivered to your doorstep.</p>
            <a href="#shop" class="bg-white text-blue-600 px-8 py-3 rounded-full font-semibold hover:bg-gray-100 transition">Shop Now</a>
        </div>
        <div class="md:w-1/2">
            <img src="https://www.naturesbounty.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/0/0/00837_1.jpg"
                 alt="Wellness Products" class="rounded-xl shadow-2xl w-full h-72 object-contain">
        </div>
    </div>
</section>

<!-- Categories Section -->
<section id="categories" class="py-16 bg-white">
    <div class="container">
        <h2 class="text-3xl font-bold text-gray-800 mb-8 text-center">Shop by Category</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <a href="${pageContext.request.contextPath}/category?cat=Medicines"
               class="card-hover bg-gray-50 p-6 rounded-xl text-center">
                <i class="fas fa-pills text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-800">Medicines</h3>
                <p class="text-gray-600 text-sm">Prescription & OTC Drugs</p>
            </a>
            <a href="${pageContext.request.contextPath}/category?cat=Wellness"
               class="card-hover bg-gray-50 p-6 rounded-xl text-center">
                <i class="fas fa-heartbeat text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-800">Wellness</h3>
                <p class="text-gray-600 text-sm">Vitamins & Supplements</p>
            </a>
            <a href="${pageContext.request.contextPath}/category?cat=Devices"
               class="card-hover bg-gray-50 p-6 rounded-xl text-center">
                <i class="fas fa-stethoscope text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-800">Devices</h3>
                <p class="text-gray-600 text-sm">Health Monitoring Devices</p>
            </a>
            <a href="${pageContext.request.contextPath}/category?cat=Personal Care"
               class="card-hover bg-gray-50 p-6 rounded-xl text-center">
                <i class="fas fa-spa text-4xl text-blue-600 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-800">Personal Care</h3>
                <p class="text-gray-600 text-sm">Skincare & Hygiene</p>
            </a>
        </div>
    </div>
</section>

<!-- Products Section -->
<section id="shop" class="py-16 bg-gray-50">
    <div class="container">
        <div class="flex justify-between items-center mb-8">
            <h2 class="text-3xl font-bold text-gray-800">Our Products</h2>
            <div class="flex space-x-2">
                <button data-category="all" class="category-filter bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 active">All</button>
                <button data-category="Medicines" class="category-filter bg-gray-200 text-gray-700 px-4 py-2 rounded-full hover:bg-blue-600 hover:text-white">Medicines</button>
                <button data-category="Wellness" class="category-filter bg-gray-200 text-gray-700 px-4 py-2 rounded-full hover:bg-blue-600 hover:text-white">Wellness</button>
                <button data-category="Devices" class="category-filter bg-gray-200 text-gray-700 px-4 py-2 rounded-full hover:bg-blue-600 hover:text-white">Devices</button>
                <button data-category="Personal Care" class="category-filter bg-gray-200 text-gray-700 px-4 py-2 rounded-full hover:bg-blue-600 hover:text-white">Personal Care</button>
            </div>
        </div>
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <!-- Categorized Products -->
        <c:choose>
            <c:when test="${not empty products && products.size() > 0}">
                <c:set var="categories" value="Medicines,Wellness,Devices,Personal Care" />
                <c:forEach var="category" items="${categories.split(',')}">
                    <div class="category-section">
                        <div class="category-header bg-gray-100 rounded-lg p-4 mb-4 flex justify-between items-center">
                            <h3 class="text-2xl font-semibold text-gray-800">${category}</h3>
                            <i class="fas fa-chevron-down text-gray-600 toggle-icon"></i>
                        </div>
                        <div class="category-products grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6" data-category="${category}">
                            <c:forEach var="product" items="${products}">
                                <c:if test="${product.category == category}">
                                    <div class="product-card card-hover fade-in"
                                         data-name="${product.name.toLowerCase()}"
                                         data-description="${product.description.toLowerCase()}"
                                         data-category="${product.category}"
                                         itemscope itemtype="https://schema.org/Product">
                                        <img src="${product.imageUrl}" alt="${product.name}"
                                             class="w-full h-48 object-contain mb-4 rounded-lg" loading="lazy" itemprop="image">
                                        <h3 class="text-lg font-semibold text-gray-800 mb-2" itemprop="name">${product.name}</h3>
                                        <p class="text-sm text-gray-600 mb-3 line-clamp-2" itemprop="description">${product.description}</p>
                                        <div class="flex justify-between items-center mb-4">
                                            <span class="text-xl font-bold text-blue-600" itemprop="offers" itemscope
                                                  itemtype="https://schema.org/Offer">
                                                <span itemprop="priceCurrency" content="USD">$</span>
                                                <span itemprop="price" content="${product.price}">${product.price}</span>
                                            </span>
                                            <span class="${product.stockQuantity > 0 ? 'text-green-600' : 'text-red-600'} text-sm font-medium">
                                                    ${product.stockQuantity > 0 ? 'In Stock' : 'Out of Stock'}
                                            </span>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <button type="submit"
                                                    class="w-full bg-blue-600 text-white py-2 rounded-full hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition"
                                                ${product.stockQuantity == 0 ? 'disabled' : ''}>
                                                <i class="fas fa-cart-plus mr-2"></i>Add to Cart
                                            </button>
                                        </form>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="no-products">
                    No products available. Please try again later or contact support.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- Footer -->
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

<!-- JavaScript for Interactivity -->
<script>
    try {
        // Search Functionality
        const searchInputs = [document.getElementById('searchInput'), document.getElementById('mobileSearchInput')];
        const productCards = document.querySelectorAll('.product-card');
        const categorySections = document.querySelectorAll('.category-section');
        const noProductsDiv = document.querySelector('.no-products');

        searchInputs.forEach(input => {
            if (input) {
                input.addEventListener('input', () => {
                    const query = input.value.toLowerCase().trim();
                    let hasResults = false;

                    productCards.forEach(card => {
                        const name = card.dataset.name;
                        const description = card.dataset.description;
                        const matches = name.includes(query) || description.includes(query);
                        card.style.display = matches ? '' : 'none';
                        if (matches) hasResults = true;
                    });

                    categorySections.forEach(section => {
                        const visibleCards = section.querySelectorAll('.product-card:not([style*="display: none"])');
                        section.style.display = visibleCards.length > 0 || query === '' ? '' : 'none';
                    });

                    if (noProductsDiv) {
                        noProductsDiv.style.display = hasResults || productCards.length === 0 ? 'none' : 'block';
                    }
                });
            }
        });

        // Category Filter
        const categoryFilters = document.querySelectorAll('.category-filter');
        categoryFilters.forEach(button => {
            button.addEventListener('click', () => {
                const category = button.dataset.category;
                categoryFilters.forEach(btn => {
                    btn.classList.remove('bg-blue-600', 'text-white', 'active');
                    btn.classList.add('bg-gray-200', 'text-gray-700');
                });
                button.classList.add('bg-blue-600', 'text-white', 'active');
                button.classList.remove('bg-gray-200', 'text-gray-700');

                let hasResults = false;
                categorySections.forEach(section => {
                    const sectionCategory = section.querySelector('.category-products').dataset.category;
                    const matches = category === 'all' || sectionCategory === category;
                    section.style.display = matches ? '' : 'none';
                    if (matches) hasResults = true;
                });

                if (noProductsDiv) {
                    noProductsDiv.style.display = hasResults || productCards.length === 0 ? 'none' : 'block';
                }
            });
        });

        // Toggle Category Sections
        const categoryHeaders = document.querySelectorAll('.category-header');
        categoryHeaders.forEach(header => {
            header.addEventListener('click', () => {
                const products = header.nextElementSibling;
                const icon = header.querySelector('.toggle-icon');
                const isHidden = products.style.display === 'none';
                products.style.display = isHidden ? '' : 'none';
                icon.classList.toggle('fa-chevron-down', isHidden);
                icon.classList.toggle('fa-chevron-up', !isHidden);
            });
        });

        // Mobile Menu Toggle
        const mobileMenuToggle = document.getElementById('mobileMenuToggle');
        const mobileMenu = document.getElementById('mobileMenu');
        if (mobileMenuToggle && mobileMenu) {
            mobileMenuToggle.addEventListener('click', () => {
                mobileMenu.classList.toggle('active');
            });
        }

        // Add to Cart (Placeholder)
        document.querySelectorAll('.product-card form button').forEach(button => {
            button.addEventListener('click', (e) => {
                if (!button.disabled) {
                    const cartCount = document.querySelectorAll('.cart-count');
                    cartCount.forEach(count => {
                        count.textContent = parseInt(count.textContent) + 1;
                    });
                    alert('Item added to cart!');
                }
            });
        });
    } catch (error) {
        console.error('JavaScript error in index.jsp:', error);
    }
</script>
</body>
</html>