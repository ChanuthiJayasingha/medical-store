package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import services.FileHandler;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private FileHandler fileHandler;

    @Override
    public void init() throws ServletException {
        fileHandler = new FileHandler(getServletContext());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Debug logging
        System.out.println("Login attempt for username: " + username);
        
        // Make role determination more flexible
        String role = null;
        
        // First try as admin
        if (fileHandler.authenticateUser(username, password, "admin")) {
            role = "admin";
        } 
        // Then try as regular user
        else if (fileHandler.authenticateUser(username, password, "user")) {
            role = "user";
        }
        
        if (role != null) {
            // Authentication successful
            System.out.println("Login successful for: " + username + " with role: " + role);
            
            HttpSession session = request.getSession();
            session.setAttribute("user", username);
            session.setAttribute("role", role);
            
            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/pages/adminDashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/userDashboard.jsp");
            }
        } else {
            // Authentication failed
            System.out.println("Login failed for: " + username);
            
            request.setAttribute("errorMessage", "Invalid username or password");
            request.setAttribute("showLoginModal", true);
            request.getRequestDispatcher("/pages/index.jsp").forward(request, response);
        }
    }
}
