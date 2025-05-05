package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AuditLog;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing audit logs in the MediCare system.
 */
public class ManageAuditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageAuditServlet.class.getName());
    private final FileHandler fileHandler;

    /**
     * Constructor for dependency injection.
     *
     * @param fileHandler The FileHandler instance
     */
    public ManageAuditServlet(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    /**
     * Default constructor for servlet container.
     */
    public ManageAuditServlet() {
        this(new FileHandler());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageAuditServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            // Generate CSRF token if not present
            if (session.getAttribute("csrfToken") == null) {
                session.setAttribute("csrfToken", UUID.randomUUID().toString());
            }

            // Log audit access
            AuditLog auditLog = new AuditLog(
                    UUID.randomUUID().toString(),
                    (String) session.getAttribute("username"),
                    "Accessed audit logs",
                    LocalDateTime.now()
            );
            fileHandler.addAuditLog(auditLog, getServletContext());

            List<AuditLog> auditLogs = fileHandler.getAllAuditLogs(getServletContext());
            request.setAttribute("auditLogs", auditLogs);
            request.getRequestDispatcher("/pages/manage-audit.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageAuditServlet GET request: " + e.getMessage());
            request.setAttribute("error", "Failed to load audit logs: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}