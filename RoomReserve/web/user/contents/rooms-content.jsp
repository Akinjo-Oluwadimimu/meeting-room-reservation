<%@page import="com.roomreserve.dao.FavoriteRoomDAO"%>
<%@page import="com.roomreserve.model.User"%>
<%@page import="com.roomreserve.dao.BuildingDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.roomreserve.model.Building"%>
<%@page import="com.roomreserve.model.Amenity"%>
<%@page import="com.roomreserve.model.Room"%>
<%@page import="java.util.List"%>
<%@page import="com.roomreserve.dao.RoomDAO"%>
<%
    
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get search parameters from request
    String building_id = request.getParameter("building_id");
    String roomType = request.getParameter("room_type");
    String minCapacity = request.getParameter("min_capacity");
    String maxCapacity = request.getParameter("max_capacity");
    String [] amenities = request.getParameterValues("amenities");

    // Convert filters to appropriate types
    Integer buildingId = null;

    try {
        if (building_id != null && !building_id.isEmpty()) {
            buildingId = Integer.parseInt(building_id);
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
    FavoriteRoomDAO favoriteRoomDAO = new FavoriteRoomDAO();
    String action = request.getParameter("action");
    if (action != null && action.equals("search")) {
        rooms = roomDAO.searchAvailableRooms(building_id, roomType, minCapacity, maxCapacity, amenities);
    } else {
        rooms = roomDAO.getAllAvailableRooms();
    }
%>
<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/user-sidebar.jsp">
        <jsp:param name="page" value="rooms" />
    </jsp:include>
    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />

        <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <jsp:include page="../../components/messages.jsp" />
            <% 
            // Pagination parameters
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int recordsPerPage = 6; // Adjust as needed
            int start = (currentPage - 1) * recordsPerPage;
            int end = Math.min(start + recordsPerPage, rooms.size());
            int totalPages = (int) Math.ceil((double) rooms.size() / recordsPerPage);

            %>
            <!-- Search and Filter Card -->
            <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                <form action="rooms.jsp" method="GET">
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
                        <a href="rooms.jsp" class="ml-3 text-sm text-blue-600 hover:text-blue-800">
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

            <!-- Rooms Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                <%
                for (int i = start; i < end; i++) { 
                    Room room = rooms.get(i);            
                %>

                <!-- Room Card 1 -->
                <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition flex flex-col h-full">
                    <div class="relative">
                        <img src="<%= room.getCoverImageId() <= 0 ? "../images/no-cover.png" : room.getCoverImage().getImageUrl() %>"
                             alt="<%= room.getName() %>" 
                             class="w-full h-48 object-cover">
                        <div class="absolute top-2 right-2">
                            <button class="rooms-favorite-btn bg-white rounded-full shadow-md w-8 h-8 flex items-center justify-center transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-red-300"
                                    data-room-id="<%= room.getId() %>"
                                    data-action="<%= favoriteRoomDAO.getFavoriteStatus(user.getUserId(), room.getId()) ? "remove" : "add" %>"
                                    aria-label="<%= favoriteRoomDAO.getFavoriteStatus(user.getUserId(), room.getId()) ? "Remove from favorites" : "Add to favorites" %>">
                                <i class="fas fa-heart <%= favoriteRoomDAO.getFavoriteStatus(user.getUserId(), room.getId()) ? "text-red-500 hover:text-red-600" : "text-gray-400 hover:text-red-500" %> transition-colors duration-200"></i>
                            </button>
                        </div>    
                    </div>
                    <div class="p-6 flex flex-col flex-grow">
                        <div class="flex justify-between items-start mb-2">
                            <h4 class="text-xl font-bold text-gray-800"><%= room.getName() %></h4>
                            <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded"><%= room.getBuilding().getName() %></span>
                        </div>
                        <p class="text-gray-600 mb-4 line-clamp-3"><%= room.getDescription()%></p>

                        <div class="flex flex-wrap gap-2 mb-4">
                            <span class="bg-gray-100 text-gray-800 text-xs px-2 py-1 rounded flex items-center">
                                <i class="fas fa-users mr-1 text-xs"></i> <%= room.getCapacity()%> people
                            </span>
                            <% for (Amenity amenity : room.getAmenities()) { %>
                            <span class="bg-gray-100 text-gray-800 text-xs px-2 py-1 rounded flex items-center">
                                <i class="<%= amenity.getIconClass() %> mr-1 text-xs"></i> <%= amenity.getName() %>
                            </span>
                            <% } %>
                        </div>

                        <div class="mt-auto flex justify-between items-center mt-2">
                            <form action="rooms/<%= room.getName().replaceAll("\\s+", "-").replaceAll("[^\\w-]", "") %>" method="GET">
                                <input type="hidden" name="roomId" value="<%= room.getId() %>">
                                <button type="submit" class="text-blue-600 hover:text-blue-800 font-medium text-sm">View Details</button>
                            </form>

                            <a href="reserve/<%= room.getName().replaceAll("\\s+", "-").replaceAll("[^\\w-]", "") %>?roomId=<%= room.getId() %>" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm font-medium transition">
                                Reserve
                            </a>
                        </div>
                    </div>
                </div>

                <% } %>


            </div>

            <!-- Pagination -->
            <div class="flex flex-col sm:flex-row justify-between items-center mt-8">
                <div class="mb-4 sm:mb-0">
                    <p class="text-sm text-gray-700">
                        Showing <span class="font-medium"><%= start + 1 %></span> to <span class="font-medium"><%= end %></span> of <span class="font-medium"><%= rooms.size() %></span> rooms
                    </p>
                </div>
                <div class="flex space-x-2">
                    <% if (currentPage > 1) { %>
                        <a href="rooms.jsp?page=<%= currentPage - 1 %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                            Previous
                        </a>
                    <% } %>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="rooms.jsp?page=<%= i %>" class="px-3 py-1 border rounded-md text-sm font-medium <%= currentPage == i ? "border-blue-500 text-white bg-blue-600" : "border-gray-300 text-gray-700 bg-white hover:bg-gray-50"%>">
                            <%= i %>
                        </a>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                        <a href="rooms.jsp?page=<%= currentPage + 1 %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                            Next
                        </a>
                    <% } %>
                </div>
            </div>

        </main>
    </div>
</div>

<script>
   // Toggle amenities filter
    document.getElementById('amenitiesToggle').addEventListener('click', function() {
        const filter = document.getElementById('amenitiesFilter');
        const icon = this.querySelector('i');

        filter.classList.toggle('hidden');
        icon.classList.toggle('fa-chevron-down');
        icon.classList.toggle('fa-chevron-up');
    });
</script>
<script src="${pageContext.request.contextPath}/js/favorites.js"></script>
<jsp:include page="../../components/user-mobile-menu.jsp" >
    <jsp:param name="page" value="rooms" />
</jsp:include>