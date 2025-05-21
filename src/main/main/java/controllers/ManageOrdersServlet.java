package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.FileHandler;
import model.Order;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing orders in the MediCare system.
 */
public class ManageOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageOrdersServlet.class.getName());
    private final FileHandler fileHandler;

    /**
     * Constructor for dependency injection.
     *
     * @param fileHandler The FileHandler instance
     */
    public ManageOrdersServlet(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    /**
     * Default constructor for servlet container.
     */
    public ManageOrdersServlet() {
        this(new FileHandler());
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

        try {
            List<Order> orders = fileHandler.getAllOrders(getServletContext());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/pages/view-orders.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageOrdersServlet GET request: " + e.getMessage());
            request.setAttribute("error", "An error occurred while loading orders. Please try again later.");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
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

        try {
            String action = request.getParameter("action");
            String csrfToken = request.getParameter("csrfToken");
            if (!csrfToken.equals(session.getAttribute("csrfToken"))) {
                LOGGER.warning("CSRF token validation failed");
                request.setAttribute("error", "Invalid CSRF token.");
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                return;
            }

            if ("add".equals(action)) {
                Order order = new Order(
                        UUID.randomUUID().toString(),
                        request.getParameter("username"),
                        request.getParameter("productId"),
                        Integer.parseInt(request.getParameter("quantity")),
                        request.getParameter("status"),
                        LocalDate.parse(request.getParameter("orderDate"))
                );
                if (fileHandler.addOrder(order, getServletContext())) {
                    request.setAttribute("message", "Order added successfully.");
                } else {
                    request.setAttribute("error", "Failed to add order.");
                }
            } else if ("update".equals(action)) {
                Order order = new Order(
                        request.getParameter("orderId"),
                        request.getParameter("username"),
                        request.getParameter("productId"),
                        Integer.parseInt(request.getParameter("quantity")),
                        request.getParameter("status"),
                        LocalDate.parse(request.getParameter("orderDate"))
                );
                if (fileHandler.updateOrder(order, getServletContext())) {
                    request.setAttribute("message", "Order updated successfully.");
                } else {
                    request.setAttribute("error", "Failed to update order.");
                }
            }

            List<Order> orders = fileHandler.getAllOrders(getServletContext());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/pages/view-orders.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageOrdersServlet POST request: " + e.getMessage());
            request.setAttribute("error", "An error occurred while processing the request. Please try again later.");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
}