<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title} | Room Reservation System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/images/icon/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/images/icon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/images/icon/favicon-16x16.png">
    <link rel="manifest" href="${pageContext.request.contextPath}/images/icon/site.webmanifest">
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col items-center justify-center p-4">
        <div class="w-full max-w-md bg-white rounded-lg shadow-md overflow-hidden">
            <div class="p-6">
                ${errorContent}
            </div>
            <div class="px-6 py-4 bg-gray-50 text-center">
                <a href="${pageContext.request.contextPath}/" 
                   class="text-blue-600 hover:text-blue-800 font-medium">
                    <i class="fas fa-home mr-2"></i>Return to Home
                </a>
            </div>
        </div>
    </div>
</body>
</html>