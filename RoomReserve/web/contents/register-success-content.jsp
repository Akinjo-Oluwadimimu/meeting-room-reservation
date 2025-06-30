<%-- register-success.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<main class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <div class="text-center mb-6">
            <i class="fas fa-check-circle text-4xl text-green-500 mb-2"></i>
            <h1 class="text-2xl font-bold text-gray-800">Registration Successful!</h1>
        </div>
        
        <div class="bg-blue-50 border border-blue-200 text-blue-700 px-4 py-3 rounded mb-6">
            <p>We've sent a verification email to your address. Please check your inbox and click the verification link to activate your account.</p>
        </div>
        
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/login" 
               class="inline-block px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                <i class="fas fa-sign-in-alt mr-2"></i> Go to Login Page
            </a>
        </div>
    </div>
</main>