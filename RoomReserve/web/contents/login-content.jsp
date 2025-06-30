<main class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <div class="text-center mb-6">
            <a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-calendar-alt text-4xl text-blue-600 mb-2"></i>
            <h1 class="text-2xl font-bold text-gray-800">Room Reservation System</h1></a>
            <p class="text-gray-600">Please sign in to continue</p>
        </div>
        
        <%-- Display error message if exists --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <%-- Display success message after registration --%>
        <% if (request.getParameter("registered") != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                Registration successful! Please log in.
            </div>
        <% } %>
        
        <%-- Display success message after registration --%>
        <% if (request.getParameter("verified") != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                Email verification successful! Please log in.
            </div>
        <% } %>
        
        <form action="login" method="post">
            <div class="mb-4">
                <label for="username" class="block text-gray-700 text-sm font-bold mb-2">
                    <i class="fas fa-user mr-2"></i>Username
                </label>
                <input type="text" id="username" name="username" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" 
                       required autofocus>
            </div>
            
            <div class="mb-6">
                <label for="password" class="block text-gray-700 text-sm font-bold mb-2">
                    <i class="fas fa-lock mr-2"></i>Password
                </label>
                <input type="password" id="password" name="password" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" 
                       required>
            </div>
            
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center">
                    <input id="remember-me" name="remember-me" type="checkbox" 
                           class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                    <label for="remember-me" class="ml-2 block text-sm text-gray-700">Remember me</label>
                </div>
                <a href="forgot-password.jsp" class="text-sm text-blue-600 hover:text-blue-800">Forgot password?</a>
            </div>
            
            <button type="submit" 
                    class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                <i class="fas fa-sign-in-alt mr-2"></i> Log In
            </button>
        </form>
        
        <div class="mt-6 text-center">
            <p class="text-gray-600">Don't have an account? 
                <a href="register.jsp" class="text-blue-600 hover:text-blue-800 font-medium">Register here</a>
            </p>
        </div>
    </div>
</main>