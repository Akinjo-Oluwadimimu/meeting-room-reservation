<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Navigation Bar -->
<jsp:include page="../../components/navigation.jsp" />
<jsp:include page="booking-configuration.jsp" />

<!-- Main Content -->
<main class="container mx-auto px-4 py-8">
    <div class="max-w-6xl mx-auto">
        <!-- Back Button -->
        <div class="mb-6">
            <a href="${pageContext.request.contextPath}/user/rooms.jsp" class="text-blue-600 hover:text-blue-800 font-medium flex items-center">
                <i class="fas fa-arrow-left mr-2"></i> Back to all rooms
            </a>
        </div>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">Reserve Meeting Room</h1>
            <p class="text-gray-600">Complete the form below to reserve your meeting room</p>
        </div>

        <!-- Reservation Form -->
        <div class="bg-white p-6 rounded-lg shadow-sm">
            <form action="${pageContext.request.contextPath}/user/reservation" method="POST" id="reservationForm" class="space-y-6" onsubmit="return checkRoomAvailability(event)">
                <!-- Room Information -->
                <div class="border-b border-gray-200 pb-6">
                    <h2 class="text-lg sm:text-xl font-semibold text-gray-800 mb-4">Room Information</h2>
                    <div class="flex flex-col md:flex-row gap-6">
                        <c:choose>
                            <c:when test="${room.coverImageId > 0}">
                                <div class="md:w-1/3">
                                    <img src="${room.coverImage.imageUrl}" 
                                         alt="${room.name}" 
                                         class="w-full h-auto rounded-lg">
                                </div>
                            </c:when>
                            <c:when test="${room.images.size() > 0 && room.coverImageId <= 0}">
                                <c:forEach begin="1" end="1" var="image" items="${room.images}">
                                    <div class="md:w-1/3">
                                        <img src="${image.imageUrl}" 
                                             alt="${image.caption}" 
                                             class="w-full h-auto rounded-lg">
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="md:w-1/3">
                                    <img src="${pageContext.request.contextPath}/images/no-cover.png" 
                                         alt="No image" 
                                         class="w-full h-auto rounded-lg">
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="md:w-2/3">
                            <h3 class="text-lg sm:text-xl font-bold text-gray-800 mb-2">${room.name}</h3>
                            <p class="text-gray-600 mb-4">${room.building.name} - Room #${room.roomNumber}</p>

                            <div class="flex flex-wrap gap-2 mb-4">
                                <span class="bg-gray-100 text-gray-800 text-xs px-2 py-1 rounded flex items-center">
                                    <i class="fas fa-users mr-1 text-xs"></i> ${room.capacity} people
                                </span>
                                <c:forEach var="amenity" items="${room.amenities}">
                                    <span class="bg-gray-100 text-gray-800 text-xs px-2 py-1 rounded flex items-center">
                                        <i class="${amenity.iconClass} mr-1 text-xs"></i> ${amenity.name}
                                    </span>
                                </c:forEach>
                            </div>

                            <input type="hidden" id="roomId" name="roomId" value="${room.id}">
                        </div>
                    </div>
                </div>

                <!-- Reservation Details -->
                <div class="border-b border-gray-200 pb-6">
                    <h2 class="text-lg sm:text-xl font-semibold text-gray-800 mb-4">Reservation Details</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-4">
                        <!-- Date Picker -->
                        <div>
                            <label for="reservationDate" class="block text-sm font-medium text-gray-700 mb-1">Date *</label>
                            <input type="text" placeholder="Select Date.." id="reservationDate" name="reservationDate" required
                                   class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        </div>

                        <div>
                            <label for="attendees" class="block text-sm font-medium text-gray-700 mb-1">Number of Attendees*</label>
                            <input type="number" id="attendees" name="attendees" min="1" max="${room.capacity}" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="Number of people" required>
                        </div>

                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-4">
                        <!-- Time Picker -->
                        <div>
                            <label for="startTime" class="block text-sm font-medium text-gray-700 mb-1">Start Time *</label>
                            <input type="time" id="startTime" name="startTime" required
                                   class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        </div>

                        <div>
                            <label for="endTime" class="block text-sm font-medium text-gray-700 mb-1">End Time *</label>
                            <input type="datetime-local" id="endTime" name="endTime" required
                                   class="w-full h-10 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        </div>

                    </div>
                                   
                    <div id="bookingError" class="hidden p-4 text-red-700 bg-red-100 rounded-md"></div>               

                </div>

                <!-- Meeting Details -->
                <div class="pb-6">
                    <h2 class="text-lg sm:text-xl font-semibold text-gray-800 mb-4">Meeting Details</h2>

                    <div class="space-y-6">
                        <!-- Purpose -->
                        <div>
                            <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Title*</label>
                            <input type="text" id="title" name="title" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="Meeting title" required>
                        </div>

                        <!-- Description -->
                        <div>
                            <label for="purpose" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea id="purpose" name="purpose" rows="4" 
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                      placeholder="Additional details about your meeting"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="flex justify-end space-x-4">
                    <a href="${pageContext.request.contextPath}/user/rooms.jsp" class="bg-white border border-gray-300 text-gray-700 px-6 py-2 rounded-md font-medium hover:bg-gray-50 transition">
                        Cancel
                    </a>
                    <button type="submit" 
                            class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-md font-medium transition">
                        Submit Reservation
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>
<jsp:include page="../../components/footer.jsp" />

<script src="${pageContext.request.contextPath}/js/reservation.js"></script>
