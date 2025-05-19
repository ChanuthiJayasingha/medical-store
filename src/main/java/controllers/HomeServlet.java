package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import services.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Servlet for handling the MediCare homepage, displaying all products.
 */
public class HomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());
    private FileHandler fileHandler;

    @Override
    public void init() throws ServletException {
        String filePath = getServletContext().getRealPath("/data/products.txt");
        LOGGER.info("Initializing FileHandler with path: " + filePath);
        fileHandler = new FileHandler(filePath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = new ArrayList<>();
        try {
            LOGGER.info("Loading products from products.txt");
            List<String> lines = fileHandler.readLines();
            if (lines.isEmpty()) {
                LOGGER.warning("No lines read from products.txt. File may be empty or missing.");
                request.setAttribute("error", "No products available. Please check back later.");
            } else {
                for (String line : lines) {
                    String[] parts = line.split(",", -1);
                    if (parts.length >= 7) {
                        try {
                            Product product = new Product(
                                    parts[0].trim(), // productId
                                    parts[1].trim(), // name
                                    parts[2].trim(), // description
                                    Double.parseDouble(parts[3].trim()), // price
                                    Integer.parseInt(parts[4].trim()), // stockQuantity
                                    parts[5].trim(), // imageUrl
                                    parts[6].trim() // category
                            );
                            products.add(product);
                        } catch (IllegalArgumentException e) {
                            LOGGER.warning("Error processing product: " + line + " | Error: " + e.getMessage());
                        }
                    } else {
                        LOGGER.warning("Incomplete product data: " + line);
                    }
                }
                if (products.isEmpty()) {
                    LOGGER.warning("No valid products parsed from products.txt");
                    request.setAttribute("error", "No valid products found. Please check product data format.");
                } else {
                    LOGGER.info("Successfully loaded " + products.size() + " products");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load products: " + e.getMessage(), e);
            request.setAttribute("error", "Unable to load products due to a server error. Please try again later.");
        }

        request.setAttribute("products", products);
        try {
            LOGGER.info("Forwarding to /pages/index.jsp");
            request.getRequestDispatcher("/pages/index.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to forward to index.jsp", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: Unable to render page.");
        }
    }
}