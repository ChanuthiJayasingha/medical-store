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
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing audit logs in the MediCare system.
 */
public class ManageAuditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageAuditServlet.class.getName());
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private FileHandler fileHandler;

    @Override
    public void init() throws ServletException {
        fileHandler = new FileHandler(getServletContext().getRealPath("/data/audit.txt"));
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
            String auditLine = String.join(",",
                    UUID.randomUUID().toString(),
                    (String) session.getAttribute("username"),
                    "Accessed audit logs",
                    LocalDateTime.now().format(DATETIME_FORMATTER));
            List<String> auditLines = fileHandler.readLines();
            auditLines.add(auditLine);
            fileHandler.writeLines(auditLines);

            // Parse audit logs
            List<AuditLog> auditLogs = new ArrayList<>();
            for (String line : auditLines) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 4) {
                    try {
                        auditLogs.add(new AuditLog(
                                parts[0], // logId
                                parts[1], // username
                                parts[2], // action
                                LocalDateTime.parse(parts[3], DATETIME_FORMATTER) // timestamp
                        ));
                    } catch (Exception e) {
                        LOGGER.warning("Invalid audit log data: " + line);
                    }
                }
            }

            request.setAttribute("auditLogs", auditLogs);
            request.getRequestDispatcher("/pages/manage-audit.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageAuditServlet GET request: " + e.getMessage());
            request.setAttribute("message", "Failed to load audit logs: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/manage-audit.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}