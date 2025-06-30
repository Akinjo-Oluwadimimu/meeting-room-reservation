<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="flex h-screen">
    <!-- Admin Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
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
            <a href="${pageContext.request.contextPath}/admin/reservations" 
               class="text-blue-600 hover:text-blue-800 font-medium flex items-center">
                <i class="fas fa-arrow-left mr-2"></i> Back to reservations
            </a>
        </div>

        <div class="bg-white shadow rounded-lg overflow-hidden mb-8">
            <div class="px-6 py-4 border-b border-gray-200">
                <div class="flex justify-between items-start">
                    <div>
                        <h1 class="text-2xl font-bold text-gray-800">Reservation #${reservation.id}</h1>
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
                                This reservation has been ${reservation.status}.
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
                        <div class="bg-gray-50 p-4 rounded-md mt-6">
                            <p class="text-gray-600">
                                ${reservation.status == 'no-show' ? 'This reservation was missed by the user' : 'This reservation has been completed'}.
                            </p>
                            <c:if test="${not empty reservation.checkInTime}">
                                <span class="text-sm text-gray-500">Check in time: <fmt:formatDate value="${reservation.checkedInTime}" pattern="MMM d, yyyy h:mm a" /></span>
                            </c:if>
                        </div>
                    </c:if>
                    
                    <c:if test="${reservation.status == 'pending'}">
                        <div class="bg-gray-50 p-4 rounded-md mt-6">
                            <p class="text-gray-600">
                                This reservation is pending a manager's review.
                            </p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
    </div>
</div>
<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="approvals" />
</jsp:include>                            
                            