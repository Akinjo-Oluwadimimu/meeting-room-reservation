<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<header class="bg-white shadow-sm border-b">
    <div class="flex items-center justify-between px-6 py-5">
        <!-- Mobile menu button -->
        <button class="md:hidden text-gray-500 focus:outline-none" id="mobile-menu-button">
            <i class="fas fa-bars text-xl"></i>
        </button>
        
        <div class="flex-1 max-w-md mx-4">
        </div>

        <!-- Right side icons -->
        <div class="flex items-center">
            
            <c:if test="${sessionScope.userRole != 'admin' && sessionScope.userRole != 'manager'}">
                <div class="relative">
                    <div id="notificationDropdown" class="flex items-center cursor-pointer">
                        <a href="notifications" class="flex items-center text-gray-500 hover:text-gray-700 focus:outline-none">
                            <i class="fas fa-bell"></i>
                            <c:if test="${unreadCount > 0}">
                                <span class="ml-1 bg-red-500 text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center">
                                    ${unreadCount}
                                </span>
                            </c:if>
                        </a>
                    </div>

                    <!-- Notification Dropdown -->
                    <div id="notificationDropdownContent" 
                         class="hidden absolute right-0 mt-2 w-80 bg-white rounded-md shadow-lg z-50 border border-gray-200">
                        <div class="p-2 border-b border-gray-200">
                            <h3 class="font-bold text-gray-800">Notifications</h3>
                        </div>
                        <div id="notificationItems" class="max-h-96 overflow-y-auto">
                            <c:forEach items="${recentNotifications}" var="notification">
                                <a href="${pageContext.request.contextPath}/notifications?${notification.read ? 'markAsUnread' : 'markAsRead'}=${notification.notificationId}" 
                                   class="block px-4 py-3 hover:bg-gray-100 border-b border-gray-100 ${notification.read ? '' : 'bg-blue-50'}" data-notification-id="${notification.notificationId}">
                                    <div class="flex justify-between">
                                        <h4 class="font-medium text-gray-800">${notification.title}</h4>
                                        <span class="text-xs text-gray-500">
                                            <fmt:formatDate value="${notification.dateCreated}" pattern="MMM dd" />
                                        </span>
                                    </div>
                                    <p class="text-sm text-gray-600 mt-1 truncate">${notification.message}</p>
                                </a>
                            </c:forEach>
                        </div>
                        <div id="notificationLoader" class="hidden p-2 text-center">
                            <div class="inline-block h-4 w-4 animate-spin rounded-full border-2 border-solid border-blue-600 border-r-transparent"></div>
                        </div>
                        <div id="loadMoreContainer" class="p-2 border-t border-gray-200 text-center">
                            <button id="loadMoreBtn" class="text-blue-600 text-sm hover:underline" ${unreadCount <= 0 ? 'hidden' : ''}>Load More</button>
                            <a href="${pageContext.request.contextPath}/notifications" class="text-blue-600 text-sm hover:underline block mt-1">View All Notifications</a>
                        </div>

                    </div>
                </div>
            </c:if>
            <div class="relative">
                <button class="flex items-center focus:outline-none" id="user-menu-button">
                    <span class="ml-2 text-gray-700">${user.username}</span>
                    <i class="fas fa-chevron-down ml-1 text-gray-500"></i>
                </button>
                
                <!-- Dropdown menu -->
                <div class="hidden origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-50" id="user-menu" role="menu" aria-orientation="vertical" aria-labelledby="user-menu-button">
                    <div class="py-1" role="none">
                        <a href="${pageContext.request.contextPath}/profile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">Your Profile</a>
                        <c:if test="${sessionScope.userRole == 'admin'}">
                            <a href="${pageContext.request.contextPath}/admin/settings" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">Settings</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">Sign out</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
<!-- JavaScript to toggle the dropdown -->
<script src="${pageContext.request.contextPath}/js/top-navigation.js"></script>