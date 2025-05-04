package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.FileHandler;
import model.Product;

import java.io.IOException;
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
            List<Product> products = fileHandler.getAllProducts(getServletContext());
            request.setAttribute("products", products);
            request.getRequestDispatcher("/pages/manage-products.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageProductsServlet GET request: " + e.getMessage());
            request.setAttribute("error", "An error occurred while loading products. Please try again later.");
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
            if (!csrfToken.equals(session.getAttribute("csrfToken"))) {
                LOGGER.warning("CSRF token validation failed");
                request.setAttribute("error", "Invalid CSRF token.");
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                return;
            }

            if ("add".equals(action)) {
                Product product = new Product(
                        UUID.randomUUID().toString(),
                        request.getParameter("name"),
                        request.getParameter("description"),
                        Double.parseDouble(request.getParameter("price")),
                        Integer.parseInt(request.getParameter("stockQuantity"))
                );
                if (fileHandler.addProduct(product, getServletContext())) {
                    request.setAttribute("message", "Product added successfully.");
                } else {
                    request.setAttribute("error", "Failed to add product.");
                }
            } else if ("update".equals(action)) {
                Product product = new Product(
                        request.getParameter("productId"),
                        request.getParameter("name"),
                        request.getParameter("description"),
                        Double.parseDouble(request.getParameter("price")),
                        Integer.parseInt(request.getParameter("stockQuantity"))
                );
                if (fileHandler.updateProduct(product, getServletContext())) {
                    request.setAttribute("message", "Product updated successfully.");
                } else {
                    request.setAttribute("error", "Failed to update product.");
                }
            }

            List<Product> products = fileHandler.getAllProducts(getServletContext());
            request.setAttribute("products", products);
            request.getRequestDispatcher("/pages/manage-products.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageProductsServlet POST request: " + e.getMessage());
            request.setAttribute("error", "An error occurred while processing the request. Please try again later.");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
}