<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.roomreserve.util.SettingsService"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%  
    SettingsService settings = (SettingsService) application.getAttribute("settingsService");
    String systemName = settings.getSetting("system_name", "Room Reservation System");
    String adminEmail = settings.getSetting("admin_email", "admin@college.edu");
%>
<footer class="bg-gray-800 text-white py-12">
    <div class="container mx-auto px-4">
        <div class="grid md:grid-cols-3 gap-8">
            <div>
                <h3 class="text-xl font-bold mb-4"><%= systemName %></h3>
                <p class="text-gray-400">The premier meeting room reservation system for academic institutions.</p>
            </div>

            <div>
                <h4 class="font-bold mb-4">Quick Links</h4>
                <ul class="space-y-2">
                    <li><a href="${pageContext.request.contextPath}/index.jsp" class="text-gray-400 hover:text-white">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/about.jsp" class="text-gray-400 hover:text-white">About</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact.jsp" class="text-gray-400 hover:text-white">Contact</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-bold mb-4">Contact Us</h4>
                <ul class="space-y-2">
                    <li class="flex items-center text-gray-400"><i class="fas fa-envelope mr-2"></i> <%= adminEmail %></li>
                    <li class="flex items-center text-gray-400"><i class="fas fa-phone mr-2"></i> (555) 123-4567</li>
                    <li class="flex items-center text-gray-400"><i class="fas fa-map-marker-alt mr-2"></i> 123 College Ave, Campus</li>
                </ul>
            </div>
        </div>

        <div class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-400">
            <p>&copy; 2025 <%= systemName %>. All rights reserved.</p>
        </div>
    </div>
</footer>

<%@include file="mobile-menu-toggle-script.jsp"%>