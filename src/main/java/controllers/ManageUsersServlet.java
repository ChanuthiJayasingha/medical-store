package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing users in the MediCare system.
 */
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageUsersServlet.class.getName());
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private FileHandler userFileHandler;
    private FileHandler auditFileHandler;

    @Override
    public void init() throws ServletException {
        userFileHandler = new FileHandler(getServletContext().getRealPath("/data/users.txt"));
        auditFileHandler = new FileHandler(getServletContext().getRealPath("/data/audit.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageUsersServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            // Generate CSRF token if not present
            if (session.getAttribute("csrfToken") == null) {
                session.setAttribute("csrfToken", UUID.randomUUID().toString());
            }

            List<String> lines = userFileHandler.readLines();
            List<User> users = new ArrayList<>();
            int lineNumber = 0;

            for (String line : lines) {
                lineNumber++;
                // Handle extra commas and trim whitespace
                line = line.replaceAll(",\\s*,", ",").replaceAll(",\\s*$", "").trim();
                String[] parts = line.split(",");
                if (parts.length == 9) {
                    try {
                        String role = parts[3].trim().equalsIgnoreCase("User") ? "Customer" : parts[3].trim();
                        LocalDate birthday;
                        try {
                            birthday = LocalDate.parse(parts[7].trim(), DATE_FORMATTER);
                        } catch (Exception e) {
                            LOGGER.warning("Invalid birthday format at line " + lineNumber + ": " + line + " | Error: " + e.getMessage());
                            continue;
                        }
                        if (birthday.isAfter(LocalDate.now())) {
                            LOGGER.warning("Invalid birthday (future date) at line " + lineNumber + ": " + line);
                            continue;
                        }
                        User user = new User(
                                parts[0].trim(), // fullName
                                parts[1].trim(), // username
                                parts[2].trim(), // password
                                role, // role
                                parts[4].trim(), // contactNo
                                parts[5].trim(), // email
                                parts[6].trim(), // address
                                birthday, // birthday
                                parts[8].trim() // gender
                        );
                        if (user.getBirthday() != null) {
                            users.add(user);
                        } else {
                            LOGGER.warning("Skipping user with null birthday at line " + lineNumber + ": " + line);
                        }
                    } catch (IllegalArgumentException e) {
                        LOGGER.warning("Invalid user data at line " + lineNumber + ": " + line + " | Error: " + e.getMessage());
                    } catch (Exception e) {
                        LOGGER.warning("Unexpected error parsing user data at line " + lineNumber + ": " + line + " | Error: " + e.getMessage());
                    }
                } else {
                    LOGGER.warning("Malformed user data (incorrect number of fields) at line " + lineNumber + ": " + line);
                }
            }

            request.setAttribute("userList", users);
            if (users.isEmpty()) {
                session.setAttribute("notification", "No valid users found. Check users.txt for errors.");
                session.setAttribute("notificationType", "error");
            }
            request.getRequestDispatcher("/pages/manage-users.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageUsersServlet GET request: " + e.getMessage());
            e.printStackTrace(); // Log full stacktrace for debugging
            session.setAttribute("notification", "Failed to load users: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            request.setAttribute("userList", new ArrayList<User>()); // Set empty list to prevent null
            request.getRequestDispatcher("/pages/manage-users.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageUsersServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            String action = request.getParameter("action");
            String csrfToken = request.getParameter("csrfToken");
            if (csrfToken == null || !csrfToken.equals(session.getAttribute("csrfToken"))) {
                LOGGER.warning("CSRF token validation failed");
                session.setAttribute("notification", "Invalid CSRF token.");
                session.setAttribute("notificationType", "error");
                response.sendRedirect(request.getContextPath() + "/ManageUsersServlet");
                return;
            }

            String adminUsername = (String) session.getAttribute("username");
            List<String> userLines = userFileHandler.readLines();

            if ("add".equals(action)) {
                String fullName = request.getParameter("fullName");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");
                String contactNo = request.getParameter("contactNo");
                String email = request.getParameter("email");
                String address = request.getParameter("address").replace(",", " ");
                String birthday = request.getParameter("birthday");
                String gender = request.getParameter("gender");

                validateInput(fullName, username, password, role, contactNo, email, address, birthday, gender);

                if (userLines.stream().anyMatch(line -> line.split(",")[1].trim().equals(username))) {
                    throw new IllegalArgumentException("Username '" + username + "' already exists.");
                }

                String userLine = String.join(",", fullName, username, password, role, contactNo, email, address, birthday, gender);
                userLines.add(userLine);
                userFileHandler.writeLines(userLines);

                logAuditAction(auditFileHandler, adminUsername, "Added user: " + username);
                session.setAttribute("notification", "User added successfully.");
                session.setAttribute("notificationType", "success");
            } else if ("update".equals(action)) {
                String fullName = request.getParameter("fullName");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");
                String contactNo = request.getParameter("contactNo");
                String email = request.getParameter("email");
                String address = request.getParameter("address").replace(",", " ");
                String birthday = request.getParameter("birthday");
                String gender = request.getParameter("gender");

                validateInput(fullName, username, password, role, contactNo, email, address, birthday, gender);

                boolean found = false;
                for (int i = 0; i < userLines.size(); i++) {
                    String[] parts = userLines.get(i).split(",");
                    if (parts.length > 1 && parts[1].trim().equals(username)) {
                        userLines.set(i, String.join(",", fullName, username, password, role, contactNo, email, address, birthday, gender));
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    throw new IllegalArgumentException("User with username '" + username + "' not found.");
                }

                userFileHandler.writeLines(userLines);
                logAuditAction(auditFileHandler, adminUsername, "Updated user: " + username);
                session.setAttribute("notification", "User updated successfully.");
                session.setAttribute("notificationType", "success");
            } else if ("delete".equals(action)) {
                String username = request.getParameter("username");
                if (username == null || username.trim().isEmpty()) {
                    throw new IllegalArgumentException("Username is required for deletion.");
                }

                boolean found = false;
                for (int i = 0; i < userLines.size(); i++) {
                    String[] parts = userLines.get(i).split(",");
                    if (parts.length > 1 && parts[1].trim().equals(username)) {
                        userLines.remove(i);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    throw new IllegalArgumentException("User with username '" + username + "' not found.");
                }

                userFileHandler.writeLines(userLines);
                logAuditAction(auditFileHandler, adminUsername, "Deleted user: " + username);
                session.setAttribute("notification", "User deleted successfully.");
                session.setAttribute("notificationType", "success");
            } else {
                throw new IllegalArgumentException("Invalid action specified.");
            }

            response.sendRedirect(request.getContextPath() + "/ManageUsersServlet");
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input in ManageUsersServlet POST request: " + e.getMessage());
            session.setAttribute("notification", "Invalid input: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageUsersServlet");
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageUsersServlet POST request: " + e.getMessage());
            session.setAttribute("notification", "An error occurred: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageUsersServlet");
        }
    }

    private void validateInput(String fullName, String username, String password, String role, String contactNo,
                               String email, String address, String birthday, String gender)
            throws IllegalArgumentException {
        if (fullName == null || username == null || password == null || role == null ||
                contactNo == null || email == null || address == null || birthday == null || gender == null) {
            throw new IllegalArgumentException("All fields are required.");
        }
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            throw new IllegalArgumentException("Username can only contain letters, numbers, and underscores.");
        }
        if (password.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters long.");
        }
        if (!role.equals("Admin") && !role.equals("Customer")) {
            throw new IllegalArgumentException("Invalid role specified.");
        }
        if (!contactNo.matches("\\+?\\d{10,15}")) {
            throw new IllegalArgumentException("Contact number must be 10-15 digits, optionally starting with +.");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format.");
        }
        try {
            LocalDate parsedBirthday = LocalDate.parse(birthday, DATE_FORMATTER);
            if (parsedBirthday.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Birthday cannot be in the future.");
            }
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid birthday format: " + e.getMessage());
        }
        if (!gender.equals("Male") && !gender.equals("Female") && !gender.equals("Other")) {
            throw new IllegalArgumentException("Invalid gender specified.");
        }
    }

    private void logAuditAction(FileHandler auditFileHandler, String adminUsername, String actionDescription)
            throws IOException {
        String auditLine = String.join(",",
                UUID.randomUUID().toString(),
                adminUsername,
                actionDescription,
                LocalDateTime.now().format(DATETIME_FORMATTER));
        List<String> auditLines = auditFileHandler.readLines();
        auditLines.add(auditLine);
        auditFileHandler.writeLines(auditLines);
    }
}