package model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

/**
 * Represents an order in the MediCare system.
 */
public class Order {
    private final String orderId;
    private final String username;
    private final String productId;
    private int quantity;
    private String status;
    private final LocalDate orderDate;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * Constructs an Order with the specified details.
     *
     * @param orderId   Unique identifier for the order
     * @param username  Username of the user placing the order
     * @param productId Identifier of the ordered product
     * @param quantity  Quantity of the product ordered
     * @param status    Status of the order (e.g., Pending, Shipped)
     * @param orderDate Date the order was placed
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public Order(String orderId, String username, String productId, int quantity, String status, LocalDate orderDate) {
        validateOrderId(orderId);
        validateUsername(username);
        validateProductId(productId);
        validateQuantity(quantity);
        validateStatus(status);
        validateOrderDate(orderDate);

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

    /**
     * Sets the quantity of the order.
     *
     * @param quantity The new quantity
     * @throws IllegalArgumentException if quantity is invalid
     */
    public void setQuantity(int quantity) {
        validateQuantity(quantity);
        this.quantity = quantity;
    }

    /**
     * Sets the status of the order.
     *
     * @param status The new status
     * @throws IllegalArgumentException if status is invalid
     */
    public void setStatus(String status) {
        validateStatus(status);
        this.status = status;
    }

    private void validateOrderId(String orderId) {
        if (orderId == null || orderId.trim().isEmpty()) {
            throw new IllegalArgumentException("Order ID cannot be null or empty");
        }
    }

    private void validateUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
    }

    private void validateProductId(String productId) {
        if (productId == null || productId.trim().isEmpty()) {
            throw new IllegalArgumentException("Product ID cannot be null or empty");
        }
    }

    private void validateQuantity(int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive");
        }
    }

    private void validateStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be null or empty");
        }
    }

    private void validateOrderDate(LocalDate orderDate) {
        if (orderDate == null) {
            throw new IllegalArgumentException("Order date cannot be null");
        }
        if (orderDate.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Order date cannot be in the future");
        }
    }

    @Override
    public String toString() {
        return String.format("Order{orderId='%s', username='%s', productId='%s', quantity=%d, status='%s', orderDate=%s}",
                orderId, username, productId, quantity, status, orderDate.format(DATE_FORMATTER));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Order order = (Order) o;
        return orderId.equals(order.orderId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(orderId);
    }
}