<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="booking-configuration.jsp" />
<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/user-sidebar.jsp">
        <jsp:param name="page" value="dashboard" />
    </jsp:include>
    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />
             <!--Main Content Area--> 
            <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
                 <!--Page Header--> 
                <div class="flex justify-between items-center mb-6">
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Welcome, ${user.username}</h1>
                </div>

                 <!--Stats Cards--> 
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
                    <!-- Upcoming Meetings Card -->
                    <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-blue-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-500">Upcoming Meetings</p>
                                <p class="text-2xl font-semibold text-gray-800">
                                    <c:out value="${upcomingCount}"/>
                                </p>
                            </div>
                            <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                                <i class="fas fa-calendar-day text-xl"></i>
                            </div>
                        </div>
                        <p class="mt-2 text-xs text-gray-600">
                            <c:choose>
                                <c:when test="${not empty nextMeetingRoom && nextMeetingRoom != 'No upcoming meetings'}">
                                    Next: <c:out value="${nextMeetingTime} - ${nextMeetingRoom}"/>
                                </c:when>
                                <c:otherwise>
                                    No upcoming meetings in the next 7 days
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-green-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-500">Pending Approvals</p>
                                <p class="text-2xl font-semibold text-gray-800">${pendingApprovalsCount}</p>
                            </div>
                            <div class="p-3 rounded-full bg-green-100 text-green-600">
                                <i class="fas fa-clock text-xl"></i>
                            </div>
                        </div>
                        <p class="mt-2 text-xs text-gray-600">
                            Waiting for manager approval
                        </p>
                    </div>

                    <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-yellow-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-500">Recent Cancellations</p>
                                <p class="text-2xl font-semibold text-gray-800">
                                    <c:out value="${cancellationCount}"/>
                                </p>
                            </div>
                            <div class="p-3 rounded-full bg-yellow-100 text-yellow-600">
                                <i class="fas fa-calendar-times text-xl"></i>
                            </div>
                        </div>
                        <p class="mt-2 text-xs text-gray-600">
                            <c:choose>
                                <c:when test="${not empty lastCancelledRoom}">
                                    ${timeframe}: <c:out value="${lastCancelledRoom}"/>
                                </c:when>
                                <c:otherwise>
                                    No cancellations in the past 30 days
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-purple-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-500">Favorite Rooms</p>
                                <p class="text-2xl font-semibold text-gray-800">${favoriteRoomsCount}</p>
                            </div>
                            <div class="p-3 rounded-full bg-purple-100 text-purple-600">
                                <i class="fas fa-star text-xl"></i>
                            </div>
                        </div>
                        <p class="mt-2 text-xs text-gray-600">
                            ${recentFavoriteRoom}
                        </p>
                    </div>
                </div>

                 <!--Today's Schedule--> 
                <div class="bg-white p-6 rounded-lg shadow-sm mb-6">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-sm sm:text-lg font-medium text-gray-800">Today's Schedule</h2>
                        <a href="${pageContext.request.contextPath}/user/calendar" class="text-sm text-blue-600 hover:text-blue-800">View Full Calendar</a>
                    </div>

                    <div class="space-y-4">
                        <c:forEach items="${todaysSchedule}" var="reservation">
                        <!--Current/Upcoming Event--> 
                        <div class="flex items-start p-4 rounded-lg ${reservation.isUpcoming() ? 'hover:bg-gray-50 transition' : 'bg-blue-50 border-l-4 border-blue-500'}">
                            <div class="flex-shrink-0 mt-1 ${reservation.isUpcoming() ? 'text-gray-500' : 'text-blue-600'}">
                                <i class="fas ${reservation.isUpcoming() ? 'fa-clock' : 'fa-calendar-check'} text-xl"></i>
                            </div>
                            <div class="ml-3 flex-1">
                                <div class="flex justify-between items-center gap-2">
                                    <p class="text-sm font-medium text-gray-800 flex-1 min-w-0">
                                      ${reservation.title}
                                    </p>
                                    <span class="flex-shrink-0 px-2 py-0.5 text-xs leading-4 font-semibold rounded-full whitespace-nowrap ${reservation.isUpcoming() ? 'bg-blue-100 text-blue-800' : 'bg-green-100 text-green-800'}">
                                      ${reservation.isUpcoming() ? 'Upcoming' : 'In Progress'}
                                    </span>
                                </div>
                                    <p class="text-sm text-gray-600">${reservation.room.name} <span class="font-bold text-black/100 text-xl">&bull;</span> <fmt:formatDate value="${reservation.startDate}" pattern="h:mm a" /> - 
                                <fmt:formatDate value="${reservation.endDate}" pattern="h:mm a" /></p>
                                <div class="mt-2 flex space-x-3">
                                    <c:if test="${reservation.isUpcoming()}">
                                        <a href="${pageContext.request.contextPath}/user/reservations/${reservation.id}" class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                                            <i class="fas fa-edit mr-1"></i> Modify
                                        </a>
                                        <button onclick="openCancelModal(${reservation.id})" class="text-red-600 hover:text-red-800 text-sm font-medium">
                                            <i class="fas fa-times mr-1"></i> Cancel
                                        </button>
                                    </c:if>
                                    <c:if test="${!reservation.isUpcoming()}">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                            <i class="fas fa-users mr-1"></i> ${reservation.attendees} attendees
                                        </span>
                                        <a href="${pageContext.request.contextPath}/user/reservations/${reservation.id}" class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                                            <i class="fas fa-info-circle mr-1"></i> Details
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        </c:forEach>

                         <!--No more events--> 
                        <div class="text-center py-4 text-gray-500">
                            <p>No more scheduled meetings for today</p>
                        </div>
                    </div>
                </div>

                 <!--Upcoming Reservations & Quick Book--> 
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6" id="upcomingReservations">
                    <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
                    <c:set var="recordsPerPage" value="${param.limit != null ? param.limit : 5}" />
                    <c:set var="start" value="${(currentPage - 1) * recordsPerPage}" />
                    <c:set var="end" value="${(start + recordsPerPage) < userUpcomingReservation.size() ? (start + recordsPerPage) : userUpcomingReservation.size()}" />
                    <c:set var="totalPages" value="${fn:substringBefore((userUpcomingReservation.size() + recordsPerPage - 1) / recordsPerPage, '.')}" />

                     <!--Upcoming Reservations--> 
                    <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow-sm">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-sm sm:text-lg font-medium text-gray-800">Upcoming Reservations (Next 7 Days)</h2>
                            <a href="${pageContext.request.contextPath}/user/reservations" class="text-sm text-blue-600 hover:text-blue-800">View All</a>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Time</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Purpose</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach items="${userUpcomingReservation}" var="reservation" begin="${start}" end="${end-1 < 0 ? 0 : end-1}">
                                        <tr class="hover:bg-gray-50">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><fmt:formatDate value="${reservation.endDate}" pattern="EEE, MMM dd" /></td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${reservation.room.name}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><fmt:formatDate value="${reservation.startDate}" pattern="h:mm a" /> - <fmt:formatDate value="${reservation.endDate}" pattern="h:mm a" /></td>
                                            <td class="px-6 py-4 text-sm text-gray-500">${reservation.title}</td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                                                    ${reservation.status == 'approved' ? 'bg-green-100 text-green-800' :
                                                    reservation.status == 'rejected' ? 'bg-red-100 text-red-800' :
                                                    reservation.status == 'cancelled' ? 'bg-gray-100 text-gray-800' :
                                                    reservation.status == 'pending' ? 'bg-yellow-100 text-yellow-800' :
                                                    reservation.status == 'no-show' ? 'bg-purple-100 text-purple-800' :
                                                    reservation.status == 'completed' ? 'bg-blue-100 text-blue-800' : ''} ">${reservation.status}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <c:if test="${not empty userUpcomingReservation}">
                        <div class="container mx-auto px-4 py-8">
                            <!-- Pagination -->
                            <div class="flex flex-col sm:flex-row justify-between items-center">
                                <!-- Items per page selector -->
                                <div class="relative mb-4 sm:mb-0">
                                    <div class="flex items-center">
                                        <span class="mr-2 text-sm text-gray-700">Items per page:</span>
                                        <div class="relative">
                                            <select onchange="location = this.value;" 
                                                    class="appearance-none bg-white border border-gray-300 text-gray-700 py-1 px-3 pr-8 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm">
                                                <option value="user?page=1&limit=5#upcomingReservations" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                                                <option value="user?page=1&limit=10#upcomingReservations" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                                <option value="user?page=1&limit=20#upcomingReservations" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
                                            </select>
                                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                                <i class="fas fa-chevron-down text-xs"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Page navigation -->
                                <nav class="flex items-center space-x-1">
                                    <c:if test="${currentPage > 1}">
                                        <a href="user?page=${currentPage-1}&limit=${recordsPerPage}#upcomingReservations"
                                           class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                            Previous
                                        </a>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <span class="px-3 py-1 border border-blue-500 bg-blue-100 text-blue-600 rounded-md text-sm font-medium">
                                                    ${i}
                                                </span>
                                            </c:when>
                                            <c:when test="${i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                                <a href="user?page=${i}&limit=${recordsPerPage}#upcomingReservations"
                                                   class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                                    ${i}
                                                </a>
                                            </c:when>
                                            <c:when test="${i == 4 && currentPage > 4}">
                                                <span class="px-3 py-1 text-gray-500">...</span>
                                            </c:when>
                                            <c:when test="${i == totalPages - 2 && currentPage < totalPages - 3}">
                                                <span class="px-3 py-1 text-gray-500">...</span>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="user?page=${currentPage+1}&limit=${recordsPerPage}#upcomingReservations"
                                           class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                            Next
                                        </a>
                                    </c:if>
                                </nav>
                            </div>

                            <!-- Info text -->
                            <div class="mt-4 text-center text-sm text-gray-500">
                                Showing page ${currentPage} of ${totalPages} (${recordsPerPage} items per page)
                            </div>
                        </div>
                        </c:if>
                    </div>

                     <!--Quick Book & Notifications--> 
                    <div class="space-y-6">
                         <!--Quick Book--> 
                        <div class="bg-white p-6 rounded-lg shadow-sm">
                            <h2 class="text-sm sm:text-lg font-medium text-gray-800 mb-4">Quick Book</h2>
                            <form action="${pageContext.request.contextPath}/user/reservation" method="POST" class="space-y-4" id="reservationForm" onsubmit="return checkRoomAvailability(event)">
                                <div>
                                    <label for="roomId" class="block text-sm font-medium text-gray-700 mb-1">Room*</label>
                                    <select id="roomId" name="roomId" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                                        <option value="">Select a room</option>
                                        <c:forEach items="${rooms}" var="room">
                                            <option value="${room.id}">${room.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Title*</label>
                                    <input type="text" id="title" name="title" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                                </div>
                                <div>
                                    <label for="reservationDate" class="block text-sm font-medium text-gray-700 mb-1">Date*</label>
                                    <input type="text" id="reservationDate" name="reservationDate" class="w-full h-10 min-w-0 appearance-none px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label for="startTime" class="block text-sm font-medium text-gray-700 mb-1">Start Time*</label>
                                        <input type="text" id="startTime" name="startTime" class="w-full h-10 min-w-0 appearance-none px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                                    </div>
                                    <div>
                                        <label for="endTime" class="block text-sm font-medium text-gray-700 mb-1">End Time*</label>
                                        <input type="text" id="endTime" name="endTime" class="w-full h-10 min-w-0 appearance-none px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                                    </div>
                                </div>

                                <div id="bookingError" class="hidden p-4 text-red-700 bg-red-100 rounded-md"></div>
                                
                                <div>
                                    <label for="attendees" class="block text-sm font-medium text-gray-700 mb-1">Attendees*</label>
                                    <input type="number" id="attendees" name="attendees" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                                </div>
                                <div>
                                    <label for="purpose" class="block text-sm font-medium text-gray-700 mb-1">Purpose</label>
                                    <textarea id="purpose" name="purpose" rows="2" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" placeholder="Brief description"></textarea>
                                </div>
                                <button type="submit" class="w-full px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                                    Confirm Reservation
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Cancel Reservation Modal -->
    <div id="cancel-modal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
        <div class="bg-white rounded-lg p-6 w-full max-w-md">
            <h3 class="text-xl font-bold mb-4">Cancel Reservation</h3>
            <form id="cancel-form" action="${pageContext.request.contextPath}/user/reservations" method="POST">
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" id="cancel-reservation-id" name="reservationId">
                <div class="mb-4">
                    <select name="reason" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" required>
                    <option value="">Select a reason...</option>
                      <option value="Change of plans">Change of plans</option>
                      <option value="No longer needed">No longer needed</option>
                      <option value="Found a better option">Found a better option</option>
                      <option value="Personal emergency">Personal emergency</option>
                      <option value="Accidental booking">Accidental booking</option>
                      <option value="Incorrect booking made">Incorrect booking made</option>
                      <option value="Other">Other</option>
                  </select>
                </div>
                <div class="mb-4">
                    <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Cancellation notes</label>
                    <textarea id="notes" name="notes" rows="3" required
                              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
                </div>

                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="closeCancelModal()"
                            class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300 transition">
                        Back
                    </button>
                    <button type="submit"
                            class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition">
                        Confirm Cancellation
                    </button>
                </div>
            </form>
        </div>
    </div>         
<script src="${pageContext.request.contextPath}/js/reservation.js"></script>
<jsp:include page="../../components/user-mobile-menu.jsp" >
    <jsp:param name="page" value="dashboard" />
</jsp:include>