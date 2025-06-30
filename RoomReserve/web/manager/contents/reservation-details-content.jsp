<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="flex h-screen">
    <!-- Admin Sidebar -->
    <jsp:include page="../../components/manager-sidebar.jsp">
        <jsp:param name="page" value="approvals" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
    <!-- Top Navigation -->
    <jsp:include page="../../components/top-navigation.jsp" />

    <!-- Main Content Area -->
    <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
        <!-- Success/Error Messages -->
        <jsp:include page="../../components/messages.jsp" />
        <div class="mb-6">
            <a href="${pageContext.request.contextPath}/manager/reservations" 
               class="text-blue-600 hover:text-blue-800 font-medium flex items-center">
                <i class="fas fa-arrow-left mr-2"></i> Back to reservations
            </a>
        </div>

        <div class="bg-white shadow rounded-lg overflow-hidden mb-8">
            <div class="px-6 py-4 border-b border-gray-200">
                <div class="flex justify-between items-start">
                    <div>
                        <h1 class="text-xl font-bold text-gray-800">Reservation #${reservation.id}</h1>
                        <p class="text-gray-600">${reservation.title}</p>
                    </div>
                    <div>
                        <span class="px-3 py-1 text-sm font-semibold rounded-full 
                            ${reservation.status == 'approved' ? 'bg-green-100 text-green-800' : 
                              reservation.status == 'rejected' ? 'bg-red-100 text-red-800' : 
                              reservation.status == 'pending' ? 'bg-yellow-100 text-yellow-800' : 
                              reservation.status == 'completed' ? 'bg-blue-100 text-blue-800' : 
                              reservation.status == 'no-show' ? 'bg-purple-100 text-purple-800' : 
                              reservation.status == 'cancelled' ? 'bg-gray-100 text-gray-800' :
                              'bg-gray-100 text-gray-800'}">
                            ${reservation.status}
                        </span>
                    </div>
                </div>
            </div>        

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-6">
                <div>
                    <h2 class="text-lg font-medium text-gray-800 mb-4">Reservation Details</h2>
                    <div class="space-y-4">
                        <div>
                            <p class="text-sm text-gray-500">Room</p>
                            <p class="mt-1 text-sm text-gray-800">${reservation.roomName}, ${reservation.buildingName}</p>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-500">Date</p>
                            <p class="mt-1 text-sm text-gray-800">
                                <fmt:formatDate value="${reservation.startDate}" pattern="EEEE, MMMM d, yyyy" />
                            </p>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-500">Time</p>
                            <p class="mt-1 text-sm text-gray-800">
                                <fmt:formatDate value="${reservation.startDate}" pattern="h:mm a" /> - 
                                <fmt:formatDate value="${reservation.endDate}" pattern="h:mm a" />
                                (<fmt:formatNumber value="${(reservation.endDate.time - reservation.startDate.time) / (1000 * 60 * 60)}" maxFractionDigits="1" /> hours)
                            </p>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-500">Requested By</p>
                            <p class="mt-1 text-sm text-gray-800">${reservation.userName} (@${reservation.user.username})</p>
                            <a href="mailto:${reservation.user.email}" class="mt-1 text-sm text-gray-600">${reservation.user.email}</a>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-500">Purpose</p>
                            <p class="mt-1 text-sm text-gray-800">${reservation.title}</p>
                            <p class="text-sm text-gray-600 mt-1">${reservation.purpose}</p>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-500">Submitted On</p>
                            <p class="mt-1 text-sm text-gray-800">
                                <fmt:formatDate value="${reservation.dateCreated}" pattern="MMM d, yyyy 'at' h:mm a" />
                            </p>
                        </div>
                    </div>
                </div>

                <div>
                    <h2 class="text-lg font-medium text-gray-800 mb-4">Status History</h2>
                    <div class="space-y-4">
                        <c:forEach items="${updates}" var="update">
                            <div class="border-l-4 ${update.newStatus == 'approved' ? 'border-green-500' : 
                                                  update.newStatus == 'rejected' ? 'border-red-500' : 
                                                  update.newStatus == 'completed' ? 'border-blue-500' :
                                                  update.newStatus == 'no-show' ? 'border-purple-500' : 
                                                  'border-yellow-500'} pl-4 py-2">
                                <div class="flex justify-between">
                                    <p class="font-medium">
                                        ${update.newStatus == 'approved' ? 'Approved' : 
                                          update.newStatus == 'rejected' ? 'Rejected' : 
                                          update.newStatus == 'completed' ? 'Completed' : 
                                          update.newStatus == 'no-show' ? 'No show' : 
                                          'Status Changed'}
                                    </p>
                                    <p class="text-sm text-gray-500">
                                        <fmt:formatDate value="${update.timeUpdated}" pattern="MMM d, h:mm a" />
                                    </p>
                                </div>
                                <p class="text-sm text-gray-600">by ${update.managerName}</p>
                                <c:if test="${not empty update.comments}">
                                    <div class="mt-2 bg-gray-50 p-2 rounded">
                                        <p class="text-sm text-gray-700">${update.comments}</p>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${reservation.status == 'cancelled' || reservation.status == 'rejected'}">
                        <div class="bg-gray-50 p-4 rounded-md mt-6">
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
                    </c:if>
                    <c:if test="${reservation.status == 'no-show' || reservation.status == 'completed'}">
                        <div class="mt-4 border-t pt-4">
                            <h3 class="font-medium text-lg mb-2">Mark Reservation</h3>
                            <form method="POST" action="${pageContext.request.contextPath}/manager/reservations">
                                <input type="hidden" name="reservationId" value="${reservation.id}">

                                <div class="grid grid-cols-2 gap-2 mb-3">
                                    <button type="submit" name="action" value="completed" 
                                            class="bg-green-600 text-white p-2 rounded hover:bg-green-700">
                                        <i class="fas fa-check-circle mr-1"></i> Completed
                                    </button>

                                    <button type="submit" name="action" value="no show" 
                                            class="bg-red-600 text-white p-2 rounded hover:bg-red-700">
                                        <i class="fas fa-user-slash mr-1"></i> No-Show
                                    </button>
                                </div>

                                <div class="mb-2">
                                    <label class="block text-sm font-medium text-gray-700">Notes</label>
                                    <textarea name="comments" class="w-full border rounded p-2"></textarea>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <c:if test="${reservation.status == 'pending'}">
                        <div class="mt-8">
                            <h3 class="text-lg font-medium text-gray-800 mb-4">Manage Reservation</h3>
                            <div class="mb-4">
                                <label for="comments" class="block text-xs font-medium text-gray-700 mb-1">Approval Comments (Optional)/Reason for Rejection *</label>
                                <textarea id="comments" name="comments" rows="3"
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
                                <p id="comment-error" class="hidden text-xs text-red-600 mt-1">Please provide a reason for rejection</p>
                            </div>
                            <div class="flex space-x-4">
                                <!-- Approval Form -->
                                <form method="POST" action="?action=approve" class="flex-1" id="approveForm">
                                    <input type="hidden" name="reservationId" value="${reservation.id}">
                                    <input type="hidden" name="comments" id="approveComments">
                                    <button type="submit" 
                                            class="w-full bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded-md font-medium transition">
                                        Approve
                                    </button>
                                </form>

                                <!-- Rejection Form -->
                                <form method="POST" action="?action=reject" class="flex-1" id="rejectForm">
                                    <input type="hidden" name="reservationId" value="${reservation.id}">
                                    <input type="hidden" name="comments" id="rejectComments">
                                    <button type="button" onclick="validateRejection()"
                                            class="w-full bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded-md font-medium transition">
                                        Reject
                                    </button>
                                </form>
                            </div>

                            <script>
                                // Handle approval - comments are optional
                                document.getElementById('approveForm').addEventListener('submit', function(e) {
                                    const commentText = document.getElementById('comments').value;
                                    document.getElementById('approveComments').value = commentText;
                                });

                                // Handle rejection - comments are required
                                function validateRejection() {
                                    const commentText = document.getElementById('comments').value.trim();
                                    const errorElement = document.getElementById('comment-error');

                                    if (!commentText) {
                                        errorElement.classList.remove('hidden');
                                        return;
                                    }

                                    errorElement.classList.add('hidden');
                                    document.getElementById('rejectComments').value = commentText;
                                    document.getElementById('rejectForm').submit();
                                }
                            </script>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
    </div>
</div>
<jsp:include page="../../components/manager-mobile-menu.jsp" >
    <jsp:param name="page" value="approvals" />
</jsp:include>                            
                            