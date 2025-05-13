package controllers;

import model.Product;
import model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("CartServlet: GET request received, forwarding to cart.jsp");
        request.getRequestDispatcher("/pages/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        System.out.println("CartServlet: POST request, action=" + action);

        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        if (cartItems == null) {
            cartItems = new ArrayList<>();
            session.setAttribute("cartItems", cartItems);
            System.out.println("CartServlet: Initialized new cartItems list");
        }

        if (action == null || action.equals("add")) {
            String productId = request.getParameter("productId");
            System.out.println("CartServlet: Adding product, productId=" + productId);

            // Fetch product from session's products list
            List<Product> products = (List<Product>) session.getAttribute("products");
            if (products == null || products.isEmpty()) {
                System.err.println("CartServlet: Products list is null or empty");
                request.setAttribute("error", "Product catalog not available.");
                request.getRequestDispatcher("/pages/cart.jsp").forward(request, response);
                return;
            }

            Product product = products.stream()
                    .filter(p -> p.getProductId().equals(productId))
                    .findFirst()
                    .orElse(null);

            if (product != null && product.getStockQuantity() > 0) {
                System.out.println("CartServlet: Found product, name=" + product.getName());
                // Check if product already in cart
                CartItem existingItem = cartItems.stream()
                        .filter(item -> item.getProduct().getProductId().equals(productId))
                        .findFirst()
                        .orElse(null);

                if (existingItem != null) {
                    // Increment quantity if within stock
                    if (existingItem.getQuantity() < product.getStockQuantity()) {
                        existingItem.setQuantity(existingItem.getQuantity() + 1);
                        System.out.println("CartServlet: Incremented quantity for " + product.getName() + ", new quantity=" + existingItem.getQuantity());
                    } else {
                        request.setAttribute("error", "Cannot add more. Stock limit reached for " + product.getName() + ".");
                        System.err.println("CartServlet: Stock limit reached for productId=" + productId);
                    }
                } else {
                    cartItems.add(new CartItem(product, 1));
                    System.out.println("CartServlet: Added new item " + product.getName() + " to cart");
                }
            } else {
                request.setAttribute("error", "Product not found or out of stock.");
                System.err.println("CartServlet: Product not found or out of stock, productId=" + productId);
            }
        } else if (action.equals("update")) {
            String productId = request.getParameter("productId");
            int quantity;
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid quantity.");
                System.err.println("CartServlet: Invalid quantity for productId=" + productId);
                request.getRequestDispatcher("/pages/cart.jsp").forward(request, response);
                return;
            }
            System.out.println("CartServlet: Updating quantity for productId=" + productId + ", quantity=" + quantity);

            CartItem item = cartItems.stream()
                    .filter(ci -> ci.getProduct().getProductId().equals(productId))
                    .findFirst()
                    .orElse(null);

            if (item != null && quantity > 0 && quantity <= item.getProduct().getStockQuantity()) {
                item.setQuantity(quantity);
                System.out.println("CartServlet: Updated quantity for " + item.getProduct().getName() + " to " + quantity);
            } else {
                request.setAttribute("error", "Invalid quantity or stock limit reached.");
                System.err.println("CartServlet: Invalid update for productId=" + productId + ", quantity=" + quantity);
            }
        } else if (action.equals("remove")) {
            String productId = request.getParameter("productId");
            System.out.println("CartServlet: Removing productId=" + productId);
            cartItems.removeIf(ci -> ci.getProduct().getProductId().equals(productId));
            System.out.println("CartServlet: Removed productId=" + productId);
        }

        // Calculate total
        double cartTotal = cartItems.stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();
        session.setAttribute("cartTotal", cartTotal);
        System.out.println("CartServlet: Cart total=" + cartTotal + ", cartItems size=" + cartItems.size());

        // Forward to cart.jsp
        request.getRequestDispatcher("/pages/cart.jsp").forward(request, response);
    }
}