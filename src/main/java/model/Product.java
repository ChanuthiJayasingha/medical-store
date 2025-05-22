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
    private String imageUrl;
    private String category;

    /**
     * Constructs a Product with the specified details.
     *
     * @param productId     Unique identifier for the product
     * @param name          Name of the product
     * @param description   Description of the product
     * @param price         Price of the product
     * @param stockQuantity Available stock quantity
     * @param imageUrl      URL or path to the product image
     * @param category      Category of the product
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public Product(String productId, String name, String description, double price, int stockQuantity, String imageUrl, String category) {
        validateProductId(productId);
        validateName(name);
        validatePrice(price);
        validateStockQuantity(stockQuantity);
        validateImageUrl(imageUrl);
        validateCategory(category);

        this.productId = productId;
        this.name = name;
        this.description = description != null ? description : "";
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl != null ? imageUrl : "";
        this.category = category != null ? category : "Uncategorized";
    }

    // Getters
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

    public String getImageUrl() {
        return imageUrl;
    }

    public String getCategory() {
        return category;
    }

    // Setters
    public void setName(String name) {
        validateName(name);
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description != null ? description : "";
    }

    public void setPrice(double price) {
        validatePrice(price);
        this.price = price;
    }

    public void setStockQuantity(int stockQuantity) {
        validateStockQuantity(stockQuantity);
        this.stockQuantity = stockQuantity;
    }

    public void setImageUrl(String imageUrl) {
        validateImageUrl(imageUrl);
        this.imageUrl = imageUrl != null ? imageUrl : "";
    }

    public void setCategory(String category) {
        validateCategory(category);
        this.category = category != null ? category : "Uncategorized";
    }

    // Validation methods
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

    private void validateImageUrl(String imageUrl) {
        // Optional: Add URL format validation if needed
        if (imageUrl != null && imageUrl.trim().isEmpty()) {
            throw new IllegalArgumentException("Image URL cannot be empty if provided");
        }
    }

    private void validateCategory(String category) {
        // Optional: Add specific category validation if needed
        if (category != null && category.trim().isEmpty()) {
            throw new IllegalArgumentException("Category cannot be empty if provided");
        }
    }

    @Override
    public String toString() {
        return String.format("Product{productId='%s', name='%s', description='%s', price=%.2f, stockQuantity=%d, imageUrl='%s', category='%s'}",
                productId, name, description, price, stockQuantity, imageUrl, category);
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