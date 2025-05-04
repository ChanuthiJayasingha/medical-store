package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.FileHandler;

import java.io.IOException;
import java.util.logging.Logger;

/**
 * Servlet for handling admin dashboard requests.
 */
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminServlet.class.getName());
    private final FileHandler fileHandler;

    /**
     * Constructor for dependency injection.
     *
     * @param fileHandler The FileHandler instance
     */
    public AdminServlet(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    /**
     * Default constructor for servlet container.
     */
    public AdminServlet() {
        this(new FileHandler());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to AdminServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            request.setAttribute("totalProducts", fileHandler.getTotalProducts(getServletContext()));
            request.setAttribute("totalOrders", fileHandler.getTotalOrders(getServletContext()));
            request.setAttribute("activeUsers", fileHandler.getActiveUsers(getServletContext()));
            request.setAttribute("pendingOrders", fileHandler.getPendingOrders(getServletContext()));
            request.getRequestDispatcher("/pages/adminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing AdminServlet request: " + e.getMessage());
            request.setAttribute("error", "An error occurred while loading the dashboard. Please try again later.");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}