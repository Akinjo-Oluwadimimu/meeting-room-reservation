<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.roomreserve.model.DepartmentMember"%>
<%@page import="java.util.List"%>
<%@page import="com.roomreserve.model.Department"%>
<%@page import="com.roomreserve.model.User"%>
<%@page import="com.roomreserve.dao.DepartmentDAO"%>
<%@page import="com.roomreserve.dao.UserDAO"%>
<%
// Authentication check
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("admin")) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="login-logs" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />

        <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <!-- Page Header -->
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Login Activity Logs</h1>
                    <p class="text-sm text-gray-600">Manage all login activity within the organization</p>
                </div>
            </div>
            
            <!-- Success/Error Messages -->
            <jsp:include page="../../components/messages.jsp" />
            
            <!-- Filter Form -->
            <div class="bg-white p-6 rounded-lg shadow-sm mb-6">
                <form method="get" action="login-logs" class="space-y-4 md:space-y-0 md:grid md:grid-cols-4 md:gap-4">
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                        <input type="text" id="username" name="username" value="${usernameFilter}"
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    </div>
                    <div>
                        <label for="startDate" class="block text-sm font-medium text-gray-700 mb-1">From Date</label>
                        <input type="date" id="startDate" name="startDate" value="${startDateFilter}"
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    </div>
                    <div>
                        <label for="endDate" class="block text-sm font-medium text-gray-700 mb-1">To Date</label>
                        <input type="date" id="endDate" name="endDate" value="${endDateFilter}"
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    </div>
                    <div class="flex items-end space-x-2">
                        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition">
                            Filter
                        </button>
                        <a href="login-logs" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-md hover:bg-gray-100 transition">
                            Reset
                        </a>
                    </div>
                </form>
            </div>
                    
            <div class="bg-white shadow rounded-lg overflow-hidden">
                
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200 border-b border-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Username</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">IP Address</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Login Time</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Failure Reason</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Device</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach items="${logs}" var="log">
                                <tr class="hover:bg-gray-50 transition">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${log.logId}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${log.username}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${log.ipAddress}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${log.loginTime}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium ${log.status == 'SUCCESS' ? 'text-green-600' : 'text-red-600'}">
                                        ${log.status}
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        ${log.failureReason != null ? log.failureReason : '-'}
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <c:set var="ua" value="${log.userAgent}"/>
                                        <c:choose>
                                            <c:when test="${ua.contains('Windows')}">
                                                <span class="inline-flex items-center">
                                                    <i class="fab fa-windows mr-2 text-blue-500"></i> Windows
                                                </span>
                                            </c:when>
                                            <c:when test="${ua.contains('Macintosh')}">
                                                <span class="inline-flex items-center">
                                                    <i class="fab fa-apple mr-2 text-gray-700"></i> Mac
                                                </span>
                                            </c:when>
                                            <c:when test="${ua.contains('Linux')}">
                                                <span class="inline-flex items-center">
                                                    <i class="fab fa-linux mr-2 text-yellow-500"></i> Linux
                                                </span>
                                            </c:when>
                                            <c:when test="${ua.contains('Android')}">
                                                <span class="inline-flex items-center">
                                                    <i class="fab fa-android mr-2 text-green-500"></i> Android
                                                </span>
                                            </c:when>
                                            <c:when test="${ua.contains('iPhone')}">
                                                <span class="inline-flex items-center">
                                                    <i class="fas fa-mobile-alt mr-2 text-gray-500"></i> iPhone
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center">
                                                    <i class="fas fa-question-circle mr-2 text-gray-400"></i> Unknown
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

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
                                        <option value="login-logs?page=1&limit=10&username=${usernameFilter}&startDate=${startDateFilter}&endDate=${endDateFilter}" ${limit == 10 ? 'selected' : ''}>10</option>
                                        <option value="login-logs?page=1&limit=20&username=${usernameFilter}&startDate=${startDateFilter}&endDate=${endDateFilter}" ${limit == 20 ? 'selected' : ''}>20</option>
                                        <option value="login-logs?page=1&limit=50&username=${usernameFilter}&startDate=${startDateFilter}&endDate=${endDateFilter}" ${limit == 50 ? 'selected' : ''}>50</option>
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
                                <a href="login-logs?page=${currentPage-1}&limit=${limit}&username=${usernameFilter}&startDate=${startDateFilter}&endDate=${endDateFilter}"
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
                                        <a href="login-logs?page=${i}&limit=${limit}&username=${usernameFilter}&startDate=${startDateFilter}&endDate=${endDateFilter}"
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
                                <a href="login-logs?page=${currentPage+1}&limit=${limit}&username=${usernameFilter}&startDate=${startDateFilter}&endDate=${endDateFilter}"
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

<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="login-logs" />
</jsp:include>