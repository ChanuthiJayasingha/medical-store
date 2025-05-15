package services;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.File;

public class FileHandler {
    private static final String USERS_FILE = "data/users.txt";

    public boolean authenticateUser(String username, String password, String role) {
        try (BufferedReader reader = new BufferedReader(new FileReader(USERS_FILE))) {
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
        }
        return false;
    }

    public List<String[]> getAllUsers() {
        List<String[]> users = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(USERS_FILE))) {
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
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(USERS_FILE, true))) {
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
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(USERS_FILE, false))) {
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