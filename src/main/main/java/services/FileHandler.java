package services;

import jakarta.servlet.ServletContext;
import model.Order;
import model.Product;
import model.User;
import model.Feedback;
import model.AuditLog;
import org.mindrot.jbcrypt.BCrypt;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles file-based data operations for the MediCare system.
 */
public class FileHandler {
    private static final Logger LOGGER = Logger.getLogger(FileHandler.class.getName());
    private static final String USERS_FILE = "/data/users.txt";
    private static final String PRODUCTS_FILE = "/data/products.txt";
    private static final String ORDERS_FILE = "/data/orders.txt";
    private static final String FEEDBACK_FILE = "/data/feedback.txt";
    private static final String AUDIT_FILE = "/data/audit.txt";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private final ReadWriteLock lock = new ReentrantReadWriteLock();

    /**
     * Authenticates a user by checking credentials against users.txt.
     */
    public boolean authenticateUser(String username, String password, String role, ServletContext context) {
        lock.readLock().lock();
        try (InputStream is = context.getResourceAsStream(USERS_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            if (is == null) {
                LOGGER.severe("Users file not found: " + USERS_FILE);
                return false;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 9 && parts[1].equals(username) && BCrypt.checkpw(password, parts[2]) && parts[3].equals(role)) {
                    return true;
                }
            }
            return false;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading users file", e);
            return false;
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * Registers a new user by appending to users.txt with hashed password.
     */
    public boolean registerUser(User user, ServletContext context) {
        lock.writeLock().lock();
        try {
            String realPath = context.getRealPath(USERS_FILE);
            Path path = Paths.get(realPath);
            if (Files.exists(path) && getAllUsers(context).stream().anyMatch(u -> u.getUsername().equals(user.getUsername()))) {
                LOGGER.warning("Username already exists: " + user.getUsername());
                return false;
            }
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            String userData = String.format("%s,%s,%s,%s,%s,%s,%s,%s,%s%n",
                    user.getFullName(), user.getUsername(), hashedPassword, user.getRole(),
                    user.getContactNo(), user.getEmail(), user.getAddress(),
                    user.getBirthday().format(DATE_FORMATTER), user.getGender());
            Files.write(path, userData.getBytes(), StandardOpenOption.APPEND, StandardOpenOption.CREATE);
            LOGGER.info("User registered: " + user.getUsername());
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing to users file", e);
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * Adds a new product to products.txt.
     */
    public boolean addProduct(Product product, ServletContext context) {
        lock.writeLock().lock();
        try {
            String realPath = context.getRealPath(PRODUCTS_FILE);
            Path path = Paths.get(realPath);
            if (Files.exists(path) && getAllProducts(context).stream().anyMatch(p -> p.getProductId().equals(product.getProductId()))) {
                LOGGER.warning("Product ID already exists: " + product.getProductId());
                return false;
            }
            String productData = String.format("%s,%s,%s,%.2f,%d%n",
                    product.getProductId(), product.getName(), product.getDescription(),
                    product.getPrice(), product.getStockQuantity());
            Files.write(path, productData.getBytes(), StandardOpenOption.APPEND, StandardOpenOption.CREATE);
            LOGGER.info("Product added: " + product.getProductId());
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing to products file", e);
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * Updates an existing product in products.txt.
     */
    public boolean updateProduct(Product product, ServletContext context) {
        lock.writeLock().lock();
        try {
            String realPath = context.getRealPath(PRODUCTS_FILE);
            Path path = Paths.get(realPath);
            if (!Files.exists(path)) {
                LOGGER.warning("Products file not found: " + PRODUCTS_FILE);
                return false;
            }
            List<String> lines = Files.readAllLines(path);
            boolean updated = false;
            for (int i = 0; i < lines.size(); i++) {
                String[] parts = lines.get(i).split(",", -1);
                if (parts[0].equals(product.getProductId())) {
                    lines.set(i, String.format("%s,%s,%s,%.2f,%d",
                            product.getProductId(), product.getName(), product.getDescription(),
                            product.getPrice(), product.getStockQuantity()));
                    updated = true;
                    break;
                }
            }
            if (updated) {
                Files.write(path, lines, StandardOpenOption.TRUNCATE_EXISTING);
                LOGGER.info("Product updated: " + product.getProductId());
            }
            return updated;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error updating products file", e);
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * Adds a new order to orders.txt.
     */
    public boolean addOrder(Order order, ServletContext context) {
        lock.writeLock().lock();
        try {
            String realPath = context.getRealPath(ORDERS_FILE);
            Path path = Paths.get(realPath);
            if (Files.exists(path) && getAllOrders(context).stream().anyMatch(o -> o.getOrderId().equals(order.getOrderId()))) {
                LOGGER.warning("Order ID already exists: " + order.getOrderId());
                return false;
            }
            String orderData = String.format("%s,%s,%s,%d,%s,%s%n",
                    order.getOrderId(), order.getUsername(), order.getProductId(),
                    order.getQuantity(), order.getStatus(), order.getOrderDate().format(DATE_FORMATTER));
            Files.write(path, orderData.getBytes(), StandardOpenOption.APPEND, StandardOpenOption.CREATE);
            LOGGER.info("Order added: " + order.getOrderId());
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing to orders file", e);
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * Updates an existing order in orders.txt.
     */
    public boolean updateOrder(Order order, ServletContext context) {
        lock.writeLock().lock();
        try {
            String realPath = context.getRealPath(ORDERS_FILE);
            Path path = Paths.get(realPath);
            if (!Files.exists(path)) {
                LOGGER.warning("Orders file not found: " + ORDERS_FILE);
                return false;
            }
            List<String> lines = Files.readAllLines(path);
            boolean updated = false;
            for (int i = 0; i < lines.size(); i++) {
                String[] parts = lines.get(i).split(",", -1);
                if (parts[0].equals(order.getOrderId())) {
                    lines.set(i, String.format("%s,%s,%s,%d,%s,%s",
                            order.getOrderId(), order.getUsername(), order.getProductId(),
                            order.getQuantity(), order.getStatus(), order.getOrderDate().format(DATE_FORMATTER)));
                    updated = true;
                    break;
                }
            }
            if (updated) {
                Files.write(path, lines, StandardOpenOption.TRUNCATE_EXISTING);
                LOGGER.info("Order updated: " + order.getOrderId());
            }
            return updated;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error updating orders file", e);
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * Adds a new feedback to feedback.txt.
     */
    public boolean addFeedback(Feedback feedback, ServletContext context) {
        lock.writeLock().lock();
        try {
            String realPath = context.getRealPath(FEEDBACK_FILE);
            Path path = Paths.get(realPath);
            if (Files.exists(path) && getAllFeedback(context).stream().anyMatch(f -> f.getFeedbackId().equals(feedback.getFeedbackId()))) {
                LOGGER.warning("Feedback ID already exists: " + feedback.getFeedbackId());
                return false;
            }
            String feedbackData = String.format("%s,%s,%s,%d,%s%n",
                    feedback.getFeedbackId(), feedback.getUsername(), feedback.getComment(),
                    feedback.getRating(), feedback.getSubmissionDate().format(DATE_FORMATTER));
            Files.write(path, feedbackData.getBytes(), StandardOpenOption.APPEND, StandardOpenOption.CREATE);
            LOGGER.info("Feedback added: " + feedback.getFeedbackId());
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing to feedback file", e);
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * Adds a new audit log to audit.txt.
     */
    public boolean addAuditLog(AuditLog auditLog, ServletContext context) {
        lock.writeLock().lock();
        try {
            String realPath = context.getRealPath(AUDIT_FILE);
            Path path = Paths.get(realPath);
            if (Files.exists(path) && getAllAuditLogs(context).stream().anyMatch(a -> a.getLogId().equals(auditLog.getLogId()))) {
                LOGGER.warning("Audit Log ID already exists: " + auditLog.getLogId());
                return false;
            }
            String auditData = String.format("%s,%s,%s,%s%n",
                    auditLog.getLogId(), auditLog.getUsername(), auditLog.getAction(),
                    auditLog.getTimestamp().format(DATETIME_FORMATTER));
            Files.write(path, auditData.getBytes(), StandardOpenOption.APPEND, StandardOpenOption.CREATE);
            LOGGER.info("Audit log added: " + auditLog.getLogId());
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing to audit file", e);
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * Retrieves all products from products.txt.
     */
    public List<Product> getAllProducts(ServletContext context) {
        lock.readLock().lock();
        try (InputStream is = context.getResourceAsStream(PRODUCTS_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            List<Product> products = new ArrayList<>();
            if (is == null) {
                LOGGER.warning("Products file not found: " + PRODUCTS_FILE);
                return products;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 5) {
                    products.add(new Product(
                            parts[0], parts[1], parts[2],
                            Double.parseDouble(parts[3]), Integer.parseInt(parts[4])));
                }
            }
            return products;
        } catch (IOException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Error reading products file", e);
            return new ArrayList<>();
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * Retrieves all orders from orders.txt.
     */
    public List<Order> getAllOrders(ServletContext context) {
        lock.readLock().lock();
        try (InputStream is = context.getResourceAsStream(ORDERS_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            List<Order> orders = new ArrayList<>();
            if (is == null) {
                LOGGER.warning("Orders file not found: " + ORDERS_FILE);
                return orders;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 6) {
                    orders.add(new Order(
                            parts[0], parts[1], parts[2], Integer.parseInt(parts[3]),
                            parts[4], LocalDate.parse(parts[5], DATE_FORMATTER)));
                }
            }
            return orders;
        } catch (IOException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Error reading orders file", e);
            return new ArrayList<>();
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * Retrieves all users from users.txt.
     */
    public List<User> getAllUsers(ServletContext context) {
        lock.readLock().lock();
        try (InputStream is = context.getResourceAsStream(USERS_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            List<User> users = new ArrayList<>();
            if (is == null) {
                LOGGER.warning("Users file not found: " + USERS_FILE);
                return users;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 9) {
                    users.add(new User(
                            parts[0], parts[1], parts[2], parts[3], parts[4],
                            parts[5], parts[6], LocalDate.parse(parts[7], DATE_FORMATTER), parts[8]));
                }
            }
            return users;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading users file", e);
            return new ArrayList<>();
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * Retrieves all feedback from feedback.txt.
     */
    public List<Feedback> getAllFeedback(ServletContext context) {
        lock.readLock().lock();
        try (InputStream is = context.getResourceAsStream(FEEDBACK_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            List<Feedback> feedbackList = new ArrayList<>();
            if (is == null) {
                LOGGER.warning("Feedback file not found: " + FEEDBACK_FILE);
                return feedbackList;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 5) {
                    feedbackList.add(new Feedback(
                            parts[0], parts[1], parts[2],
                            Integer.parseInt(parts[3]), LocalDate.parse(parts[4], DATE_FORMATTER)));
                }
            }
            return feedbackList;
        } catch (IOException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Error reading feedback file", e);
            return new ArrayList<>();
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * Retrieves all audit logs from audit.txt.
     */
    public List<AuditLog> getAllAuditLogs(ServletContext context) {
        lock.readLock().lock();
        try (InputStream is = context.getResourceAsStream(AUDIT_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            List<AuditLog> auditLogs = new ArrayList<>();
            if (is == null) {
                LOGGER.warning("Audit file not found: " + AUDIT_FILE);
                return auditLogs;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 4) {
                    auditLogs.add(new AuditLog(
                            parts[0], parts[1], parts[2],
                            LocalDateTime.parse(parts[3], DATETIME_FORMATTER)));
                }
            }
            return auditLogs;
        } catch (IOException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Error reading audit file", e);
            return new ArrayList<>();
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * Calculates total number of products.
     */
    public int getTotalProducts(ServletContext context) {
        return getAllProducts(context).size();
    }

    /**
     * Calculates total number of orders.
     */
    public int getTotalOrders(ServletContext context) {
        return getAllOrders(context).size();
    }

    /**
     * Calculates number of active users (non-admin users).
     */
    public int getActiveUsers(ServletContext context) {
        return (int) getAllUsers(context).stream()
                .filter(user -> !"Admin".equalsIgnoreCase(user.getRole()))
                .count();
    }

    /**
     * Calculates number of pending orders.
     */
    public int getPendingOrders(ServletContext context) {
        return (int) getAllOrders(context).stream()
                .filter(order -> "Pending".equalsIgnoreCase(order.getStatus()))
                .count();
    }

    /**
     * Calculates total number of feedback entries.
     */
    public int getTotalFeedback(ServletContext context) {
        return getAllFeedback(context).size();
    }
}