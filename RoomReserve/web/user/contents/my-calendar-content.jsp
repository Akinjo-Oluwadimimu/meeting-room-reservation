<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="flex h-screen">
    <!-- User Sidebar -->
    <jsp:include page="../../components/user-sidebar.jsp">
        <jsp:param name="page" value="calendar" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
    <!-- Top Navigation -->
    <jsp:include page="../../components/top-navigation.jsp" />

    <!-- Main Content Area -->
    <main class="flex-1 overflow-y-auto p-6 bg-gray-100">

            <!-- Calendar Navigation -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2 mb-4">
                <div class="flex flex-wrap gap-2 w-full sm:w-auto">
                    <button onclick="calendar.prev()" class="bg-white border border-gray-300 px-3 py-1 rounded-md hover:bg-gray-50 cal-btn">Previous</button>
                    <button onclick="calendar.today()" class="bg-white border border-gray-300 px-3 py-1 rounded-md hover:bg-gray-50 cal-btn">Today</button>
                    <button onclick="calendar.next()" class="bg-white border border-gray-300 px-3 py-1 rounded-md hover:bg-gray-50 cal-btn">Next</button>
                </div>
                <h2 id="calendar-title" class="text-lg font-semibold text-gray-700 order-first sm:order-none w-full text-center sm:w-auto sm:text-left"></h2>
                <div class="flex flex-wrap gap-2 w-full sm:w-auto justify-end">
                    <button onclick="calendar.changeView('dayGridMonth')" class="bg-white border border-gray-300 px-3 py-1 rounded-md hover:bg-gray-50 cal-btn">Month</button>
                    <button onclick="calendar.changeView('timeGridWeek')" class="bg-white border border-gray-300 px-3 py-1 rounded-md hover:bg-gray-50 cal-btn">Week</button>
                    <button onclick="calendar.changeView('timeGridDay')" class="bg-white border border-gray-300 px-3 py-1 rounded-md hover:bg-gray-50 cal-btn">Day</button>
                </div>
            </div>


            <!-- Calendar -->
            <div class="bg-white p-4 rounded-lg shadow-md">
                <div id="calendar"></div>
            </div>

            <!-- Status Filter -->
            <div class="mt-4 flex flex-wrap gap-4">
                <div class="flex items-center">
                    <input type="checkbox" id="filter-approved" checked 
                           class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                           onchange="filterEvents()">
                    <label for="filter-approved" class="ml-2 text-sm text-gray-700">Approved</label>
                </div>
                <div class="flex items-center">
                    <input type="checkbox" id="filter-pending" checked 
                           class="h-4 w-4 text-yellow-600 focus:ring-yellow-500 border-gray-300 rounded"
                           onchange="filterEvents()">
                    <label for="filter-pending" class="ml-2 text-sm text-gray-700">Pending</label>
                </div>
                <div class="flex items-center">
                    <input type="checkbox" id="filter-rejected" checked 
                           class="h-4 w-4 text-red-600 focus:ring-red-500 border-gray-300 rounded"
                           onchange="filterEvents()">
                    <label for="filter-rejected" class="ml-2 text-sm text-gray-700">Rejected</label>
                </div>
                <div class="flex items-center">
                    <input type="checkbox" id="filter-cancelled" checked 
                           class="h-4 w-4 text-red-600 focus:ring-red-500 border-gray-300 rounded"
                           onchange="filterEvents()">
                    <label for="filter-cancelled" class="ml-2 text-sm text-gray-700">Cancelled</label>
                </div>
            </div>

        </main>
    </div>
</div>

<!-- Reservation Details Modal -->
<div id="details-modal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50 p-2">
    <div class="bg-white rounded-lg p-6 w-full max-w-md mx-4 overflow-y-auto" style="max-height: 90vh;">
        <h3 id="reservation-title" class="text-xl font-bold mb-2"></h3>
        <div class="flex justify-between items-center gap-2 text-sm text-gray-600 mb-4">
            <span id="reservation-time" class="min-w-0"></span>
            <span id="reservation-status" class="flex-shrink-0 px-2 py-0.5 rounded-full text-xs font-semibold whitespace-nowrap"></span>
        </div>
        <p id="reservation-room" class="text-gray-700 mb-2"></p>
        <p id="reservation-purpose" class="text-sm text-gray-500 mb-2"></p>
        <div class="mb-4" id="approval-comments" hidden>
            <label for="comments" class="block text-xs font-medium text-gray-700 mb-1">Approval Comments (Optional)/Reason for Rejection *</label>
            <textarea id="comments" name="comments" rows="3"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
            <p id="comment-error" class="hidden text-xs text-red-600 mt-1">Please provide a reason for rejection</p>
        </div>

        <div id="action-buttons" class="flex justify-end space-x-3">
            <!-- Buttons will be populated based on reservation status -->
        </div>
    </div>
</div>

<script>
    // Initialize FullCalendar only if a room is selected
    document.addEventListener('DOMContentLoaded', function() {
            const calendarEl = document.getElementById('calendar');
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                headerToolbar: false,
                nowIndicator: true,
                selectable: true,
                editable: true,
                height: 'auto',
                contentHeight: 'auto',
                handleWindowResize: true,
                windowResize: function(view) {
                    if (window.innerWidth < 640) { // Tailwind's sm breakpoint
                        calendar.changeView('timeGridDay');
                    }
                },
                eventClick: function(info) {
                    showReservationDetails(info.event);
                },
                eventDidMount: function(info) {
                    // Color events based on status
                    const status = info.event.extendedProps.status;
                    if (status === 'pending') {
                        info.el.style.backgroundColor = '#fbbf24'; // yellow
                        info.el.style.borderColor = '#f59e0b';
                    } else if (status === 'rejected') {
                        info.el.style.backgroundColor = '#ef4444'; // red
                        info.el.style.borderColor = '#dc2626';
                    } else if (status === 'approved') {
                        info.el.style.backgroundColor = '#10b981'; // green
                        info.el.style.borderColor = '#059669';
                    } else if (status === 'cancelled') {
                        info.el.style.backgroundColor = '#cccccc'; // gray
                        info.el.style.borderColor = '#050505';
                    } else if (status === 'completed') {
                        info.el.style.backgroundColor = '#0505ff'; // gray
                        info.el.style.borderColor = '#050505';
                    } else if (status === 'no-show') {
                        info.el.style.backgroundColor = '#df05df'; // gray
                        info.el.style.borderColor = '#050505';
                    }
                },
                events: [
                    <c:forEach items="${reservations}" var="reservation">
                    {
                        id: "${reservation.id}",
                        title: "${reservation.title}",
                        start: "${reservation.startTime}",
                        end: "${reservation.endTime}",
                        extendedProps: {
                            purpose: "${reservation.purpose}",
                            status: "${reservation.status}",
                            userId: ${reservation.userId},
                            roomName: "${reservation.room.name}",
                            building: "${reservation.room.building.name}",
                            userName: "${reservation.user.username}"
                        }
                    },
                    </c:forEach>
                ]
            });

            calendar.render();
            updateCalendarTitle(calendar);
            window.calendar = calendar;

        // Handle messages from server
        <c:if test="${not empty success}">
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: '${success}'
            });
        </c:if>
        <c:if test="${not empty error}">
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: '${error}'
            });
        </c:if>

        // Select all buttons with the specific class
        const buttons = document.querySelectorAll('.cal-btn');

        // Add click event listener to each button
        buttons.forEach(button => {
          button.addEventListener('click', function() {
            updateCalendarTitle(calendar); // Call your function here
          });
        });
    });

    function updateCalendarTitle(calendar) {
        const view = calendar.view;
        let title = '';

        if (view.type === 'dayGridMonth') {
            title = view.currentStart.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
        } else if (view.type === 'timeGridWeek') {
            const start = view.currentStart;
            const end = new Date(start);
            end.setDate(end.getDate() + 6);

            title = start.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }) + 
                   ' - ' + end.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        } else if (view.type === 'timeGridDay') {
            title = view.currentStart.toLocaleDateString('en-US', { weekday: 'long', month: 'short', day: 'numeric', year: 'numeric' });
        }

        document.getElementById('calendar-title').textContent = title;
    }

    function filterEvents() {
        const showApproved = document.getElementById('filter-approved').checked;
        const showPending = document.getElementById('filter-pending').checked;
        const showRejected = document.getElementById('filter-rejected').checked;
        const showCancelled = document.getElementById('filter-cancelled').checked;

        calendar.getEvents().forEach(event => {
            const status = event.extendedProps.status;
            if ((status === 'approved' && !showApproved) || 
                (status === 'pending' && !showPending) || 
                (status === 'cancelled' && !showCancelled) ||
                (status === 'rejected' && !showRejected)) {
                event.setProp('display', 'none');
            } else {
                event.setProp('display', 'auto');
            }
        });
    }

    function formatDateTimeLocal(date) {
        return date.toISOString().slice(0, 16);
    }

    
    // Close modals when clicking outside
    window.onclick = function(event) {
        if (event.target == document.getElementById('details-modal')) {
            closeDetailsModal();
        }
    }

    function showReservationDetails(event) {
        const modal = document.getElementById('details-modal');
        const start = event.start.toLocaleString('en-US', {
            month: 'short', day: 'numeric', year: 'numeric',
            hour: 'numeric', minute: '2-digit', hour12: true
        });
        const end = event.end.toLocaleString('en-US', {
            hour: 'numeric', minute: '2-digit', hour12: true
        });

        document.getElementById('reservation-title').textContent = event.title;
        document.getElementById('reservation-room').textContent = event.extendedProps.roomName +` (` +event.extendedProps.building + `)`;
        document.getElementById('reservation-time').textContent = start +` - ` + end;
        document.getElementById('reservation-purpose').textContent = event.extendedProps.purpose || 'No purpose specified';

        const statusElement = document.getElementById('reservation-status');
        statusElement.textContent = event.extendedProps.status;
        statusElement.className = 'px-2 py-1 rounded-full text-xs ';

        if (event.extendedProps.status === 'pending') {
            statusElement.className += 'bg-yellow-100 text-yellow-800';
        } else if (event.extendedProps.status === 'approved') {
            statusElement.className += 'bg-green-100 text-green-800';
        } else if (event.extendedProps.status === 'rejected') {
            statusElement.className += 'bg-red-100 text-red-800';
        } else if (event.extendedProps.status === 'cancelled') {
            statusElement.className += 'bg-gray-100 text-gray-800';
        } else if (event.extendedProps.status === 'completed') {
            statusElement.className += 'bg-blue-100 text-blue-800';
        } else if (event.extendedProps.status === 'no-show') {
            statusElement.className += 'bg-purple-100 text-purple-800';
        }

        const actionButtons = document.getElementById('action-buttons');
        const approvalComments = document.getElementById('approval-comments');
        const commentText = document.getElementById('comments').value.trim();
        actionButtons.innerHTML = '';

        approvalComments.hidden = true;
        actionButtons.innerHTML = `
            <button onclick="closeDetailsModal()"
                    class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300 transition">
                Close
            </button>
        `;

        modal.classList.remove('hidden');
    }

    function closeDetailsModal() {
        document.getElementById('details-modal').classList.add('hidden');
    }
    
    // Handle click outside modal to close
    document.addEventListener('click', function(event) {
        // For details modal
        const detailsModal = document.getElementById('details-modal');
        if (event.target === detailsModal) {
            closeDetailsModal();
        }
    });

    // Prevent clicks inside modal from closing it
    document.querySelectorAll('#details-modal > div').forEach(modalContent => {
        modalContent.addEventListener('click', function(event) {
            event.stopPropagation();
        });
    });
</script>                
    
<jsp:include page="../../components/user-mobile-menu.jsp" >
    <jsp:param name="page" value="calendar" />
</jsp:include>