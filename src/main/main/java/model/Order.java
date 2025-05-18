package model;

import java.time.LocalDate;

public class Order {
    private String orderId;
    private String username;
    private String productId;
    private int quantity;
    private String status;
    private LocalDate orderDate;

    public Order(String orderId, String username, String productId, int quantity, String status, LocalDate orderDate) {
        this.orderId = orderId;
        this.username = username;
        this.productId = productId;
        this.quantity = quantity;
        this.status = status;
        this.orderDate = orderDate;
    }

    public String getOrderId() {
        return orderId;
    }

    public String getUsername() {
        return username;
    }

    public String getProductId() {
        return productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public String getStatus() {
        return status;
    }

    public LocalDate getOrderDate() {
        return orderDate;
    }
}