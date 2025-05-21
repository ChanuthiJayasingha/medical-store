package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import services.FileHandler;

public class LoginServlet extends HttpServlet {
    private FileHandler fileHandler = new FileHandler();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username != null && password != null && role != null) {
            boolean isAuthenticated = fileHandler.authenticateUser(username, password, role, getServletContext());
            if (isAuthenticated) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                if ("Admin".equals(role)) {
                    response.sendRedirect("pages/adminDashboard.jsp");
                } else {
                    response.sendRedirect("pages/index.jsp");
                }
            } else {
                request.setAttribute("errorMessage", "Invalid username, password, or role");
                request.getRequestDispatcher("pages/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("pages/login.jsp").forward(request, response);
        }
    }
}