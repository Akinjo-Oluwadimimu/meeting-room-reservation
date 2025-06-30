<%@page contentType="text/html" pageEncoding="UTF-8"%>
<main class="bg-gray-100">
    <div class="min-h-screen flex items-center justify-center p-4">
        <div class="w-full max-w-md">
            <div class="verification-container bg-white rounded-xl shadow-lg overflow-hidden">
                <div class="bg-blue-600 py-4 px-6 text-white text-center">
                    <i class="fas fa-envelope-open-text text-4xl mb-2"></i>
                    <h1 class="text-2xl font-bold">Verify Your Email Address</h1>
                </div>
                
                <div class="p-6">
                    <%-- Display success message if verification was just sent --%>
                    <% if (request.getParameter("sent") != null) { %>
                        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                            <i class="fas fa-check-circle mr-2"></i> Verification email sent successfully!
                        </div>
                    <% } %>
                    
                    <%-- Display error message if exists --%>
                    <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                            <i class="fas fa-exclamation-circle mr-2"></i> ${errorMessage}
                        </div>
                    <% } %>
                    
                    <div class="mb-6 text-center">
                        <i class="fas fa-envelope text-5xl text-blue-500 mb-4"></i>
                        <p class="text-gray-700 mb-2">We've sent a verification email to:</p>
                        <p class="font-bold text-lg"><%= session.getAttribute("userEmail") %></p>
                        <p class="text-gray-600 mt-4">Please check your inbox and click the verification link to activate your account.</p>
                    </div>
                    
                    <div class="bg-blue-50 p-4 rounded-lg mb-6">
                        <h3 class="font-medium text-blue-800 mb-2"><i class="fas fa-lightbulb mr-2"></i>Didn't receive the email?</h3>
                        <ul class="list-disc list-inside text-sm text-gray-700 pl-2">
                            <li>Check your spam or junk folder</li>
                            <li>Make sure you entered the correct email address</li>
                            <li>Wait a few minutes - it may take a while to arrive</li>
                        </ul>
                    </div>
                    
                    <form action="resend-verification" method="POST" class="mb-4">
                        <button type="submit" 
                                class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition">
                            <i class="fas fa-paper-plane mr-2"></i> Resend Verification Email
                        </button>
                    </form>
                    
                    <form action="${pageContext.request.contextPath}/logout" method="GET">
                        <button type="submit" 
                                class="w-full bg-gray-200 text-gray-800 py-2 px-4 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 transition">
                            <i class="fas fa-sign-out-alt mr-2"></i> Logout
                        </button>
                    </form>
                </div>
            </div>
            
            <div class="mt-6 text-center text-sm text-gray-600">
                <p>Need help? <a href="contact.jsp" class="text-blue-600 hover:text-blue-800">Contact support</a></p>
            </div>
        </div>
    </div>
</main>
