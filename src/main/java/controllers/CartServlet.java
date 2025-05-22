package controllers;

import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        System.out.println("CartServlet: GET request received, forwarding to cart.jsp");

        // Ensure cart is initialized
        List<Product> cart = (List<Product>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        // Ensure quantities are initialized
        Map<String, Integer> quantities = (Map<String, Integer>) session.getAttribute("cartQuantities");
        if (quantities == null) {
            quantities = new HashMap<>();
            session.setAttribute("cartQuantities", quantities);
        }

        // Calculate total
        double cartTotal = calculateCartTotal(cart, quantities);
        session.setAttribute("cartTotal", cartTotal);

        request.getRequestDispatcher("/pages/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        Map<String, Integer> quantities = (Map<String, Integer>) session.getAttribute("cartQuantities");
        if (quantities == null) {
            quantities = new HashMap<>();
            session.setAttribute("cartQuantities", quantities);
        }

        String action = request.getParameter("action");
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        System.out.println("CartServlet: POST request, action=" + action + ", isAjax=" + isAjax);

        if ("add".equals(action)) {
            String productId = request.getParameter("productId");
            String productName = request.getParameter("productName");
            double productPrice = Double.parseDouble(request.getParameter("productPrice"));
            String description = request.getParameter("productDescription");
            String imageUrl = request.getParameter("productImageUrl");
            String category = request.getParameter("productCategory");

            Product product = new Product(productId, productName, description, productPrice, 0, imageUrl, category);

            // Check if product already exists in cart
            boolean exists = cart.stream().anyMatch(p -> p.getProductId().equals(productId));
            if (!exists) {
                cart.add(product);
            }
            quantities.put(productId, quantities.getOrDefault(productId, 0) + 1);

            session.setAttribute("cart", cart);
            session.setAttribute("cartQuantities", quantities);
            double cartTotal = calculateCartTotal(cart, quantities);
            session.setAttribute("cartTotal", cartTotal);

            if (isAjax) {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(String.format("{\"success\":true,\"cartTotal\":%.2f,\"cartSize\":%d}", cartTotal, cart.size()));
                out.flush();
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else if ("delete".equals(action)) {
            String productId = request.getParameter("productId");
            cart.removeIf(p -> p.getProductId().equals(productId));
            quantities.remove(productId);

            session.setAttribute("cart", cart);
            session.setAttribute("cartQuantities", quantities);
            double cartTotal = calculateCartTotal(cart, quantities);
            session.setAttribute("cartTotal", cartTotal);

            if (isAjax) {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(String.format("{\"success\":true,\"cartTotal\":%.2f,\"cartSize\":%d}", cartTotal, cart.size()));
                out.flush();
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else if ("update".equals(action)) {
            String productId = request.getParameter("productId");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity > 0) {
                quantities.put(productId, quantity);
            } else {
                cart.removeIf(p -> p.getProductId().equals(productId));
                quantities.remove(productId);
            }

            session.setAttribute("cart", cart);
            session.setAttribute("cartQuantities", quantities);
            double cartTotal = calculateCartTotal(cart, quantities);
            session.setAttribute("cartTotal", cartTotal);

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(String.format("{\"success\":true,\"cartTotal\":%.2f,\"cartSize\":%d}", cartTotal, cart.size()));
            out.flush();
        } else {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"error\":\"Invalid action\"}");
            out.flush();
        }
    }

    private double calculateCartTotal(List<Product> cart, Map<String, Integer> quantities) {
        double total = 0.0;
        for (Product p : cart) {
            Integer qty = quantities.get(p.getProductId());
            if (qty != null) {
                total += p.getPrice() * qty;
            }
        }
        return total;
    }
}