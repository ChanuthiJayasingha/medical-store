<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Online Medical Store - Login</title>
    <link rel="stylesheet" href="../Css/Login.css">
    <!-- Favicon from URL -->
    <link rel="icon" href="https://cdn-icons-png.flaticon.com/512/2969/2969620.png" type="image/png">
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <!-- Logo from URL -->
        <img src="https://cdn-icons-png.flaticon.com/512/2969/2969620.png" alt="Medical Store Logo" class="logo">
        <h1>Online Medical Store</h1>
        <p>Please login to access your account</p>
    </div>

    <div class="login-type-selector">
        <button class="login-type-btn active" id="userLoginBtn">User Login</button>
        <button class="login-type-btn" id="adminLoginBtn">Admin Login</button>
    </div>

    <form id="loginForm" action="LoginServlet" method="post">
        <input type="hidden" id="loginType" name="loginType" value="user">

        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>
        </div>

        <div class="form-options">
            <label>
                <input type="checkbox" name="remember"> Remember me
            </label>
            <a href="forgot-password.jsp">Forgot password?</a>
        </div>

        <button type="submit" class="login-btn">Login</button>

        <div class="register-link">
            Don't have an account? <a href="SignUp.jsp">Register here</a>
        </div>
    </form>
</div>

<script src="../Js/login.js"></script>
</body>
</html>