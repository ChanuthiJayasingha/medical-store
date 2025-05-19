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
        fileHandler = new FileHandler(getServletContext().getRealPath("/data/products.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = new ArrayList<>();
        try {
            LOGGER.info("Loading products from products.txt");
            List<String> lines = fileHandler.readLines();
            for (String line : lines) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 7) {
                    try {
                        Product product = new Product(
                                parts[0], // productId
                                parts[1], // name
                                parts[2], // description
                                Double.parseDouble(parts[3]), // price
                                Integer.parseInt(parts[4]), // stockQuantity
                                parts[5], // imageUrl
                                parts[6] // category
                        );
                        products.add(product);
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid product data: " + line);
                    }
                }
            }
            if (products.isEmpty()) {
                LOGGER.warning("No products found in products.txt");
                request.setAttribute("error", "No products available. Please check back later.");
            } else {
                LOGGER.info("Loaded " + products.size() + " products");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load products: " + e.getMessage(), e);
            request.setAttribute("error", "Unable to load products. Please try again later.");
        }

        request.setAttribute("products", products);
        try {
            request.getRequestDispatcher("/pages/index.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to forward to index.jsp", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: Unable to render page.");
        }
    }
}