<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - My Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="user-styles.css">
</head>
<body>
<div class="user-dashboard-container">
    <!-- Header -->
    <header class="user-header">
        <div class="logo">
            <a href="#">
                <i class="fas fa-heartbeat"></i>
                <span>MediCare</span>
            </a>
        </div>
        <nav class="user-nav">
            <ul>
                <li><a href="#"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="#"><i class="fas fa-pills"></i> Shop</a></li>
                <li><a href="#"><i class="fas fa-prescription-bottle-alt"></i> Prescriptions</a></li>
                <li><a href="#"><i class="fas fa-question-circle"></i> Help</a></li>
            </ul>
        </nav>
        <div class="user-actions">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search medicines...">
            </div>
            <div class="cart">
                <i class="fas fa-shopping-cart"></i>
                <span class="cart-count">3</span>
            </div>
            <div class="user-profile">
                <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="User">
                <span>Sarah Johnson</span>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="user-main-content">
        <!-- Sidebar -->
        <aside class="user-sidebar">
            <div class="user-info">
                <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="User">
                <h3>Sarah Johnson</h3>
                <p>Member since: Jan 2022</p>
            </div>
            <ul class="user-menu">
                <li class="active"><a href="#"><i class="fas fa-user"></i> My Profile</a></li>
                <li><a href="#"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
                <li><a href="#"><i class="fas fa-prescription-bottle-alt"></i> My Prescriptions</a></li>
                <li><a href="#"><i class="fas fa-heart"></i> My Wishlist</a></li>
                <li><a href="#"><i class="fas fa-map-marker-alt"></i> Address Book</a></li>
                <li><a href="#"><i class="fas fa-bell"></i> Notifications</a></li>
                <li><a href="#"><i class="fas fa-cog"></i> Settings</a></li>
                <li><a href="#"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </aside>

        <!-- Dashboard Content -->
        <div class="user-dashboard-content">
            <div class="welcome-banner">
                <h1>Welcome back, Sarah!</h1>
                <p>Here's what's happening with your account today.</p>
            </div>

            <!-- Quick Stats -->
            <div class="quick-stats">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-shopping-bag"></i>
                    </div>
                    <div class="stat-info">
                        <h3>5</h3>
                        <p>Active Orders</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h3>12</h3>
                        <p>Completed Orders</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="stat-info">
                        <h3>8</h3>
                        <p>Wishlist Items</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-prescription-bottle-alt"></i>
                    </div>
                    <div class="stat-info">
                        <h3>3</h3>
                        <p>Active Prescriptions</p>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2>Recent Orders</h2>
                    <a href="#" class="view-all">View All</a>
                </div>
                <div class="orders-list">
                    <div class="order-card">
                        <div class="order-info">
                            <h4>Order #MED78945</h4>
                            <p>Placed on May 10, 2023</p>
                            <div class="order-status shipped">
                                <i class="fas fa-truck"></i>
                                Shipped
                            </div>
                        </div>
                        <div class="order-details">
                            <div class="order-items">
                                <img src="https://via.placeholder.com/60" alt="Product">
                                <img src="https://via.placeholder.com/60" alt="Product">
                                <img src="https://via.placeholder.com/60" alt="Product">
                                <span class="more-items">+2 more</span>
                            </div>
                            <div class="order-total">
                                <h4>$87.50</h4>
                                <a href="#" class="btn btn-outline">Track Order</a>
                            </div>
                        </div>
                    </div>
                    <div class="order-card">
                        <div class="order-info">
                            <h4>Order #MED78944</h4>
                            <p>Placed on May 5, 2023</p>
                            <div class="order-status delivered">
                                <i class="fas fa-check-circle"></i>
                                Delivered
                            </div>
                        </div>
                        <div class="order-details">
                            <div class="order-items">
                                <img src="https://via.placeholder.com/60" alt="Product">
                                <img src="https://via.placeholder.com/60" alt="Product">
                            </div>
                            <div class="order-total">
                                <h4>$42.99</h4>
                                <a href="#" class="btn btn-outline">Reorder</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Health Reminders -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2>Health Reminders</h2>
                    <a href="#" class="view-all">Manage</a>
                </div>
                <div class="reminders-list">
                    <div class="reminder-card">
                        <div class="reminder-icon">
                            <i class="fas fa-pills"></i>
                        </div>
                        <div class="reminder-info">
                            <h4>Vitamin D3</h4>
                            <p>Take 1 capsule daily with breakfast</p>
                            <div class="reminder-time">
                                <i class="fas fa-clock"></i>
                                8:00 AM (Daily)
                            </div>
                        </div>
                        <div class="reminder-actions">
                            <button class="btn btn-success">Taken</button>
                        </div>
                    </div>
                    <div class="reminder-card">
                        <div class="reminder-icon">
                            <i class="fas fa-prescription-bottle-alt"></i>
                        </div>
                        <div class="reminder-info">
                            <h4>Amoxicillin</h4>
                            <p>Take 1 tablet every 8 hours (3 times daily)</p>
                            <div class="reminder-time">
                                <i class="fas fa-clock"></i>
                                Next dose at 2:00 PM
                            </div>
                        </div>
                        <div class="reminder-actions">
                            <button class="btn btn-outline">Snooze</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recommended Products -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2>Recommended For You</h2>
                    <a href="#" class="view-all">Browse All</a>
                </div>
                <div class="products-grid">
                    <div class="product-card">
                        <div class="product-badge">15% OFF</div>
                        <img src="https://via.placeholder.com/150" alt="Product">
                        <div class="product-info">
                            <h4>Vitamin C 1000mg</h4>
                            <p>60 Tablets</p>
                            <div class="product-price">
                                <span class="current-price">$12.99</span>
                                <span class="original-price">$15.29</span>
                            </div>
                            <button class="btn btn-primary">Add to Cart</button>
                        </div>
                    </div>
                    <div class="product-card">
                        <img src="https://via.placeholder.com/150" alt="Product">
                        <div class="product-info">
                            <h4>Omega-3 Fish Oil</h4>
                            <p>120 Softgels</p>
                            <div class="product-price">
                                <span class="current-price">$18.50</span>
                            </div>
                            <button class="btn btn-primary">Add to Cart</button>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-badge">NEW</div>
                        <img src="https://via.placeholder.com/150" alt="Product">
                        <div class="product-info">
                            <h4>Probiotic Complex</h4>
                            <p>30 Capsules</p>
                            <div class="product-price">
                                <span class="current-price">$24.99</span>
                            </div>
                            <button class="btn btn-primary">Add to Cart</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="user-footer">
        <div class="footer-content">
            <div class="footer-section">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="#">Home</a></li>
                    <li><a href="#">Shop</a></li>
                    <li><a href="#">Prescriptions</a></li>
                    <li><a href="#">My Account</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Customer Service</h4>
                <ul>
                    <li><a href="#">Contact Us</a></li>
                    <li><a href="#">FAQs</a></li>
                    <li><a href="#">Shipping Policy</a></li>
                    <li><a href="#">Returns & Refunds</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>About MediCare</h4>
                <ul>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms & Conditions</a></li>
                    <li><a href="#">Blog</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Connect With Us</h4>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
                <div class="newsletter">
                    <p>Subscribe to our newsletter</p>
                    <div class="newsletter-input">
                        <input type="email" placeholder="Your email">
                        <button><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2023 MediCare. All rights reserved.</p>
            <div class="payment-methods">
                <i class="fab fa-cc-visa"></i>
                <i class="fab fa-cc-mastercard"></i>
                <i class="fab fa-cc-paypal"></i>
                <i class="fab fa-cc-apple-pay"></i>
            </div>
        </div>
    </footer>
</div>

<script src="user-script.js"></script>
</body>
</html>