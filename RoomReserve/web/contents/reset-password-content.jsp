<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<main class="bg-gray-50 min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-md bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="p-8">
            <div class="text-center mb-8">
                <i class="fas fa-key text-blue-600 text-5xl mb-4"></i>
                <h1 class="text-2xl font-bold text-gray-800">Reset Password</h1>
                <p class="text-gray-600 mt-2">for ${email}</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-50 text-red-800 p-4 mb-4 text-sm rounded-lg">
                    <i class="fas fa-exclamation-circle mr-2"></i>
                    ${error}
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/reset-password" method="post" class="space-y-6">
                <input type="hidden" name="token" value="${token}">
                
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400"></i>
                        </div>
                        <input type="password" id="password" name="password" 
                               class="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                               required minlength="8">
                    </div>
                    <p class="mt-1 text-xs text-gray-500">Minimum 8 characters with numbers</p>
                </div>

                <div>
                    <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-1">Confirm Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400"></i>
                        </div>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               class="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                               required minlength="8">
                    </div>
                </div>

                <div>
                    <button type="submit" 
                            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                        Reset Password
                    </button>
                </div>
            </form>

            <div class="mt-6 text-center text-sm text-gray-600">
                <a href="${pageContext.request.contextPath}/login" class="font-medium text-blue-600 hover:text-blue-500">Back to login</a>
            </div>
        </div>
    </div>
</main>
