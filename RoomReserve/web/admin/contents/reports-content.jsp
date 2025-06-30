<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="flex h-screen">
    <!-- Admin Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="reports" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />

        <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <!-- Success/Error Messages -->
            <jsp:include page="../../components/messages.jsp" />
            <!-- Header and Tabs -->
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Reports Dashboard</h1>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
                <!-- Reports List -->
                <div class="lg:col-span-1">
                    <div class="bg-white shadow rounded-lg overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-200">
                            <h3 class="text-lg font-medium text-gray-800">Available Reports</h3>
                        </div>
                        <div class="divide-y divide-gray-200">
                            <c:forEach items="${reports}" var="report">
                                <div class="px-6 py-4 hover:bg-gray-50">
                                    <a href="?action=view&id=${report.reportId}" 
                                       class="block font-medium text-blue-600 hover:text-blue-800">
                                        ${report.reportName}
                                    </a>
                                    <p class="text-sm text-gray-500 mt-1">${report.description}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Report Content -->
                <div class="lg:col-span-3">
                    <c:choose>
                        <c:when test="${not empty reportResult}">
                            <div class="bg-white shadow rounded-lg overflow-hidden">
                                <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
                                    <h3 class="text-lg font-medium text-gray-800">${reportResult.reportName}</h3>
                                    <div class="flex space-x-2">
                                        <form action="reports" method="post" class="inline">
                                            <input type="hidden" name="action" value="export-excel">
                                            <input type="hidden" name="report_id" value="${param.id}">
                                            <input type="hidden" name="start_date" value="${param.start_date}">
                                            <input type="hidden" name="end_date" value="${param.end_date}">
                                            <button type="submit" 
                                                    class="px-3 py-1 bg-green-600 text-white rounded text-sm hover:bg-green-700">
                                                Export Excel
                                            </button>
                                        </form>
                                        <form action="reports" method="post" class="inline">
                                            <input type="hidden" name="action" value="export-pdf">
                                            <input type="hidden" name="report_id" value="${param.id}">
                                            <input type="hidden" name="start_date" value="${param.start_date}">
                                            <input type="hidden" name="end_date" value="${param.end_date}">
                                            <button type="submit" 
                                                    class="px-3 py-1 bg-red-600 text-white rounded text-sm hover:bg-red-700">
                                                Export PDF
                                            </button>
                                        </form>
                                    </div>
                                </div>

                                <div class="p-6">
                                    <!-- Date Range Selector -->
                                    <form method="get" class="mb-6">
                                        <input type="hidden" name="action" value="view">
                                        <input type="hidden" name="id" value="${param.id}">
                                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                            <div>
                                                <label class="block text-sm font-medium text-gray-700">Start Date</label>
                                                <input type="date" name="start_date" value="${param.start_date}"
                                                       class="mt-1 block w-full h-10 rounded-md border-gray-300 shadow-sm datepicker">
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-gray-700">End Date</label>
                                                <input type="date" name="end_date" value="${param.end_date}"
                                                       class="mt-1 block w-full h-10 rounded-md border-gray-300 shadow-sm datepicker">
                                            </div>
                                            <div class="flex items-end">
                                                <button type="submit" 
                                                        class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                                                    Apply Filters
                                                </button>
                                            </div>
                                        </div>
                                    </form>

                                    <!-- Data Table -->
                                    <div class="overflow-x-auto">
                                        <table class="min-w-full divide-y divide-gray-200">
                                            <thead class="bg-gray-50">
                                                <tr>
                                                    <c:forEach items="${reportResult.columnNames}" var="col">
                                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                            ${col}
                                                        </th>
                                                    </c:forEach>
                                                </tr>
                                            </thead>
                                            <tbody class="bg-white divide-y divide-gray-200">
                                                <c:forEach items="${reportResult.data}" var="row">
                                                    <tr>
                                                        <c:forEach items="${reportResult.columnNames}" var="col">
                                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                                <c:choose>
                                                                    <%-- Check for Date --%>
                                                                    <c:when test="${row[col].getClass().name == 'java.util.Date' or 
                                                                                    row[col].getClass().name == 'java.sql.Timestamp'}">
                                                                        <fmt:formatDate value="${row[col]}" pattern="MMM dd, yyyy"/>
                                                                    </c:when>

                                                                    <%-- Check for Number --%>
                                                                    <c:when test="${row[col].getClass().superclass.name == 'java.lang.Number'}">
                                                                        <fmt:formatNumber value="${row[col]}"/>
                                                                    </c:when>

                                                                    <%-- Default case --%>
                                                                    <c:otherwise>
                                                                        ${row[col]}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </c:forEach>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Chart Visualization -->
                                    <div class="mt-8">
                                        <canvas id="reportChart" height="150"></canvas>
                                        <script>
                                            const ctx = document.getElementById('reportChart').getContext('2d');
                                            const chart = new Chart(ctx, {
                                                type: 'bar',
                                                data: {
                                                    labels: [
                                                        <c:forEach items="${reportResult.data}" var="row" varStatus="loop">
                                                            '${row[reportResult.columnNames[0]]}'${!loop.last ? ',' : ''}
                                                        </c:forEach>
                                                    ],
                                                    datasets: [{
                                                        label: '${reportResult.columnNames[1]}',
                                                        data: [
                                                            <c:forEach items="${reportResult.data}" var="row" varStatus="loop">
                                                                ${row[reportResult.columnNames[1]]}${!loop.last ? ',' : ''}
                                                            </c:forEach>
                                                        ],
                                                        backgroundColor: 'rgba(59, 130, 246, 0.5)',
                                                        borderColor: 'rgba(59, 130, 246, 1)',
                                                        borderWidth: 1
                                                    }]
                                                },
                                                options: {
                                                    responsive: true,
                                                    plugins: {
                                                        title: {
                                                            display: true,
                                                            text: '${reportResult.reportName}'
                                                        }
                                                    },
                                                    scales: {
                                                        y: {
                                                            beginAtZero: true
                                                        }
                                                    }
                                                }
                                            });
                                        </script>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="bg-white shadow rounded-lg overflow-hidden">
                                <div class="p-8 text-center">
                                    <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                    </svg>
                                    <h3 class="mt-2 text-lg font-medium text-gray-900">No report selected</h3>
                                    <p class="mt-1 text-sm text-gray-500">Choose a report from the list to view data</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>


<script>
    flatpickr(".datepicker", {
        dateFormat: "Y-m-d",
        allowInput: true
    });
</script>
<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="reports" />
</jsp:include>