<main class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="w-full md:w-1/2 p-8 md:p-12 bg-white rounded-lg shadow-md">
        <div class="text-center mb-6">
            <a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-calendar-alt text-4xl text-blue-600 mb-2"></i>
            <h1 class="text-2xl font-bold text-gray-800">Room Reservation System</h1></a>
            <p class="text-gray-600">Join our room reservation system</p>
        </div>
        
        <%-- Display error message if exists --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                ${errorMessage}
            </div>
        <% } %>
        
        <!-- Registration Form -->
        <form class="space-y-4" id="register-form" action="register" method="POST">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="first-name" class="block text-sm font-medium text-gray-700 mb-1">First Name*</label>
                    <input type="text" id="first-name" name="first-name" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                           required>
                </div>
                <div>
                    <label for="last-name" class="block text-sm font-medium text-gray-700 mb-1">Last Name*</label>
                    <input type="text" id="last-name" name="last-name" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                           required>
                </div>
            </div>

            <div>
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email Address*</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-envelope text-gray-400"></i>
                    </div>
                    <input type="email" id="email" name="email" 
                           class="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                           required>
                </div>
            </div>
            
            <div>
                <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">Phone*</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-phone text-gray-400"></i>
                    </div>
                    <input type="tel" id="phone" name="phone" 
                           class="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                           required>
                </div>
            </div>

            <div>
                <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username*</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-user text-gray-400"></i>
                    </div>
                    <input type="text" id="username" name="username" 
                           class="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                           required>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password*</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400"></i>
                        </div>
                        <input type="password" id="password" name="password" 
                               class="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                               required>
                    </div>

                    <!-- Password strength meter -->
                    <div class="mt-2">
                      <!-- Background bar -->
                      <div class="h-2 w-full bg-gray-200 rounded overflow-hidden">
                        <!-- Fill bar -->
                        <div id="strength-bar" class="h-2 w-0 transition-all duration-300 ease-in-out rounded"></div>
                      </div>

                      <!-- Strength label and icon -->
                      <div class="flex items-center gap-2 mt-2 text-sm text-gray-600">
                        <span id="strength-icon" class="text-lg"></span>
                        <span id="strength-text"></span>
                      </div>
                    </div>

                </div>
                <div>
                    <label for="confirm-password" class="block text-sm font-medium text-gray-700 mb-1">Confirm Password*</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400"></i>
                        </div>
                        <input type="password" id="confirm-password" name="confirm-password" 
                               class="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                               required>
                    </div>
                </div>
            </div>

            <div>
                <label for="role" class="block text-sm font-medium text-gray-700 mb-1">Role*</label>
                <select id="role" name="role" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" required>
                    <option value="">Select your primary role</option>
                    <option value="faculty">Faculty</option>
                    <option value="staff">Staff</option>
                    <option value="student">Graduate Student</option>
                </select>
            </div>

            <div class="flex items-start">
                <div class="flex items-center h-5">
                    <input id="terms" name="terms" type="checkbox" 
                           class="focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300 rounded" required>
                </div>
                <div class="ml-3 text-sm">
                    <label for="terms" class="font-medium text-gray-700">I agree to the <a href="#" class="text-blue-600 hover:text-blue-500">Terms of Service</a> and <a href="#" class="text-blue-600 hover:text-blue-500">Privacy Policy</a></label>
                </div>
            </div>

            <div class="pt-2">
                <button type="submit" 
                        class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    Create Account
                </button>
            </div>
        </form>

        <div class="mt-6 text-center text-sm text-gray-600">
            Already have an account? 
            <a href="login.jsp" class="font-medium text-blue-600 hover:text-blue-500">Sign in here</a>
        </div>
    </div>
</main>
<script src="${pageContext.request.contextPath}/js/register.js"></script>
