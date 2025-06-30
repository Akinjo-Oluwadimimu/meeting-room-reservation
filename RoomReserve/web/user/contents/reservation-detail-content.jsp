<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="booking-configuration.jsp" />

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
            <div class="mb-6">
                <a href="${pageContext.request.contextPath}/user/reservations"
                   class="text-blue-600 hover:text-blue-800 font-medium flex items-center">
                    <i class="fas fa-arrow-left mr-2"></i> Back to My Reservations
                </a>
            </div>

            <c:if test="${not empty success}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                    ${success}
                </div>
                <c:remove scope="session" var="success" />
            </c:if>

            <c:if test="${not empty error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    ${error}
                </div>
                <c:remove scope="session" var="error" />
            </c:if>

            <div class="bg-white shadow rounded-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200">
                    <div class="flex justify-between items-start">
                        <div>
                            <h1 class="text-xl sm:text-2xl font-bold text-gray-800">${reservation.title}</h1>
                            <p class="text-gray-600">${reservation.roomName}, ${reservation.buildingName}</p>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${reservation.status == 'approved'}">
                                    <span class="px-3 py-1 text-sm font-semibold rounded-full bg-green-100 text-green-800">
                                        Approved
                                    </span>
                                </c:when>
                                <c:when test="${reservation.status == 'pending'}">
                                    <span class="px-3 py-1 text-sm font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                        Pending
                                    </span>
                                </c:when>
                                <c:when test="${reservation.status == 'rejected'}">
                                    <span class="px-3 py-1 text-sm font-semibold rounded-full bg-red-100 text-red-800">
                                        Rejected
                                    </span>
                                </c:when>
                                <c:when test="${reservation.status == 'cancelled'}">
                                    <span class="px-3 py-1 text-sm font-semibold rounded-full bg-gray-100 text-gray-800">
                                        Cancelled
                                    </span>
                                </c:when>
                                <c:when test="${reservation.status == 'completed'}">
                                    <span class="px-3 py-1 text-sm font-semibold rounded-full bg-blue-100 text-blue-800">
                                        Completed
                                    </span>
                                </c:when>
                                <c:when test="${reservation.status == 'no-show'}">
                                    <span class="px-3 py-1 text-sm font-semibold rounded-full bg-purple-100 text-purple-800">
                                        No show
                                    </span>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div>
                            <h2 class="text-lg font-medium text-gray-900 mb-4">Reservation Details</h2>

                            <div class="space-y-4">
                                <div>
                                    <h3 class="text-sm font-medium text-gray-500">Date</h3>
                                    <p class="mt-1 text-sm text-gray-900">
                                        <fmt:formatDate value="${reservation.startDate}" pattern="EEEE, MMMM d, yyyy" />
                                    </p>
                                </div>

                                <div>
                                    <h3 class="text-sm font-medium text-gray-500">Time</h3>
                                    <p class="mt-1 text-sm text-gray-900">
                                        <fmt:formatDate value="${reservation.startDate}" pattern="h:mm a" /> - 
                                        <fmt:formatDate value="${reservation.endDate}" pattern="h:mm a" />
                                        (<fmt:formatNumber value="${(reservation.endDate.time - reservation.startDate.time) / (1000 * 60 * 60)}" maxFractionDigits="1" /> hours)
                                    </p>
                                </div>

                                <div>
                                    <h3 class="text-sm font-medium text-gray-500">Purpose</h3>
                                    <p class="mt-1 text-sm text-gray-900">${reservation.purpose}</p>
                                </div>

                                <div>
                                    <h3 class="text-sm font-medium text-gray-500">Attendees</h3>
                                    <p class="mt-1 text-sm text-gray-900">${reservation.attendees}</p>
                                </div>

                                <div>
                                    <h3 class="text-sm font-medium text-gray-500">Created</h3>
                                    <p class="mt-1 text-sm text-gray-900">
                                        <fmt:formatDate value="${reservation.dateCreated}" pattern="MMM d, yyyy h:mm a" />
                                    </p>
                                </div>

                                <c:if test="${not empty updates}">
                                    <div>
                                        <h3 class="text-sm font-medium text-gray-500 mb-1">Status History</h3>
                                        <c:forEach items="${updates}" var="update">
                                            <div class="border-l-4 ${update.newStatus == 'approved' ? 'border-green-500' : 
                                                          update.newStatus == 'rejected' ? 'border-red-500' : 
                                                          update.newStatus == 'completed' ? 'border-blue-500' :
                                                          update.newStatus == 'no-show' ? 'border-purple-500' : 
                                                          'border-yellow-500'} pl-2 mb-2">
                                                <p class="mt-1 text-sm text-gray-900">
                                                    ${update.newStatus == 'approved' ? 'Approved' : 
                                                  update.newStatus == 'rejected' ? 'Rejected' : 
                                                  update.newStatus == 'completed' ? 'Completed' : 
                                                  update.newStatus == 'no-show' ? 'No show' : 
                                                  'Status Changed'} by ${update.managerName}
                                                    <c:if test="${not empty update.timeUpdated}">
                                                        on <fmt:formatDate value="${update.timeUpdated}" pattern="MMM d, yyyy h:mm a" />
                                                    </c:if>
                                                </p>
                                                <c:if test="${not empty update.comments}">
                                                    <p class="mt-1 text-sm text-gray-600">"${update.comments}"</p>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div>
                            <h2 class="text-lg font-medium text-gray-900 mb-4">Manage Reservation</h2>

                            <c:choose>
                                <c:when test="${reservation.status == 'pending' || reservation.status == 'approved'}">
                                    <form action="${pageContext.request.contextPath}/user/reservations" method="POST" class="space-y-4" id="reservationForm" onsubmit="return checkRoomAvailabilityForUpdate(event)">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" id="reservationId" name="reservationId" value="${reservation.id}">
                                        <input type="hidden" id="roomId" name="roomId" value="${reservation.room.id}">
                                        <c:if test="${reservation.status =='approved'}">
                                            <input type="hidden" name="title" value="${reservation.title}">
                                            <input type="hidden" name="purpose" value="${reservation.purpose}">
                                            <input type="hidden" name="reservationDate" value="<fmt:formatDate value="${reservation.startDate}" pattern="yyyy-MM-dd" />">
                                            <input type="hidden" name="startTime" value="<fmt:formatDate value="${reservation.startDate}" pattern="HH:mm" />">
                                            <input type="hidden" name="endTime" value="<fmt:formatDate value="${reservation.endDate}" pattern="HH:mm" />">
                                        </c:if>
                                        <div>
                                            <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Title *</label>
                                            <input type="text" id="title" name="title" required ${reservation.status == 'approved' ? 'disabled' : ''}
                                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                                   value="${reservation.title}">
                                        </div>

                                        <div>
                                            <label for="purpose" class="block text-sm font-medium text-gray-700 mb-1">Purpose</label>
                                            <textarea id="purpose" name="purpose" rows="2" ${reservation.status == 'approved' ? 'disabled' : ''}
                                                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">${reservation.purpose}</textarea>
                                        </div>

                                        <div class="grid grid-cols-2 gap-4">
                                            <div>
                                                <label for="reservationDate" class="block text-sm font-medium text-gray-700 mb-1">Date*</label>
                                                <input type="date" id="reservationDate" name="reservationDate" ${reservation.status == 'approved' ? 'disabled' : ''} 
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                                                       value="<fmt:formatDate value="${reservation.startDate}" pattern="yyyy-MM-dd'T'HH:mm" />" required>
                                            </div>
                                            <div>
                                                <label for="attendees" class="block text-sm font-medium text-gray-700 mb-1">Attendees *</label>
                                                <input type="number" id="attendees" name="attendees" min="1" max="${reservation.room.capacity}" required
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                                       value="${reservation.attendees}">
                                            </div>
                                        </div>

                                        <div class="grid grid-cols-2 gap-4">
                                            <div>
                                                <label for="startTime" class="block text-sm font-medium text-gray-700 mb-1">Start Time *</label>
                                                <input type="time" id="startTime" name="startTime" required ${reservation.status == 'approved' ? 'disabled' : ''}
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                                       value="<fmt:formatDate value="${reservation.startDate}" pattern="HH:mm" />">
                                            </div>
                                            <div>
                                                <label for="endTime" class="block text-sm font-medium text-gray-700 mb-1">End Time *</label>
                                                <input type="time" id="endTime" name="endTime" required ${reservation.status == 'approved' ? 'disabled' : ''}
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                                       value="<fmt:formatDate value="${reservation.endDate}" pattern="HH:mm" />">
                                            </div>
                                        </div>

                                        <div id="bookingError" class="hidden p-4 text-red-700 bg-red-100 rounded-md"></div>
                                        
                                        <div class="flex space-x-4 pt-2">
                                            <button type="submit"
                                                    class="bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-md font-medium transition">
                                                Update Reservation
                                            </button>

                                            <button type="button" onclick="openCancelModal(${reservation.id})"
                                                    class="bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded-md font-medium transition">
                                                Cancel Reservation
                                            </button>
                                        </div>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-gray-50 p-4 rounded-md">
                                        <p class="text-gray-600">
                                            This reservation can no longer be modified because it is ${reservation.status}.
                                        </p>
                                        <c:if test="${reservation.status == 'cancelled' && not empty reservation.cancellationReason}">
                                            <div class="mt-4 p-3 bg-gray-100 rounded-md">
                                                <h4 class="text-sm font-medium text-gray-700">Cancellation Reason:</h4>
                                                <p class="mt-1 text-sm text-gray-600">${reservation.cancellationReason}</p>
                                                <p class="mt-1 text-xs text-gray-500">${reservation.cancellationNote}</p>
                                            </div>
                                        </c:if>
                                        <c:if test="${reservation.status == 'rejected' && not empty reservation.rejectionReason}">
                                            <div class="mt-4 p-3 bg-gray-100 rounded-md">
                                                <h4 class="text-sm font-medium text-gray-700">Rejection Reason:</h4>
                                                <p class="mt-1 text-sm text-gray-600">${reservation.rejectionReason}</p>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
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
<script>
    window.onclick = function(event) {
        if (event.target == document.getElementById('cancel-modal')) {
            closeCancelModal();
        }
    }

    // Cancel modal functions
    function openCancelModal(reservationId) {
        document.getElementById('cancel-reservation-id').value = reservationId;
        document.getElementById('cancel-modal').classList.remove('hidden');
    }

    function closeCancelModal() {
        document.getElementById('cancel-form').reset();
        document.getElementById('cancel-modal').classList.add('hidden');
    }
</script>

<jsp:include page="../../components/user-mobile-menu.jsp" >
    <jsp:param name="page" value="reservations" />
</jsp:include>