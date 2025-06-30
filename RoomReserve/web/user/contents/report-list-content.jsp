<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>

<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/user-sidebar.jsp">
        <jsp:param name="page" value="reports" />
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
            <c:set var="end" value="${(start + recordsPerPage) < reports.size() ? (start + recordsPerPage) : reports.size()}" />
            <c:set var="totalPages" value="${fn:substringBefore((reports.size() + recordsPerPage - 1) / recordsPerPage, '.')}" />

            <div class="flex justify-between items-center mb-8">
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">My Reports</h1>
                <div class="flex space-x-4">
                    <a href="${pageContext.request.contextPath}/user/reports/new" 
                       class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">
                        Generate New Report
                    </a>
                </div>
            </div>       

            <div class="bg-white shadow rounded-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Report Type</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date Range</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Format</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Generated At</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach items="${reports}" var="report" begin="${start}" end="${end-1 < 0 ? 0 : end-1}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${report.reportType == 'reservation_history'}">
                                                Reservation History
                                            </c:when>
                                            <c:when test="${report.reportType == 'room_utilization'}">
                                                Room Utilization
                                            </c:when>
                                            <c:otherwise>
                                                ${report.reportType}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${report.dateRange == 'last_7_days'}">Last 7 Days</c:when>
                                            <c:when test="${report.dateRange == 'last_month'}">Last Month</c:when>
                                            <c:when test="${report.dateRange == 'last_quarter'}">Last Quarter</c:when>
                                            <c:when test="${report.dateRange == 'custom'}">
                                                ${report.startDate} to ${report.endDate}
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">${report.format.toUpperCase()}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        ${report.generatedAt.toLocalDate()} ${report.generatedAt.toLocalTime()}
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                                            ${report.status == 'ready' ? 'bg-green-100 text-green-800' : 
                                              report.status == 'failed' ? 'bg-red-100 text-red-800' : 
                                              'bg-yellow-100 text-yellow-800'}">
                                            ${report.status}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:if test="${report.status == 'ready'}">
                                            <a href="${pageContext.request.contextPath}/user/reports/download/${report.reportId}"
                                               class="text-blue-600 hover:text-blue-900">Download</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>    
                        </tbody>
                    </table>
                </div>
                <c:if test="${not empty reports}">
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
                                        <option value="reports?page=1&limit=10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                        <option value="reports?page=1&limit=15" ${recordsPerPage == 15 ? 'selected' : ''}>15</option>
                                        <option value="reports?page=1&limit=20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
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
                                <a href="reports?page=${currentPage-1}&limit=${recordsPerPage}"
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
                                        <a href="reports?page=${i}&limit=${recordsPerPage}"
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
                                <a href="reports?page=${currentPage+1}&limit=${recordsPerPage}"
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

        </main>
    </div>
</div>


<jsp:include page="../../components/user-mobile-menu.jsp" >
    <jsp:param name="page" value="reports" />
</jsp:include>