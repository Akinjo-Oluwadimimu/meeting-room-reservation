<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/user-sidebar.jsp">
        <jsp:param name="page" value="favorites" />
    </jsp:include>
    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />

        <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-4 bg-gray-100">
            <jsp:include page="../../components/messages.jsp" />
            <div class="container py-6">
                <div class="flex justify-between items-center mb-8">
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">My Favorite Rooms</h1>
                    <a href="rooms.jsp" class="text-blue-600 hover:text-blue-800 flex items-center text-sm sm:text-md">
                        <i class="fas fa-arrow-left mr-2"></i> Back to All Rooms
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty favoriteRooms}">
                        <div class="bg-gray-100 pt-4 rounded-lg">
                            <p class="text-gray-600">You haven't added any rooms to favorites yet.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                            <c:forEach items="${favoriteRooms}" var="room">
                                <div class="bg-white rounded-lg shadow-md overflow-hidden border border-gray-200 flex flex-col h-full fav-container">
                                    <div class="p-4 flex flex-col flex-grow">
                                        <div class="flex justify-between items-start">
                                            <h3 class="text-lg font-semibold">${room.name}</h3>
                                            <button class="favorite-btn text-red-500 hover:text-red-700" 
                                                data-room-id="${room.id}" data-action="remove">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <p class="flex flex-wrap gap-2 text-sm text-gray-500 mt-1 mb-4">
                                            <span class="bg-gray-100 text-gray-800 text-xs px-2 py-1 rounded flex items-center">
                                                <i class="fas fa-users mr-1 text-xs"></i> ${room.capacity} people
                                            </span>
                                            <c:forEach items="${room.amenities}" var="amenity">
                                                <span class="bg-gray-100 text-gray-800 text-xs px-2 py-1 rounded flex items-center">
                                                    <i class="${amenity.iconClass} mr-1 text-xs"></i> ${amenity.name}
                                                </span>
                                            </c:forEach>
                                        </p>
                                        <!-- Action Buttons -->
                                        <c:if test="${room.isActive()}">
                                            <div class="mt-auto mt-4 flex space-x-3">
                                                <a href="reserve?roomId=${room.id}" ${room.isActive() ? '' : 'disabled'}
                                                   class="flex-1 inline-flex justify-center items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700">
                                                    <i class="fas fa-calendar-plus mr-2"></i> Book Now
                                                </a>
                                            </div>
                                        </c:if>
                                        <c:if test="${!room.isActive()}">
                                            <div class="mt-auto mt-4 flex space-x-3">
                                                <button disabled
                                                   class="flex-1 inline-flex justify-center items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-300">
                                                    <i class="fas fa-calendar-plus mr-2"></i> Book Now
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>        
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/favorites.js"></script>
<jsp:include page="../../components/user-mobile-menu.jsp" >
    <jsp:param name="page" value="favorites" />
</jsp:include>