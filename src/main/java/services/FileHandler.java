package services;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.File;
import jakarta.servlet.ServletContext;

public class FileHandler {
    private ServletContext servletContext;

    public FileHandler() {
        ensureDefaultAccounts();
    }
    
    public FileHandler(ServletContext servletContext) {
        this.servletContext = servletContext;
        ensureDefaultAccounts();
    }

    private String getUsersFilePath() {
        if (servletContext != null) {
            return servletContext.getRealPath("/WEB-INF/users.txt");
        } else {
            // This is a fallback but will likely fail in production
            return "src/main/webapp/WEB-INF/users.txt";
        }
    }
    
    /**
     * Ensures that default admin and user accounts exist in the system
     */
    public void ensureDefaultAccounts() {
        File usersFile = new File(getUsersFilePath());
        
        // If file doesn't exist or is empty, create it with default accounts
        if (!usersFile.exists() || usersFile.length() == 0) {
            try {
                // Create parent directories if they don't exist
                if (!usersFile.getParentFile().exists()) {
                    usersFile.getParentFile().mkdirs();
                }
                
                // Write default accounts to the file
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(usersFile))) {
                    // Default admin account
                    writer.write("admin,admin123,admin");
                    writer.newLine();
                    
                    // Default user account
                    writer.write("user,user123,user");
                    writer.newLine();
                    
                    System.out.println("Created default admin and user accounts");
                }
            } catch (IOException e) {
                System.err.println("Failed to create default accounts: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            // Check if admin and user accounts exist, add them if they don't
            boolean adminExists = false;
            boolean userExists = false;
            
            List<String[]> users = getAllUsers();
            for (String[] user : users) {
                if ("admin".equals(user[0])) {
                    adminExists = true;
                }
                if ("user".equals(user[0])) {
                    userExists = true;
                }
            }
            
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(usersFile, true))) {
                if (!adminExists) {
                    writer.write("admin,admin123,admin");
                    writer.newLine();
                    System.out.println("Added default admin account");
                }
                
                if (!userExists) {
                    writer.write("user,user123,user");
                    writer.newLine();
                    System.out.println("Added default user account");
                }
            } catch (IOException e) {
                System.err.println("Failed to add missing default accounts: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    public boolean authenticateUser(String username, String password, String role) {
        BufferedReader reader = null;
        try {
            String path = getUsersFilePath();
            reader = new BufferedReader(new FileReader(path));
            
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 3 &&
                        parts[0].equals(username) &&
                        parts[1].equals(password) &&
                        parts[2].equals(role)) {
                    return true;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try { reader.close(); } catch (IOException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    public List<String[]> getAllUsers() {
        List<String[]> users = new ArrayList<>();
        File file = new File(getUsersFilePath());
        
        if (!file.exists()) {
            return users; // Return empty list if file doesn't exist
        }
        
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 3) {
                    users.add(parts);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean addUser(String username, String password, String role) {
        // Prevent duplicate usernames
        List<String[]> users = getAllUsers();
        for (String[] user : users) {
            if (user[0].equals(username)) {
                return false;
            }
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getUsersFilePath(), true))) {
            writer.write(username + "," + password + "," + role);
            writer.newLine();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUser(String username, String newPassword, String newRole) {
        List<String[]> users = getAllUsers();
        boolean found = false;
        for (String[] user : users) {
            if (user[0].equals(username)) {
                user[1] = newPassword;
                user[2] = newRole;
                found = true;
            }
        }
        if (!found) return false;
        return writeAllUsers(users);
    }

    public boolean deleteUser(String username) {
        List<String[]> users = getAllUsers();
        boolean removed = users.removeIf(user -> user[0].equals(username));
        if (!removed) return false;
        return writeAllUsers(users);
    }

    private boolean writeAllUsers(List<String[]> users) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getUsersFilePath(), false))) {
            for (String[] user : users) {
                writer.write(user[0] + "," + user[1] + "," + user[2]);
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}