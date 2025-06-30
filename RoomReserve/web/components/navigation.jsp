<%@page import="com.roomreserve.util.SettingsService"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%  
    SettingsService settings = (SettingsService) application.getAttribute("settingsService");
    String systemName = settings.getSetting("system_name", "Room Reservation System");
%>
<!-- navigation.jsp -->
<nav class="bg-blue-700 text-white shadow-lg">
    <div class="container mx-auto px-4">
        <!-- Desktop Nav -->
        <div class="hidden md:flex justify-between items-center py-3">
            <div class="flex items-center space-x-2">
                <i class="fas fa-calendar-alt text-2xl"></i>
                <span class="text-xl font-bold"><%= systemName %></span>
            </div>
            
            <div class="flex space-x-6">
                <a href="${pageContext.request.contextPath}/index.jsp" class="hover:text-blue-200 py-2 ${param.page == 'home' ? 'font-medium border-b-2 border-white' : ''}">Home</a>
                <%-- Show different links based on authentication --%>
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <%-- Authenticated User Navigation --%>
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'admin'}">
                                <a href="${pageContext.request.contextPath}/admin" class="hover:text-blue-200 py-2 ${param.page == 'dashboard' ? 'font-medium border-b-2 border-white' : ''}">Dashboard</a>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'manager'}">
                                <a href="${pageContext.request.contextPath}/manager" class="hover:text-blue-200 py-2 ${param.page == 'dashboard' ? 'font-medium border-b-2 border-white' : ''}">Dashboard</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/user/rooms.jsp" class="hover:text-blue-200 py-2 ${param.page == 'rooms' ? 'font-medium border-b-2 border-white' : ''}">Rooms</a>
                                <a href="${pageContext.request.contextPath}/user/reservations" class="hover:text-blue-200 py-2 ${param.page == 'reservations' ? 'font-medium border-b-2 border-white' : ''}">My Reservations</a>
                                <a href="${pageContext.request.contextPath}/user" class="hover:text-blue-200 py-2 ${param.page == 'dashboard' ? 'font-medium border-b-2 border-white' : ''}">Dashboard</a>
                            </c:otherwise>
                        </c:choose>
                        
                    </c:when>
                    <c:otherwise>
                        <%-- Guest Navigation --%>
                        <a href="about.jsp" class="hover:text-blue-200 py-2 ${param.page == 'about' ? 'font-medium border-b-2 border-white' : ''}">About</a>
                        <a href="contact.jsp" class="hover:text-blue-200 py-2 ${param.page == 'contact' ? 'font-medium border-b-2 border-white' : ''}">Contact</a>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="flex space-x-4">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <%-- User is logged in - show profile dropdown --%>
                        <div class="relative">
                            <button id="user-menu-button" class="flex items-center space-x-2 focus:outline-none">
                                <span class="hidden sm:inline">${sessionScope.username}</span>
                                <img class="h-10 w-10 rounded-full" src="https://ui-avatars.com/api/?name=${user.firstName} + ${user.lastName}" alt="">
                                <i class="fas fa-chevron-down text-xs"></i>
                            </button>
                            
                            <!-- Dropdown menu -->
                            <div id="user-menu" class="hidden absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-50">
                                <a href="${pageContext.request.contextPath}/profile.jsp" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profile</a>
                                <c:if test="${sessionScope.userRole == 'admin'}">
                                    <a href="${pageContext.request.contextPath}/admin/settings" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Settings</a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sign out</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- Guest buttons --%>
                        <a href="login.jsp" class="bg-white text-blue-700 px-4 py-2 rounded-md font-medium hover:bg-blue-100 transition">Login</a>
                        <a href="register.jsp" class="bg-blue-600 px-4 py-2 rounded-md font-medium hover:bg-blue-800 transition">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Mobile Nav -->
        <div class="md:hidden flex justify-between items-center py-3">
            <div class="flex items-center space-x-2">
                <i class="fas fa-calendar-alt text-2xl"></i>
                <span class="text-xl font-bold"><%= systemName %></span>
            </div>
            <button id="mobile-menu-button" class="text-2xl focus:outline-none">
                <i class="fas fa-bars"></i>
            </button>
        </div>
        
        <!-- Mobile Menu -->
        <div id="mobile-menu" class="hidden md:hidden pb-3">
            <div class="flex flex-col space-y-3">
                <a href="${pageContext.request.contextPath}/index.jsp" class="hover:text-blue-200 py-2 border-b border-blue-600">Home</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'admin'}">
                                <a href="${pageContext.request.contextPath}/admin" class="hover:text-blue-200 py-2 border-b border-blue-600">Dashboard</a>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'manager'}">
                                <a href="${pageContext.request.contextPath}/manager" class="hover:text-blue-200 py-2 border-b border-blue-600">Dashboard</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/user/rooms.jsp" class="hover:text-blue-200 py-2 border-b border-blue-600">Rooms</a>
                                <a href="${pageContext.request.contextPath}/user/reservations" class="hover:text-blue-200 py-2 border-b border-blue-600">My Reservations</a>
                                <a href="${pageContext.request.contextPath}/user" class="hover:text-blue-200 py-2 border-b border-blue-600">Dashboard</a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/profile.jsp" class="hover:text-blue-200 py-2 border-b border-blue-600">Profile</a>
                        <a href="${pageContext.request.contextPath}/logout" class="hover:text-blue-200 py-2 border-b border-blue-600">Sign out</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/about.jsp" class="hover:text-blue-200 py-2 border-b border-blue-600">About</a>
                        <a href="${pageContext.request.contextPath}/contact.jsp" class="hover:text-blue-200 py-2 border-b border-blue-600">Contact</a>
                        <div class="pt-2 flex flex-col space-y-3">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="bg-white text-blue-700 px-4 py-2 rounded-md font-medium hover:bg-blue-100 transition text-center">Login</a>
                            <a href="${pageContext.request.contextPath}/register.jsp" class="bg-blue-600 px-4 py-2 rounded-md font-medium hover:bg-blue-800 transition text-center">Register</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
