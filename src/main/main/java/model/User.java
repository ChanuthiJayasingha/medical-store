package model;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

/**
 * Represents a user in the MediCare system.
 */
public class User {
    private String fullName;
    private final String username;
    private String password;
    private String role;
    private String contactNo;
    private String email;
    private String address;
    private LocalDate birthday;
    private String gender;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * Constructs a User with the specified details.
     *
     * @param fullName   Full name of the user
     * @param username   Unique username
     * @param password   Password for authentication
     * @param role       Role of the user (e.g., Admin, Customer)
     * @param contactNo  Contact number
     * @param email      Email address
     * @param address    Physical address
     * @param birthday   Date of birth
     * @param gender     Gender of the user
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public User(String fullName, String username, String password, String role, String contactNo,
                String email, String address, LocalDate birthday, String gender) {
        validateFullName(fullName);
        validateUsername(username);
        validatePassword(password);
        validateRole(role);
        validateContactNo(contactNo);
        validateEmail(email);
        validateAddress(address);
        validateBirthday(birthday);
        validateGender(gender);

        this.fullName = fullName;
        this.username = username;
        this.password = password;
        this.role = role;
        this.contactNo = contactNo;
        this.email = email;
        this.address = address;
        this.birthday = birthday;
        this.gender = gender;
    }

    public String getFullName() {
        return fullName;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }

    public String getContactNo() {
        return contactNo;
    }

    public String getEmail() {
        return email;
    }

    public String getAddress() {
        return address;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public String getGender() {
        return gender;
    }

    public void setFullName(String fullName) {
        validateFullName(fullName);
        this.fullName = fullName;
    }

    public void setPassword(String password) {
        validatePassword(password);
        this.password = password;
    }

    public void setRole(String role) {
        validateRole(role);
        this.role = role;
    }

    public void setContactNo(String contactNo) {
        validateContactNo(contactNo);
        this.contactNo = contactNo;
    }

    public void setEmail(String email) {
        validateEmail(email);
        this.email = email;
    }

    public void setAddress(String address) {
        validateAddress(address);
        this.address = address;
    }

    public void setBirthday(LocalDate birthday) {
        validateBirthday(birthday);
        this.birthday = birthday;
    }

    public void setGender(String gender) {
        validateGender(gender);
        this.gender = gender;
    }

    /**
     * Returns the birthday as a java.util.Date for use with JSTL fmt:formatDate.
     *
     * @return the birthday as a java.util.Date, or null if birthday is null
     */
    public Date getBirthdayAsDate() {
        return birthday != null ? Date.from(birthday.atStartOfDay(ZoneId.systemDefault()).toInstant()) : null;
    }

    private void validateFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name cannot be null or empty");
        }
    }

    private void validateUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            throw new IllegalArgumentException("Username can only contain letters, numbers, and underscores");
        }
    }

    private void validatePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        if (password.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters long");
        }
        if (!password.matches("^[a-zA-Z0-9!@#$%^&*()_+=]+$")) {
            throw new IllegalArgumentException("Password can only contain letters, numbers, and common special characters");
        }
    }

    private void validateRole(String role) {
        if (role == null || role.trim().isEmpty()) {
            throw new IllegalArgumentException("Role cannot be null or empty");
        }
        if (!role.equals("Admin") && !role.equals("Customer")) {
            throw new IllegalArgumentException("Role must be either 'Admin' or 'Customer'");
        }
    }

    private void validateContactNo(String contactNo) {
        if (contactNo == null || contactNo.trim().isEmpty()) {
            throw new IllegalArgumentException("Contact number cannot be null or empty");
        }
        if (!contactNo.matches("\\+?\\d{10,15}")) {
            throw new IllegalArgumentException("Invalid contact number format");
        }
    }

    private void validateEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be null or empty");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format");
        }
    }

    private void validateAddress(String address) {
        if (address == null || address.trim().isEmpty()) {
            throw new IllegalArgumentException("Address cannot be null or empty");
        }
        if (address.contains(",")) {
            throw new IllegalArgumentException("Address cannot contain commas");
        }
    }

    private void validateBirthday(LocalDate birthday) {
        if (birthday == null) {
            throw new IllegalArgumentException("Birthday cannot be null");
        }
        if (birthday.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Birthday cannot be in the future");
        }
    }

    private void validateGender(String gender) {
        if (gender == null || gender.trim().isEmpty()) {
            throw new IllegalArgumentException("Gender cannot be null or empty");
        }
    }

    @Override
    public String toString() {
        return String.format("User{username='%s', fullName='%s', role='%s', email='%s', birthday=%s}",
                username, fullName, role, email, birthday != null ? birthday.format(DATE_FORMATTER) : "null");
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return username.equals(user.username);
    }

    @Override
    public int hashCode() {
        return Objects.hash(username);
    }
}