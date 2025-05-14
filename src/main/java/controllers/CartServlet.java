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
    List<Product> products = new ArrayList<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        System.out.println("CartServlet: GET request received, forwarding to cart.jsp");
        session.setAttribute("cart", products);
        request.getRequestDispatcher("/pages/cart.jsp").forward(request, response);

    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        System.out.println("Req Came");
        String action = request.getParameter("action");
        System.out.println("CartServlet: POST request, action=" + action);

        if (action.equals("add")) {
            double productPrice = Double.parseDouble(request.getParameter("productPrice"));
            String productID = request.getParameter("productId");
            String productName = request.getParameter("productName");
            System.out.println(productPrice);
            System.out.println(productID);
            System.out.println(productName);
            Product product = new Product(productID, productName, null, productPrice, 0, null, null);
            System.out.println("Add to cart");
            products.add(product);
            System.out.println(product.toString());
            session.setAttribute("cart", products);
            response.sendRedirect(request.getContextPath() + "/home");

        } else if (action.equals("delete")) {
            String productID = request.getParameter("productId");
            System.out.println("Delete product ID: " + productID);

            // Remove product from cart
            products.removeIf(p -> p.getProductId().equals(productID));


            session.setAttribute("cart", products);
            response.sendRedirect(request.getContextPath() + "/cart");

        }


    }



}