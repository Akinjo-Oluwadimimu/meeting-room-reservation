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
            <!-- Header and Tabs -->
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Reservation Management</h1>
                <div class="flex space-x-4">
                    <button onclick="openExportModal()" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                        <i class="fas fa-download mr-2"></i> Export
                    </button>
                </div>
            </div>

            <!-- Search and Filter Section -->
            <div class="bg-white p-4 rounded-lg shadow-sm mb-6">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Search By</label>
                        <select id="searchType" class="w-full border border-gray-300 rounded-md p-2" onchange="handleSearchTypeChange()">
                            <option value="user" ${param.searchType == 'user' ? 'selected' : ''}>User</option>
                            <option value="room" ${param.searchType == 'room' ? 'selected' : ''}>Room</option>
                            <option value="date" ${param.searchType == 'date' ? 'selected' : ''}>Date</option>
                        </select>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Search Query</label>
                        <div class="flex">
                            <input type="text" id="searchQuery" value="${searchQueryFilter}" class="flex-1 border border-gray-300 rounded-l-md p-2">
                            <button onclick="searchReservations()" class="bg-blue-600 text-white px-4 rounded-r-md">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                        <select id="statusFilter" class="w-full border border-gray-300 rounded-md p-2" onchange="filterByStatus()">
                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
                            <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                            <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
                            <option value="no-show" ${param.status == 'no-show' ? 'selected' : ''}>No show</option>
                            <option value="all" ${param.status == 'all' ? 'selected' : ''}>All</option>
                        </select>
                    </div>
                </div>
            </div>
                        
            <!-- Reservations Table -->
            <div class="bg-white shadow rounded-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Room</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">User</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date/Time</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Purpose</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach items="${reservations}" var="reservation">
                            <tr>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="font-medium">${reservation.roomName}</div>
                                    <div class="text-sm text-gray-500">${reservation.buildingName}</div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="font-medium">${reservation.user.firstName} ${reservation.user.lastName}</div>
                                    <div class="text-sm text-gray-500">${reservation.user.email}</div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div><fmt:formatDate value="${reservation.startDate}" pattern="MMM d, yyyy"/></div>
                                    <div class="text-sm text-gray-500">
                                        <fmt:formatDate value="${reservation.startDate}" pattern="h:mm a"/> - 
                                        <fmt:formatDate value="${reservation.endDate}" pattern="h:mm a"/>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="font-medium">${reservation.title}</div>
                                    <div class="text-sm text-gray-500 truncate max-w-xs">${reservation.purpose}</div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-2 py-1 text-xs font-semibold rounded-full 
                                        ${reservation.status == 'approved' ? 'bg-green-100 text-green-800' : 
                                          reservation.status == 'rejected' ? 'bg-red-100 text-red-800' : 
                                          reservation.status == 'completed' ? 'bg-blue-100 text-blue-800' : 
                                          reservation.status == 'no-show' ? 'bg-purple-100 text-purple-800' : 
                                          reservation.status == 'cancelled' ? 'bg-gray-100 text-gray-800' : 
                                          'bg-yellow-100 text-yellow-800'}">
                                        ${reservation.status}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <a href="?action=view&id=${reservation.id}" 
                                       class="text-blue-600 hover:text-blue-900 mr-1"
                                       title="View">
                                        <i class="fas fa-info-circle"></i>
                                    </a>
                                    <c:if test="${reservation.status == 'pending'}">
                                        <a href="#" onclick="showApproveModal(${reservation.id})" 
                                           class="text-green-600 hover:text-green-900 mr-1"
                                           title="Approve">
                                            <i class="fas fa-check-circle"></i>
                                        </a>
                                        <a href="#" onclick="showRejectModal(${reservation.id})" 
                                           class="text-red-600 hover:text-red-900 mr-1"
                                           title="Reject">
                                            <i class="fas fa-times-circle"></i>
                                        </a>
                                    </c:if>
                                    <c:if test="${reservation.status == 'approved' && reservation.isUpcoming()}">
                                        <a href="#" onclick="showRejectModal(${reservation.id})" 
                                           class="text-orange-600 hover:text-orange-900"
                                           title="Cancel">
                                            <i class="fas fa-calendar-times"></i>
                                        </a>
                                    </c:if>
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
                                        <option value="reservations?page=1&limit=5&status=${statusFilter}&searchType=${searchTypeFilter}&query=${searchQueryFilter}" ${limit == 5 ? 'selected' : ''}>5</option>
                                        <option value="reservations?page=1&limit=10&status=${statusFilter}&searchType=${searchTypeFilter}&query=${searchQueryFilter}" ${limit == 10 ? 'selected' : ''}>10</option>
                                        <option value="reservations?page=1&limit=20&status=${statusFilter}&searchType=${searchTypeFilter}&query=${searchQueryFilter}" ${limit == 20 ? 'selected' : ''}>20</option>
                                        <option value="reservations?page=1&limit=50&status=${statusFilter}&searchType=${searchTypeFilter}&query=${searchQueryFilter}" ${limit == 50 ? 'selected' : ''}>50</option>
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
                                <a href="reservations?page=${currentPage-1}&limit=${limit}&status=${statusFilter}&searchType=${searchTypeFilter}&query=${searchQueryFilter}"
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
                                        <a href="reservations?page=${i}&limit=${limit}&status=${statusFilter}&searchType=${searchTypeFilter}&query=${searchQueryFilter}"
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
                                <a href="reservations?page=${currentPage+1}&limit=${limit}&status=${statusFilter}&searchType=${searchTypeFilter}&query=${searchQueryFilter}"
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
            
            <div id="exportModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50 p-2">
                <div class="bg-white rounded-lg p-6 w-full max-w-md">
                    <h3 class="text-xl font-bold mb-4">Export Reservations</h3>
                    <form action="?action=export" method="POST">
                        <div class="grid grid-cols-1 gap-4 mb-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Start Date</label>
                                <input type="date" name="startDate" class="w-full h-10 border border-gray-300 rounded-md p-2 datepicker" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">End Date</label>
                                <input type="date" name="endDate" class="w-full h-10 border border-gray-300 rounded-md p-2 datepicker" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Format</label>
                                <select name="format" class="w-full h-10 border border-gray-300 rounded-md p-2">
                                    <option value="excel">Excel</option>
                                    <option value="pdf">PDF</option>
                                </select>
                            </div>
                        </div>
                        <div class="flex justify-end space-x-3">
                            <button type="button" onclick="closeExportModal()" 
                                    class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300">
                                Cancel
                            </button>
                            <button type="submit" 
                                    class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                                Export
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Approve Modal -->
            <div id="approveModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50 p-2">
                <div class="bg-white rounded-lg p-6 w-full max-w-md">
                    <h3 class="text-xl font-bold mb-4">Approve Reservation</h3>
                    <form id="approveForm" method="POST">
                        <input type="hidden" name="action" value="approve">
                        <input type="hidden" name="reservationId" id="approveReservationId">
                        <div class="mb-4">
                            <label for="approveComments" class="block text-sm font-medium text-gray-700 mb-1">Comments (Optional)</label>
                            <textarea id="approveComments" name="comments" rows="3"
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
                        </div>
                        <div class="flex justify-end space-x-3">
                            <button type="button" onclick="hideApproveModal()"
                                    class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300 transition">
                                Cancel
                            </button>
                            <button type="submit"
                                    class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition">
                                Confirm Approval
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Reject Modal -->
            <div id="rejectModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50 p-2">
                <div class="bg-white rounded-lg p-6 w-full max-w-md">
                    <h3 class="text-xl font-bold mb-4">Reject Reservation</h3>
                    <form id="rejectForm" method="POST">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="reservationId" id="rejectReservationId">
                        <div class="mb-4">
                            <label for="rejectComments" class="block text-sm font-medium text-gray-700 mb-1">Reason for Rejection</label>
                            <textarea id="rejectComments" name="comments" rows="3" required
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
                        </div>
                        <div class="flex justify-end space-x-3">
                            <button type="button" onclick="hideRejectModal()"
                                    class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300 transition">
                                Cancel
                            </button>
                            <button type="submit"
                                    class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition">
                                Confirm Rejection
                            </button>
                        </div>
                    </form>
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

    function showApproveModal(reservationId) {
            document.getElementById('approveReservationId').value = reservationId;
            document.getElementById('approveModal').classList.remove('hidden');
        }

        function hideApproveModal() {
            document.getElementById('approveModal').classList.add('hidden');
        }

        function showRejectModal(reservationId) {
            document.getElementById('rejectReservationId').value = reservationId;
            document.getElementById('rejectModal').classList.remove('hidden');
        }

        function hideRejectModal() {
            document.getElementById('rejectModal').classList.add('hidden');
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            if (event.target == document.getElementById('approveModal')) {
                hideApproveModal();
            }
            if (event.target == document.getElementById('rejectModal')) {
                hideRejectModal();
            }
            if (event.target == document.getElementById('exportModal')) {
                closeExportModal();
            }
        }
        
        // Modal handling functions
        function openExportModal() {
            document.getElementById('exportModal').classList.remove('hidden');
        }
        
        function closeExportModal() {
            document.getElementById('exportModal').classList.add('hidden');
        }
        
        function searchReservations() {
            const searchType = document.getElementById('searchType').value;
            const query = document.getElementById('searchQuery').value;
            const status = document.getElementById('statusFilter').value;
            
            window.location.href = `?searchType=` + searchType + `&query=` + query + `&status=` + status;
        }
        
        function filterByStatus() {
            const searchType = document.getElementById('searchType').value;
            const query = document.getElementById('searchQuery').value;
            const status = document.getElementById('statusFilter').value;
            window.location.href = `?status=`+status + `&searchType=` + searchType + `&query=` + query;
        }
        
        let datePicker = null;

        function handleSearchTypeChange() {
            const searchType = document.getElementById('searchType').value;
            const searchQuery = document.getElementById('searchQuery');

            // Destroy existing flatpickr instance if it exists
            if (datePicker) {
                datePicker.destroy();
                datePicker = null;
            }

            // Reset input attributes
            searchQuery.type = 'text';
            searchQuery.placeholder = '';
            //searchQuery.value = '';
            searchQuery.readOnly = false;

            if (searchType === 'date') {
                // Initialize flatpickr for date input
                datePicker = flatpickr(searchQuery, {
                    dateFormat: 'Y-m-d',
                    mode: "range",
                    //allowInput: true,
                    placeholder: 'Select a date'
                });
            }
        }

        // Initialize on page load in case 'date' is selected by default
        document.addEventListener('DOMContentLoaded', function() {
            handleSearchTypeChange();
        });
    </script>
<jsp:include page="../../components/manager-mobile-menu.jsp" >
    <jsp:param name="page" value="approvals" />
</jsp:include>