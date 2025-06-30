<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>My Reports</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <div class="container mx-auto px-4 py-8">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-2xl font-bold">My Reports</h1>
            <a href="${pageContext.request.contextPath}/user/reports/new"
               class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                Generate New Report
            </a>
        </div>

        <div class="bg-white shadow rounded-lg overflow-hidden">
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
                    <c:forEach items="${reports}" var="report">
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
    </div>
</body>
</html>