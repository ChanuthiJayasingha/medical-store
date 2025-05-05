package model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

/**
 * Represents customer feedback in the MediCare system.
 */
public class Feedback {
    private final String feedbackId;
    private final String username;
    private String comment;
    private int rating;
    private final LocalDate submissionDate;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * Constructs a Feedback with the specified details.
     *
     * @param feedbackId      Unique identifier for the feedback
     * @param username        Username of the user providing feedback
     * @param comment         Feedback comment
     * @param rating          Rating (1-5)
     * @param submissionDate  Date the feedback was submitted
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public Feedback(String feedbackId, String username, String comment, int rating, LocalDate submissionDate) {
        validateFeedbackId(feedbackId);
        validateUsername(username);
        validateComment(comment);
        validateRating(rating);
        validateSubmissionDate(submissionDate);

        this.feedbackId = feedbackId;
        this.username = username;
        this.comment = comment != null ? comment : "";
        this.rating = rating;
        this.submissionDate = submissionDate;
    }

    public String getFeedbackId() {
        return feedbackId;
    }

    public String getUsername() {
        return username;
    }

    public String getComment() {
        return comment;
    }

    public int getRating() {
        return rating;
    }

    public LocalDate getSubmissionDate() {
        return submissionDate;
    }

    /**
     * Sets the comment of the feedback.
     *
     * @param comment The new comment
     */
    public void setComment(String comment) {
        validateComment(comment);
        this.comment = comment != null ? comment : "";
    }

    /**
     * Sets the rating of the feedback.
     *
     * @param rating The new rating
     * @throws IllegalArgumentException if rating is invalid
     */
    public void setRating(int rating) {
        validateRating(rating);
        this.rating = rating;
    }

    private void validateFeedbackId(String feedbackId) {
        if (feedbackId == null || feedbackId.trim().isEmpty()) {
            throw new IllegalArgumentException("Feedback ID cannot be null or empty");
        }
    }

    private void validateUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
    }

    private void validateComment(String comment) {
        if (comment == null) {
            throw new IllegalArgumentException("Comment cannot be null");
        }
    }

    private void validateRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }

    private void validateSubmissionDate(LocalDate submissionDate) {
        if (submissionDate == null) {
            throw new IllegalArgumentException("Submission date cannot be null");
        }
        if (submissionDate.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Submission date cannot be in the future");
        }
    }

    @Override
    public String toString() {
        return String.format("Feedback{feedbackId='%s', username='%s', comment='%s', rating=%d, submissionDate=%s}",
                feedbackId, username, comment, rating, submissionDate.format(DATE_FORMATTER));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Feedback feedback = (Feedback) o;
        return feedbackId.equals(feedback.feedbackId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(feedbackId);
    }
}