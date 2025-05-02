package model;

public class User {
    private String fullName;
    private String username;
    private String password;
    private String role;
    private String contactNo;
    private String email;
    private String address;
    private String birthday;
    private String gender;

    public User(String fullName, String username, String password, String role, String contactNo,
                String email, String address, String birthday, String gender) {
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

    // Getters and Setters
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getContactNo() {
        return contactNo;
    }

    public void setContactNo(String contactNo) {
        this.contactNo = contactNo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }
}