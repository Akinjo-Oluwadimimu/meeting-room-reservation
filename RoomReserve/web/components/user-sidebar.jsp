<%@page import="com.roomreserve.util.SettingsService"%>
<%  
    SettingsService settings = (SettingsService) application.getAttribute("settingsService");
    String systemName = settings.getSetting("system_name", "RoomReserve");
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
            <!-- User Profile -->
            <div class="flex items-center px-4 py-3 bg-blue-700 rounded-lg mb-6">
                <img class="h-10 w-10 rounded-full" src="https://ui-avatars.com/api/?name=${user.firstName} + ${user.lastName}" alt="User profile">
                <div class="ml-3">
                    <p class="text-sm font-medium">${user.firstName} ${user.lastName}</p>
                    <p class="text-xs text-blue-200 uppercase">${user.role}</p>
                </div>
            </div>

            <!-- Navigation -->
            <nav class="flex-1 space-y-2">
                <a href="${pageContext.request.contextPath}/user" class="flex items-center px-4 py-3 text-blue-200 hover:bg-blue-700 hover:text-white ${param.page == 'dashboard' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-tachometer-alt mr-3"></i>
                    Dashboard
                </a>
<!--                <a href="#" class="flex items-center px-4 py-3 text-blue-200 hover:bg-blue-700 hover:text-white ${param.page == 'new-reservation' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-calendar-plus mr-3"></i>
                    New Reservation
                </a>-->
                <a href="${pageContext.request.contextPath}/user/rooms.jsp" class="flex items-center px-4 py-3 text-blue-200 hover:bg-blue-700 hover:text-white ${param.page == 'rooms' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-door-open mr-3"></i>
                    Available Rooms
                </a>
                <a href="${pageContext.request.contextPath}/user/favorites" class="flex items-center px-4 py-3 text-blue-200 hover:bg-blue-700 hover:text-white ${param.page == 'favorites' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-heart mr-3"></i>
                    Favorite Rooms
                </a>
                <a href="${pageContext.request.contextPath}/user/reservations" class="flex items-center px-4 py-3 text-blue-200 hover:bg-blue-700 hover:text-white ${param.page == 'reservations' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-calendar-check mr-3"></i>
                    My Reservations
                </a>    
                <a href="${pageContext.request.contextPath}/user/calendar" class="flex items-center px-4 py-3 text-blue-200 hover:bg-blue-700 hover:text-white ${param.page == 'calendar' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-calendar-alt mr-3"></i>
                    My Calendar
                </a>
                <a href="${pageContext.request.contextPath}/user/reports" class="flex items-center px-4 py-3 text-blue-200 hover:bg-blue-700 hover:text-white ${param.page == 'reports' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                    <i class="fas fa-file-alt mr-3"></i>
                    Reports
                </a>
            </nav>
        </div>
        <div class="px-4 py-4 border-t border-blue-700">
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-4 py-3 text-blue-200 hover:bg-blue-700 hover:text-white ${param.page == 'logout' ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-700 hover:text-white'} rounded-lg">
                <i class="fas fa-sign-out-alt mr-3"></i>
                Logout
            </a>
        </div>
    </div>
</div>