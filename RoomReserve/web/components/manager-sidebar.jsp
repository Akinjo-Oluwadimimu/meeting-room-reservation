<%@page import="com.roomreserve.util.SettingsService"%>
<%@page import="com.roomreserve.dao.ReservationDAO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%  ReservationDAO reservationDAO = new ReservationDAO();
    SettingsService settings = (SettingsService) application.getAttribute("settingsService");
    String systemName = settings.getSetting("system_name", "Room Reservation System");
%>
<!-- Sidebar -->
<div class="hidden md:flex md:flex-shrink-0">
    <div class="flex flex-col w-64 bg-blue-800 text-white">
        <div class="flex items-center justify-center h-16 px-4 border-b border-blue-700">
            <div class="flex items-center space-x-2">
                <i class="fas fa-calendar-alt text-2xl"></i>
                <span class="text-xl font-bold"><%= systemName %></span>
            </div>
        </div>
        <div class="flex flex-col flex-grow px-4 py-4 overflow-y-auto scrollbar-hide">
            <!-- Manager Profile -->
            <div class="flex items-center px-4 py-3 bg-blue-700 rounded-lg mb-6">
                <img class="h-10 w-10 rounded-full" src="https://ui-avatars.com/api/?name=${user.firstName} + ${user.lastName}" alt="Admin profile">
                <div class="ml-3">
                    <p class="text-sm font-medium">${user.firstName} ${user.lastName}</p>
                    <p class="text-xs text-blue-200">Room Manager</p>
                </div>
            </div>

            <!-- Navigation -->
            <nav class="flex-1 space-y-2">
                <a href="${pageContext.request.contextPath}/manager" class="flex items-center px-4 py-3 ${param.page == 'dashboard' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-tachometer-alt mr-3"></i>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/manager/reservations" class="flex items-center px-4 py-3 ${param.page == 'approvals' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-clipboard-check mr-3"></i>
                    Approvals<% if (reservationDAO.getPendingApprovalsCount() > 0) {%>
                        <span class="ml-auto bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full"><%= reservationDAO.getPendingApprovalsCount() %></span>
                    <% } %>
                </a>
                <a href="${pageContext.request.contextPath}/manager/room-calendar" class="flex items-center px-4 py-3 ${param.page == 'calendar' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-calendar-alt mr-3"></i>
                    Room Calendar
                </a>
                <a href="${pageContext.request.contextPath}/manager/room_management.jsp" class="flex items-center px-4 py-3 ${param.page == 'rooms' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-door-open mr-3"></i>
                    Manage Rooms
                </a>
                <a href="${pageContext.request.contextPath}/manager/analytics" class="flex items-center px-4 py-3 ${param.page == 'utilization' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-chart-pie mr-3"></i>
                    Utilization Reports
                </a>
                <a href="${pageContext.request.contextPath}/manager/cancellations" class="flex items-center px-4 py-3 ${param.page == 'cancellations' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-exclamation-triangle mr-3"></i>
                    Cancellations
                </a>
                <a href="${pageContext.request.contextPath}/manager/export" class="flex items-center px-4 py-3 ${param.page == 'export' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-file-export mr-3"></i>
                    Export Data
                </a>
            </nav>
        </div>
        <div class="px-4 py-4 border-t border-blue-700">
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-4 py-3 ${param.page == 'logout' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                <i class="fas fa-sign-out-alt mr-3"></i>
                Logout
            </a>
        </div>
    </div>
</div>              