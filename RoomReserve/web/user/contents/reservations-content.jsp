<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>

<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/user-sidebar.jsp">
        <jsp:param name="page" value="reservations" />
    </jsp:include>
    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />

        <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <jsp:include page="../../components/messages.jsp" />

            <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
            <c:set var="recordsPerPage" value="${param.limit != null ? param.limit : 10}" />
            <c:set var="start" value="${(currentPage - 1) * recordsPerPage}" />
            <c:set var="end" value="${(start + recordsPerPage) < reservations.size() ? (start + recordsPerPage) : reservations.size()}" />
            <c:set var="totalPages" value="${fn:substringBefore((reservations.size() + recordsPerPage - 1) / recordsPerPage, '.')}" />

            <div class="flex justify-between items-center mb-8">
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">My Reservations</h1>
                <div class="flex space-x-4">
                    <a href="?show=${showAll ? 'current' : 'all'}&page=1&limit=${recordsPerPage}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}" 
                       class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">
                        ${showAll ? 'Show Current Only' : 'Show All Reservations'}
                    </a>
                </div>
            </div>

            <!-- Filters -->
            <div class="bg-white p-4 rounded-lg shadow-sm mb-6">
                <form method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <input type="hidden" name="action" value="search">
                    <input type="hidden" name="limit" value="${recordsPerPage}">
                    <input type="hidden" name="show" value="${showAll ? 'all' : 'current'}">

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Date</label>
                        <input type="text" id="startDate" value="${param.startDate}" name="startDate" value="${startDate}" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md">
                    </div>


                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Room</label>
                        <select name="roomId" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">All Rooms</option>
                            <c:forEach items="${rooms}" var="room">
                                <option value="${room.id}" ${param.roomId == room.id ? 'selected' : ''}>${room.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                        <select name="status" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">All</option>
                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
                            <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                            <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
                            <option value="no-show" ${param.status == 'no-show' ? 'selected' : ''}>No show</option>
                        </select>
                    </div>

                    <div class="flex items-end">
                        <button type="submit" 
                                class="w-full bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">
                            <i class="fas fa-filter"></i> Filter
                        </button>
                    </div>
                </form>
            </div>

            <div class="bg-white shadow rounded-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Time</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Purpose</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach items="${reservations}" var="reservation" begin="${start}" end="${end-1 < 0 ? 0 : end-1}">
                                <tr data-reservation-id="${reservation.id}">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <a href="reserve/${reservation.roomName.replaceAll("\\s+", "-").replaceAll("[^\\w-]", "")}?roomId=${reservation.roomId}"><div class="font-medium text-gray-900">${reservation.roomName}</div></a>
                                        <div class="text-sm text-gray-500">${reservation.buildingName}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <fmt:formatDate value="${reservation.startDate}" pattern="EEE, MMM d, yyyy" />
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <fmt:formatDate value="${reservation.startDate}" pattern="h:mm a" /> - 
                                        <fmt:formatDate value="${reservation.endDate}" pattern="h:mm a" />
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-sm text-gray-900 truncate max-w-xs">${reservation.title}</div>
                                        <div class="text-sm text-gray-500 truncate max-w-xs">${reservation.purpose}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${reservation.status == 'approved'}">
                                                <span class="px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">
                                                    Approved
                                                </span>
                                            </c:when>
                                            <c:when test="${reservation.status == 'pending'}">
                                                <span class="px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                    Pending
                                                </span>
                                            </c:when>
                                            <c:when test="${reservation.status == 'rejected'}">
                                                <span class="px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">
                                                    Rejected
                                                </span>
                                            </c:when>
                                            <c:when test="${reservation.status == 'cancelled'}">
                                                <span class="px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">
                                                    Cancelled
                                                </span>
                                            </c:when>
                                            <c:when test="${reservation.status == 'complted'}">
                                                <span class="px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">
                                                    Completed
                                                </span>
                                            </c:when>
                                            <c:when test="${reservation.status == 'no-show'}">
                                                <span class="px-2 py-1 text-xs font-semibold rounded-full bg-purple-100 text-purple-800">
                                                    No show
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">
                                                    ${reservation.status}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <a href="${pageContext.request.contextPath}/user/reservations/${reservation.id}"
                                           class="text-blue-600 hover:text-blue-900 mr-1" title="View"><i class="fas fa-info-circle"></i></a>
                                        <c:if test="${reservation.status == 'pending' || reservation.status == 'approved'}">
                                            <a href="#" onclick="openCancelModal(${reservation.id})"
                                               class="text-red-600 hover:text-red-900 mr-1" title="Cancel"><i class="fas fa-times-circle"></i></a>
                                        </c:if>
                                        <c:if test="${reservation.status == 'approved'}">
                                            <a href="#" onclick="handleCheckIn(${reservation.id})"
                                               class="text-red-600 hover:text-red-900" title="Check in"><i class="fas fa-calendar-check"></i></a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <c:if test="${not empty reservations}">
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
                                        <option value="reservations?page=1&limit=5&show=${show}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                                        <option value="reservations?page=1&limit=10&show=${show}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                        <option value="reservations?page=1&limit=20&show=${show}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
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
                                <a href="reservations?page=${currentPage-1}&limit=${recordsPerPage}&show=${show}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}"
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
                                        <a href="reservations?page=${i}&limit=${recordsPerPage}&show=${show}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}"
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
                                <a href="reservations?page=${currentPage+1}&limit=${recordsPerPage}&show=${show}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}"
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


            <c:if test="${empty reservations}">
                <div class="bg-white p-8 rounded-lg shadow-sm text-center">
                    <i class="fas fa-calendar-times text-5xl text-gray-400 mb-4"></i>
                    <h3 class="text-lg font-medium text-gray-900 mb-1">No ${statusFilter} reservations found</h3>
                    <p class="text-gray-500">
                        ${showAll ? 'You haven\'t made any reservations yet.' : 'You don\'t have any upcoming reservations.'}
                    </p>
                    <a href="${pageContext.request.contextPath}/user/rooms.jsp"
                       class="mt-4 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700">
                        Book a Room
                    </a>
                </div>
            </c:if>
        </main>
    </div>
</div>

<!-- Cancel Reservation Modal -->
<div id="cancel-modal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50 p-2">
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

<script src="${pageContext.request.contextPath}/js/user-reservations-content.js"></script>

<jsp:include page="../../components/user-mobile-menu.jsp" >
    <jsp:param name="page" value="reservations" />
</jsp:include>