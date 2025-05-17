# Online Medical Store

A Java-based web application for browsing and ordering medicines online. This store provides a complete online pharmacy experience with user and admin interfaces.

## Key Features

- User registration and authentication
- Product browsing and searching
- Shopping cart functionality
- Order processing
- Admin dashboard for product and user management
- Secure login/logout

## Default Accounts

The system comes with pre-configured default accounts for testing and administration:

### Admin Account
- **Username**: admin
- **Password**: admin123
- **Role**: admin

### User Account
- **Username**: user
- **Password**: user123
- **Role**: user

These default accounts are automatically created if they don't exist in the system. The accounts are stored in the `users.txt` file located in the `WEB-INF` directory.

## Technology Stack

- Java Servlets and JSP
- Jakarta EE
- Apache Tomcat
- HTML/CSS (Tailwind CSS)
- JavaScript
- File-based storage (users.txt, products.txt, etc.)

## Setup and Deployment

1. Clone this repository
2. Configure Apache Tomcat (10.1 or newer)
3. Deploy the application to Tomcat
4. Access the application at http://localhost:8080/medical_store_war_exploded/

## Project Structure

- `src/main/java/` - Java source files (controllers, services, models)
- `src/main/webapp/` - Web resources (JSP pages, CSS, JavaScript)
- `src/main/webapp/WEB-INF/` - Configuration files and secure resources

## License

This project is licensed under the MIT License - see the LICENSE file for details.
