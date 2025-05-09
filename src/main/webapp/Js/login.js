document.addEventListener('DOMContentLoaded', function() {
    const userLoginBtn = document.getElementById('userLoginBtn');
    const adminLoginBtn = document.getElementById('adminLoginBtn');
    const loginForm = document.getElementById('loginForm');
    const loginTypeInput = document.getElementById('loginType');
    const loginContainer = document.querySelector('.login-container');

    // Switch between user and admin login
    userLoginBtn.addEventListener('click', function() {
        userLoginBtn.classList.add('active');
        adminLoginBtn.classList.remove('active');
        loginTypeInput.value = 'user';
        loginContainer.classList.remove('admin-login');
    });

    adminLoginBtn.addEventListener('click', function() {
        adminLoginBtn.classList.add('active');
        userLoginBtn.classList.remove('active');
        loginTypeInput.value = 'admin';
        loginContainer.classList.add('admin-login');
    });

    // Form submission
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();

        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value.trim();
        const loginType = loginTypeInput.value;

        // Basic validation
        if (!username || !password) {
            alert('Please enter both username and password');
            return;
        }

        // You can add more specific validation here if needed

        // Submit the form
        this.submit();
    });

    // Check if there's a login error message from server
    const urlParams = new URLSearchParams(window.location.search);
    const error = urlParams.get('error');
    if (error) {
        alert(error);
    }
});