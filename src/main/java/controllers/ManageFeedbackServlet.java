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

    @Override
    public void init() throws ServletException {
        fileHandler = new FileHandler(getServletContext().getRealPath("/data/feedback.txt"));
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
            List<String> lines = fileHandler.readLines();
            List<Feedback> feedbackList = new ArrayList<>();
            for (String line : lines) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 5) {
                    try {
                        feedbackList.add(new Feedback(
                                parts[0], // feedbackId
                                parts[1], // username
                                parts[2], // comment
                                Integer.parseInt(parts[3]), // rating
                                LocalDate.parse(parts[4], DATE_FORMATTER) // submissionDate
                        ));
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid feedback rating: " + line);
                    } catch (IllegalArgumentException e) {
                        LOGGER.warning("Invalid feedback date: " + line);
                    }
                }
            }
            request.setAttribute("feedbackList", feedbackList);
            request.getRequestDispatcher("/pages/manage-feedback.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageFeedbackServlet GET request: " + e.getMessage());
            session.setAttribute("message", "Failed to load feedback: " + e.getMessage());
            session.setAttribute("messageType", "error");
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
                session.setAttribute("message", "Invalid CSRF token.");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/ManageFeedbackServlet");
                return;
            }

            String username = (String) session.getAttribute("username");
            if ("add".equals(action)) {
                String feedbackId = UUID.randomUUID().toString();
                String comment = request.getParameter("comment");
                String ratingStr = request.getParameter("rating");
                String submissionDate = request.getParameter("submissionDate");

                if (comment == null || ratingStr == null || submissionDate == null) {
                    throw new IllegalArgumentException("All fields are required.");
                }

                int rating;
                try {
                    rating = Integer.parseInt(ratingStr);
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid rating format: " + ratingStr);
                    throw new IllegalArgumentException("Rating must be a valid number.");
                }
                if (rating < 1 || rating > 5) {
                    throw new IllegalArgumentException("Rating must be between 1 and 5.");
                }

                try {
                    LocalDate.parse(submissionDate, DATE_FORMATTER);
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Invalid submission date format: " + submissionDate);
                    throw new IllegalArgumentException("Submission date must be in YYYY-MM-DD format.");
                }

                String feedbackLine = String.join(",", feedbackId, request.getParameter("username"), comment, ratingStr, submissionDate);
                List<String> feedbackLines = fileHandler.readLines();
                feedbackLines.add(feedbackLine);
                fileHandler.writeLines(feedbackLines);

                // Log audit action
                FileHandler auditHandler = new FileHandler(getServletContext().getRealPath("/data/audit.txt"));
                String auditLine = String.join(",",
                        UUID.randomUUID().toString(),
                        username,
                        "Added feedback: " + feedbackId,
                        LocalDateTime.now().format(DATETIME_FORMATTER));
                List<String> auditLines = auditHandler.readLines();
                auditLines.add(auditLine);
                auditHandler.writeLines(auditLines);

                session.setAttribute("message", "Feedback added successfully.");
                session.setAttribute("messageType", "success");
            }

            response.sendRedirect(request.getContextPath() + "/ManageFeedbackServlet");
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input in ManageFeedbackServlet POST request: " + e.getMessage());
            session.setAttribute("message", "Invalid input: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageFeedbackServlet");
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageFeedbackServlet POST request: " + e.getMessage());
            session.setAttribute("message", "An error occurred: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageFeedbackServlet");
        }
    }
}