<%@page import="com.roomreserve.util.SettingsService"%>
<%  
    SettingsService settings = (SettingsService) application.getAttribute("settingsService");
    String systemName = settings.getSetting("system_name", "Room Reservation System");
%>
<footer class="bg-gray-800 text-white py-6">
    <div class="container mx-auto px-4 text-center text-gray-400">
        <p>&copy; 2025 <%= systemName %>. All rights reserved.</p>
    </div>
</footer>