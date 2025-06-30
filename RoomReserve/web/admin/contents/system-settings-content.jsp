<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
%>
<div class="flex h-screen">
    <!-- Sidebar -->
    <jsp:include page="../../components/admin-sidebar.jsp">
        <jsp:param name="page" value="settings" />
    </jsp:include>

    <!-- Main Content -->
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top Navigation -->
        <jsp:include page="../../components/top-navigation.jsp" />

        <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-6 bg-gray-100">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">System Settings</h1>
                <div class="flex space-x-4">
                    <a href="?action=email-templates"
                       class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">
                        Email Templates
                    </a>
                </div>
            </div>
            
            <!-- Success/Error Messages -->
            <jsp:include page="../../components/messages.jsp" />
            
            <div class="bg-white shadow rounded-lg overflow-hidden">
                <div class="divide-y divide-gray-200">
                    <c:forEach items="${settings}" var="setting">
                        <div class="px-4 sm:px-6 py-4">
                            <form action="${pageContext.request.contextPath}/admin/settings" method="POST" class="setting-form">
                                <input type="hidden" name="action" value="update-setting">
                                <input type="hidden" name="key" value="${setting.key}">

                                <div class="flex flex-col gap-4 md:flex-row md:items-center">
                                    <!-- Setting Info -->
                                    <div class="md:w-2/5 lg:w-1/3">
                                        <label class="block text-gray-700 font-medium">${setting.key}</label>
                                        <p class="text-sm text-gray-500 mt-1">${setting.description}</p>
                                    </div>

                                    <!-- Input Field -->
                                    <div class="md:w-2/5 lg:w-1/3">
                                        <c:choose>
                                            <c:when test="${setting.editable}">
                                                <input type="text" name="value" value="${setting.value}"
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
                                            </c:when>
                                            <c:otherwise>
                                                <input type="text" value="${setting.value}"
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-50 text-gray-600"
                                                       readonly>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Action Button -->
                                    <div class="md:w-1/5 lg:w-1/3 md:pl-4 md:text-right">
                                        <c:if test="${setting.editable}">
                                            <button type="submit"
                                                    class="w-full md:w-auto bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
                                                Update
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </div>
                    
        </main>
    </div>
</div>

<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="settings" />
</jsp:include>
