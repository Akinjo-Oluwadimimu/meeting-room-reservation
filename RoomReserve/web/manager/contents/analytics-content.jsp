<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<div class="flex h-screen">
    <!-- Admin Sidebar -->
    <jsp:include page="../../components/manager-sidebar.jsp">
        <jsp:param name="page" value="utilization" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
    <!-- Top Navigation -->
    <jsp:include page="../../components/top-navigation.jsp" />

    <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
                <fmt:parseDate value="${startDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS" var="parsedStartDate" />
                <fmt:parseDate value="${endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS" var="parsedEndDate" />

                <div class="order-1 md:order-none">
                    <h1 class="text-xl sm:text-xl font-bold text-gray-800">Room Utilization Analytics</h1>
                    <p class="text-xs sm:text-sm text-gray-600">
                        <fmt:formatDate value="${parsedStartDate}" pattern="MMM d, yyyy, h:mm a" /> to 
                        <fmt:formatDate value="${parsedEndDate}" pattern="MMM d, yyyy, h:mm a" /> (${duration})
                    </p>
                </div>

                <div class="flex flex-wrap gap-2 order-3 md:order-none w-full md:w-auto">
                    <a href="?period=hour" title="Last 24 hours" 
                       class="flex-1 md:flex-none text-center px-3 py-1 rounded-md ${param.period == 'hour' ? 'bg-blue-600 text-white' : 'bg-gray-200'}">
                       Hourly
                    </a>
                    <a href="?period=day" title="Last 7 days" 
                       class="flex-1 md:flex-none text-center px-3 py-1 rounded-md ${param.period == 'day' ? 'bg-blue-600 text-white' : 'bg-gray-200'}">
                       Daily
                    </a>
                    <a href="?period=week" title="Last 4 weeks" 
                       class="flex-1 md:flex-none text-center px-3 py-1 rounded-md ${param.period == 'week' ? 'bg-blue-600 text-white' : 'bg-gray-200'}">
                       Weekly
                    </a>
                    <a href="?period=month" title="Last 12 months" 
                       class="flex-1 md:flex-none text-center px-3 py-1 rounded-md ${param.period == 'month' ? 'bg-blue-600 text-white' : 'bg-gray-200'}">
                       Monthly
                    </a>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                <!-- Summary Cards -->
                <div class="bg-blue-50 p-4 rounded-lg shadow">
                    <h3 class="text-sm font-medium text-blue-800 mb-2">Overall Utilization</h3>
                    <p class="text-2xl font-bold">
                        <fmt:formatNumber value="${overallRate}" maxFractionDigits="1" />%
                    </p>
                </div>

                <div class="bg-green-50 p-4 rounded-lg shadow">
                    <h3 class="text-sm font-medium text-green-800 mb-2">Completed Reservations</h3>
                    <p class="text-2xl font-bold">
                        ${totalCompleted}
                    </p>
                    <p class="text-xs text-gray-500 mt-1">Successful meetings</p>
                </div>

                <div class="bg-yellow-50 p-4 rounded-lg shadow">
                    <h3 class="text-sm font-medium text-yellow-800 mb-2">Cancellation Rate</h3>
                    <p class="text-2xl font-bold">
                        <fmt:formatNumber value="${totalScheduled > 0 ? (totalCancelled / totalScheduled * 100) : 0}" maxFractionDigits="1" />%
                    </p>
                    <p class="text-xs text-gray-500 mt-1">${totalCancelled} cancellations</p>
                </div>
            </div>

            <!-- Utilization Trend Chart -->
            <div class="bg-white p-6 rounded-lg shadow mb-8">
                <h3 class="text-lg font-medium text-gray-800 mb-4">Utilization Trend</h3>
                <div class="h-80">
                    <canvas id="utilizationChart"></canvas>
                </div>
            </div>
            <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
            <c:set var="recordsPerPage" value="${param.limit != null ? param.limit : 3}" />
            <c:set var="period" value="${param.period != null ? param.period : 'week'}" />
            <c:set var="start" value="${(currentPage - 1) * recordsPerPage}" />
            <c:set var="end" value="${(start + recordsPerPage) < utilization.size() ? (start + recordsPerPage) : utilization.size()}" />
            <c:set var="totalPages" value="${fn:substringBefore((utilization.size() + recordsPerPage - 1) / recordsPerPage, '.')}" />

            <!-- Room Utilization Details -->
            <div class="bg-white shadow rounded-lg overflow-hidden mb-8" id="roomUtilization">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-medium text-gray-800">Room Utilization Details</h3>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Completed</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Cancelled</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No Shows</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Utilization</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach items="${utilization}" var="room" begin="${start}" end="${end-1 < 0 ? 0 : end-1}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="font-medium text-gray-900">${room.roomName}</div>
                                        <div class="text-sm text-gray-500">${room.buildingName}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        ${room.completedCount}
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        ${room.cancelledCount}
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        ${room.noShowCount}
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <span class="px-2 py-1 rounded-full 
                                            ${room.getUtilizationRate() >= 70 ? 'bg-green-100 text-green-800' : 
                                              room.getUtilizationRate() >= 40 ? 'bg-yellow-100 text-yellow-800' : 
                                              'bg-red-100 text-red-800'}">
                                            <fmt:formatNumber value="${room.getUtilizationRate()}" maxFractionDigits="1" />%
                                        </span>
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
                                        <option value="analytics?page=1&limit=3&period=${period}#roomUtilization" ${recordsPerPage == 3 ? 'selected' : ''}>3</option>
                                        <option value="analytics?page=1&limit=5&period=${period}#roomUtilization" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                                        <option value="analytics?page=1&limit=10&period=${period}#roomUtilization" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
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
                                <a href="analytics?page=${currentPage-1}&limit=${recordsPerPage}&period=${period}#roomUtilization"
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
                                        <a href="analytics?page=${i}&limit=${recordsPerPage}&period=${period}#roomUtilization"
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
                                <a href="analytics?page=${currentPage+1}&limit=${recordsPerPage}&period=${period}#roomUtilization"
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
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <!-- Cancellation Rate -->
                <div class="bg-white p-6 rounded-lg shadow-sm">
                    <h2 class="text-lg font-medium text-gray-800 mb-4">Cancellation Rates</h2>
                    <div class="h-64">
                        <canvas id="cancellationRateChart"></canvas>
                    </div>
                </div>

                <!-- Cancellation Reasons -->
                <div class="bg-white p-6 rounded-lg shadow-sm">
                    <h2 class="text-lg font-medium text-gray-800 mb-4">Cancellation Reasons</h2>
                    <div class="space-y-2">
                        <c:set var="total" value="0" />
                        <c:forEach items="${cancellationReasons}" var="reason">
                            <c:set var="total" value="${total + reason.value}" />
                        </c:forEach>
                        <c:forEach items="${cancellationReasons}" var="reason">
                            <div class="flex justify-between items-center">
                                <span class="text-sm text-gray-700">${reason.key}</span>
                                <span class="text-xs font-medium">${reason.value} <span class="text-gray-500 text-sm">(<fmt:formatNumber value="${reason.value * 100 / total}" maxFractionDigits="1" />%)</span></span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <div class="bg-red-600 h-2 rounded-full" 
                                     style="width: ${reason.value * 100 / total}%"></div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>



            <!-- Recent Cancellations -->
            <div class="bg-white shadow rounded-lg overflow-hidden mb-6">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-medium text-gray-800">Recent Cancellations</h3>
                </div>
                <div class="divide-y divide-gray-200">
                    <c:forEach items="${cancellations}" var="cancel" end="4">
                        <div class="px-6 py-4">
                            <div class="flex justify-between">
                                <div>
                                    <p class="font-medium text-gray-900">${cancel.roomName}</p>
                                    <p class="text-sm text-gray-500">
                                        <fmt:formatDate value="${cancel.originalDate}" pattern="MMM d, h:mm a" />
                                    </p>
                                </div>
                                <span class="text-sm text-red-600">${cancel.reason}</span>
                            </div>
                            <c:if test="${not empty cancel.notes}">
                                <div class="mt-2 bg-gray-50 p-2 rounded">
                                    <p class="text-sm text-gray-700">${cancel.notes}</p>
                                </div>
                            </c:if>
                            <p class="text-xs text-gray-500 mt-1">
                                Cancelled by ${cancel.cancelledByName} on 
                                <fmt:formatDate value="${cancel.cancellationDate}" pattern="MMM d, h:mm a" />
                            </p>
                        </div>
                    </c:forEach>
                    <c:if test="${not empty cancellations}">
                        <div class="px-6 py-3 bg-gray-50 text-right">
                            <a href="${pageContext.request.contextPath}/manager/cancellations" class="text-sm font-medium text-blue-600 hover:text-blue-800">
                                View all cancellations →
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Peak Hours -->
            <div class="bg-white p-6 rounded-lg shadow-sm">
                <h2 class="text-xl font-bold text-gray-800 mb-4">Peak Usage Hours</h2>
                <div class="grid grid-cols-6 md:grid-cols-12 gap-2">
                    <c:forEach begin="0" end="23" var="hour">
                        <c:set var="percentage" value="${peakHours.getOrDefault(hour, 0.0)}" />
                        <div class="text-center">
                            <div class="text-sm text-gray-600 mb-1">${hour}:00</div>
                            <div class="bg-blue-100 rounded-md h-32 relative">
                                <div class="bg-blue-600 rounded-md absolute bottom-0 w-full" 
                                     style="height: ${percentage}%"></div>
                            </div>
                            <div class="text-xs mt-1"><fmt:formatNumber value="${percentage}" maxFractionDigits="1" />%</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>
    </div>
</div>


<script>
    // Utilization Trend Chart
    const trendCtx = document.getElementById('utilizationChart').getContext('2d');
    const trendChart = new Chart(trendCtx, {
        type: 'line',
        data: {
            labels: [<c:forEach items="${trend}" var="entry">"${entry.key}",</c:forEach>],
            datasets: [{
                label: 'Average Utilization (minutes)',
                data: [<c:forEach items="${trend}" var="entry">${entry.value},</c:forEach>],
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                borderColor: 'rgba(59, 130, 246, 1)',
                borderWidth: 2,
                tension: 0.3,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Minutes'
                    }
                }
            }
        }
    });

    // Cancellation Chart
    const cancellationRateCtx = document.getElementById('cancellationRateChart').getContext('2d');
    const cancellationRateChart = new Chart(cancellationRateCtx, {
        type: 'doughnut',
        data: {
            labels: [
                <c:forEach items="${cancellationRates}" var="rate" varStatus="loop">
                    '${rate.key}'${!loop.last ? ',' : ''}
                </c:forEach>
            ],
            datasets: [{
                data: [
                    <c:forEach items="${cancellationRates}" var="rate" varStatus="loop">
                        ${rate.value}${!loop.last ? ',' : ''}
                    </c:forEach>
                ],
                backgroundColor: [
                    'rgba(239, 68, 68, 0.7)', 
                    'rgba(249, 115, 22, 0.7)', 
                    'rgba(0, 163, 104, 0.7)',
                    'rgba(234, 179, 8, 0.7)',  
                    'rgba(20, 184, 166, 0.7)', 
                    'rgba(59, 130, 246, 0.7)', 
                    'rgba(120, 113, 108, 0.7)'
                ],
                borderColor: [
                    'rgba(239, 68, 68, 1)',
                    'rgba(249, 115, 22, 1)',
                    'rgba(0, 163, 104, 1)',
                    'rgba(234, 179, 8, 1)',
                    'rgba(20, 184, 166, 1)',
                    'rgba(59, 130, 246, 1)',
                    'rgba(120, 113, 108, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom'
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.label+ `: ` + context.raw.toFixed(1) + `%`;
                        }
                    }
                }
            }
        }
    });
</script>
<jsp:include page="../../components/manager-mobile-menu.jsp" >
    <jsp:param name="page" value="utilization" />
</jsp:include>