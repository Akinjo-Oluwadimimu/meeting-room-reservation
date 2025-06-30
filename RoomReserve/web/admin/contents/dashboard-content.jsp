<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="dashboard" />
    </jsp:include>
    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />

        <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <!-- Page Header -->
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Welcome, ${user.username}</h1>
            </div>

            <!-- Stats Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
                 <!--Total Users Card--> 
                <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-blue-500">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Total Users</p>
                            <p class="text-2xl font-semibold text-gray-800">${totalUsers}</p>
                        </div>
                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                            <i class="fas fa-users text-xl"></i>
                        </div>
                    </div>
                    <fmt:parseNumber var="growthNum" value="${userGrowthPercentage}" type="number"/>
                    <p class="mt-2 text-xs ${growthNum > 0 ? 'text-green-600' :
                                             growthNum < 0 ? 'text-red-600' : ''}">
                        <i class="fas ${growthNum > 0 ? 'fa-arrow-up' : 
                                        growthNum < 0 ? 'fa-arrow-down' : 'fa-minus'} mr-1"></i> 
                                        ${growthNum == 0 ? 'No change' :  userGrowthPercentage += '% from last month'}
                    </p>
                </div>

                <!--Active Reservations Card--> 
                <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-green-500">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Active Reservations</p>
                            <p class="text-2xl font-semibold text-gray-800">${activeReservations}</p>
                        </div>
                        <div class="p-3 rounded-full bg-green-100 text-green-600">
                            <i class="fas fa-calendar-check text-xl"></i>
                        </div>
                    </div>
                    <p class="mt-2 text-xs text-green-600">
                        At this present moment
                    </p>
                </div>

                 <!--Meeting Rooms Card--> 
                <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-yellow-500">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Meeting Rooms</p>
                            <p class="text-2xl font-semibold text-gray-800">${totalRooms}</p>
                        </div>
                        <div class="p-3 rounded-full bg-yellow-100 text-yellow-600">
                            <i class="fas fa-door-open text-xl"></i>
                        </div>
                    </div>
                    <p class="mt-2 text-xs text-gray-600">
                        Total meeting room count
                    </p>
                </div>

                 <!--Pending Approvals Card--> 
                <div class="bg-white p-6 rounded-lg shadow-sm border-l-4 border-red-500">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Pending Approvals</p>
                            <p class="text-2xl font-semibold text-gray-800">${pendingApprovals}</p>
                        </div>
                        <div class="p-3 rounded-full bg-red-100 text-red-600">
                            <i class="fas fa-clock text-xl"></i>
                        </div>
                    </div>
                    <p class="mt-2 text-xs text-red-600">
                        Waiting for manager approval
                    </p>
                </div>
            </div>

             <!--Charts Row--> 
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
                 <!--Room Utilization Chart--> 

                <div class="bg-white p-6 rounded-lg shadow-sm">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-medium text-gray-800">Room Utilization</h2>
                        <select id="timePeriod" class="text-sm border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
                            <option value="7">Last 7 Days</option>
                            <option value="30">Last 30 Days</option>
                            <option value="current_month">This Month</option>
                            <option value="last_month">Last Month</option>
                        </select>
                    </div>
                    <div class="h-64">
                        <canvas id="utilizationChart"></canvas>
                    </div>
                </div>

                <script>
                // Initialize chart with empty data
                let utilizationChart;

                function initChart(labels, data) {
                    const ctx = document.getElementById('utilizationChart').getContext('2d');
                    utilizationChart = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Utilization %',
                                data: data,
                                backgroundColor: 'rgba(59, 130, 246, 0.7)',
                                borderColor: 'rgba(59, 130, 246, 1)',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    max: 100,
                                    ticks: {
                                        callback: function(value) {
                                            return value + '%';
                                        }
                                    }
                                }
                            }
                        }
                    });
                }

                // Function to fetch data based on time period
                function fetchData(timePeriod) {
                    fetch('utilization?period=' + timePeriod)
                        .then(response => response.json())
                        .then(data => {
                            // Destroy previous chart if exists
                            if (utilizationChart) {
                                utilizationChart.destroy();
                            }

                            const labels = data.map(item => item[0]);
                            const utilizationPercentages = data.map(item => item[2]); // index 2 is the percentage

                            // Get the chart context
                            const ctx = document.getElementById('utilizationChart').getContext('2d');

                            // Initialize new chart with fetched data
                            initChart(labels, utilizationPercentages);
                        })
                        .catch(error => console.error('Error:', error));
                }

                // Initial load (Last 7 Days)
                fetchData('7');

                // Event listener for select change
                document.getElementById('timePeriod').addEventListener('change', function() {
                    fetchData(this.value);
                });
                </script>

                <div class="bg-white p-6 rounded-lg shadow-sm">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-medium text-gray-800">Reservation Status</h2>
                        <select id="reservationPeriod" class="text-sm border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
                            <option value="current_month">Current Month</option>
                            <option value="last_month">Last Month</option>
                            <option value="last_quarter">Last Quarter</option>
                        </select>
                    </div>
                    <div class="h-64">
                        <canvas id="reservationChart"></canvas>
                    </div>
                </div>

                <script>
                // Initialize chart variable
                let reservationChart;

                // Function to load reservation data
                function loadReservationData(timePeriod) {
                    fetch('reservation-status?period=' + timePeriod)
                        .then(response => response.json())
                        .then(data => {
                            updateReservationChart(data);
                        });
                }

                // Function to update the chart
                function updateReservationChart(data) {
                    if (reservationChart) {
                        reservationChart.data.datasets[0].data = [
                            data.approvedCount,
                            data.pendingCount,
                            data.cancelledCount,
                            data.rejectedCount,
                            data.completedCount,
                            data.noShowCount
                        ];
                        reservationChart.update();
                    } else {
                        // Initial chart creation
                        const ctx = document.getElementById('reservationChart').getContext('2d');
                        reservationChart = new Chart(ctx, {
                            type: 'doughnut',
                            data: {
                                labels: ['Approved', 'Pending', 'Cancelled', 'Rejected', 'Completed', 'No show'],
                                datasets: [{
                                    data: [
                                        data.approvedCount,
                                        data.pendingCount,
                                        data.cancelledCount,
                                        data.rejectedCount,
                                        data.completedCount,
                                        data.noShowCount
                                    ],
                                    backgroundColor: [
                                        'rgba(0, 163, 104, 0.7)',
                                        'rgba(255, 187, 0, 0.7)',
                                        'rgba(220, 38, 38, 0.7)',
                                        'rgba(234, 88, 12, 0.7)',
                                        'rgba(29, 78, 216, 0.7)',
                                        'rgba(120, 113, 108, 0.7)'
                                    ],
                                    borderColor: [
                                        'rgba(0, 163, 104, 1)',
                                        'rgba(255, 187, 0, 1)',
                                        'rgba(220, 38, 38, 1)',
                                        'rgba(234, 88, 12, 1)',
                                        'rgba(29, 78, 216, 1)',
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
                                        position: 'bottom',
                                    },
                                    tooltip: {
                                        callbacks: {
                                            label: function(context) {
                                                const label = context.label || '';
                                                const value = context.raw || 0;
                                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                                const percentage = Math.round((value / total) * 100);
                                                return label + `: ` + value + ` (` + percentage + `%)`;
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    }
                }

                // Event listener for select change
                document.getElementById('reservationPeriod').addEventListener('change', function() {
                    loadReservationData(this.value);
                });

                // Load initial data
                loadReservationData('current_month');
                </script>
            </div>

            <!--Recent Activity & Quick Actions--> 
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                 <!--Recent Reservations--> 
                <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow-sm">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-medium text-gray-800">Recent Reservations</h2>
                        <a href="${pageContext.request.contextPath}/admin/reservations" class="text-sm text-blue-600 hover:text-blue-800">View All</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date/Time</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach items="${recentReservations}" var="reservation" end="3">
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${reservation.roomName}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${reservation.userName}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <fmt:formatDate value="${reservation.startDate}" pattern="MMM d, yyyy h:mm a" /> - 
                                            <fmt:formatDate value="${reservation.endDate}" pattern="h:mm a" />
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${reservation.status == 'approved'}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Approved</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'pending'}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">Pending</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'completed'}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">Completed</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'no-show'}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800">No show</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'cancelled'}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">Cancelled</span>
                                                </c:when>    
                                                <c:when test="${reservation.status == 'rejected'}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">Rejected</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <a href="${pageContext.request.contextPath}/admin/reservations?action=view&id=${reservation.id}" title="View" class="text-blue-600 hover:text-blue-900 mr-1"><i class="fas fa-info-circle"></i> Details</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                 <!--Quick Actions & System Alerts--> 
                <div class="space-y-6">
                     <!--Quick Actions--> 
                    <div class="bg-white p-6 rounded-lg shadow-sm">
                        <h2 class="text-lg font-medium text-gray-800 mb-4">Quick Actions</h2>
                        <div class="grid grid-cols-2 gap-4">
                            <a href="${pageContext.request.contextPath}/admin/user_management.jsp?action=create" class="p-4 border border-gray-200 rounded-lg text-center hover:bg-gray-50 transition">
                                <div class="mx-auto h-10 w-10 text-blue-600 mb-2">
                                    <i class="fas fa-user-plus text-2xl"></i>
                                </div>
                                <span class="text-sm font-medium">Add User</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/room_management.jsp?action=create" class="p-4 border border-gray-200 rounded-lg text-center hover:bg-gray-50 transition">
                                <div class="mx-auto h-10 w-10 text-blue-600 mb-2">
                                    <i class="fas fa-door-open text-2xl"></i>
                                </div>
                                <span class="text-sm font-medium">Add Room</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/reports" class="p-4 border border-gray-200 rounded-lg text-center hover:bg-gray-50 transition">
                                <div class="mx-auto h-10 w-10 text-blue-600 mb-2">
                                    <i class="fas fa-file-export text-2xl"></i>
                                </div>
                                <span class="text-sm font-medium">Generate Report</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/notifications" class="p-4 border border-gray-200 rounded-lg text-center hover:bg-gray-50 transition">
                                <div class="mx-auto h-10 w-10 text-blue-600 mb-2">
                                    <i class="fas fa-bell text-2xl"></i>
                                </div>
                                <span class="text-sm font-medium">Notifications</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="dashboard" />
</jsp:include>                                