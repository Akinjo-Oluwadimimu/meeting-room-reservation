<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Navigation Bar -->
<jsp:include page="../../components/navigation.jsp" />
<jsp:include page="booking-configuration.jsp" />
<!-- Main Content -->
<main class="container mx-auto px-4 py-8">
    <!-- Back Button -->
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/user/rooms.jsp" class="text-blue-600 hover:text-blue-800 font-medium flex items-center">
            <i class="fas fa-arrow-left mr-2"></i> Back to all rooms
        </a>
    </div>

    <!-- Room Header -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8">
        <div>
            <h1 class="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">${room.name}</h1>
            <div class="flex items-center space-x-4">
                <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded">${room.building.name}</span>
                <c:if test="${room.isActive()}">
                    <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded flex items-center">
                        <i class="fas fa-circle text-xs mr-1"></i> Available Now
                    </span>
                </c:if>
                <c:if test="${!room.isActive()}">
                    <span class="bg-red-100 text-red-800 text-xs font-medium px-2.5 py-0.5 rounded flex items-center">
                        <i class="fas fa-circle text-xs mr-1"></i> Unavailable
                    </span>
                </c:if>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/user/reserve/${room.name.replaceAll("\\s+", "-").replaceAll("[^\\w-]", "")}?roomId=${room.getId()}" class="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-md font-medium transition">
            <i class="fas fa-calendar-plus mr-2"></i> Reserve This Room
        </a>
    </div>
            
    <c:if test="${not empty error}">
        <div class="mb-4 p-4 bg-red-100 border-l-4 border-red-500 text-red-700">
            <c:if test="${not empty errorCode}">
                <div class="font-bold">Error ${errorCode}</div>
            </c:if>
            <p>${error}</p>
            <c:if test="${not empty fieldError}">
                <p class="text-sm mt-1">Problem with: ${fieldError}</p>
            </c:if>
        </div>
        <c:remove scope="session" var="error" />
    </c:if>        

    <!-- Room Gallery and Details -->
    <div class="flex flex-col lg:flex-row gap-8">
        <!-- Room Images -->
        <div class="lg:w-2/3">
            <div class="bg-white p-4 rounded-lg shadow-sm mb-6">
                <!-- Main Image -->
                <c:choose>
                    <c:when test="${room.coverImageId > 0}">
                        <div class="mb-4 rounded-lg overflow-hidden">
                            <img src="${room.coverImage.imageUrl}" 
                                 alt="${room.name}" 
                                 class="w-full h-96 object-cover rounded-lg">
                        </div>
                    </c:when>
                    <c:when test="${room.images.size() > 0 && room.coverImageId <= 0}">
                        <c:forEach begin="1" end="1" var="image" items="${room.images}">
                            <div class="mb-4 rounded-lg overflow-hidden">
                                <img src="${image.imageUrl}" 
                                     alt="${image.caption}" 
                                     class="w-full h-96 object-cover rounded-lg">
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="mb-4 rounded-lg overflow-hidden">
                            <img src="${pageContext.request.contextPath}/images/no-cover.png" 
                                 alt="No image" 
                                 class="w-full h-96 object-cover rounded-lg">
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Thumbnail Gallery with Controls -->
                <div class="relative">
                    <div class="flex items-center">
                        <button id="prevThumb" class="p-2 rounded-full bg-gray-100 hover:bg-gray-200 mr-2">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                            </svg>
                        </button>

                        <div class="overflow-hidden flex-1">
                            <div id="thumbContainer" class="flex space-x-2 transition-transform duration-300">
                                <c:forEach var="image" items="${room.images}">
                                    <button class="thumbnail-btn flex-shrink-0 rounded-lg overflow-hidden ${image.imageId == room.coverImageId ? "border-2 border-blue-500" : ""}">
                                        <img src="${image.imageUrl}" 
                                             alt="${image.caption}" 
                                             class="w-20 h-20 object-cover">
                                    </button>
                                </c:forEach>
                            </div>
                        </div>

                        <button id="nextThumb" class="p-2 rounded-full bg-gray-100 hover:bg-gray-200 ml-2">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                            </svg>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Room Description -->
            <div class="bg-white p-6 rounded-lg shadow-sm mb-6">
                <h2 class="text-lg sm:text-xl font-bold text-gray-800 mb-4">Description</h2>
                <p class="text-gray-600 mb-4">
                    ${room.description}
                </p>
            </div>

            <!-- Room Features -->
            <div class="bg-white p-6 rounded-lg shadow-sm">
                <h2 class="text-lg sm:text-xl font-bold text-gray-800 mb-4">Features & Amenities</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="flex items-start">
                        <div class="flex-shrink-0 text-blue-600 mr-3">
                            <i class="fas fa-users text-lg"></i>
                        </div>
                        <div>
                            <h3 class="font-medium text-gray-800">Capacity</h3>
                            <p class="text-gray-600">${room.capacity} people (comfortable seating)</p>
                        </div>
                    </div>
                    <c:forEach var="amenity" items="${room.amenities}">
                        <div class="flex items-start">
                            <div class="flex-shrink-0 text-blue-600 mr-3">
                                <i class="${amenity.iconClass} text-lg"></i>
                            </div>
                            <div>
                                <h3 class="font-medium text-gray-800">${amenity.name}</h3>
                                <p class="text-gray-600">${amenity.description}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Booking Panel -->
        <div class="lg:w-1/3">
            <div class="bg-white p-6 rounded-lg shadow-sm sticky top-4">

                <!-- Quick Reserve -->
                <form action="${pageContext.request.contextPath}/user/reservation" method="POST" class="" id="reservationForm" onsubmit="return checkRoomAvailability(event)">
                    <input type="hidden" id="roomId" name="roomId" value="${room.id}">

                    <h3 class="text-lg sm:text-xl font-bold text-gray-800 mb-4">Reserve This Room</h3>
                    <div class="space-y-4">
                        <div>
                            <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Meeting Title *</label>
                            <input type="text" id="title" name="title" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                   placeholder="Team meeting, Class discussion, etc.">
                        </div>

                        <div>
                            <label for="reservationDate" class="block text-sm font-medium text-gray-700 mb-1">Date *</label>
                            <input type="text" placeholder="Select Date.." id="reservationDate" name="reservationDate" required
                                   class="w-full min-w-0 h-10 appearance-none px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        </div>

                        <div>
                            <label for="startTime" class="block text-sm font-medium text-gray-700 mb-1">Start Time *</label>
                            <input type="time" id="startTime" name="startTime" required
                                   class="w-full min-w-0 h-10 appearance-none px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        </div>

                        <div>
                            <label for="endTime" class="block text-sm font-medium text-gray-700 mb-1">End Time *</label>
                            <input type="datetime-local" id="endTime" name="endTime" required
                                   class="w-full min-w-0 h-10 appearance-none px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        </div>
                        
                        <div id="bookingError" class="hidden p-4 text-red-700 bg-red-100 rounded-md"></div>

                        <div>
                            <label for="attendees" class="block text-sm font-medium text-gray-700 mb-1">Number of Attendees*</label>
                            <input type="number" id="attendees" name="attendees" min="1" max="${room.capacity}" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="Number of people" required>
                        </div>

                        <div>
                            <label for="purpose" class="block text-sm font-medium text-gray-700 mb-1">Purpose</label>
                            <textarea id="purpose" name="purpose" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="Brief description of your meeting"></textarea>
                        </div>

                        <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-md font-medium transition">
                            Confirm Reservation
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</main>

<!-- Footer -->
<jsp:include page="../../components/footer.jsp" />

<script>

    // Image gallery functionality
    const thumbnails = document.querySelectorAll('#thumbContainer button');
    const mainImage = document.querySelector('.w-full.h-96');

    thumbnails.forEach(thumb => {
        thumb.addEventListener('click', function() {
            // Remove border from all thumbnails
            thumbnails.forEach(t => t.classList.remove('border-2', 'border-blue-500'));

            // Add border to clicked thumbnail
            this.classList.add('border-2', 'border-blue-500');

            // Update main image (in a real app, this would use the full resolution image)
            const imgSrc = this.querySelector('img').src;
            mainImage.src = imgSrc;
        });
    });

    document.addEventListener('DOMContentLoaded', function() {
        const container = document.getElementById('thumbContainer');
        const prevBtn = document.getElementById('prevThumb');
        const nextBtn = document.getElementById('nextThumb');
        const thumbnails = document.querySelectorAll('.thumbnail-btn');
        const thumbnailWidth = 88; // 80px width + 8px margin (adjust as needed)
        let scrollPosition = 0;
        const maxScroll = (thumbnails.length - 4) * thumbnailWidth; // Show 4 thumbnails at a time

        // Initialize buttons
        updateButtons();

        prevBtn.addEventListener('click', function() {
            scrollPosition = Math.max(scrollPosition - (thumbnailWidth * 4), 0);
            container.style.transform = `translateX(-`+scrollPosition+`px)`;
            updateButtons();
        });

        nextBtn.addEventListener('click', function() {
            scrollPosition = Math.min(scrollPosition + (thumbnailWidth * 4), maxScroll);
            container.style.transform = `translateX(-`+scrollPosition+`px)`;
            updateButtons();
        });

        function updateButtons() {
            prevBtn.hidden = scrollPosition <= 0;
            nextBtn.hidden = scrollPosition >= maxScroll;
        }
    });

</script>

<script src="${pageContext.request.contextPath}/js/reservation.js"></script>