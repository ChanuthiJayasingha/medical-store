package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Feedback;
import model.AuditLog;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Servlet for managing feedback in the MediCare system.
 */
public class ManageFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ManageFeedbackServlet.class.getName());
    private final FileHandler fileHandler;

    /**
     * Constructor for dependency injection.
     *
     * @param fileHandler The FileHandler instance
     */
    public ManageFeedbackServlet(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    /**
     * Default constructor for servlet container.
     */
    public ManageFeedbackServlet() {
        this(new FileHandler());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
            LOGGER.warning("Unauthorized access attempt to ManageFeedbackServlet");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            feedbackList = fileHandler.getAllFeedback(getServletContext());
            request.setAttribute("feedbackList", feedbackList);
            request.getRequestDispatcher("/pages/manage-feedback.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing ManageFeedbackServlet GET request: " + e.getMessage());
            request.setAttribute("error", "Failed to load feedback: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
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

            String username = (String) session.getAttribute("username");

            if ("add".equals(action)) {
                String feedbackId = UUID.randomUUID().toString();
                Feedback feedback = new Feedback(
                        feedbackId,
                        request.getParameter("username"),
                        request.getParameter("comment"),
                        Integer.parseInt(request.getParameter("rating")),
                        LocalDate.parse(request.getParameter("submissionDate"))
                );
                if (fileHandler.addFeedback(feedback, getServletContext())) {
                    AuditLog auditLog = new AuditLog(
                            UUID.randomUUID().toString(),
                            username,
                            "Added feedback: " + feedbackId,
                            LocalDateTime.now()
                    );
                    fileHandler.addAuditLog(auditLog, getServletContext());
                    session.setAttribute("notification", "Feedback added successfully.");
                    session.setAttribute("notificationType", "success");
                } else {
                    session.setAttribute("notification", "Failed to add feedback.");
                    session.setAttribute("notificationType", "error");
                }
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
}