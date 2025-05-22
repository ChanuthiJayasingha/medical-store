<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="description" content="MediCare Error Page">
  <title>MediCare - Error</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Inter', sans-serif;
    }
    h1, h2, h3, h4, h5, h6 {
      font-family: 'Poppins', sans-serif;
    }
    .error-bg {
      background: linear-gradient(135deg, #1e3a8a, #3b82f6);
    }
    .error-card {
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .error-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
    }
    .btn {
      transition: background-color 0.2s ease, transform 0.2s ease;
    }
    .btn:hover {
      transform: scale(1.05);
    }
    @media (max-width: 768px) {
      .error-card {
        margin: 1rem;
      }
    }
  </style>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen error-bg">
<div class="error-card bg-white p-8 rounded-lg shadow-lg w-full max-w-md text-center">
  <i class="fas fa-exclamation-circle text-6xl text-red-600 mb-4" aria-hidden="true"></i>
  <h1 class="text-3xl font-bold text-gray-800 mb-4">Oops! Something Went Wrong</h1>
  <p class="text-gray-600 mb-6">
    <c:choose>
      <c:when test="${not empty exception}">
        <c:out value="${exception.message}" default="An unexpected error occurred."/>
      </c:when>
      <c:otherwise>
        An unexpected error occurred.
      </c:otherwise>
    </c:choose>
  </p>
  <div class="flex justify-center space-x-4">
    <a href="${pageContext.request.contextPath}/AdminServlet" class="btn bg-blue-600 text-white px-4 py-2 rounded-full hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-600" role="button" aria-label="Back to Dashboard">
      Back to Dashboard
    </a>
    <a href="mailto:support@medicare.com" class="btn bg-gray-500 text-white px-4 py-2 rounded-full hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-600" role="button" aria-label="Contact Support">
      Contact Support
    </a>
  </div>
  <p class="text-gray-500 text-sm mt-6">Error Code: ${pageContext.errorData.statusCode}</p>
</div>
</body>
</html>