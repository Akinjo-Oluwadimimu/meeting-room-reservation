<%@page import="com.roomreserve.dao.ReservationDAO"%>
<%@page import="com.roomreserve.util.SettingsService"%>
<%  
    ReservationDAO reservationDAO = new ReservationDAO();
    SettingsService settings = (SettingsService) application.getAttribute("settingsService");
    String systemName = settings.getSetting("system_name", "Room Reservation System");
%>
<!-- Mobile Menu (hidden by default) -->
<div id="mobile-menu" class="hidden md:hidden fixed inset-0 z-50">
    <div class="fixed inset-0 bg-gray-600 bg-opacity-75"></div>
    <div class="fixed inset-0 flex z-50">
        <div class="relative flex-1 flex flex-col max-w-xs w-full bg-blue-800">
            <div class="absolute top-0 right-0 -mr-12 pt-2">
                <button type="button" class="ml-1 flex items-center justify-center h-10 w-10 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                        id="mobile-menu-close">
                    <span class="sr-only">Close sidebar</span>
                    <i class="fas fa-times text-white text-xl"></i>
                </button>
            </div>
            <div class="flex-1 h-0 pt-5 pb-4 overflow-y-auto">
                <div class="flex-shrink-0 flex items-center px-4">
                    <i class="fas fa-calendar-alt text-2xl text-white"></i>
                    <span class="ml-2 text-xl font-bold text-white"><%= systemName %></span>
                </div>
                <nav class="mt-5 px-2 space-y-1">
                    <a href="${pageContext.request.contextPath}/manager" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'dashboard' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-tachometer-alt mr-4 text-blue-300"></i>
                        Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/reservations" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'approvals' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-clipboard-check mr-4 text-blue-300"></i>
                        Approvals<% if (reservationDAO.getPendingApprovalsCount() > 0) {%>
                        <span class="ml-auto bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full"><%= reservationDAO.getPendingApprovalsCount() %></span>
                    <% } %>
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/room-calendar" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'calendar' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-calendar-alt mr-4 text-blue-300"></i>
                        Room Calendar
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/room_management.jsp" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'rooms' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-door-open mr-4 text-blue-300"></i>
                        Manage Rooms
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/analytics" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'utilization' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-chart-pie mr-4 text-blue-300"></i>
                        Utilization Report
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/cancellations" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'cancellations' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-exclamation-triangle mr-4 text-blue-300"></i>
                        Cancellations
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/export" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'export' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-file-export mr-4 text-blue-300"></i>
                        Export Data
                    </a>
                </nav>
            </div>
            <div class="flex-shrink-0 flex border-t border-blue-700 p-4">
                <a href="${pageContext.request.contextPath}/logout" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'logout' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                    <i class="fas fa-sign-out-alt mr-4 text-blue-300"></i>
                    Logout
                </a>
            </div>
        </div>
        <div class="flex-shrink-0 w-14"></div>
    </div>
</div>

<script>
    // Mobile menu toggle
    document.getElementById('mobile-menu-button').addEventListener('click', function() {
        document.getElementById('mobile-menu').classList.remove('hidden');
    });

    document.getElementById('mobile-menu-close').addEventListener('click', function() {
        document.getElementById('mobile-menu').classList.add('hidden');
    });
</script>