<%@page import="com.roomreserve.util.SettingsService"%>
<%@page import="com.roomreserve.model.RoomImage"%>
<%@page import="com.roomreserve.dao.AmenityDAO"%>
<%@page import="java.util.ArrayList"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@page import="java.util.List"%>
<%@page import="com.roomreserve.model.Amenity"%>
<%@page import="com.roomreserve.model.Room"%>
<%@page import="com.roomreserve.model.Building"%>
<%@page import="com.roomreserve.dao.RoomDAO"%>
<%@page import="com.roomreserve.dao.BuildingDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.14.0/Sortable.min.js"></script>
<style>
    .handle {
        cursor: move;
        opacity: 0.6;
        transition: opacity 0.2s;
    }
    .handle:hover {
        opacity: 1;
    }

    #imageGallery .sortable-chosen {
        opacity: 0.8;
        box-shadow: 0 0 10px rgba(0,0,0,0.2);
    }

    #imageGallery .sortable-ghost {
        opacity: 0.4;
        background: #c8ebfb;
    }
</style>
<%
// Get search parameters from request
String building_id = request.getParameter("building_id");
String statusFilter = request.getParameter("statusFilter");
String roomType = request.getParameter("room_type");
String minCapacity = request.getParameter("min_capacity");
String maxCapacity = request.getParameter("max_capacity");
String [] amenities = request.getParameterValues("amenities");

String searchString = "&action=search&building_id=" + (building_id != null ? building_id : "") + "&room_type=" + (roomType != null ? roomType : "") + "&min_capacity=" + 
        (minCapacity != null ? minCapacity : "") + "&max_capacity=" + (maxCapacity != null ? maxCapacity : "");
// Convert filters to appropriate types
Integer buildingId = null;
Boolean isActive = null;

try {
    if (building_id != null && !building_id.isEmpty()) {
        buildingId = Integer.parseInt(building_id);
    }
    if (statusFilter != null && !statusFilter.isEmpty()) {
        isActive = Boolean.parseBoolean(statusFilter);
    }
} catch (NumberFormatException e) {
    // Handle invalid parameters if needed
}

// Get filtered rooms
RoomDAO roomDAO = new RoomDAO();
List<Room> rooms = new ArrayList<Room>();


// Get buildings for filter dropdown
BuildingDAO buildingDAO = new BuildingDAO();
List<Building> buildings = buildingDAO.getAllBuildings();
String action = request.getParameter("action");
if (action != null && action.equals("search")) {
    rooms = roomDAO.searchRooms(building_id, roomType, minCapacity, maxCapacity, amenities);
} else {
    rooms = roomDAO.getAllRooms();
}
%>
<div class="flex h-screen">
    <!-- Admin Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="rooms" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
    <!-- Top Navigation -->
    <jsp:include page="../../components/top-navigation.jsp" />

    <!-- Main Content Area -->
    <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
        <!-- Success/Error Messages -->
        <jsp:include page="../../components/messages.jsp" />

        <!-- Room Form (for create/edit) -->
        <% if ("create".equals(action) || "edit".equals(action)) { 
            Room room = new Room();
            if ("edit".equals(action)) {
                int roomId = Integer.parseInt(request.getParameter("id"));
                room = roomDAO.getRoomById(roomId);
            }
        %>
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800">
                <%= "create".equals(action) ? "Add New Room" : "Edit Room" %>
            </h1>
            <a href="room_management.jsp" class="px-4 py-2 bg-gray-300 text-gray-700 rounded-md hover:bg-gray-400">
                <i class="fas fa-arrow-left mr-2"></i> Back to List
            </a>
        </div>

        <div class="bg-white rounded-lg shadow-md p-6">
            <form action="RoomController" method="POST" enctype="multipart/form-data">  
                <input type="hidden" name="action" value="<%= action %>">
                <% if ("edit".equals(action)) { %>
                <input type="hidden" name="roomId" value="<%= room.getId() %>">
                <% } %>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Basic Info -->
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Building</label>
                            <select name="building_id" required 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                <option value="">Select Building</option>
                                <% for (Building building : buildings) { %>
                                <option value="<%= building.getId() %>" 
                                        <%= (room.getBuildingId() != 0 && room.getBuildingId() == building.getId()) ? "selected" : "" %>>
                                    <%= building.getName() %>
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Room Name</label>
                            <input type="text" name="name" required 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md"
                                   value="<%= room.getName() != null ? room.getName() : "" %>">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Room Number</label>
                            <input type="text" name="room_number" required 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md"
                                   value="<%= room.getRoomNumber() != null ? room.getRoomNumber() : "" %>">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Floor</label>
                            <input type="number" name="floor" required min="1" max="<%= ("edit".equals(action)) ? room.getBuilding().getFloorCount() : "" %>"  
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md"
                                   value="<%= room.getFloor() != 0 ? room.getFloor() : "" %>">
                        </div>
                    </div>

                    <!-- Room Details -->
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Capacity</label>
                            <input type="number" name="capacity" required min="1" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md"
                                   value="<%= room.getCapacity() != 0 ? room.getCapacity() : "" %>">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Room Type</label>
                            <select name="room_type" required 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                <option value="">Select Type</option>
                                <option value="conference" <%= room.getRoomType() != null && room.getRoomType().equals("conference") ? "selected" : "" %>>
                                    Conference Room
                                </option>
                                <option value="lecture" <%= room.getRoomType() != null && room.getRoomType().equals("lecture") ? "selected" : "" %>>
                                    Lecture Hall
                                </option>
                                <option value="seminar" <%= room.getRoomType() != null && room.getRoomType().equals("seminar") ? "selected" : "" %>>
                                    Seminar Room
                                </option>
                                <option value="lab" <%= room.getRoomType() != null && room.getRoomType().equals("lab") ? "selected" : "" %>>
                                    Lab
                                </option>
                                <option value="other" <%= room.getRoomType() != null && room.getRoomType().equals("other") ? "selected" : "" %>>
                                    Other
                                </option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea name="description" rows="3"
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md"><%= room.getDescription() != null ? room.getDescription() : "" %></textarea>
                        </div>

                        <div class="flex items-center">
                            <input type="checkbox" name="is_active" id="is_active" 
                                   class="h-4 w-4 text-blue-600 rounded" 
                                   <%= action.equals("create") || room.isActive() ? "checked" : "" %>>
                            <label for="is_active" class="ml-2 text-sm text-gray-700">Active</label>
                        </div>
                    </div>
                </div>

                <!-- Image Upload Section -->
                <div class="mt-6 pt-6 border-t border-gray-200">
                    <h3 class="text-lg font-medium text-gray-800 mb-4">Room Images</h3>

                    <% if ("edit".equals(action)) { %>
                    <div class="mb-6">
                        <h4 class="text-md font-medium text-gray-700 mb-2">Existing Images</h4>
                        <div id="imageGallery" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
                            <% for (RoomImage image : room.getImages()) { %>
                            <div class="relative group border rounded-md overflow-hidden image-container" data-image-id="<%= image.getImageId() %>">
                                <img src="<%= image.getImageUrl() %>" alt="<%= image.getCaption() %>" 
                                     class="w-full h-32 object-cover">

                                <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition-all flex items-center justify-center opacity-0 group-hover:opacity-100">
                                    <button type="button" onclick="setPrimaryImage(<%= image.getImageId() %>, <%= room.getId() %>, this)"
                                        class="px-2 py-1 rounded-full <%= image.isPrimary() ? "bg-green-500 text-white" : "bg-white text-gray-700" %> mr-2"
                                        title="<%= image.isPrimary() ? "Primary Image" : "Set as Primary" %>">
                                        <i class="fas fa-star"></i>
                                    </button>
                                    <button type="button" onclick="confirmDeleteImage(<%= image.getImageId() %>, this)"
                                        class="px-2.5 py-1 rounded-full bg-white text-red-600"
                                        title="Delete Image">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>

                                <% if (image.isPrimary()) { %>
                                <div class="absolute top-2 left-2 bg-green-500 text-white text-xs px-2 py-1 rounded">
                                    Primary
                                </div>
                                <% } %>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <div>
                        <h4 class="text-md font-medium text-gray-700 mb-2"><%= "edit".equals(action) ? "Add More Images" : "Upload Images" %></h4>
                        <div class="border-2 border-dashed border-gray-300 rounded-lg p-4">
                            <div class="flex flex-col items-center justify-center">
                                <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                </svg>
                                <p class="mt-2 text-sm text-gray-600">Drag and drop images here, or click to browse</p>
                                <input type="file" name="images" id="images" multiple accept="image/*" 
                                       class="hidden" onchange="previewImages(this)">
                                <label for="images" class="mt-3 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 cursor-pointer">
                                    <i class="fas fa-upload mr-2"></i> Select Images
                                </label>
                            </div>

                            <div id="imagePreviews" class="mt-4 grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4 hidden">
                                <!-- Preview images will be added here by JavaScript -->
                            </div>
                        </div>
                        <p class="mt-1 text-xs text-gray-500">Upload high-quality images of the room (JPEG, PNG, max 5MB each)</p>
                    </div>
                </div>

                <!-- Amenities Section -->
                <div class="mt-6 pt-6 border-t border-gray-200">
                    <h3 class="text-lg font-medium text-gray-800 mb-4">Amenities</h3>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <%
                        List<Amenity> amenitiesList = roomDAO.getAllAmenities();

                        for (Amenity amenity : amenitiesList) {
                        %>
                        <div class="flex items-center">
                            <input type="checkbox" name="amenities" value="<%= amenity.getId() %>" 
                                   id="amenity-<%= amenity.getId() %>" 
                                   class="h-4 w-4 text-blue-600 rounded"
                                   <% if (action.equals("edit")) {
                                       List<Amenity> roomAmenitiesList = room.getAmenities();
                                       for (Amenity roomAmenity : roomAmenitiesList) {%>
                                            <%= roomAmenity.getId() == amenity.getId() ? "checked" : "" %>
                                    <% }
                                   }
                                   %>>
                            <label for="amenity-<%= amenity.getId() %>" class="ml-2 text-sm text-gray-700">
                                <i class="<%= amenity.getIconClass() %> mr-1"></i> <%= amenity.getName() %>
                            </label>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="mt-8">
                    <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                        <i class="fas fa-save mr-2"></i> <%= "create".equals(action) ? "Add Room" : "Update Room" %>
                    </button>
                </div>
            </form>
        </div>


        <% } %>


        <% if (!"create".equals(action) && !"edit".equals(action)) { 

        // Pagination parameters
        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int recordsPerPage = request.getParameter("limit") != null ? Integer.parseInt(request.getParameter("limit")) : 5; // Adjust as needed
        int start = (currentPage - 1) * recordsPerPage;
        int end = Math.min(start + recordsPerPage, rooms.size());
        int totalPages = (int) Math.ceil((double) rooms.size() / recordsPerPage);

        %>
        <!-- Page Header -->
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Rooms Management</h1>
                <p class="text-sm text-gray-600">Manage all rooms within the system </p>
            </div>
            <div class="flex space-x-2">
                <a href="room_management.jsp?action=create" 
                    class="px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                    <i class="fas fa-plus mr-2"></i> Add Room
                </a>
            </div>
        </div>
        <!-- Search and Filter Card -->
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <form action="RoomController" method="GET">
                <input type="hidden" name="action" value="search">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <!-- Building Filter -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Building</label>
                        <select name="building_id" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">All Buildings</option>
                            <% for (Building building : buildings) { %>
                            <option value="<%= building.getId() %>" 
                                    <%= (buildingId != null && buildingId == building.getId()) ? "selected" : "" %>>
                                <%= building.getName() %>
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Room Type Filter -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Room Type</label>
                        <select name="room_type" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">All Types</option>
                            <option value="conference" ${param.room_type == 'conference' ? 'selected' : ''}>Conference Room</option>
                            <option value="lecture" ${param.room_type == 'lecture' ? 'selected' : ''}>Lecture Hall</option>
                            <option value="seminar" ${param.room_type == 'seminar' ? 'selected' : ''}>Seminar Room</option>
                            <option value="lab" ${param.room_type == 'lab' ? 'selected' : ''}>Lab</option>
                            <option value="other" ${param.room_type == 'other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <!-- Capacity Range -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Capacity</label>
                        <div class="flex space-x-2">
                            <input type="number" name="min_capacity" placeholder="Min" 
                                   class="w-1/2 px-3 py-2 border border-gray-300 rounded-md"
                                   value="${param.min_capacity}">
                            <input type="number" name="max_capacity" placeholder="Max" 
                                   class="w-1/2 px-3 py-2 border border-gray-300 rounded-md"
                                   value="${param.max_capacity}">
                        </div>
                    </div>

                    <!-- Search Button -->
                    <div class="flex items-end">
                        <button type="submit" class="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                            <i class="fas fa-search mr-2"></i> Search
                        </button>
                    </div>
                </div>

                <!-- Amenities Filter (Toggleable) -->
                <div class="mt-4">
                    <button type="button" id="amenitiesToggle" class="text-sm text-blue-600 hover:text-blue-800">
                        <i class="fas fa-chevron-down mr-1"></i> Filter by Amenities
                    </button>
                    <% if (roomType != null || buildingId != null || minCapacity != null || maxCapacity != null || amenities != null) { %>
                    <a href="room_management.jsp" class="ml-3 text-sm text-blue-600 hover:text-blue-800">
                        Reset Filters
                    </a>
                    <% } %>
                    <div id="amenitiesFilter" class="hidden mt-4 pt-4 border-t border-gray-200">
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <%
                            for (Amenity amenity : roomDAO.getAllAmenities()) {
                            %>
                                <div class="flex items-center">
                                    <input type="checkbox" name="amenities" value="<%= amenity.getId() %>" 
                                           id="amenity-<%= amenity.getId() %>" class="h-4 w-4 text-blue-600 rounded"
                                           <% if (amenities != null) {
                                            for (String eachAmenity : amenities) {%>
                                            <%= eachAmenity.equals(Integer.toString(amenity.getId())) ? "checked" : "" %>
                                    <% }
                                   }
                                   %>>
                                    <label for="amenity-<%= amenity.getId() %>" class="ml-2 text-sm text-gray-700">
                                        <i class="<%= amenity.getIconClass()%> mr-1"></i> <%= amenity.getName()%>
                                    </label>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- Rooms Table -->
        <div class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Building</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Capacity</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Amenities</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <%
                            for (int i = start; i < end; i++) { 
                            Room room = rooms.get(i);
                            Building building = buildingDAO.getBuildingById(room.getBuildingId());
                        %>
                            <tr class="hover:bg-gray-50">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex items-center -space-x-4">
                                            <% 
                                            List<RoomImage> roomImages = room.getImages();
                                            int displayedImages = Math.min(2, roomImages.size());
                                            int remainingImages = Math.max(0, roomImages.size() - 2);

                                            if (!roomImages.isEmpty()) {
                                                for (int j = 0; j < displayedImages; j++) { 
                                            %>
                                                <div class="relative flex-shrink-0 h-10 w-10">
                                                    <img src="<%= roomImages.get(j).getImageUrl() %>" 
                                                         alt="Room image <%= j+1 %>" 
                                                         class="w-10 h-10 rounded-full border-2 border-white object-cover shadow-sm hover:z-10 hover:scale-110 transition-all">
                                                </div>
                                            <% }%>

                                            <% if (remainingImages > 0) { %>
                                                <div class="relative">
                                                    <div class="w-10 h-10 rounded-full bg-gray-200 border-2 border-white flex items-center justify-center shadow-sm">
                                                        <span class="text-xs font-medium text-gray-700">+<%= remainingImages %></span>
                                                    </div>
                                                </div>
                                            <% }  }%>
                                        </div>
                                        <div class="ml-4">
                                            <div class="font-medium text-gray-900"><%= room.getName() %></div>
                                            <div class="text-sm text-gray-500"><%= room.getRoomNumber() %> (Floor <%= room.getFloor() %>)</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <%= building.getName() %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <% if (room.getRoomType().equals("conference")) { %>
                                        <span class="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full">Conference</span>
                                    <% } else if (room.getRoomType().equals("lecture")) { %>
                                        <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">Lecture Hall</span>
                                    <% } else if (room.getRoomType().equals("seminar")) { %>
                                        <span class="px-2 py-1 bg-purple-100 text-purple-800 text-xs rounded-full">Seminar</span>
                                    <% } else if (room.getRoomType().equals("lab")) { %>
                                        <span class="px-2 py-1 bg-red-100 text-red-800 text-xs rounded-full">Lab</span>
                                    <% } else { %>
                                        <span class="px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded-full">Other</span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <%= room.getCapacity() %> people
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex gap-1">
                                        <%
                                        List<Amenity> roomAmenities = room.getAmenities();
                                        for (Amenity amenity : roomAmenities) {
                                        %>
                                            <span class="inline-flex items-center px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded" title="<%= amenity.getName() %>">
                                                <i class="<%= amenity.getIconClass() %>"></i> 
                                            </span>
                                        <% } %>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <button type="button" 
                                            onclick="toggleRoomStatus(<%= room.getId() %>, this)"
                                            class="px-2 py-1 text-xs rounded-full <%= room.isActive() ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800" %>">
                                        <%= room.isActive() ? "Active" : "Inactive" %>
                                    </button>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <a href="room_management.jsp?action=edit&id=<%= room.getId() %>" title="Edit" class="text-blue-600 hover:text-blue-900 mr-1">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="RoomController?action=delete&id=<%= room.getId() %>" title="Delete"
                                       class="text-red-600 hover:text-red-900"
                                       onclick="event.preventDefault(); 
                                        Swal.fire({
                                          title: 'Are you sure?',
                                          text: 'You won\'t be able to revert this!',
                                          icon: 'warning',
                                          showCancelButton: true,
                                          confirmButtonColor: '#3085d6',
                                          cancelButtonColor: '#d33',
                                          confirmButtonText: 'Yes, delete it!'
                                        }).then((result) => {
                                          if (result.isConfirmed) {
                                            window.location.href = this.href;
                                          }
                                        });">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>

                            <% } %>
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
                                    <option value="RoomController?page=1&limit=5<%= searchString %>" <%= recordsPerPage == 5 ? "selected" : "" %>>5</option>
                                    <option value="RoomController?page=1&limit=10<%= searchString %>" <%= recordsPerPage == 10 ? "selected" : "" %>>10</option>
                                    <option value="RoomController?page=1&limit=20<%= searchString %>" <%= recordsPerPage == 20 ? "selected" : "" %>>20</option>
                                    <option value="RoomController?page=1&limit=50<%= searchString %>" <%= recordsPerPage == 50 ? "selected" : "" %>>50</option>
                                </select>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                    <i class="fas fa-chevron-down text-xs"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Page navigation -->
                    <nav class="flex items-center space-x-1">
                               
                        <% if (currentPage > 1) { %>
                            <a href="RoomController?page=<%= currentPage - 1 %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                Previous
                            </a>
                        <% } %>        

                         <% for (int i = 1; i <= totalPages; i++) { %>
                            <% if (i == currentPage) {%>
                                <span class="px-3 py-1 border border-blue-500 bg-blue-100 text-blue-600 rounded-md text-sm font-medium">
                                    <%= i %>
                                </span>
                            <% } else if (i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)) {%>
                                <a href="RoomController?page=<%= i %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                    <%= i %>
                                </a>
                            <% } else if (i == 4 && currentPage > 4) {%>
                                <span class="px-3 py-1 text-gray-500">...</span>
                            <% } else if (i == totalPages - 2 && currentPage < totalPages - 3) {%>
                                <span class="px-3 py-1 border border-blue-500 bg-blue-100 text-blue-600 rounded-md text-sm font-medium">
                                    <span class="px-3 py-1 text-gray-500">...</span>
                                </span>
                            <% } %>

                        <% } %>

                        <% if (currentPage < totalPages) { %>
                            <a href="RoomController?page=<%= currentPage + 1 %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                Next
                            </a>
                        <% } %>
                    </nav>
                </div>

                <!-- Info text -->
                <div class="mt-4 text-center text-sm text-gray-500">
                    Showing page <%= currentPage %> of <%= totalPages %> (<%= recordsPerPage %> items per page)
                </div>
            </div>      
        </div>
        <% } %>

        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/room-management.js"></script>
    
<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="rooms" />
</jsp:include>