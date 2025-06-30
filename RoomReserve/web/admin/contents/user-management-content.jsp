<%@page import="java.util.ArrayList"%>
<%@page import="com.roomreserve.util.EmailUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.roomreserve.util.AuthUtil"%>
<%@page import="com.roomreserve.model.User"%>
<%@page import="com.roomreserve.dao.UserDAO"%>

<%
// Check admin authentication
if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("admin")) {
    response.sendRedirect("login.jsp");
    return;
}

// Get search parameters from request
String searchQuery = request.getParameter("searchQuery");
String role = request.getParameter("roleFilter");
String statusFilter = request.getParameter("statusFilter");

// Convert filters to appropriate types
Integer buildingId = null;
Boolean isActive = null;

try {if (statusFilter != null && !statusFilter.isEmpty()) {
        isActive = Boolean.parseBoolean(statusFilter);
    }
} catch (NumberFormatException e) {
    // Handle invalid parameters if needed
}

UserDAO userDAO = new UserDAO();
List<User> users = new ArrayList<User>();
String action = request.getParameter("action");

if (action != null && action.equals("search")) {
    users = userDAO.searchUsers(searchQuery, role, isActive);
} else {
    users = userDAO.getAllUsers();
}

String searchString = "&action=search&searchQuery=" + (searchQuery != null ? searchQuery : "") + "&roleFilter=" + (role != null ? role : "") + "&statusFilter=" + (isActive != null ? isActive : "");
// Handle user actions
if (("POST".equals(request.getMethod()) && request.getParameter("userId") != null)) {
    action = request.getParameter("action");
    int userId = Integer.parseInt(request.getParameter("userId"));
    
    if ("toggleStatus".equals(action)) {
        userDAO.toggleUserStatus(userId);
        session.setAttribute("success", "User status updated successfully");
    } else if ("changeRole".equals(action)) {
        String newRole = request.getParameter("newRole");
        userDAO.updateUserRole(userId, newRole);
        session.setAttribute("success", "User role updated successfully");
    } else if ("resetPassword".equals(action)) {
        String tempPassword = AuthUtil.generateTempPassword();
        String hashedPassword = AuthUtil.hashPassword(tempPassword);
        userDAO.updatePassword(userId, hashedPassword);
        User user = userDAO.findById(userId);
        EmailUtil.sendTempPasswordEmail(user.getEmail(), tempPassword);
        session.setAttribute("tempPassword", tempPassword);
        session.setAttribute("success", "Temporary Password: " + tempPassword);
    }
    // Refresh user list
    users = userDAO.getAllUsers();
}
%>
<div class="flex h-screen">
    <!-- Admin Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="users" />
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
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">User Management</h1>
                    <p class="text-sm text-gray-600">Manage all system users and their permissions</p>
                </div>
                <div class="flex space-x-2">
                    <a href="user_management.jsp?action=create" 
                        class="px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                        <i class="fas fa-plus mr-2"></i> Add User
                    </a>
                </div>
            </div>
            
            <!-- Success/Error Messages -->
            <jsp:include page="../../components/messages.jsp" />
            
            <!-- User Form (for create/edit) -->
            <% if ("create".equals(action) || "edit".equals(action)) { 
                User user = new User();
                if ("edit".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    user = userDAO.findById(id);
                }
            %>
            <div class="bg-white shadow-md rounded-lg p-6 mb-6">
                <h3 class="text-lg font-medium text-gray-800 mb-4">
                    <%= "create".equals(action) ? "Create New User" : "Edit User" %>
                </h3>

                <form action="UserController" method="post">
                    <input type="hidden" name="action" value="<%= action %>">
                    <% if ("edit".equals(action)) { %>
                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                    <% } %>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        
                        <div class="mb-3">
                            <label for="first-name" class="block text-sm font-medium text-gray-700 mb-1">First Name*</label>
                            <input type="text" id="first-name" name="first-name" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   value="<%= user.getFirstName() != null ? user.getFirstName() : "" %>" required>
                        </div>

                        <div class="mb-3">
                            <label for="last-name" class="block text-sm font-medium text-gray-700 mb-1">Last Name*</label>
                            <input type="text" id="last-name" name="last-name" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   value="<%= user.getLastName() != null ? user.getLastName() : "" %>" required>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email Address*</label>
                            <input type="email" id="email" name="email" 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                    value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
                       </div>

                        <div class="mb-3">
                            <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">Phone*</label>
                            <input type="tel" id="phone" name="phone" 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                    value="<%= user.getPhone() != null ? user.getPhone() : "" %>" required>
                        </div>
                            
                        <div class="mb-3">
                            <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username*</label>
                            <input type="text" id="username" name="username" 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                    value="<%= user.getUsername() != null ? user.getUsername(): "" %>" required <%= action.equals("edit") ? "disabled" : "" %>>
                        </div>

                        <div class="mb-4">
                            <label for="role" class="block text-sm font-medium text-gray-700 mb-1">Role*</label>
                            <select id="role" name="role" 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" required>
                                <option value=""></option>
                                <option value="faculty" <% if (user.getRole() != null && user.getRole().equals("faculty")) { %> selected <% } %>>Faculty</option>
                                <option value="staff" <% if (user.getRole() != null && user.getRole().equals("staff")) { %> selected <% } %>>Staff</option>
                                <option value="student" <% if (user.getRole() != null && user.getRole().equals("student")) { %> selected <% } %>>Graduate Student</option>
                                <option value="manager" <% if (user.getRole() != null && user.getRole().equals("manager")) { %> selected <% } %>>Manager</option>
                            </select>
                        </div>
                    </div>

                    <div class="flex justify-end">
                        <a href="user_management.jsp" class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 mr-3">
                            Cancel
                        </a>
                        <button type="submit" class="px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                            <%= "create".equals(action) ? "Create User" : "Update User" %>
                        </button>
                    </div>
                </form>
            </div>
            <% } %>

            <!-- Users Table -->
            <div class="bg-white shadow rounded-lg overflow-hidden">
            <% 
            if (!"create".equals(action) && !"edit".equals(action)) { 
            // Pagination parameters
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int recordsPerPage = request.getParameter("limit") != null ? Integer.parseInt(request.getParameter("limit")) : 10; // Adjust as needed
            int start = (currentPage - 1) * recordsPerPage;
            int end = Math.min(start + recordsPerPage, users.size());
            int totalPages = (int) Math.ceil((double) users.size() / recordsPerPage);
            %>
            <div class="p-4 border-b border-gray-200">
                <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4">
                    <h2 class="text-lg font-medium text-gray-800">All Users</h2>

                    <!-- Search and filter controls -->
                    <div class="w-full lg:w-auto flex flex-col lg:flex-row items-stretch lg:items-center gap-4">
                        <!-- Search form - full width on mobile, fixed width on desktop -->
                        <form id="searchForm" method="GET" action="user_management.jsp" class="relative w-full lg:w-64">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="searchQuery" value="<%= searchQuery != null ? searchQuery : "" %>" 
                                   placeholder="Search users..." 
                                   class="pl-10 pr-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 w-full">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </form>

                        <!-- Filter controls - horizontal on desktop, vertical on mobile -->
                        <div class="flex flex-col md:flex-row gap-2 w-full lg:w-auto">
                            <!-- Role Filter Dropdown -->
                            <div class="relative flex-1 min-w-[150px]">
                                <select name="roleFilter" onchange="this.form.submit()" form="searchForm" 
                                        class="appearance-none pl-3 pr-8 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 w-full">
                                    <option value="">All Roles</option>
                                    <option value="admin" <%= (role != null && role.equals("admin")) ? "selected" : "" %>>Admin</option>
                                    <option value="manager" <%= (role != null && role.equals("manager")) ? "selected" : "" %>>Manager</option>
                                    <option value="student" <%= (role != null && role.equals("student")) ? "selected" : "" %>>Student</option>
                                    <option value="faculty" <%= (role != null && role.equals("faculty")) ? "selected" : "" %>>Faculty</option>
                                </select>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                            </div>

                            <!-- Status Filter Dropdown -->
                            <div class="relative flex-1 min-w-[150px]">
                                <select name="statusFilter" onchange="this.form.submit()" form="searchForm" 
                                        class="appearance-none pl-3 pr-8 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 w-full">
                                    <option value="">All Statuses</option>
                                    <option value="true" <%= (isActive != null && isActive) ? "selected" : "" %>>Active</option>
                                    <option value="false" <%= (isActive != null && !isActive) ? "selected" : "" %>>Inactive</option>
                                </select>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                            </div>

                            <!-- Clear Filters Button -->
                            <% if (searchQuery != null || buildingId != null || isActive != null) { %>
                            <a href="user_management.jsp" class="px-3 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 flex items-center justify-center whitespace-nowrap">
                                <i class="fas fa-times mr-1"></i> Clear
                            </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Last Login</th>
                            <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <% for (int i = start; i < end; i++) { 
                            User user = users.get(i);
                        %>
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 h-10 w-10">
                                        <img class="h-10 w-10 rounded-full" src="https://ui-avatars.com/api/?name=<%= user.getFirstName() + "+" + user.getLastName() %>" alt="">
                                    </div>
                                    <div class="ml-4">
                                        <div class="text-sm font-medium text-gray-900"><%= user.getFirstName() %> <%= user.getLastName() %></div>
                                        <div class="text-sm text-gray-500">@<%= user.getUsername() %></div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                <a href="mailto:<%= user.getEmail() %>"><div class="text-sm text-gray-900"><%= user.getEmail() %></div></a>
                                <a href="tel:<%= user.getEmail() %>"><div class="text-sm text-gray-500">@<%= user.getPhone()%></div></a>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <form method="POST" action="user_management.jsp" class="inline">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                    <input type="hidden" name="action" value="changeRole">
                                    <select name="newRole" 
                                            onchange="changeUserRole(<%= user.getUserId() %>, this)" 
                                            class="text-sm border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 <%= user.getRole().equals("admin") ? "bg-gray-100" : "" %>" 
                                            <%= user.getRole().equals("admin") ? "disabled" : "" %>>
                                        <option value="student" <%= user.getRole().equals("student") ? "selected" : "" %>>Student</option>
                                        <option value="faculty" <%= user.getRole().equals("faculty") ? "selected" : "" %>>Faculty</option>
                                        <option value="staff" <%= user.getRole().equals("staff") ? "selected" : "" %>>Staff</option>
                                        <option value="manager" <%= user.getRole().equals("manager") ? "selected" : "" %>>Manager</option>
                                        <option value="admin" <%= user.getRole().equals("admin") ? "selected" : "" %>>Admin</option>
                                    </select>
                                </form>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <button type="button" 
                                        onclick="toggleUserStatus(<%= user.getUserId() %>, this)"
                                        class="px-2 py-1 text-xs rounded-full <%= user.isActive() ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800" %>">
                                    <%= user.isActive() ? "Active" : "Inactive" %>
                                </button>    
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= user.getLastLogin() != null ? user.getLastLogin().toString() : "Never" %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                <div class="flex justify-end space-x-2">
                                    <form method="POST" action="user_management.jsp" class="inline">
                                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                        <input type="hidden" name="action" value="resetPassword">
                                        <button type="submit" class="text-blue-600 hover:text-blue-900" title="Reset Password">
                                            <i class="fas fa-key"></i>
                                        </button>
                                    </form>
                                    <a href="user_management.jsp?action=edit&id=<%= user.getUserId() %>" class="text-gray-600 hover:text-gray-900" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <% if (!user.getRole().equals("admin")) { %>
                                    <a href="UserController?action=delete&id=<%= user.getUserId() %>" 
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
                                    <% } %>
                                </div>
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
                                    <option value="user_management.jsp?page=1&limit=5<%= searchString %>" <%= recordsPerPage == 5 ? "selected" : "" %>>5</option>
                                    <option value="user_management.jsp?page=1&limit=10<%= searchString %>" <%= recordsPerPage == 10 ? "selected" : "" %>>10</option>
                                    <option value="user_management.jsp?page=1&limit=20<%= searchString %>" <%= recordsPerPage == 20 ? "selected" : "" %>>20</option>
                                    <option value="user_management.jsp?page=1&limit=50<%= searchString %>" <%= recordsPerPage == 50 ? "selected" : "" %>>50</option>
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
                            <a href="user_management.jsp?page=<%= currentPage - 1 %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
                                Previous
                            </a>
                        <% } %>        

                         <% for (int i = 1; i <= totalPages; i++) { %>
                            <% if (i == currentPage) {%>
                                <span class="px-3 py-1 border border-blue-500 bg-blue-100 text-blue-600 rounded-md text-sm font-medium">
                                    <%= i %>
                                </span>
                            <% } else if (i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)) {%>
                                <a href="user_management.jsp?page=<%= i %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
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
                            <a href="user_management.jsp?page=<%= currentPage + 1 %>&limit=<%= recordsPerPage %><%= searchString %>" class="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition">
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
            <% } %>
        </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/user-management.js"></script>       
<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="users" />
</jsp:include>