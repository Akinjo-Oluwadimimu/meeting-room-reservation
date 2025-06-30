<%@page import="com.roomreserve.util.SettingsService"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%  
    SettingsService settings = (SettingsService) application.getAttribute("settingsService");
    String systemName = settings.getSetting("system_name", "RoomReserve");
%>
<!DOCTYPE html>
<html>
<head>
    <title>${param.title} | <%= systemName %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/images/icon/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/images/icon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/images/icon/favicon-16x16.png">
    <link rel="manifest" href="${pageContext.request.contextPath}/images/icon/site.webmanifest">
    <style>
        /* Loading spinner animation */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .animate-spin {
            animation: spin 1s linear infinite;
        }
        
        @media (max-width: 640px) {
            #notificationDropdownContent {
                width: 70vw;
                right: -25vw !important;
                left: auto !important;
                transform: none !important;
            }
        }
        
        .scrollbar-hide::-webkit-scrollbar {
            display: none;
        }

        .scrollbar-hide {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
        
        /* Notification dropdown styling */
        #notificationDropdownContent {
            animation: fadeIn 0.2s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .notification-item.unread {
            background-color: #f0f9ff;
        }

        .notification-item:hover {
            background-color: #f8fafc;
        }

        /* Scrollbar styling for dropdown */
        #notificationItems::-webkit-scrollbar {
            width: 6px;
        }

        #notificationItems::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }

        #notificationItems::-webkit-scrollbar-thumb {
            background: #cbd5e0;
            border-radius: 3px;
        }

        #notificationItems::-webkit-scrollbar-thumb:hover {
            background: #a0aec0;
        }
        
        input[type="date"], input[type="time"] {
            -webkit-appearance: none;
            min-width: 0;
        }

    </style>
</head>
<body class="bg-gray-100">
    <script>
        const BASE_PATH = '${pageContext.request.contextPath}';
    </script>
    <jsp:include page="${param.content}" />
</body>
</html>