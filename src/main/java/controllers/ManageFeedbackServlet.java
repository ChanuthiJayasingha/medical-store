package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Feedback;
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
 * Servlet for managing feedback in the MediCare system.
 */
public class ManageFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageFeedbackServlet.class.getName());
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private FileHandler fileHandler;
    private FileHandler auditHandler;

    @Override
    public void init() throws ServletException {
        fileHandler = new FileHandler(getServletContext().getRealPath("/data/feedback.txt"));
        auditHandler = new FileHandler(getServletContext().getRealPath("/data/audit.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageFeedbackServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            // Generate CSRF token if not present
            if (session.getAttribute("csrfToken") == null) {
                session.setAttribute("csrfToken", UUID.randomUUID().toString());
            }

            List<String> lines = fileHandler.readLines();
            List<Feedback> feedbackList = new ArrayList<>();
            for (String line : lines) {
                // Handle extra commas
                line = line.replaceAll(",\\s*,", ",").replaceAll(",\\s*$", "");
                String[] parts = line.split(",");
                if (parts.length == 5) {
                    try {
                        String feedbackId = parts[0].trim();
                        // Validate feedbackId format (FDB followed by 3 digits)
                        if (!feedbackId.matches("^FDB\\d{3}$")) {
                            LOGGER.warning("Invalid feedbackId format in line: " + line);
                            continue;
                        }
                        feedbackList.add(new Feedback(
                                feedbackId, // feedbackId
                                parts[1].trim(), // username
                                parts[2].trim(), // comment
                                Integer.parseInt(parts[3].trim()), // rating
                                LocalDate.parse(parts[4].trim(), DATE_FORMATTER) // submissionDate
                        ));
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid feedback rating in line: " + line + " | Error: " + e.getMessage());
                    } catch (Exception e) {
                        LOGGER.warning("Invalid feedback data in line: " + line + " | Error: " + e.getMessage());
                    }
                } else {
                    LOGGER.warning("Malformed feedback data (incorrect number of fields): " + line);
                }
            }
            request.setAttribute("feedbackList", feedbackList);
            request.getRequestDispatcher("/pages/manage-feedback.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageFeedbackServlet GET request: " + e.getMessage());
            session.setAttribute("notification", "Failed to load feedback: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            request.getRequestDispatcher("/pages/manage-feedback.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageFeedbackServlet");
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
                response.sendRedirect(request.getContextPath() + "/ManageFeedbackServlet");
                return;
            }

            String adminUsername = (String) session.getAttribute("username");
            List<String> feedbackLines = fileHandler.readLines();

            if ("add".equals(action)) {
                // Generate feedbackId in FDBXXX format
                String feedbackId = generateFeedbackId(feedbackLines);
                String username = request.getParameter("username");
                String comment = request.getParameter("comment");
                String ratingStr = request.getParameter("rating");
                String submissionDate = request.getParameter("submissionDate");

                validateInput(username, comment, ratingStr, submissionDate);

                String feedbackLine = String.join(",", feedbackId, username, comment, ratingStr, submissionDate);
                feedbackLines.add(feedbackLine);
                fileHandler.writeLines(feedbackLines);

                logAuditAction(auditHandler, adminUsername, "Added feedback: " + feedbackId);
                session.setAttribute("notification", "Feedback added successfully.");
                session.setAttribute("notificationType", "success");
            } else if ("delete".equals(action)) {
                String feedbackId = request.getParameter("feedbackId");
                if (feedbackId == null || feedbackId.trim().isEmpty()) {
                    throw new IllegalArgumentException("Feedback ID is required for deletion.");
                }
                if (!feedbackId.matches("^FDB\\d{3}$")) {
                    throw new IllegalArgumentException("Invalid feedback ID format.");
                }

                boolean found = false;
                for (int i = 0; i < feedbackLines.size(); i++) {
                    String[] parts = feedbackLines.get(i).split(",");
                    if (parts.length > 0 && parts[0].trim().equals(feedbackId)) {
                        feedbackLines.remove(i);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    throw new IllegalArgumentException("Feedback with ID '" + feedbackId + "' not found.");
                }

                fileHandler.writeLines(feedbackLines);
                logAuditAction(auditHandler, adminUsername, "Deleted feedback: " + feedbackId);
                session.setAttribute("notification", "Feedback deleted successfully.");
                session.setAttribute("notificationType", "success");
            } else {
                throw new IllegalArgumentException("Invalid action specified.");
            }

            response.sendRedirect(request.getContextPath() + "/ManageFeedbackServlet");
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input in ManageFeedbackServlet POST request: " + e.getMessage());
            session.setAttribute("notification", "Invalid input: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageFeedbackServlet");
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageFeedbackServlet POST request: " + e.getMessage());
            session.setAttribute("notification", "An error occurred: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageFeedbackServlet");
        }
    }

    private String generateFeedbackId(List<String> feedbackLines) {
        int maxId = 0;
        for (String line : feedbackLines) {
            String[] parts = line.split(",");
            if (parts.length > 0 && parts[0].matches("^FDB\\d{3}$")) {
                int idNum = Integer.parseInt(parts[0].substring(3));
                maxId = Math.max(maxId, idNum);
            }
        }
        return String.format("FDB%03d", maxId + 1);
    }

    private void validateInput(String username, String comment, String ratingStr, String submissionDate)
            throws IllegalArgumentException {
        if (username == null || comment == null || ratingStr == null || submissionDate == null) {
            throw new IllegalArgumentException("All fields are required.");
        }
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            throw new IllegalArgumentException("Username can only contain letters, numbers, and underscores.");
        }
        if (comment.trim().isEmpty() || comment.length() > 500) {
            throw new IllegalArgumentException("Comment must be between 1 and 500 characters.");
        }
        int rating;
        try {
            rating = Integer.parseInt(ratingStr);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Rating must be a valid number.");
        }
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5.");
        }
        try {
            LocalDate parsedDate = LocalDate.parse(submissionDate, DATE_FORMATTER);
            if (parsedDate.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Submission date cannot be in the future.");
            }
        } catch (Exception e) {
            throw new IllegalArgumentException("Submission date must be in YYYY-MM-DD format.");
        }
    }

    private void logAuditAction(FileHandler auditHandler, String adminUsername, String actionDescription)
            throws IOException {
        String auditLine = String.join(",",
                UUID.randomUUID().toString(),
                adminUsername,
                actionDescription,
                LocalDateTime.now().format(DATETIME_FORMATTER));
        List<String> auditLines = auditHandler.readLines();
        auditLines.add(auditLine);
        auditHandler.writeLines(auditLines);
    }
}