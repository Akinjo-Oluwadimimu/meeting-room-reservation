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

DepartmentDAO departmentDAO = new DepartmentDAO();
List<Department> departments = new ArrayList<Department>();
String action = request.getParameter("action");

if (action != null && action.equals("search")) {
    departments = departmentDAO.searchDepartments(searchQuery);
} else {
    departments = departmentDAO.getAllDepartments();
}

%>
<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="departments" />
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
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Department Management</h1>
                </div>
                <div class="flex space-x-2">
                    <a href="department_management.jsp?action=create" 
                        class="px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                        <i class="fas fa-plus mr-2"></i> Add Department
                    </a>
                </div>
            </div>
            
            <!-- Success/Error Messages -->
            <jsp:include page="../../components/messages.jsp" />
            

            <!-- Department Form (for create/edit) -->
            <% if ("create".equals(action) || "edit".equals(action)) { 
                Department department = new Department();
                if ("edit".equals(action)) {
                    int departmentId = Integer.parseInt(request.getParameter("id"));
                    department = departmentDAO.getDepartmentById(departmentId);
                }
            %>
            <div class="bg-white shadow-md rounded-lg p-6 mb-6">
                <h3 class="text-lg font-medium text-gray-800 mb-4">
                    <%= "create".equals(action) ? "Create New Department" : "Edit Department" %>
                </h3>

                <form action="DepartmentController" method="post">
                    <input type="hidden" name="action" value="<%= action %>">
                    <% if ("edit".equals(action)) { %>
                    <input type="hidden" name="departmentId" value="<%= department.getId() %>">
                    <% } %>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label for="code" class="block text-sm font-medium text-gray-700 mb-1">Department Code*</label>
                            <input type="text" id="code" name="code" value="<%= department.getCode() != null ? department.getCode() : "" %>" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                        </div>

                        <div>
                            <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Department Name*</label>
                            <input type="text" id="name" name="name" value="<%= department.getName() != null ? department.getName() : "" %>" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                        </div>

                        <div class="md:col-span-2">
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea id="description" name="description" rows="3"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"><%= department.getDescription() != null ? department.getDescription() : "" %></textarea>
                        </div>
                    </div>

                    <div class="flex justify-end">
                        <a href="department_management.jsp" class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 mr-3">
                            Cancel
                        </a>
                        <button type="submit" class="px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                            <%= "create".equals(action) ? "Create Department" : "Update Department" %>
                        </button>
                    </div>
                </form>
            </div>
            <% } %>

            <!-- Department Members Management -->
            <% if ("manageMembers".equals(action)) { 
                int departmentId = Integer.parseInt(request.getParameter("id"));
                Department department = departmentDAO.getDepartmentById(departmentId);
                List<DepartmentMember> members = departmentDAO.getDepartmentMembers(departmentId);
                UserDAO userDAO = new UserDAO();
                List<User> allUsers = userDAO.getAllUsers();
            %>
            <div class="bg-white shadow-md rounded-lg p-6 mb-6">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-md sm:text-lg font-medium text-gray-800">
                        Members of <%= department.getName() %>
                    </h3>
                    <a href="department_management.jsp" class="text-blue-600 hover:text-blue-800">
                        <i class="fas fa-arrow-left mr-1"></i> Back to Departments
                    </a>
                </div>

                <!-- Add Member Form -->
                <div class="mb-8 p-4 bg-gray-50 rounded-lg">
                    <h4 class="text-md font-medium text-gray-800 mb-3">Add New Member</h4>
                    <form action="DepartmentController" method="post">
                        <input type="hidden" name="action" value="addMember">
                        <input type="hidden" name="departmentId" value="<%= departmentId %>">

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div>
                                <label for="userId" class="block text-sm font-medium text-gray-700 mb-1">Select User*</label>
                                <select id="userId" name="userId" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500" required>
                                    <option value="">Select a user</option>
                                    <% for (User u : allUsers) { %>
                                    <option value="<%= u.getUserId() %>"><%= u.getFirstName() %> <%= u.getLastName() %> (<%= u.getEmail() %>)</option>
                                    <% } %>
                                </select>
                            </div>

                            <div class="flex items-end">
                                <div class="flex items-center h-5">
                                    <input id="isHead" name="isHead" type="checkbox" 
                                           class="focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300 rounded">
                                </div>
                                <div class="ml-3 text-sm">
                                    <label for="isHead" class="font-medium text-gray-700">Department Head</label>
                                </div>
                            </div>

                            <div class="flex items-end">
                                <button type="submit" class="w-full px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                                    Add Member
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Members List -->
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <% for (DepartmentMember member : members) { %>
                            <tr>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <%= member.getUserName() %>
                                    <% if (member.getIsHead()) { %>
                                    <span class="ml-2 text-xs text-purple-600">(Head)</span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= member.getUserEmail() %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <% if (member.getIsHead()) { %>
                                    <span class="px-2 py-1 bg-purple-100 text-purple-800 text-xs rounded">Department Head</span>
                                    <% } else { %>
                                    <span class="px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded">Member</span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <div class="flex items-center space-x-2">
                                        <% if (!member.getIsHead()) { %>
                                        <form action="DepartmentController" method="POST" class="inline">
                                            <input type="hidden" name="action" value="setHead">
                                            <input type="hidden" name="departmentId" value="<%= departmentId %>">
                                            <input type="hidden" name="userId" value="<%= member.getUserId() %>">
                                            <button class="text-green-600 hover:text-green-900" title="Set as Head">
                                                <i class="fas fa-user-tie"></i>
                                            </button>
                                        </form>
                                        <% } %>
                                        <a href="DepartmentController?action=removeMember&departmentId=<%= departmentId %>&userId=<%= member.getUserId() %>" 
                                           class="text-red-600 hover:text-red-900" title="Remove"
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
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } %>

            <!-- Departments List (Default View) -->
            <% if (!"create".equals(action) && !"edit".equals(action) && !"manageMembers".equals(action)) { 
                // Pagination parameters
                int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int recordsPerPage = request.getParameter("limit") != null ? Integer.parseInt(request.getParameter("limit")) : 10; // You can adjust this number
                int start = (currentPage - 1) * recordsPerPage;
                int end = Math.min(start + recordsPerPage, departments.size());
                int totalPages = (int) Math.ceil((double) departments.size() / recordsPerPage);
            %>
            <div class="bg-white shadow rounded-lg overflow-hidden">
                <div class="p-4 border-b border-gray-200">
                    <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                        <h2 class="text-lg font-medium text-gray-800">All Departments</h2>
                        <form id="searchForm" method="GET" action="department_management.jsp" class="relative w-full md:w-auto">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="searchQuery" value="<%= searchQuery != null ? searchQuery : "" %>" 
                                   placeholder="Search departments..." 
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
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Head</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Created</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <% for (int i = start; i < end; i++) { 
                                Department dept = departments.get(i);
                                UserDAO userDAO = new UserDAO();
                                User head = dept.getHeadId()> 0 ? userDAO.findById(dept.getHeadId()) : null;
                            %>
                            <tr>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium"><%= dept.getCode() %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%= dept.getName() %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <% if (head != null) { %>
                                    <%= head.getFirstName()%> <%= head.getLastName()%>
                                    <% } else { %>
                                    <span class="text-gray-400">Not assigned</span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <%= dept.getCreatedAt().toString().split(" ")[0] %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <a href="department_management.jsp?action=edit&id=<%= dept.getId() %>" 
                                       class="text-blue-600 hover:text-blue-900 mr-1" title="Edit"><i class="fas fa-edit"></i></a>
                                    <a href="department_management.jsp?action=manageMembers&id=<%= dept.getId() %>" 
                                       class="text-green-600 hover:text-green-900 mr-1" title="Members"><i class="fas fa-users"></i></a>
                                    <a href="DepartmentController?action=delete&id=<%= dept.getId() %>" 
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
                                        <option value="department_management.jsp?page=1&limit=5<%= searchString %>" <%= recordsPerPage == 5 ? "selected" : "" %>>5</option>
                                        <option value="department_management.jsp?page=1&limit=10<%= searchString %>" <%= recordsPerPage == 10 ? "selected" : "" %>>10</option>
                                        <option value="department_management.jsp?page=1&limit=20<%= searchString %>" <%= recordsPerPage == 20 ? "selected" : "" %>>20</option>
                                        <option value="department_management.jsp?page=1&limit=50<%= searchString %>" <%= recordsPerPage == 50 ? "selected" : "" %>>50</option>
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
                                <a href="department_management.jsp?page=<%= currentPage - 1 %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                    Previous
                                </a>
                            <% } %>        

                             <% for (int i = 1; i <= totalPages; i++) { %>
                                <% if (i == currentPage) {%>
                                    <span class="px-3 py-1 border border-blue-500 bg-blue-100 text-blue-600 rounded-md text-sm font-medium">
                                        <%= i %>
                                    </span>
                                <% } else if (i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)) {%>
                                    <a href="department_management.jsp?page=<%= i %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
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
                                <a href="department_management.jsp?page=<%= currentPage + 1 %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
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
    <jsp:param name="page" value="departments" />
</jsp:include>