package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing orders in the MediCare system.
 */
public class ManageOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageOrdersServlet.class.getName());
    private FileHandler orderFileHandler;

    @Override
    public void init() throws ServletException {
        orderFileHandler = new FileHandler(getServletContext().getRealPath("/data/orders.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageOrdersServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        List<String> orders = orderFileHandler.readLines();
        if (orders == null) orders = new ArrayList<>();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/pages/view-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageOrdersServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String csrfToken = request.getParameter("csrfToken");
        if (!csrfToken.equals(session.getAttribute("csrfToken"))) {
            LOGGER.warning("CSRF token validation failed");
            session.setAttribute("message", "Invalid CSRF token.");
            session.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/view-orders.jsp").forward(request, response);
            return;
        }

        try {
            List<String> orders = orderFileHandler.readLines();
            if (orders == null) orders = new ArrayList<>();

            switch (action) {
                case "add":
                    handleAdd(request, orders);
                    break;
                case "edit":
                    handleEdit(request, orders);
                    break;
                case "remove":
                    handleRemove(request, orders);
                    break;
                default:
                    throw new IllegalArgumentException("Invalid action: " + action);
            }

            orderFileHandler.writeLines(orders);
            session.setAttribute("message", action.equals("add") ? "Order added successfully." :
                    action.equals("edit") ? "Order updated successfully." : "Order deleted successfully.");
            session.setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/ManageOrdersServlet");
        } catch (Exception e) {
            LOGGER.severe("Error processing POST request: " + e.getMessage());
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/view-orders.jsp").forward(request, response);
        }
    }

    private void handleAdd(HttpServletRequest request, List<String> orders) {
        String username = request.getParameter("username");
        String productId = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        String status = request.getParameter("status");
        String orderDate = request.getParameter("orderDate");

        if (username == null || username.trim().isEmpty() || productId == null || productId.trim().isEmpty() ||
                quantityStr == null || status == null || orderDate == null) {
            throw new IllegalArgumentException("All fields are required for adding an order.");
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity < 1) throw new IllegalArgumentException("Quantity must be at least 1.");
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid quantity format.");
        }

        try {
            LocalDate.parse(orderDate);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid order date format.");
        }

        String orderId = UUID.randomUUID().toString();
        String newOrder = String.join(",", orderId, username.trim(), productId.trim(),
                quantityStr, status.trim(), orderDate);
        orders.add(newOrder);
    }

    private void handleEdit(HttpServletRequest request, List<String> orders) {
        String orderId = request.getParameter("orderId");
        String username = request.getParameter("username");
        String productId = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        String status = request.getParameter("status");
        String orderDate = request.getParameter("orderDate");

        if (orderId == null || orderId.trim().isEmpty() || username == null || username.trim().isEmpty() ||
                productId == null || productId.trim().isEmpty() || quantityStr == null || status == null || orderDate == null) {
            throw new IllegalArgumentException("All fields are required for editing an order.");
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity < 1) throw new IllegalArgumentException("Quantity must be at least 1.");
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid quantity format.");
        }

        try {
            LocalDate.parse(orderDate);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid order date format.");
        }

        boolean found = false;
        for (int i = 0; i < orders.size(); i++) {
            String[] parts = orders.get(i).split(",");
            if (parts[0].equals(orderId.trim())) {
                String updatedOrder = String.join(",", orderId.trim(), username.trim(), productId.trim(),
                        quantityStr, status.trim(), orderDate);
                orders.set(i, updatedOrder);
                found = true;
                break;
            }
        }
        if (!found) {
            throw new IllegalArgumentException("Order with ID '" + orderId + "' not found.");
        }
    }

    private void handleRemove(HttpServletRequest request, List<String> orders) {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            throw new IllegalArgumentException("Order ID is required for removal.");
        }
        boolean removed = orders.removeIf(line -> line.split(",")[0].equals(orderId.trim()));
        if (!removed) {
            throw new IllegalArgumentException("Order with ID '" + orderId + "' not found.");
        }
    }
}