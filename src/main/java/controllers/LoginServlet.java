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
        fileHandler = new FileHandler();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        // For this example, treat 'admin' as admin, everything else as user
        String role = "user";
        if ("admin".equalsIgnoreCase(username)) {
            role = "admin";
        }

        boolean authenticated = fileHandler.authenticateUser(username, password, role);

        if (authenticated) {
            HttpSession session = request.getSession();
            session.setAttribute("user", username);
            session.setAttribute("role", role);
            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/pages/adminDashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/userDashboard.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.setAttribute("showLoginModal", true);
            request.getRequestDispatcher("/pages/index.jsp").forward(request, response);
        }
    }
}
