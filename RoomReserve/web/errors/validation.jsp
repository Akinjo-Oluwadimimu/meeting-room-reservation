<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="Validation Error" />
<c:set var="errorContent">
    <div class="text-center">
        <i class="fas fa-exclamation-circle text-yellow-500 text-5xl mb-4"></i>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">Validation Error</h1>
        <p class="text-gray-600">There was a problem with your submission.</p>
        
        <div class="mt-4 p-3 bg-yellow-50 rounded-md text-left">
            <h3 class="font-medium text-gray-800 mb-2">
                <c:if test="${not empty requestScope.fieldError}">
                    Problem with ${requestScope.fieldError}:
                </c:if>
            </h3>
            <p class="text-gray-700">${requestScope.error}</p>
            
            <c:if test="${not empty requestScope.errorCode}">
                <div class="mt-2">
                    <span class="text-xs bg-yellow-200 text-yellow-800 px-2 py-1 rounded">
                        Error Code: ${requestScope.errorCode}
                    </span>
                </div>
            </c:if>
        </div>
        
        <div class="mt-4">
            <a href="javascript:history.back()" 
               class="inline-flex items-center text-blue-600 hover:text-blue-800">
                <i class="fas fa-arrow-left mr-2"></i> Go back and try again
            </a>
        </div>
    </div>
</c:set>
<%@ include file="error-base.jsp" %>