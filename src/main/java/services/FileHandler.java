package services;

import jakarta.servlet.ServletContext;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

public class FileHandler {
    private static final Logger LOGGER = Logger.getLogger(FileHandler.class.getName());
    private static final String USERS_FILE = "/data/users.txt"; // Relative to webapp root

    /**
     * Authenticates a user by checking username, password, and role against users.txt.
     * @param username The user's username
     * @param password The user's password (plaintext)
     * @param role The user's role (e.g., Admin, User)
     * @param context The ServletContext to access webapp resources
     * @return true if authentication succeeds, false otherwise
     */
    public boolean authenticateUser(String username, String password, String role, ServletContext context) {
        // Input validation
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                role == null || role.trim().isEmpty()) {
            LOGGER.warning("Invalid input: username, password, or role is null or empty");
            return false;
        }

        try (InputStream is = context.getResourceAsStream(USERS_FILE);
             BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            if (is == null) {
                LOGGER.severe("Users file not found: " + USERS_FILE);
                return false;
            }

            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4 &&
                        parts[1].trim().equals(username) &&
                        parts[2].trim().equals(password) &&
                        parts[3].trim().equals(role)) {
                    return true;
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading users file: " + USERS_FILE, e);
            return false;
        }
        return false;
    }

    /**
     * Registers a new user by appending a single line to users.txt.
     * @param user The User object containing user details
     * @param context The ServletContext to access webapp resources
     * @return true if registration succeeds, false if username exists or an error occurs
     */
    public boolean registerUser(User user, ServletContext context) {
        // Input validation
        if (user == null ||
                user.getUsername() == null || user.getUsername().trim().isEmpty() ||
                user.getPassword() == null || user.getPassword().trim().isEmpty() ||
                user.getRole() == null || user.getRole().trim().isEmpty() ||
                user.getFullName() == null || user.getFullName().trim().isEmpty() ||
                user.getContactNo() == null || user.getContactNo().trim().isEmpty() ||
                user.getEmail() == null || user.getEmail().trim().isEmpty() ||
                user.getAddress() == null || user.getAddress().trim().isEmpty() ||
                user.getBirthday() == null || user.getBirthday().trim().isEmpty() ||
                user.getGender() == null || user.getGender().trim().isEmpty()) {
            LOGGER.warning("Invalid user data: one or more fields are null or empty");
            return false;
        }

        // Check for duplicate username
        try (InputStream is = context.getResourceAsStream(USERS_FILE);
             BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            if (is == null) {
                LOGGER.severe("Users file not found: " + USERS_FILE);
                return false;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 2 && parts[1].trim().equals(user.getUsername())) {
                    LOGGER.warning("Username already exists: " + user.getUsername());
                    return false;
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error checking username in users file: " + USERS_FILE, e);
            return false;
        }

        // Format user data as a single line
        String userData = String.format("%s,%s,%s,%s,%s,%s,%s,%s,%s%n",
                user.getFullName(), user.getUsername(), user.getPassword(), user.getRole(),
                user.getContactNo(), user.getEmail(), user.getAddress(), user.getBirthday(), user.getGender());

        // Append user data line by line
        try {
            String realPath = context.getRealPath(USERS_FILE);
            try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(realPath),
                    StandardOpenOption.APPEND, StandardOpenOption.CREATE)) {
                writer.write(userData);
                writer.flush();
            }
            LOGGER.info("User registered successfully: " + user.getUsername());
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing to users file: " + USERS_FILE, e);
            return false;
        }
    }
}