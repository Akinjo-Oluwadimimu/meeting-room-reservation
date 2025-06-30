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
                    <span class="ml-2 text-xl font-bold text-white">RoomReserve</span>
                </div>
                <nav class="mt-5 px-2 space-y-1">
                    <a href="dashboard.jsp" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'dashboard' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-tachometer-alt mr-4 text-blue-300"></i>
                        Dashboard
                    </a>
                    <a href="department_management.jsp" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'departments' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-building mr-4 text-blue-300"></i>
                        Departments
                    </a>
                    <a href="user_management.jsp" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'users' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-users mr-4 text-blue-300"></i>
                        User Management
                    </a>
                    <a href="room_management.jsp" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'rooms' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-door-open mr-4 text-blue-300"></i>
                        Room Management
                    </a>
                    <a href="reservation_management.jsp" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'reservations' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-calendar-check mr-4 text-blue-300"></i>
                        Reservations
                    </a>
                    <a href="reports.jsp" class="group flex items-center px-2 py-2 text-base font-medium rounded-md ${param.page == 'reports' ? 'text-white bg-blue-900' : 'text-blue-200 hover:text-white hover:bg-blue-700'}">
                        <i class="fas fa-chart-bar mr-4 text-blue-300"></i>
                        Reports
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