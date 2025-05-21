package model;

import java.util.Objects;

/**
 * Represents a product in the MediCare system.
 */
public class Product {
    private final String productId;
    private String name;
    private String description;
    private double price;
    private int stockQuantity;

    /**
     * Constructs a Product with the specified details.
     *
     * @param productId     Unique identifier for the product
     * @param name          Name of the product
     * @param description   Description of the product
     * @param price         Price of the product
     * @param stockQuantity Available stock quantity
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public Product(String productId, String name, String description, double price, int stockQuantity) {
        validateProductId(productId);
        validateName(name);
        validatePrice(price);
        validateStockQuantity(stockQuantity);

        this.productId = productId;
        this.name = name;
        this.description = description != null ? description : "";
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    public String getProductId() {
        return productId;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    /**
     * Sets the name of the product.
     *
     * @param name The new name
     * @throws IllegalArgumentException if name is invalid
     */
    public void setName(String name) {
        validateName(name);
        this.name = name;
    }

    /**
     * Sets the description of the product.
     *
     * @param description The new description
     */
    public void setDescription(String description) {
        this.description = description != null ? description : "";
    }

    /**
     * Sets the price of the product.
     *
     * @param price The new price
     * @throws IllegalArgumentException if price is invalid
     */
    public void setPrice(double price) {
        validatePrice(price);
        this.price = price;
    }

    /**
     * Sets the stock quantity of the product.
     *
     * @param stockQuantity The new stock quantity
     * @throws IllegalArgumentException if stock quantity is invalid
     */
    public void setStockQuantity(int stockQuantity) {
        validateStockQuantity(stockQuantity);
        this.stockQuantity = stockQuantity;
    }

    private void validateProductId(String productId) {
        if (productId == null || productId.trim().isEmpty()) {
            throw new IllegalArgumentException("Product ID cannot be null or empty");
        }
    }

    private void validateName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be null or empty");
        }
    }

    private void validatePrice(double price) {
        if (price < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
    }

    private void validateStockQuantity(int stockQuantity) {
        if (stockQuantity < 0) {
            throw new IllegalArgumentException("Stock quantity cannot be negative");
        }
    }

    @Override
    public String toString() {
        return String.format("Product{productId='%s', name='%s', description='%s', price=%.2f, stockQuantity=%d}",
                productId, name, description, price, stockQuantity);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Product product = (Product) o;
        return productId.equals(product.productId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(productId);
    }
}