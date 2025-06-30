<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>

<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="export" />
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
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Export Data</h1>
                </div>
            </div>

            <div class="grid md:grid-cols-3 gap-6">
                <!-- Reservations Export Form -->
                <div class="bg-white shadow rounded-lg p-6">
                    <h2 class="text-xl font-semibold mb-4">Export Reservations</h2>
                    <form action="${pageContext.request.contextPath}/admin/export" method="post">
                        <input type="hidden" name="action" value="reservations">

                        <div class="mb-4">
                            <label class="block text-gray-700 font-medium mb-1">Start Date</label>
                            <input type="date" name="startDate" 
                                   class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md datepicker" required>
                        </div>

                        <div class="mb-4">
                            <label class="block text-gray-700 font-medium mb-1">End Date</label>
                            <input type="date" name="endDate" 
                                   class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md datepicker" required>
                        </div>

                        <div class="mb-4">
                            <label class="block text-gray-700 font-medium mb-1">Format</label>
                            <select name="format" class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md">
                                <option value="csv">CSV</option>
                                <option value="excel">Excel</option>
                                <option value="pdf">PDF</option>
                            </select>
                        </div>

                        <button type="submit" 
                                class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700">
                            Export Reservations
                        </button>
                    </form>
                </div>

                <!-- Rooms Export Form -->
                <div class="bg-white shadow rounded-lg p-6">
                    <h2 class="text-xl font-semibold mb-4">Export Rooms</h2>
                    <form action="${pageContext.request.contextPath}/admin/export" method="post">
                        <input type="hidden" name="action" value="rooms">

                        <div class="mb-4">
                            <label class="block text-gray-700 font-medium mb-1">Format</label>
                            <select name="format" class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md">
                                <option value="csv">CSV</option>
                                <option value="excel">Excel</option>
                                <option value="pdf">PDF</option>
                            </select>
                        </div>

                        <button type="submit" 
                                class="w-full bg-green-600 text-white py-2 px-4 rounded-md hover:bg-green-700">
                            Export Rooms
                        </button>
                    </form>
                </div>

                <!-- Usage Export Form -->
                <div class="bg-white shadow rounded-lg p-6">
                    <h2 class="text-xl font-semibold mb-4">Export Usage Analytics</h2>
                    <form action="${pageContext.request.contextPath}/admin/export" method="post">
                        <input type="hidden" name="action" value="usage">

                        <div class="mb-4">
                            <label class="block text-gray-700 font-medium mb-1">Start Date</label>
                            <input type="date" name="startDate" 
                                   class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md datepicker" required>
                        </div>

                        <div class="mb-4">
                            <label class="block text-gray-700 font-medium mb-1">End Date</label>
                            <input type="date" name="endDate" 
                                   class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md datepicker" required>
                        </div>

                        <div class="mb-4">
                            <label class="block text-gray-700 font-medium mb-1">Format</label>
                            <select name="format" class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md">
                                <option value="csv">CSV</option>
                                <option value="excel">Excel</option>
                                <option value="pdf">PDF</option>
                            </select>
                        </div>

                        <button type="submit" 
                                class="w-full bg-purple-600 text-white py-2 px-4 rounded-md hover:bg-purple-700">
                            Export Usage Data
                        </button>
                    </form>
                </div>
            </div>

            <div class="mt-8 bg-white shadow rounded-lg p-6">
                <h2 class="text-xl font-semibold mb-4">Export History</h2>
                
                <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
                <c:set var="recordsPerPage" value="${param.limit != null ? param.limit : 10}" />
                <c:set var="start" value="${(currentPage - 1) * recordsPerPage}" />
                <c:set var="end" value="${(start + recordsPerPage) < exports.size() ? (start + recordsPerPage) : exports.size()}" />
                <c:set var="totalPages" value="${fn:substringBefore((exports.size() + recordsPerPage - 1) / recordsPerPage, '.')}" />
                
                <div class="bg-white shadow rounded-lg overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date Range</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Format</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Exported At</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Action</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach items="${exports}" var="export" begin="${start}" end="${end-1 < 0 ? 0 : end-1}">
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap">${export.exportType}</td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:if test="${export.startDate != null}">
                                                ${export.startDate} to ${export.endDate}
                                            </c:if>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">${export.format}</td>
                                        <td class="px-6 py-4 whitespace-nowrap"><fmt:formatDate value="${export.dateCreated}" pattern="MMM d, yyyy h:mm a"/></td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <a href="${pageContext.request.contextPath}/admin/export/download?path=${export.filePath}"
                                               class="text-blue-600 hover:text-blue-900">Download</a>
                                        </td>
                                    </tr>
                                </c:forEach>    
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${not empty exports}">
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
                                            <option value="export?page=1&limit=10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                            <option value="export?page=1&limit=15" ${recordsPerPage == 15 ? 'selected' : ''}>15</option>
                                            <option value="export?page=1&limit=20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
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
                                    <a href="export?page=${currentPage-1}&limit=${recordsPerPage}"
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
                                            <a href="export?page=${i}&limit=${recordsPerPage}"
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
                                    <a href="export?page=${currentPage+1}&limit=${recordsPerPage}"
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
            </div>
        </main>
    </div>
</div>
<script>
    // Initialize date pickers
    flatpickr(".datepicker", {
        dateFormat: "Y-m-d",
        allowInput: true
    });

    // Make context path available to JavaScript
    const contextPath = "${pageContext.request.contextPath}";
    const currentPage = "${currentPage}";
    const recordsPerPage = "${recordsPerPage}";
</script>
<script src="${pageContext.request.contextPath}/js/admin-export.js"></script>
<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="export" />
</jsp:include>