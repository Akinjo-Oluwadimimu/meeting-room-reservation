<main class="bg-gray-50 min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-md bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="p-8">
            <div class="text-center mb-8">
                <i class="fas fa-calendar-alt text-blue-600 text-5xl mb-4"></i>
                <h1 class="text-2xl font-bold text-gray-800">Forgot Password</h1>
                <p class="text-gray-600 mt-2">Enter your email to receive a reset link</p>
            </div>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="space-y-6">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="bg-red-50 text-red-800 p-4 mb-4 text-sm rounded-lg">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                        ${error}
                    </div>
                <% } %>
                
                <% if (request.getAttribute("message") != null) { %>
                    <div class="bg-green-50 text-green-800 p-4 mb-4 text-sm rounded-lg">
                        <i class="fas fa-check-circle mr-2"></i>
                        ${message}
                    </div>
                <% } %>

                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-envelope text-gray-400"></i>
                        </div>
                        <input type="email" id="email" name="email" 
                               class="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                               placeholder="your@university.edu" required>
                    </div>
                </div>

                <div>
                    <button type="submit" 
                            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                        Send Reset Link
                    </button>
                </div>
            </form>

            <div class="mt-6 text-center text-sm text-gray-600">
                Remember your password? 
                <a href="${pageContext.request.contextPath}/login" class="font-medium text-blue-600 hover:text-blue-500">Sign in here</a>
            </div>
        </div>
    </div>
</main>