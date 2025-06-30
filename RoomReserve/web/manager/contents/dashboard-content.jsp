<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/manager-sidebar.jsp">
        <jsp:param name="page" value="dashboard" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />

         <!--Main Content Area--> 
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <jsp:include page="../../components/messages.jsp" />
             <!--Page Header--> 
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Welcome, ${user.username}</h1>
                </div>
            </div>

             <!--Stats Cards--> 
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
                <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-blue-500">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Pending Approvals</p>
                            <p class="text-2xl font-semibold text-gray-800">${pendingApprovalsCount}</p>
                        </div>
                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                            <i class="fas fa-clipboard-list text-xl"></i>
                        </div>
                    </div>
                    <p class="mt-2 text-xs text-red-600">
                        Waiting for approval
                    </p>
                </div>

                <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-green-500">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Active Reservations</p>
                            <p class="text-2xl font-semibold text-gray-800">${activeReservationsCount}</p>
                        </div>
                        <div class="p-3 rounded-full bg-green-100 text-green-600">
                            <i class="fas fa-calendar-check text-xl"></i>
                        </div>
                    </div>
                    <p class="mt-2 text-xs text-green-600">
                        At this present moment
                    </p>
                </div>

                <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-yellow-500">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Rooms Available</p>
                            <p class="text-2xl font-semibold text-gray-800">${availableRoomsCount}/${totalRoomsCount}</p>
                        </div>
                        <div class="p-3 rounded-full bg-yellow-100 text-yellow-600">
                            <i class="fas fa-door-open text-xl"></i>
                        </div>
                    </div>
                    <p class="mt-2 text-xs text-gray-600">
                        ${inactiveRooms} inactive rooms
                    </p>
                </div>

                <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-red-500">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Conflicts</p>
                            <p class="text-2xl font-semibold text-gray-800">${conflictCount}</p>
                        </div>
                        <div class="p-3 rounded-full bg-red-100 text-red-600">
                            <i class="fas fa-exclamation-triangle text-xl"></i>
                        </div>
                    </div>
                    <p class="mt-2 text-xs text-red-600">
                        ${conflictMessage}
                    </p>
                </div>
            </div>

             <!--Main Content Row--> 
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
                 <!--Approval Requests--> 
                <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow-sm">
                    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 mb-4">
                        <h2 class="text-lg font-medium text-gray-800">Approval Requests</h2>

                        <div class="grid grid-cols-3 sm:flex gap-2 w-full sm:w-auto">
                            <button class="filter-btn px-2 py-1 sm:px-3 bg-gray-100 border border-gray-300 rounded-md text-xs font-medium text-gray-700 hover:bg-gray-200"
                                    data-filter="today">
                                Today
                            </button>
                            <button class="filter-btn px-2 py-1 sm:px-3 bg-gray-100 border border-gray-300 rounded-md text-xs font-medium text-gray-700 hover:bg-gray-200"
                                    data-filter="week">
                                This Week
                            </button>
                            <button class="filter-btn px-2 py-1 sm:px-3 bg-blue-600 border border-transparent rounded-md text-xs font-medium text-white hover:bg-blue-700"
                                    data-filter="all">
                                All Pending
                            </button>
                        </div>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Requester</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date/Time</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Purpose</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                            </tbody>
                        </table>
                    </div>
                    <div class="mt-4 text-center">
                        <a href="${pageContext.request.contextPath}/manager/reservations" 
                           class="text-sm font-medium text-blue-600 hover:text-blue-800 view-all-link"
                           data-base-url="${pageContext.request.contextPath}/manager/reservations">
                            View all ${pendingApprovalsCount} pending requests
                        </a>
                    </div>
                </div>

                 <!--Room Status & Quick Actions--> 
                <div class="space-y-6">
                     <!--Room Status--> 
                    <div class="bg-white p-6 rounded-lg shadow-sm">
                        <h2 class="text-lg font-medium text-gray-800 mb-4">Room Status Overview</h2>
                        <div class="space-y-4">
                            <c:forEach items="${roomUtilization}" var="room">
                                <div>
                                    <div class="flex justify-between mb-1">
                                        <span class="text-sm font-medium text-gray-700">${room.name}</span>
                                        <span class="text-sm font-medium text-gray-700">
                                            <fmt:formatNumber value="${room.timeUtilizationPercentage}" maxFractionDigits="0"/>% utilized
                                        </span>
                                    </div>
                                    <div class="w-full bg-gray-200 rounded-full h-2.5">
                                        <div class="h-2.5 rounded-full ${room.utilizationClass}" style="width: ${room.timeUtilizationPercentage}%"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/manager/analytics" class="text-sm font-medium text-blue-600 hover:text-blue-800">View detailed room utilization</a>
                        </div>
                    </div>
                </div>
            </div>

             <!--Current Day Schedule--> 
            <div class="bg-white p-6 rounded-lg shadow-sm mb-6">
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 mb-4">
                    <h2 class="text-lg font-medium text-gray-800">Today's Room Schedule</h2>
                    <div class="grid grid-cols-2 sm:flex gap-2 w-full sm:w-auto">
                        <button class="print-schedule-btn px-3 py-1 bg-gray-100 border border-gray-300 rounded-md text-xs font-medium text-gray-700 hover:bg-gray-200">
                            <i class="fas fa-print mr-1"></i> Print
                        </button>
                        <button class="refresh-schedule-btn px-3 py-1 bg-blue-600 border border-transparent rounded-md text-xs font-medium text-white hover:bg-blue-700">
                            <i class="fas fa-sync-alt mr-1"></i> Refresh
                        </button>
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200 room-schedule">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">8-10AM</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">10-12PM</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">12-2PM</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">2-4PM</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">4-6PM</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach items="${todaysSchedule}" var="roomSchedule">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${roomSchedule.roomName}</td>
                                    <c:forEach items="${roomSchedule.timeSlots}" var="slot">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${not empty slot.reservation}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded ${slot.reservation.status}">
                                                        ${slot.reservation.title}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-sm text-gray-500">Available</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Approve Modal --> 
            <div id="approveModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
                <div class="bg-white rounded-lg p-6 w-full max-w-md">
                    <h3 class="text-xl font-bold mb-4">Approve Reservation</h3>
                    <form id="approveForm" method="POST">
                        <input type="hidden" name="action" value="approve">
                        <input type="hidden" name="reservationId" id="approveReservationId">
                        <div class="mb-4">
                            <label for="approveComments" class="block text-sm font-medium text-gray-700 mb-1">Comments (Optional)</label>
                            <textarea id="approveComments" name="comments" rows="3"
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
                        </div>
                        <div class="flex justify-end space-x-3">
                            <button type="button" onclick="hideApproveModal()"
                                    class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300 transition">
                                Cancel
                            </button>
                            <button type="submit"
                                    class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition">
                                Confirm Approval
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Reject Modal -->
            <div id="rejectModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
                <div class="bg-white rounded-lg p-6 w-full max-w-md">
                    <h3 class="text-xl font-bold mb-4">Reject Reservation</h3>
                    <form id="rejectForm" method="POST">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="reservationId" id="rejectReservationId">
                        <div class="mb-4">
                            <label for="rejectComments" class="block text-sm font-medium text-gray-700 mb-1">Reason for Rejection</label>
                            <textarea id="rejectComments" name="comments" rows="3" required
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
                        </div>
                        <div class="flex justify-end space-x-3">
                            <button type="button" onclick="hideRejectModal()"
                                    class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300 transition">
                                Cancel
                            </button>
                            <button type="submit"
                                    class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition">
                                Confirm Rejection
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/manager-dashboard.js"></script>
<script>
    function showApproveModal(reservationId) {
        document.getElementById('approveReservationId').value = reservationId;
        document.getElementById('approveModal').classList.remove('hidden');
    }

    function hideApproveModal() {
        document.getElementById('approveModal').classList.add('hidden');
    }

    function showRejectModal(reservationId) {
        document.getElementById('rejectReservationId').value = reservationId;
        document.getElementById('rejectModal').classList.remove('hidden');
    }

    function hideRejectModal() {
        document.getElementById('rejectModal').classList.add('hidden');
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        if (event.target == document.getElementById('approveModal')) {
            hideApproveModal();
        }
        if (event.target == document.getElementById('rejectModal')) {
            hideRejectModal();
        }
        if (event.target == document.getElementById('exportModal')) {
            closeExportModal();
        }
    }

    // Modal handling functions
    function openExportModal() {
        document.getElementById('exportModal').classList.remove('hidden');
    }

    function closeExportModal() {
        document.getElementById('exportModal').classList.add('hidden');
    }
    // Initialize date picker
    document.addEventListener('DOMContentLoaded', function() {
        flatpickr("#datePicker", {
            defaultDate: "today",
            dateFormat: "M j, Y",
            onChange: function(selectedDates, dateStr, instance) {
                // Refresh the dashboard for the selected date
                window.location.href = '${pageContext.request.contextPath}/manager?date=' + dateStr;
            }
        });
    });
</script>

<jsp:include page="../../components/manager-mobile-menu.jsp" >
    <jsp:param name="page" value="dashboard" />
</jsp:include>