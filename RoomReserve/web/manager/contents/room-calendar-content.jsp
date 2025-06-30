<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <div class="flex h-screen">
        <!-- Admin Sidebar -->
        <jsp:include page="../../components/manager-sidebar.jsp">
            <jsp:param name="page" value="calendar" />
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
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">
                        <c:choose>
                            <c:when test="${not empty selectedRoom}">${selectedRoom.name} Calendar</c:when>
                            <c:otherwise>Select a Room</c:otherwise>
                        </c:choose>
                    </h1>
                    <c:if test="${not empty selectedRoom}">
                        <p class="text-gray-600">Building: ${selectedRoom.building.name} | Capacity: ${selectedRoom.capacity}</p>
                    </c:if>
                </div>
            </div>
            
            <!-- Room Selection Dropdown -->
            <div class="bg-white p-4 rounded-lg shadow-md mb-6">
                <form id="room-select-form" method="GET" action="${pageContext.request.contextPath}/manager/room-calendar">
                    <div class="flex items-center space-x-4">
                        <label for="room-select" class="text-sm font-medium text-gray-700">Select Room:</label>
                        <select id="room-select" name="roomId" onchange="this.form.submit()"
                                class="w-full md:w-64 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <option value="">-- Select a Room --</option>
                            <c:forEach items="${allRooms}" var="room">
                                <option value="${room.id}" ${selectedRoom != null && selectedRoom.id == room.id ? 'selected' : ''}>
                                    ${room.name} (${room.building.name})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </form>
            </div>

            <c:if test="${not empty selectedRoom}">
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
            </c:if>

            </main>
        </div>
    </div>

    <!-- Reservation Details Modal -->
    <div id="details-modal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50 p-2">
        <div class="bg-white rounded-lg p-6 w-full max-w-md">
            <h3 id="reservation-title" class="text-xl font-bold mb-2"></h3>
            <div class="flex justify-between items-center gap-2 text-sm text-gray-600 mb-4">
                <span id="reservation-time" class="min-w-0"></span>
                <span id="reservation-status" class="flex-shrink-0 px-2 py-0.5 rounded-full text-xs font-semibold whitespace-nowrap"></span>
            </div>
            <p id="reservation-purpose" class="text-gray-700 text-md mb-0"></p>
            <p class="text-sm text-gray-500 mb-2">Reserved by: <span id="reservation-user"></span></p>
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
    
    <!-- Rejection Reason Modal (hidden by default) -->
    <div id="rejectModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-2">
      <div class="bg-white p-6 rounded-lg max-w-md w-full">
        <h3 class="font-bold text-lg mb-4">Reason for Rejection</h3>
        <textarea 
          id="rejectionReason" 
          placeholder="Enter reason..."
          class="w-full p-2 border rounded mb-4"
          rows="3"></textarea>
        <div class="flex justify-end gap-2">
          <button onclick="closeRejectModal()" class="px-4 py-2 border rounded">Cancel</button>
          <button onclick="submitRejection()" class="px-4 py-2 bg-red-600 text-white rounded">Submit</button>
        </div>
      </div>
    </div>

    <script>
        // Initialize FullCalendar only if a room is selected
        document.addEventListener('DOMContentLoaded', function() {
    <c:if test="${not empty selectedRoom}">
        const calendarEl = document.getElementById('calendar');
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'timeGridWeek',
            headerToolbar: {
                start: 'title',
                center: '',
                end: 'today prev,next timeGridDay,timeGridWeek'
            },
            nowIndicator: true,
            selectable: true,
            editable: true,
            height: 'auto',
            contentHeight: 'auto',
            handleWindowResize: true,
            dayMaxEventRows: 3, // Limit stacked events
            eventMaxStack: 2,   // Maximum events to stack before "+ more"
            slotMinTime: '07:00:00', // Adjust based on your needs
            slotMaxTime: '21:00:00', // Adjust based on your needs
            allDaySlot: false,  // Remove all-day slot if not needed
            slotEventOverlap: false, // Prevent event overlap
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'timeGridDay,timeGridWeek'
            },
            windowResize: function(view) {
                if (window.innerWidth < 768) { // Tailwind's md breakpoint
                    calendar.changeView('timeGridDay');
                    calendar.setOption('headerToolbar', {
                        left: 'prev,next',
                        center: 'title',
                        right: ''
                    });
                } else {
                    calendar.changeView('timeGridWeek');
                    calendar.setOption('headerToolbar', {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'timeGridDay,timeGridWeek'
                    });
                }
            },
            eventClick: function(info) {
                showReservationDetails(info.event);
            },
            eventDidMount: function(info) {
                // Color events based on status
                const status = info.event.extendedProps.status;
                const statusColors = {
                    'pending': { bg: '#fbbf24', border: '#f59e0b' },
                    'rejected': { bg: '#ef4444', border: '#dc2626' },
                    'approved': { bg: '#10b981', border: '#059669' },
                    'cancelled': { bg: '#cccccc', border: '#050505' },
                    'completed': { bg: '#3b82f6', border: '#2563eb' }, // blue
                    'no-show': { bg: '#d946ef', border: '#c026d3' } // purple
                };
                
                if (statusColors[status]) {
                    info.el.style.backgroundColor = statusColors[status].bg;
                    info.el.style.borderColor = statusColors[status].border;
                    info.el.style.fontSize = '0.75rem'; // Smaller text on mobile
                    info.el.style.padding = '2px 4px'; // Tighter padding
                }

                // Truncate long titles on small screens
                if (window.innerWidth < 640) {
                    const titleEl = info.el.querySelector('.fc-event-title');
                    if (titleEl) {
                        titleEl.style.whiteSpace = 'nowrap';
                        titleEl.style.overflow = 'hidden';
                        titleEl.style.textOverflow = 'ellipsis';
                    }
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
                        userName: "${reservation.user.username}",
                        isUpcoming: ${reservation.isUpcoming()}
                    }
                },
                </c:forEach>
            ]
        });
        
        // Initial render
        calendar.render();
        
        // Check viewport size on load
        if (window.innerWidth < 768) {
            calendar.changeView('timeGridDay');
        }
        
        updateCalendarTitle(calendar);
        window.calendar = calendar;
    </c:if>
            
            // Handle messages from server
            <c:if test="${not empty success}">
                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: '${success}'
                });
            <c:remove var="success" scope="session"/>    
            </c:if>
            <c:if test="${not empty error}">
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: '${error}'
                });
            <c:remove var="error" scope="session"/>    
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
        
        function showRejectModal(eventId) {
            currentEventId = eventId;
            document.getElementById('rejectModal').classList.remove('hidden');
        }

        function closeRejectModal() {
            document.getElementById('rejectModal').classList.add('hidden');
            document.getElementById('rejectionReason').value = '';
        }

        function submitRejection() {
            const reason = document.getElementById('rejectionReason').value.trim();
            if (!reason) {
              alert("Please provide a rejection reason");
              return;
            }

            updateReservationStatus(currentEventId, 'rejected', reason);
            closeRejectModal();
        }
        
        // Close modals when clicking outside
        window.onclick = function(event) {
            if (event.target == document.getElementById('rejectModal')) {
                closeRejectModal();
            }
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
            document.getElementById('reservation-time').textContent = start +` - ` + end;
            document.getElementById('reservation-purpose').textContent = event.extendedProps.purpose || 'No purpose specified';
            document.getElementById('reservation-user').textContent = event.extendedProps.userName;
            
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
            
            if (event.extendedProps.status === 'pending') {
                approvalComments.hidden = false;
                const buttons = document.createElement('div');
                buttons.innerHTML = `
                    <button class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition">
                        Reject
                    </button>
                    <button class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition">
                        Approve
                    </button>
                `;

                buttons.querySelector('button:first-child').onclick = () => 
                    validateRejection(event.id);
                buttons.querySelector('button:last-child').onclick = () => 
                    updateReservationStatus(event.id, 'approved', commentText);

                actionButtons.innerHTML = '';
                actionButtons.appendChild(buttons);
            } else if (event.extendedProps.status === 'approved' && event.extendedProps.isUpcoming === true) {
                approvalComments.hidden = false;
                const buttons = document.createElement('div');
                buttons.innerHTML = `
                    <button class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition">
                        Reject
                    </button>
                `;

                buttons.querySelector('button:first-child').onclick = () => 
                    validateRejection(event.id);

                actionButtons.innerHTML = '';
                actionButtons.appendChild(buttons);
            } else {
                approvalComments.hidden = true;
                actionButtons.innerHTML = `
                    <button onclick="closeDetailsModal()"
                            class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300 transition">
                        Close
                    </button>
                `;
            }
            
            modal.classList.remove('hidden');
        }

        function closeDetailsModal() {
            document.getElementById('details-modal').classList.add('hidden');
        }

        function updateReservationStatus(reservationId, status, comments) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/manager/reservations';
            
            const roomIdInput = document.createElement('input');
            roomIdInput.type = 'hidden';
            roomIdInput.name = 'roomId';
            roomIdInput.value = '${selectedRoom.id}';
            form.appendChild(roomIdInput);
            
            const commentsInput = document.createElement('input');
            commentsInput.type = 'hidden';
            commentsInput.name = 'comments';
            commentsInput.value = comments;
            form.appendChild(commentsInput);
            
            const calendarInput = document.createElement('input');
            calendarInput.type = 'hidden';
            calendarInput.name = 'calendar';
            calendarInput.value = true;
            form.appendChild(calendarInput);
            
            const reservationIdInput = document.createElement('input');
            reservationIdInput.type = 'hidden';
            reservationIdInput.name = 'reservationId';
            reservationIdInput.value = reservationId;
            form.appendChild(reservationIdInput);
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = status === 'approved' ? 'approve' : 'reject';
            form.appendChild(actionInput);
            
            document.body.appendChild(form);
            form.submit();
        }
        
        // Handle approval - comments are optional
        document.getElementById('approveForm').addEventListener('submit', function(e) {
            const commentText = document.getElementById('comments').value;
            document.getElementById('approveComments').value = commentText;
        });

        // Handle rejection - comments are required
        function validateRejection(reservationId) {
            const commentText = document.getElementById('comments').value.trim();
            const errorElement = document.getElementById('comment-error');

            if (!commentText) {
                errorElement.classList.remove('hidden');
                return;
            }

            errorElement.classList.add('hidden');
            updateReservationStatus(reservationId, 'rejected', commentText);
        }
        
        // Handle click outside modal to close
        document.addEventListener('click', function(event) {

            // For details modal
            const detailsModal = document.getElementById('details-modal');
            if (event.target === detailsModal) {
                closeDetailsModal();
            }
        });

    </script>                
    
<jsp:include page="../../components/manager-mobile-menu.jsp" >
    <jsp:param name="page" value="calendar" />
</jsp:include>