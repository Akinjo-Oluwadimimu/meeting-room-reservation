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
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Generate New Report</h1>
                <div class="flex space-x-4">
                    <a href="${pageContext.request.contextPath}/user/reports" 
                       class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">
                        All Reports
                    </a>
                </div>
            </div>       

            <form id="reportForm" action="${pageContext.request.contextPath}/user/reports" method="post" 
                class="bg-white shadow rounded-lg p-6">
              <div class="mb-4">
                  <label class="block text-gray-700 font-medium mb-2">Report Type</label>
                  <select name="reportType" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                      <option value="reservation_history">Reservation History</option>
                      <option value="cancellations">Cancellations</option>
                  </select>
              </div>

              <div class="mb-4">
                  <label class="block text-gray-700 font-medium mb-2">Date Range</label>
                  <select id="dateRange" name="dateRange" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                      <option value="last_7_days">Last 7 Days</option>
                      <option value="last_month">Last Month</option>
                      <option value="last_quarter">Last Quarter</option>
                      <option value="custom">Custom Range</option>
                  </select>
              </div>

              <div id="customDateRange" class="mb-4 hidden">
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                          <label class="block text-gray-700 font-medium mb-2">Start Date</label>
                          <input type="date" name="startDate" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                      </div>
                      <div>
                          <label class="block text-gray-700 font-medium mb-2">End Date</label>
                          <input type="date" name="endDate" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                      </div>
                  </div>
              </div>

              <div class="mb-6">
                  <label class="block text-gray-700 font-medium mb-2">Format</label>
                  <div class="flex space-x-4">
                      <label class="inline-flex items-center">
                          <input type="radio" name="format" value="pdf" checked class="form-radio">
                          <span class="ml-2">PDF</span>
                      </label>
                      <label class="inline-flex items-center">
                          <input type="radio" name="format" value="csv" class="form-radio">
                          <span class="ml-2">CSV</span>
                      </label>
                      <label class="inline-flex items-center">
                          <input type="radio" name="format" value="xlsx" class="form-radio">
                          <span class="ml-2">Excel</span>
                      </label>
                  </div>
              </div>

              <div class="flex justify-end">
                  <button type="submit" 
                          class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                      Generate Report
                  </button>
              </div>
          </form>

          <div id="reportStatus" class="hidden mt-6 p-4 bg-blue-50 text-blue-800 rounded-md">
              <h2 class="font-bold mb-2">Report Generation Status</h2>
              <p id="statusMessage">Your report is being generated...</p>
              <div class="mt-2">
                  <a id="downloadLink" href="#" class="hidden text-blue-600 hover:underline">Download Report</a>
              </div>
          </div>

        </main>
    </div>
</div>

<script>
    $(document).ready(function() {
        // Show/hide custom date range
        $('#dateRange').change(function() {
            if ($(this).val() === 'custom') {
                $('#customDateRange').removeClass('hidden');
            } else {
                $('#customDateRange').addClass('hidden');
            }
        });
        
        // Handle form submission
        $('#reportForm').submit(function(e) {
            e.preventDefault();
            
            // Show status panel
            $('#reportStatus').removeClass('hidden');
            $('#downloadLink').addClass('hidden');
            
            // Submit form via AJAX
            $.ajax({
                type: 'POST',
                url: $(this).attr('action'),
                data: $(this).serialize(),
                success: function(result) {
                    // Start polling for status
                    pollReportStatus(result.reportId);
                },
                error: function() {
                    $('#statusMessage').text('Error generating report');
                }
            });
        });
        
        function pollReportStatus(reportId) {
            const checkStatus = function() {
                $.get('${pageContext.request.contextPath}/user/reports/status/' + reportId, 
                    function(data) {
                        if (data.ready) {
                            $('#statusMessage').text('Your report is ready!');
                            $('#downloadLink')
                                .attr('href', data.downloadUrl)
                                .removeClass('hidden');
                        } else if (data.status === 'failed') {
                            $('#statusMessage').text('Report generation failed');
                        } else {
                            // Check again in 3 seconds
                            setTimeout(checkStatus, 3000);
                        }
                    })
                    .fail(function() {
                        $('#statusMessage').text('Error checking report status');
                    });
            };
            
            checkStatus();
        }
    });
</script>
<jsp:include page="../../components/user-mobile-menu.jsp" >
    <jsp:param name="page" value="reports" />
</jsp:include>