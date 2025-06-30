<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<main class="bg-gray-50">
    <div  class="flex h-screen">
        <c:choose>
            <c:when test="${user.role == 'admin'}">
                <jsp:include page="../components/admin-sidebar.jsp">
                    <jsp:param name="page" value="profile" />
                </jsp:include>
            </c:when>
            <c:when test="${user.role == 'manager'}">
                <jsp:include page="../components/manager-sidebar.jsp">
                    <jsp:param name="page" value="profile" />
                </jsp:include>
            </c:when>
            <c:otherwise>
                <jsp:include page="../components/user-sidebar.jsp">
                    <jsp:param name="page" value="profile" />
                </jsp:include>
            </c:otherwise>
        </c:choose>
    
    <div class="flex flex-col flex-1 overflow-hidden">
        <jsp:include page="../components/top-navigation.jsp" />
        <!-- Main Content Area -->
            <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
                <jsp:include page="../components/messages.jsp" />
            
            <div class="bg-white rounded-lg shadow-md overflow-hidden mt-6 mb-6 mx-4">
                
                <div class="p-6">
                    <div class="">
                        <h3 class="text-2xl font-bold text-lg font-medium text-gray-800">Profile Settings</h3>
                        <p class="text-gray-600 text-sm mb-6">Manage your account information and settings</p>
                        
                        <!-- Profile Information Section -->
                        <div class="md:w-2/3">
                            <form id="profileForm" method="post" action="profile" class="space-y-6">
                                <input type="hidden" name="action" value="updateProfile">
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
                                        <input type="text" id="firstName" name="firstName" 
                                               value="${user.firstName}"
                                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                    </div>
                                    <div>
                                        <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
                                        <input type="text" id="lastName" name="lastName" 
                                               value="${user.lastName}"
                                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                    </div>
                                </div>
                                
                                <div>
                                    <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                                    <input type="text" id="username" 
                                           value="${user.username}"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-100 cursor-not-allowed" disabled>
                                </div>
                                
                                <div>
                                    <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                                    <input type="email" id="email" name="email" 
                                           value="${user.email}"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                </div>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">Phone</label>
                                        <input type="tel" id="phone" name="phone" 
                                               value="${user.phone}"
                                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                    </div>
                                    <div>
                                        <label for="role" class="block text-sm font-medium text-gray-700 mb-1">Role</label>
                                        <input type="text" id="position" name="role" 
                                               value="${user.role}"
                                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" disabled>
                                    </div>
                                </div>
                                <div class="pt-4">
                                    <button type="submit" 
                                            class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition">
                                        Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Change Password Section -->
                    <div class="mt-12 border-t border-gray-200 pt-8">
                        <h3 class="text-lg font-medium text-gray-800 mb-6">Change Password</h3>
                        <div class="md:w-2/3">
                        
                        <form id="passwordForm" method="post" action="profile" class="space-y-6">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div>
                                <label for="currentPassword" class="block text-sm font-medium text-gray-700 mb-1">Current Password</label>
                                <input type="password" id="currentPassword" name="currentPassword" 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500${fieldError == 'oldPassword' ? 'border-red-500' : ''}" required
                                       minlength="8">
                                       
                                <c:if test="${fieldError == 'oldPassword'}">
                                    <p class="mt-1 text-sm text-red-600">${errorMessage}</p>
                                </c:if>
                            </div>
                            
                            <div>
                                <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${fieldError == 'password' ? 'border-red-500' : ''}" required
                                       minlength="8" pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$" oninput="validatePassword()">
                                 <p class="mt-1 text-sm text-gray-500">
                                     Must be at least 8 characters with uppercase, lowercase, number, and special character
                                 </p>
                                 <div id="passwordError" class="mt-1 text-sm text-red-600 hidden"></div>
                                 
                            <c:if test="${fieldError == 'password'}">
                                <p class="mt-1 text-sm text-red-600">${errorMessage}</p>
                            </c:if>
                            </div>
                            
                            <div>
                                <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-1">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${field == 'confirmPassword' ? 'border-red-500' : ''}" required
                                       minlength="8" oninput="validatePassword()">
                                       <div id="confirmPasswordError" class="mt-1 text-sm text-red-600 hidden"></div>
                                <c:if test="${fieldError == 'confirmPassword'}">
                                    <p class="mt-1 text-sm text-red-600">${errorMessage}</p>
                                </c:if>
                            </div>
                            
                            <div class="pt-2">
                                <button type="submit" 
                                        class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition">
                                    Change Password
                                </button>
                            </div>
                        </form>
                            </div>
                    </div>
                </div>
            </div>
            </main>
        </div>
    </div>
    
    <script>
        // Password form validation
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                Swal.fire({
                    title: 'An error occured',
                    text: 'New passwords do not match!',
                    icon: 'error'
                });
                e.preventDefault();
            }
            
            // Add additional password strength validation if needed
        });
        
        
        function validatePassword() {
            const password = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            const passwordError = document.getElementById('passwordError');
            const confirmPasswordError = document.getElementById('confirmPasswordError');

            // Clear previous errors
            passwordError.textContent = '';
            passwordError.classList.add('hidden');
            confirmPasswordError.textContent = '';
            confirmPasswordError.classList.add('hidden');

            let isValid = true;

            // Password strength validation
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

            if (!passwordRegex.test(password.value)) {
                passwordError.textContent = 'Password must contain at least 8 characters including uppercase, lowercase, number, and special character';
                passwordError.classList.remove('hidden');
                isValid = false;
            }

            // Confirm password match validation
            if (password.value !== confirmPassword.value) {
                confirmPasswordError.textContent = 'Passwords do not match';
                confirmPasswordError.classList.remove('hidden');
                isValid = false;
            }

            return isValid;
        }

        // Form submission handler
        document.getElementById('passwordForm').addEventListener('submit', function(event) {
            if (!validatePassword()) {
                event.preventDefault();
                // Scroll to the first error
                document.querySelector('.text-red-600:not(.hidden)')?.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });
            }
        });

        // Real-time validation as user types
        document.getElementById('password').addEventListener('input', validatePassword);
        document.getElementById('confirmPassword').addEventListener('input', validatePassword);
    </script>
    <c:choose>
            <c:when test="${user.role == 'admin'}">
                <jsp:include page="../components/admin-mobile-menu.jsp" >
                    <jsp:param name="page" value="profile" />
                </jsp:include>
            </c:when>
            <c:when test="${user.role == 'manager'}">
                <jsp:include page="../components/manager-mobile-menu.jsp" >
                    <jsp:param name="page" value="profile" />
                </jsp:include>
            </c:when>
            <c:otherwise>
                <jsp:include page="../components/user-mobile-menu.jsp" >
                    <jsp:param name="page" value="profile" />
                </jsp:include>
            </c:otherwise>
        </c:choose>
</main>
