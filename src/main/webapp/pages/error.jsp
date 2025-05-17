<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - MediCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <div class="min-h-screen flex flex-col items-center justify-center p-4">
        <div class="bg-white rounded-xl shadow-lg p-8 max-w-lg w-full text-center">
            <div class="text-red-500 mb-4">
                <i class="fas fa-exclamation-triangle text-6xl"></i>
            </div>
            <h1 class="text-3xl font-bold text-gray-800 mb-4">Oops! Something went wrong</h1>
            <p class="text-gray-600 mb-6">We apologize for the inconvenience. Please try again later or contact support if the problem persists.</p>
            <div class="flex justify-center space-x-4">
                <a href="${pageContext.request.contextPath}/pages/index.jsp" class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700">
                    <i class="fas fa-home mr-2"></i> Return Home
                </a>
                <a href="#" onclick="window.history.back();" class="bg-gray-200 text-gray-700 px-6 py-2 rounded-lg hover:bg-gray-300">
                    <i class="fas fa-arrow-left mr-2"></i> Go Back
                </a>
            </div>
        </div>
    </div>
</body>
</html> 