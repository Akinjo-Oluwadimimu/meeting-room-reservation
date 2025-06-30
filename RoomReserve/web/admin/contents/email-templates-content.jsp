<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.roomreserve.model.DepartmentMember"%>
<%@page import="java.util.List"%>
<%@page import="com.roomreserve.model.Department"%>
<%@page import="com.roomreserve.model.User"%>
<%@page import="com.roomreserve.dao.DepartmentDAO"%>
<%@page import="com.roomreserve.dao.UserDAO"%>
<script src="https://cdn.ckeditor.com/ckeditor5/36.0.1/classic/ckeditor.js"></script>
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
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Email Templates</h1>
                <div class="flex space-x-4">
                    <a href="${pageContext.request.contextPath}/admin/settings"
                       class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300 transition">
                        System Settings
                    </a>
                </div>
            </div>
            
            <!-- Success/Error Messages -->
            <jsp:include page="../../components/messages.jsp" />
            
            <div class="grid md:grid-cols-2 gap-6">
                <c:forEach items="${templates}" var="template">
                    <div class="bg-white shadow rounded-lg overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-200">
                            <h3 class="text-lg font-medium text-gray-800">${template.templateName}</h3>
                        </div>
                        <div class="p-6">
                            <form action="${pageContext.request.contextPath}/admin/settings" method="POST">
                                <input type="hidden" name="action" value="update-template">
                                <input type="hidden" name="templateId" value="${template.templateId}">

                                <div class="mb-4">
                                    <label class="block text-gray-700 font-medium mb-1">Subject</label>
                                    <input type="text" name="subject" value="${template.subject}"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                </div>

                                <div class="mb-4">
                                    <label class="block text-gray-700 font-medium mb-1">Content</label>
                                    <textarea id="editor-${template.templateId}" name="content"
                                              class="w-full px-3 py-2 border border-gray-300 rounded-md hidden">${template.content}</textarea>
                                    <div id="editor-container-${template.templateId}" class="border border-gray-300 rounded-md">
                                        ${template.content}
                                    </div>
                                </div>

                                <div class="text-right">
                                    <button type="submit"
                                            class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">
                                        Update Template
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script>
                        ClassicEditor
                            .create(document.querySelector('#editor-container-${template.templateId}'), {
                                toolbar: ['heading', '|', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote']
                            })
                            .then(editor => {
                                editor.model.document.on('change:data', () => {
                                    document.querySelector('#editor-${template.templateId}').value = editor.getData();
                                });
                            })
                            .catch(error => {
                                console.error(error);
                            });
                    </script>
                </c:forEach>
            </div>
                    
        </main>
    </div>
</div>

<jsp:include page="../../components/admin-mobile-menu.jsp" >
    <jsp:param name="page" value="settings" />
</jsp:include>
