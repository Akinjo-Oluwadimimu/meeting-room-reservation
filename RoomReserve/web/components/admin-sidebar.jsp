<%@page import="com.roomreserve.util.SettingsService"%>
<%
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
            <!-- Admin Profile -->
            <div class="flex items-center px-4 py-3 bg-blue-700 rounded-lg mb-6">
                <img class="h-10 w-10 rounded-full" src="https://ui-avatars.com/api/?name=${user.firstName} + ${user.lastName}" alt="Admin profile">
                <div class="ml-3">
                    <p class="text-sm font-medium">${user.firstName} ${user.lastName}</p>
                    <p class="text-xs text-blue-200">Administrator</p>
                </div>
            </div>

            <!-- Navigation -->
            <nav class="flex-1 space-y-2">
                <a href="${pageContext.request.contextPath}/admin" class="flex items-center px-4 py-3 ${param.page == 'dashboard' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-tachometer-alt mr-3"></i>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/user_management.jsp" class="flex items-center px-4 py-3 ${param.page == 'users' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-users mr-3"></i>
                    Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/room_management.jsp" class="flex items-center px-4 py-3 ${param.page == 'rooms' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-door-open mr-3"></i>
                    Rooms
                </a>
                <a href="${pageContext.request.contextPath}/admin/building_management.jsp" class="flex items-center px-4 py-3 ${param.page == 'buildings' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-building mr-3"></i>
                    Buildings
                </a>
                <a href="${pageContext.request.contextPath}/admin/department_management.jsp" class="flex items-center px-4 py-3 ${param.page == 'departments' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-building-user mr-3"></i>
                    Departments
                </a>
                <a href="${pageContext.request.contextPath}/admin/reservations" class="flex items-center px-4 py-3 ${param.page == 'reservations' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-calendar-check mr-3"></i>
                    Reservations
                </a>
                <a href="${pageContext.request.contextPath}/admin/login-logs" class="flex items-center px-4 py-3 ${param.page == 'login-logs' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-right-to-bracket mr-3"></i>
                    Login Logs
                </a>
                <a href="${pageContext.request.contextPath}/admin/analytics" class="flex items-center px-4 py-3 ${param.page == 'utilization' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-chart-pie mr-3"></i>
                    Utilization Reports
                </a>
                <a href="${pageContext.request.contextPath}/admin/cancellations" class="flex items-center px-4 py-3 ${param.page == 'cancellations' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-exclamation-triangle mr-3"></i>
                    Cancellations
                </a>    
                <a href="${pageContext.request.contextPath}/admin/reports" class="flex items-center px-4 py-3 ${param.page == 'reports' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-chart-bar mr-3"></i>
                    Reports
                </a>
                <a href="${pageContext.request.contextPath}/admin/export" class="flex items-center px-4 py-3 ${param.page == 'export' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
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