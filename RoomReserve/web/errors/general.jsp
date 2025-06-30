<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Error Occurred" />
<c:set var="errorContent">
    <div class="text-center">
        <i class="fas fa-bug text-red-500 text-5xl mb-4"></i>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">Unexpected Error</h1>
        <p class="text-gray-600">An unexpected error occurred while processing your request.</p>
        
        <div class="mt-4 p-3 bg-gray-100 rounded-md">
            <p class="text-sm text-gray-700">
                ${requestScope['javax.servlet.error.message']}
            </p>
            
            <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                <div class="mt-3">
                    <h4 class="font-medium text-gray-800 mb-1">Technical Details:</h4>
                    <pre class="text-xs text-gray-600 overflow-x-auto">${requestScope['javax.servlet.error.exception'].stackTrace}</pre>
                </div>
            </c:if>
        </div>
    </div>
</c:set>
<%@ include file="error-base.jsp" %>