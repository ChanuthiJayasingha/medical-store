package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

/**
 * Represents an audit log entry in the MediCare system.
 */
public class AuditLog {
    private final String logId;
    private final String username;
    private String action;
    private final LocalDateTime timestamp;
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * Constructs an AuditLog with the specified details.
     *
     * @param logId     Unique identifier for the audit log
     * @param username  Username of the user performing the action
     * @param action    Description of the action performed
     * @param timestamp Timestamp of when the action occurred
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public AuditLog(String logId, String username, String action, LocalDateTime timestamp) {
        validateLogId(logId);
        validateUsername(username);
        validateAction(action);
        validateTimestamp(timestamp);

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

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    /**
     * Sets the action of the audit log.
     *
     * @param action The new action
     * @throws IllegalArgumentException if action is invalid
     */
    public void setAction(String action) {
        validateAction(action);
        this.action = action;
    }

    private void validateLogId(String logId) {
        if (logId == null || logId.trim().isEmpty()) {
            throw new IllegalArgumentException("Log ID cannot be null or empty");
        }
    }

    private void validateUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
    }

    private void validateAction(String action) {
        if (action == null || action.trim().isEmpty()) {
            throw new IllegalArgumentException("Action cannot be null or empty");
        }
    }

    private void validateTimestamp(LocalDateTime timestamp) {
        if (timestamp == null) {
            throw new IllegalArgumentException("Timestamp cannot be null");
        }
        if (timestamp.isAfter(LocalDateTime.now())) {
            throw new IllegalArgumentException("Timestamp cannot be in the future");
        }
    }

    @Override
    public String toString() {
        return String.format("AuditLog{logId='%s', username='%s', action='%s', timestamp=%s}",
                logId, username, action, timestamp.format(DATETIME_FORMATTER));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AuditLog auditLog = (AuditLog) o;
        return logId.equals(auditLog.logId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(logId);
    }
}