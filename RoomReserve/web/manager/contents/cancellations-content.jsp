<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="flex h-screen">
    <!-- Admin Sidebar -->
    <jsp:include page="../../components/manager-sidebar.jsp">
        <jsp:param name="page" value="cancellations" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
    <!-- Top Navigation -->
    <jsp:include page="../../components/top-navigation.jsp" />

    <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">
                    <c:choose>
                        <c:when test="${not empty room}">
                            Cancellations for ${room.name}
                        </c:when>
                        <c:otherwise>
                            Cancelled Reservations
                        </c:otherwise>
                    </c:choose>
                </h1>

                <a href="${pageContext.request.contextPath}/manager/analytics" 
                   class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">
                    View Analytics
                </a>
            </div>

            <!-- Filters -->
            <div class="bg-white p-4 rounded-lg shadow-sm mb-6">
                <form method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <input type="hidden" name="action" value="search">

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
                            <option value="all">All Cancellations</option>
                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                            <option value="no-show" ${param.status == 'no-show' ? 'selected' : ''}>No Show</option>
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

            <!-- Cancellations Table -->
            <div class="bg-white shadow rounded-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Room
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    User
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Date & Time
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Title
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Status
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Reason
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Actions
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach items="${cancellations}" var="cancel">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="font-medium text-gray-900">${cancel.roomName}</div>
                                        <div class="text-sm text-gray-500">${cancel.buildingName}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="font-medium text-gray-900">${cancel.userName}</div>
                                        <div class="text-sm text-gray-500">${cancel.user.email}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-gray-900">
                                            <fmt:formatDate value="${cancel.startDate}" pattern="MMM d, yyyy" />
                                        </div>
                                        <div class="text-sm text-gray-500">
                                            <fmt:formatDate value="${cancel.startDate}" pattern="h:mm a" /> - 
                                            <fmt:formatDate value="${cancel.endDate}" pattern="h:mm a" />
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-gray-900">${cancel.title}</div>
                                        <div class="text-sm text-gray-500 truncate max-w-xs">${cancel.purpose}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 py-1 text-xs font-semibold rounded-full 
                                            ${cancel.status == 'cancelled' ? 'bg-red-100 text-red-800' : 'bg-yellow-100 text-yellow-800'}">
                                            ${cancel.status}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-sm text-gray-500">${cancel.cancellationReason != null ? cancel.cancellationReason : 'No reason provided'}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <a href="${pageContext.request.contextPath}/manager/reservations?action=view&id=${cancel.id}" 
                                           class="text-blue-600 hover:text-blue-900"><i class="fas fa-info-circle"></i> Details</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            
                <!-- Pagination -->
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
                                        <option value="cancellations?page=1&limit=10&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}" ${limit == 10 ? 'selected' : ''}>10</option>
                                        <option value="cancellations?page=1&limit=20&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}" ${limit == 20 ? 'selected' : ''}>20</option>
                                        <option value="cancellations?page=1&limit=50&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}" ${limit == 50 ? 'selected' : ''}>50</option>
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
                                <a href="cancellations?page=${currentPage-1}&limit=${limit}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}"
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
                                        <a href="cancellations?page=${i}&limit=${limit}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}"
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
                                <a href="cancellations?page=${currentPage+1}&limit=${limit}&startDate=${dateFilter}&roomId=${roomIdFilter}&status=${statusFilter}"
                                   class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                    Next
                                </a>
                            </c:if>
                        </nav>
                    </div>

                    <!-- Info text -->
                    <div class="mt-4 text-center text-sm text-gray-500">
                        Showing page ${currentPage} of ${totalPages} (${limit} items per page)
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>


<script>
    const startDate = document.getElementById('startDate');
    // Initialize flatpickr for date input
    datePicker = flatpickr(startDate, {
        dateFormat: 'Y-m-d',
        mode: "range",
        //allowInput: true,
        placeholder: 'Select a date'
    });
</script>

<jsp:include page="../../components/manager-mobile-menu.jsp" >
    <jsp:param name="page" value="cancellations" />
</jsp:include>