package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.AuditService;
import services.BackupService;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for managing audit logs in the MediCare system.
 */
public class ManageAuditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageAuditServlet.class.getName());
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
    private AuditService auditService;
    private BackupService backupService;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        FileHandler auditFileHandler = new FileHandler(basePath + "audit.txt");
        auditService = new AuditService(auditFileHandler);
        backupService = new BackupService(basePath, auditService);
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

            // Log access to audit logs
            String username = (String) session.getAttribute("username");
            String logId = generateAuditId();
            String auditLine = String.format("AUD%s: Accessed audit logs performed by %s at %s",
                    logId, username, LocalDateTime.now().format(DATETIME_FORMATTER));
            auditService.addAuditLog(auditLine);

            // Read audit logs
            List<String> auditLogs = auditService.readAuditLogs();
            request.setAttribute("auditLogs", auditLogs);
            request.getRequestDispatcher("/pages/manage-audit.jsp").forward(request, response);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading audit logs", e);
            session.setAttribute("notification", "Error: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageAuditServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            String csrfToken = request.getParameter("csrfToken");
            if (csrfToken == null || !csrfToken.equals(session.getAttribute("csrfToken"))) {
                LOGGER.warning("CSRF token validation failed");
                session.setAttribute("notification", "Invalid CSRF token.");
                session.setAttribute("notificationType", "error");
                response.sendRedirect(request.getContextPath() + "/ManageAuditServlet");
                return;
            }

            String action = request.getParameter("action");
            String username = (String) session.getAttribute("username");

            if ("backup".equals(action)) {
                backupService.createBackup(username);
                String logId = generateAuditId();
                String auditLine = String.format("AUD%s: Backup created performed by %s at %s",
                        logId, username, LocalDateTime.now().format(DATETIME_FORMATTER));
                auditService.addAuditLog(auditLine);
                session.setAttribute("notification", "Backup created successfully.");
                session.setAttribute("notificationType", "success");
            } else if ("clearLogs".equals(action)) {
                auditService.clearAuditLogs();
                String logId = generateAuditId();
                String auditLine = String.format("AUD%s: Cleared audit logs performed by %s at %s",
                        logId, username, LocalDateTime.now().format(DATETIME_FORMATTER));
                auditService.addAuditLog(auditLine);
                session.setAttribute("notification", "Audit logs cleared successfully.");
                session.setAttribute("notificationType", "success");
            } else {
                LOGGER.warning("Invalid action: " + action);
                session.setAttribute("notification", "Invalid action specified.");
                session.setAttribute("notificationType", "error");
            }

            response.sendRedirect(request.getContextPath() + "/ManageAuditServlet");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing action", e);
            session.setAttribute("notification", "Error: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageAuditServlet");
        }
    }

    private String generateAuditId() throws IOException {
        List<String> logs = auditService.readAuditLogs();
        int maxId = 0;
        for (String log : logs) {
            if (log.matches("^AUD\\d{3}: .+")) {
                int idNum = Integer.parseInt(log.substring(3, 6));
                maxId = Math.max(maxId, idNum);
            }
        }
        return String.format("%03d", maxId + 1);
    }
}