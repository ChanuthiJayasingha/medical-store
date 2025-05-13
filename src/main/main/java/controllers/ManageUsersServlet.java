package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.AuditLog;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing users in the MediCare system.
 */
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageUsersServlet.class.getName());
    private final FileHandler fileHandler;

    /**
     * Constructor for dependency injection.
     *
     * @param fileHandler The FileHandler instance
     */
    public ManageUsersServlet(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    /**
     * Default constructor for servlet container.
     */
    public ManageUsersServlet() {
        this(new FileHandler());
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

            List<User> users = fileHandler.getAllUsers(getServletContext());
            request.setAttribute("users", users);
            request.getRequestDispatcher("/pages/manage-users.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageUsersServlet GET request: " + e.getMessage());
            request.setAttribute("error", "Failed to load users: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
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

            String username = (String) session.getAttribute("username");

            if ("add".equals(action)) {
                User user = new User(
                        request.getParameter("fullName"),
                        request.getParameter("username"),
                        request.getParameter("password"),
                        request.getParameter("role"),
                        request.getParameter("contactNo"),
                        request.getParameter("email"),
                        request.getParameter("address"),
                        LocalDate.parse(request.getParameter("birthday")),
                        request.getParameter("gender")
                );
                if (fileHandler.registerUser(user, getServletContext())) {
                    AuditLog auditLog = new AuditLog(
                            UUID.randomUUID().toString(),
                            username,
                            "Added user: " + user.getUsername(),
                            LocalDateTime.now()
                    );
                    fileHandler.addAuditLog(auditLog, getServletContext());
                    session.setAttribute("notification", "User added successfully.");
                    session.setAttribute("notificationType", "success");
                } else {
                    session.setAttribute("notification", "Failed to add user.");
                    session.setAttribute("notificationType", "error");
                }
            } else if ("update".equals(action)) {
                User user = new User(
                        request.getParameter("fullName"),
                        request.getParameter("username"),
                        request.getParameter("password"),
                        request.getParameter("role"),
                        request.getParameter("contactNo"),
                        request.getParameter("email"),
                        request.getParameter("address"),
                        LocalDate.parse(request.getParameter("birthday")),
                        request.getParameter("gender")
                );
                if (fileHandler.registerUser(user, getServletContext())) {
                    AuditLog auditLog = new AuditLog(
                            UUID.randomUUID().toString(),
                            username,
                            "Updated user: " + user.getUsername(),
                            LocalDateTime.now()
                    );
                    fileHandler.addAuditLog(auditLog, getServletContext());
                    session.setAttribute("notification", "User updated successfully.");
                    session.setAttribute("notificationType", "success");
                } else {
                    session.setAttribute("notification", "Failed to update user.");
                    session.setAttribute("notificationType", "error");
                }
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
}