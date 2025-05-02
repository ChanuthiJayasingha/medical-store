import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

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
}