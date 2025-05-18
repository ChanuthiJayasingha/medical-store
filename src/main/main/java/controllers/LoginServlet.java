package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.FileHandler;

import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for handling user login in the MediCare system.
 */
public class LoginServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private FileHandler fileHandler;

    @Override
    public void init() throws ServletException {
        fileHandler = new FileHandler(getServletContext().getRealPath("/data/users.txt"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username == null || password == null || role == null) {
            request.setAttribute("message", "All fields are required");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        try {
            List<String> userLines = fileHandler.readLines();
            boolean isAuthenticated = userLines.stream()
                    .anyMatch(line -> {
                        String[] parts = line.split(",", -1);
                        return parts.length >= 4 &&
                                parts[1].equals(username) &&
                                parts[2].equals(password) &&
                                parts[3].equals(role);
                    });

            if (isAuthenticated) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                session.setAttribute("csrfToken", UUID.randomUUID().toString()); // Set CSRF token
                if ("Admin".equals(role)) {
                    response.sendRedirect("pages/adminDashboard.jsp");
                } else {
                    response.sendRedirect("pages/index.jsp");
                }
            } else {
                request.setAttribute("message", "Invalid username, password, or role");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing LoginServlet POST request: " + e.getMessage());
            request.setAttribute("message", "An error occurred: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }
}