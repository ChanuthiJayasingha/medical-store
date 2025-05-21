//package controllers;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import model.User;
//import services.FileHandler;
//
//public class RegisterServlet extends HttpServlet {
//    private FileHandler fileHandler = new FileHandler();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String fullName = request.getParameter("fullName");
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//        String contactNo = request.getParameter("contactNo");
//        String email = request.getParameter("email");
//        String address = request.getParameter("address");
//        String birthday = request.getParameter("birthday");
//        String gender = request.getParameter("gender");
//        String role = "User"; // Hardcoded to User
//
//        // Basic validation
//        if (fullName == null || fullName.trim().isEmpty() ||
//                username == null || username.trim().isEmpty() ||
//                password == null || password.trim().isEmpty() ||
//                contactNo == null || contactNo.trim().isEmpty() ||
//                email == null || email.trim().isEmpty() ||
//                address == null || address.trim().isEmpty() ||
//                birthday == null || birthday.trim().isEmpty() ||
//                gender == null || gender.trim().isEmpty()) {
//            request.setAttribute("errorMessage", "All fields are required");
//            request.getRequestDispatcher("pages/register.jsp").forward(request, response);
//            return;
//        }
//
//        // Additional validation
//        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
//            request.setAttribute("errorMessage", "Invalid email format");
//            request.getRequestDispatcher("pages/register.jsp").forward(request, response);
//            return;
//        }
//        if (!contactNo.matches("\\d{10}")) {
//            request.setAttribute("errorMessage", "Contact number must be 10 digits");
//            request.getRequestDispatcher("pages/register.jsp").forward(request, response);
//            return;
//        }
//        if (!birthday.matches("\\d{4}-\\d{2}-\\d{2}")) {
//            request.setAttribute("errorMessage", "Birthday must be in YYYY-MM-DD format");
//            request.getRequestDispatcher("pages/register.jsp").forward(request, response);
//            return;
//        }
//
//        User user = new User(fullName, username, password, role, contactNo, email, address, birthday, gender);
//        boolean isRegistered = fileHandler.registerUser(user, getServletContext());
//
//        if (isRegistered) {
//            response.sendRedirect("pages/login.jsp?role=User");
//        } else {
//            request.setAttribute("errorMessage", "Registration failed: Username may already exist");
//            request.getRequestDispatcher("pages/register.jsp").forward(request, response);
//        }
//    }
//}