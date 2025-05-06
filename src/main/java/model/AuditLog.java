package model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class AuditLog {
    private String logId;
    private String username;
    private String action;
    private LocalDateTime timestamp;

    public AuditLog(String logId, String username, String action, LocalDateTime timestamp) {
        this.logId = logId;
        this.username = username;
        this.action = action;
        this.timestamp = timestamp;
    }

    public String getLogId() {
        return logId;
    }

    public String getUsername() {
        return username;
    }

    public String getAction() {
        return action;
    }

    public Date getTimestamp() {
        return timestamp != null ? Date.from(timestamp.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }
}