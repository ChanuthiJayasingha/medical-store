package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.FileHandler;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Logger;

/**
 * Servlet for handling user registration in the MediCare system.
 */
public class RegisterServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private FileHandler fileHandler;

    @Override
    public void init() throws ServletException {
        fileHandler = new FileHandler(getServletContext().getRealPath("/data/users.txt"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String contactNo = request.getParameter("contactNo");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String birthday = request.getParameter("birthday");
        String gender = request.getParameter("gender");
        String role = "User"; // Hardcoded to User

        // Basic validation
        if (fullName == null || fullName.trim().isEmpty() ||
                username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                contactNo == null || contactNo.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                birthday == null || birthday.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty()) {
            request.setAttribute("message", "All fields are required");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        // Additional validation
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("message", "Invalid email format");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }
        if (!contactNo.matches("\\d{10}")) {
            request.setAttribute("message", "Contact number must be 10 digits");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }
        try {
            LocalDate.parse(birthday, DATE_FORMATTER);
        } catch (Exception e) {
            request.setAttribute("message", "Birthday must be in YYYY-MM-DD format");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        try {
            List<String> userLines = fileHandler.readLines();
            if (userLines.stream()
                    .anyMatch(line -> {
                        String[] parts = line.split(",", -1);
                        return parts.length >= 2 && parts[1].equals(username);
                    })) {
                request.setAttribute("message", "Username '" + username + "' already exists");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
                return;
            }

            String userLine = String.join(",", fullName, username, password, role, contactNo, email, address, birthday, gender);
            userLines.add(userLine);
            fileHandler.writeLines(userLines);

            response.sendRedirect("pages/login.jsp?role=User");
        } catch (Exception e) {
            LOGGER.severe("Error processing RegisterServlet POST request: " + e.getMessage());
            request.setAttribute("message", "Registration failed: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
        }
    }
}