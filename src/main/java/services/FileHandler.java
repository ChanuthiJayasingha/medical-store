package services;

import jakarta.servlet.ServletContext;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Simplified file handler for reading and writing lines to a file.
 */
public class FileHandler {
    private static final Logger LOGGER = Logger.getLogger(FileHandler.class.getName());
    private final String filePath;

    public FileHandler(String filePath) {
        this.filePath = filePath;
    }

    /**
     * Reads all lines from the file.
     * @return List of lines, or empty list if file is inaccessible.
     */
    public List<String> readLines() {
        try {
            Path path = Paths.get(filePath);
            if (!Files.exists(path)) {
                LOGGER.warning("File not found: " + filePath);
                return new ArrayList<>();
            }
            return Files.readAllLines(path);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading file: " + filePath, e);
            return new ArrayList<>();
        }
    }

    /**
     * Writes lines to the file, overwriting existing content.
     * @param lines List of lines to write.
     */
    public void writeLines(List<String> lines) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());
            Files.write(path, lines, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
            LOGGER.info("File written successfully: " + filePath);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing to file: " + filePath, e);
            throw new RuntimeException("Failed to write to file: " + e.getMessage());
        }
    }
}