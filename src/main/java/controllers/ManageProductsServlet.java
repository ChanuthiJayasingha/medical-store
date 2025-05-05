package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.AuditLog;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing products in the MediCare system.
 */
public class ManageProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageProductsServlet.class.getName());
    private final FileHandler fileHandler;

    /**
     * Constructor for dependency injection.
     *
     * @param fileHandler The FileHandler instance
     */
    public ManageProductsServlet(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    /**
     * Default constructor for servlet container.
     */
    public ManageProductsServlet() {
        this(new FileHandler());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageProductsServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            // Generate CSRF token if not present
            if (session.getAttribute("csrfToken") == null) {
                session.setAttribute("csrfToken", UUID.randomUUID().toString());
            }

            List<Product> products = fileHandler.getAllProducts(getServletContext());
            request.setAttribute("products", products);
            request.getRequestDispatcher("/pages/manage-products.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageProductsServlet GET request: " + e.getMessage());
            request.setAttribute("error", "Failed to load products: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageProductsServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            String action = request.getParameter("action");
            String csrfToken = request.getParameter("csrfToken");
            if (csrfToken == null || !csrfToken.equals(session.getAttribute("csrfToken"))) {
                LOGGER.warning("CSRF token validation failed");
                session.setAttribute("notification", "Invalid CSRF token.");
                session.setAttribute("notificationType", "error");
                response.sendRedirect(request.getContextPath() + "/ManageProductsServlet");
                return;
            }

            String username = (String) session.getAttribute("username");

            if ("add".equals(action)) {
                String productId = UUID.randomUUID().toString();
                Product product = new Product(
                        productId,
                        request.getParameter("name"),
                        request.getParameter("description"),
                        Double.parseDouble(request.getParameter("price")),
                        Integer.parseInt(request.getParameter("stockQuantity"))
                );
                if (fileHandler.addProduct(product, getServletContext())) {
                    AuditLog auditLog = new AuditLog(
                            UUID.randomUUID().toString(),
                            username,
                            "Added product: " + productId,
                            LocalDateTime.now()
                    );
                    fileHandler.addAuditLog(auditLog, getServletContext());
                    session.setAttribute("notification", "Product added successfully.");
                    session.setAttribute("notificationType", "success");
                } else {
                    session.setAttribute("notification", "Failed to add product.");
                    session.setAttribute("notificationType", "error");
                }
            } else if ("update".equals(action)) {
                String productId = request.getParameter("productId");
                Product product = new Product(
                        productId,
                        request.getParameter("name"),
                        request.getParameter("description"),
                        Double.parseDouble(request.getParameter("price")),
                        Integer.parseInt(request.getParameter("stockQuantity"))
                );
                if (fileHandler.updateProduct(product, getServletContext())) {
                    AuditLog auditLog = new AuditLog(
                            UUID.randomUUID().toString(),
                            username,
                            "Updated product: " + productId,
                            LocalDateTime.now()
                    );
                    fileHandler.addAuditLog(auditLog, getServletContext());
                    session.setAttribute("notification", "Product updated successfully.");
                    session.setAttribute("notificationType", "success");
                } else {
                    session.setAttribute("notification", "Failed to update product.");
                    session.setAttribute("notificationType", "error");
                }
            }

            response.sendRedirect(request.getContextPath() + "/ManageProductsServlet");
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input in ManageProductsServlet POST request: " + e.getMessage());
            session.setAttribute("notification", "Invalid input: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageProductsServlet");
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageProductsServlet POST request: " + e.getMessage());
            session.setAttribute("notification", "An error occurred: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageProductsServlet");
        }
    }
}