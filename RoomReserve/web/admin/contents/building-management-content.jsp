<%@page import="com.roomreserve.model.Building"%>
<%@page import="com.roomreserve.dao.BuildingDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.roomreserve.model.DepartmentMember"%>
<%@page import="java.util.List"%>
<%@page import="com.roomreserve.model.Department"%>
<%@page import="com.roomreserve.model.User"%>
<%@page import="com.roomreserve.dao.DepartmentDAO"%>
<%@page import="com.roomreserve.dao.UserDAO"%>
<%
// Authentication check
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("admin")) {
    response.sendRedirect("login.jsp");
    return;
}
// Get search parameters from request
String searchQuery = request.getParameter("searchQuery");

String searchString = "&action=search&searchQuery=" + (searchQuery != null ? searchQuery : "");

BuildingDAO buildingDAO = new BuildingDAO();
List<Building> buildings = new ArrayList<Building>();
String action = request.getParameter("action");

if (action != null && action.equals("search")) {
    buildings = buildingDAO.searchBuildings(searchQuery);
} else {
    buildings = buildingDAO.getAllBuildings();
}

%>
<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="buildings" />
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
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Building Management</h1>
                </div>
                <div class="flex space-x-2">
                    <a href="building_management.jsp?action=create" 
                        class="px-2 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                        <i class="fas fa-plus mr-2"></i> Add Building
                    </a>
                </div>
            </div>
            
            <!-- Success/Error Messages -->
            <jsp:include page="../../components/messages.jsp" />
            

            <!-- Department Form (for create/edit) -->
            <% if ("create".equals(action) || "edit".equals(action)) { 
                Building building = new Building();
                if ("edit".equals(action)) {
                    int buildingId = Integer.parseInt(request.getParameter("id"));
                    building = buildingDAO.getBuildingById(buildingId);
                }
            %>
            <div class="bg-white shadow-md rounded-lg p-6 mb-6">
                <h3 class="text-lg font-medium text-gray-800 mb-4">
                    <%= "create".equals(action) ? "Create New Building" : "Edit Building" %>
                </h3>

                <form action="BuildingController" method="post">
                    <input type="hidden" name="action" value="<%= action %>">
                    <% if ("edit".equals(action)) { %>
                    <input type="hidden" name="buildingId" value="<%= building.getId() %>">
                    <% } %>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label for="code" class="block text-sm font-medium text-gray-700 mb-1">Building Code*</label>
                            <input type="text" id="code" name="code" value="<%= building.getCode() != null ? building.getCode() : "" %>" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                        </div>

                        <div>
                            <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Building Name*</label>
                            <input type="text" id="name" name="name" value="<%= building.getName() != null ? building.getName() : "" %>" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                        </div>

                        <div>
                            <label for="location" class="block text-sm font-medium text-gray-700 mb-1">Location*</label>
                            <input type="text" id="location" name="location" value="<%= building.getLocation()!= null ? building.getLocation() : "" %>" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                        </div>

                        <div>
                            <label for="floor" class="block text-sm font-medium text-gray-700 mb-1">Floor Count*</label>
                            <input type="number" id="floor" name="floor" value="<%= building.getFloorCount() != 0 ? building.getFloorCount() : "" %>" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                        </div>
                    </div>

                    <div class="flex justify-end">
                        <a href="building_management.jsp" class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 mr-3">
                            Cancel
                        </a>
                        <button type="submit" class="px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                            <%= "create".equals(action) ? "Create Building" : "Update Building" %>
                        </button>
                    </div>
                </form>
            </div>
            <% } %>

            <!-- Buildings List (Default View) -->
            <% if (!"create".equals(action) && !"edit".equals(action)) { 
                // Pagination parameters
                int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int recordsPerPage = request.getParameter("limit") != null ? Integer.parseInt(request.getParameter("limit")) : 10; // You can adjust this number
                int start = (currentPage - 1) * recordsPerPage;
                int end = Math.min(start + recordsPerPage, buildings.size());
                int totalPages = (int) Math.ceil((double) buildings.size() / recordsPerPage);
            %>
            <div class="bg-white shadow rounded-lg overflow-hidden">
                <div class="p-4 border-b border-gray-200">
                    <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                        <h2 class="text-lg font-medium text-gray-800">All Buildings</h2>

                        <!-- Search form - full width on mobile, auto width on desktop -->
                        <form id="searchForm" method="GET" action="building_management.jsp" class="relative w-full md:w-auto">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="searchQuery" value="<%= searchQuery != null ? searchQuery : "" %>" 
                                   placeholder="Search buildings..." 
                                   class="pl-10 pr-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 w-full md:w-64">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </form>
                    </div>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200 border-b border-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Code</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Location</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Floor Count</th>                                
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Created</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <% for (int i = start; i < end; i++) { 
                                Building building = buildings.get(i);
                            %>
                            <tr>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium"><%= building.getCode() %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%= building.getName() %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%= building.getLocation()%></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%= building.getFloorCount()%> Floors</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <%= building.getCreatedAt().toString().split(" ")[0] %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <a href="building_management.jsp?action=edit&id=<%= building.getId() %>" 
                                       class="text-blue-600 hover:text-blue-900 mr-1" title="Edit"><i class="fas fa-edit"></i></a>
                                    <a href="BuildingController?action=delete&id=<%= building.getId() %>" 
                                       class="text-red-600 hover:text-red-900" title="Delete"
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
                    <div class="flex flex-col sm:flex-row justify-between items-center">
                        <!-- Items per page selector -->
                        <div class="relative mb-4 sm:mb-0">
                            <div class="flex items-center">
                                <span class="mr-2 text-sm text-gray-700">Items per page:</span>
                                <div class="relative">
                                    <select onchange="location = this.value;" 
                                            class="appearance-none bg-white border border-gray-300 text-gray-700 py-1 px-3 pr-8 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm">
                                        <option value="building_management.jsp?page=1&limit=5<%= searchString %>" <%= recordsPerPage == 5 ? "selected" : "" %>>5</option>
                                        <option value="building_management.jsp?page=1&limit=10<%= searchString %>" <%= recordsPerPage == 10 ? "selected" : "" %>>10</option>
                                        <option value="building_management.jsp?page=1&limit=20<%= searchString %>" <%= recordsPerPage == 20 ? "selected" : "" %>>20</option>
                                        <option value="building_management.jsp?page=1&limit=50<%= searchString %>" <%= recordsPerPage == 50 ? "selected" : "" %>>50</option>
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
                                <a href="building_management.jsp?page=<%= currentPage - 1 %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                    Previous
                                </a>
                            <% } %>        

                             <% for (int i = 1; i <= totalPages; i++) { %>
                                <% if (i == currentPage) {%>
                                    <span class="px-3 py-1 border border-blue-500 bg-blue-100 text-blue-600 rounded-md text-sm font-medium">
                                        <%= i %>
                                    </span>
                                <% } else if (i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)) {%>
                                    <a href="building_management.jsp?page=<%= i %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
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
                                <a href="building_management.jsp?page=<%= currentPage + 1 %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
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

<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="buildings" />
</jsp:include>