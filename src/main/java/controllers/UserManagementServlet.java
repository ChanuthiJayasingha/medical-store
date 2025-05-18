package controllers;

import services.FileHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/user-management/*")
public class UserManagementServlet extends HttpServlet {
    private FileHandler fileHandler;

    @Override
    public void init() throws ServletException {
        fileHandler = new FileHandler();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }
        try {
            switch (action) {
                case "/list":
                    listUsers(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/add";
        }
        try {
            switch (action) {
                case "/add":
                    addUser(request, response);
                    break;
                case "/update":
                    updateUser(request, response);
                    break;
                case "/delete":
                    deleteUser(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<String[]> users = fileHandler.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/pages/adminDashboard.jsp").forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        boolean success = fileHandler.addUser(username, password, role);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-management/list");
        } else {
            request.setAttribute("error", "Failed to add user (username may already exist)");
            listUsers(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        boolean success = fileHandler.updateUser(username, password, role);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-management/list");
        } else {
            request.setAttribute("error", "Failed to update user");
            listUsers(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        boolean success = fileHandler.deleteUser(username);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-management/list");
        } else {
            request.setAttribute("error", "Failed to delete user");
            listUsers(request, response);
        }
    }
} 