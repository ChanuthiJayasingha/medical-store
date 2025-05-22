package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for handling admin dashboard requests.
 */
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminServlet.class.getName());
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private FileHandler productFileHandler;
    private FileHandler orderFileHandler;
    private FileHandler userFileHandler;
    private FileHandler feedbackFileHandler;
    private FileHandler auditFileHandler;

    @Override
    public void init() throws ServletException {
        productFileHandler = new FileHandler(getServletContext().getRealPath("/data/products.txt"));
        orderFileHandler = new FileHandler(getServletContext().getRealPath("/data/orders.txt"));
        userFileHandler = new FileHandler(getServletContext().getRealPath("/data/users.txt"));
        feedbackFileHandler = new FileHandler(getServletContext().getRealPath("/data/feedback.txt"));
        auditFileHandler = new FileHandler(getServletContext().getRealPath("/data/audit.txt"));
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
            // Generate CSRF token if not present
            if (session.getAttribute("csrfToken") == null) {
                session.setAttribute("csrfToken", UUID.randomUUID().toString());
            }

            // Log dashboard access
            String auditLine = String.join(",",
                    UUID.randomUUID().toString(),
                    (String) session.getAttribute("username"),
                    "Accessed admin dashboard",
                    LocalDateTime.now().format(DATETIME_FORMATTER));
            List<String> auditLines = auditFileHandler.readLines();
            auditLines.add(auditLine);
            auditFileHandler.writeLines(auditLines);

            // Calculate dashboard metrics
            // Total Products
            List<String> productLines = productFileHandler.readLines();
            long totalProducts = productLines.stream().filter(line -> !line.trim().isEmpty()).count();

            // Total Orders
            List<String> orderLines = orderFileHandler.readLines();
            long totalOrders = orderLines.stream().filter(line -> !line.trim().isEmpty()).count();

            // Active Users (Users with role 'User')
            List<String> userLines = userFileHandler.readLines();
            long activeUsers = userLines.stream()
                    .filter(line -> {
                        String[] parts = line.split(",", -1);
                        return parts.length >= 4 && "User".equals(parts[3]);
                    })
                    .count();

            // Pending Orders
            long pendingOrders = orderLines.stream()
                    .filter(line -> {
                        String[] parts = line.split(",", -1);
                        return parts.length >= 5 && "Pending".equals(parts[4]);
                    })
                    .count();

            // Total Feedback
            List<String> feedbackLines = feedbackFileHandler.readLines();
            long totalFeedback = feedbackLines.stream().filter(line -> !line.trim().isEmpty()).count();

            // Set dashboard metrics
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("totalFeedback", totalFeedback);

            request.getRequestDispatcher("/pages/adminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing AdminServlet request: " + e.getMessage());
            session.setAttribute("message", "Failed to load dashboard: " + e.getMessage());
            session.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/adminDashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}