<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page isErrorPage="true" %>
<c:set var="title" value="500 Server Error" />
<c:set var="errorContent">
    <div class="text-center">
        <i class="fas fa-server text-red-500 text-5xl mb-4"></i>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">500 - Internal Server Error</h1>
        <p class="text-gray-600">Something went wrong on our end. We're working to fix it.</p>
        
        <c:if test="${not empty requestScope['javax.servlet.error.exception']}">
            <div class="mt-4 p-3 bg-gray-100 rounded-md text-left">
                <h3 class="font-medium text-gray-800 mb-2">Error Details:</h3>
                <p class="text-sm text-gray-700">${requestScope['javax.servlet.error.exception'].message}</p>
                
                <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                    <div class="mt-3">
                        <h4 class="font-medium text-gray-800 mb-1">Stack Trace:</h4>
                        <pre class="text-xs text-gray-600 overflow-x-auto">${requestScope['javax.servlet.error.exception'].stackTrace}</pre>
                    </div>
                </c:if>
            </div>
        </c:if>
    </div>
</c:set>
<%@ include file="error-base.jsp" %>