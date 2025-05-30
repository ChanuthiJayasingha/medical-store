package services;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class BackupService {
    private final String basePath;
    private final services.AuditService auditService;

    public BackupService(String basePath, services.AuditService auditService) {
        this.basePath = basePath;
        this.auditService = auditService;
    }

    public void createBackup(String username) throws IOException {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        File backupDir = new File(basePath + "backup_" + timestamp);
        if (!backupDir.exists()) {
            backupDir.mkdir();
        }
        copyFile("feedback.txt", backupDir);
        copyFile("orders.txt", backupDir);
        copyFile("products.txt", backupDir);
        copyFile("users.txt", backupDir);
        copyFile("audit.txt", backupDir);
        auditService.addAuditLog("Backup created at " + timestamp + " by " + username);
    }

    private void copyFile(String fileName, File backupDir) throws IOException {
        Files.copy(new File(basePath + fileName).toPath(), new File(backupDir, fileName).toPath());
    }
}