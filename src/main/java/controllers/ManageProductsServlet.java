package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing products.txt in the MediCare system.
 */
public class ManageProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageProductsServlet.class.getName());
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private FileHandler productFileHandler;
    private FileHandler auditFileHandler;

    @Override
    public void init() throws ServletException {
        productFileHandler = new FileHandler(getServletContext().getRealPath("/data/products.txt"));
        auditFileHandler = new FileHandler(getServletContext().getRealPath("/data/audit.txt"));
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

            List<String> lines = productFileHandler.readLines();
            List<Product> products = new ArrayList<>();
            for (String line : lines) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 7) {
                    try {
                        products.add(new Product(
                                parts[0], // productId
                                parts[1], // name
                                parts[2], // description
                                Double.parseDouble(parts[3]), // price
                                Integer.parseInt(parts[4]), // stockQuantity
                                parts[5], // imageUrl
                                parts[6] // category
                        ));
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid product data: " + line);
                    }
                }
            }
            request.setAttribute("products", products);
            request.getRequestDispatcher("/pages/manage-products.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageProductsServlet GET request: " + e.getMessage());
            session.setAttribute("message", "Failed to load products: " + e.getMessage());
            session.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/manage-products.jsp").forward(request, response);
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
                session.setAttribute("message", "Invalid CSRF token.");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/ManageProductsServlet");
                return;
            }

            String username = (String) session.getAttribute("username");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockQuantityStr = request.getParameter("stockQuantity");
            String imageUrl = request.getParameter("imageUrl");
            String category = request.getParameter("category");

            if (name == null || description == null || priceStr == null || stockQuantityStr == null) {
                throw new IllegalArgumentException("All fields are required.");
            }

            double price;
            int stockQuantity;
            try {
                price = Double.parseDouble(priceStr);
                if (price <= 0) throw new IllegalArgumentException("Price must be positive.");
                stockQuantity = Integer.parseInt(stockQuantityStr);
                if (stockQuantity < 0) throw new IllegalArgumentException("Stock quantity cannot be negative.");
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid price or stock quantity format.");
            }

            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = "https://via.placeholder.com/200";
            }
            if (category == null || category.trim().isEmpty()) {
                category = "Medicines";
            }

            List<String> productLines = productFileHandler.readLines();
            if ("add".equals(action)) {
                String productId = UUID.randomUUID().toString();
                String productLine = String.join(",", productId, name, description, priceStr, stockQuantityStr, imageUrl, category);
                productLines.add(productLine);

                productFileHandler.writeLines(productLines);

                // Log audit action
                String auditLine = String.join(",",
                        UUID.randomUUID().toString(),
                        username,
                        "Added product: " + productId,
                        LocalDateTime.now().format(DATETIME_FORMATTER));
                List<String> auditLines = auditFileHandler.readLines();
                auditLines.add(auditLine);
                auditFileHandler.writeLines(auditLines);

                session.setAttribute("message", "Product added successfully.");
                session.setAttribute("messageType", "success");
            } else if ("update".equals(action)) {
                String productId = request.getParameter("productId");
                if (productId == null || productId.trim().isEmpty()) {
                    throw new IllegalArgumentException("Product ID is required.");
                }

                boolean found = false;
                for (int i = 0; i < productLines.size(); i++) {
                    String[] parts = productLines.get(i).split(",");
                    if (parts[0].equals(productId)) {
                        productLines.set(i, String.join(",", productId, name, description, priceStr, stockQuantityStr, imageUrl, category));
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    throw new IllegalArgumentException("Product with ID '" + productId + "' not found.");
                }

                productFileHandler.writeLines(productLines);

                // Log audit action
                String auditLine = String.join(",",
                        UUID.randomUUID().toString(),
                        username,
                        "Updated product: " + productId,
                        LocalDateTime.now().format(DATETIME_FORMATTER));
                List<String> auditLines = auditFileHandler.readLines();
                auditLines.add(auditLine);
                auditFileHandler.writeLines(auditLines);

                session.setAttribute("message", "Product updated successfully.");
                session.setAttribute("messageType", "success");
            }

            response.sendRedirect(request.getContextPath() + "/ManageProductsServlet");
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input in ManageProductsServlet POST request: " + e.getMessage());
            session.setAttribute("message", "Invalid input: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageProductsServlet");
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageProductsServlet POST request: " + e.getMessage());
            session.setAttribute("message", "An error occurred: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageProductsServlet");
        }
    }
}