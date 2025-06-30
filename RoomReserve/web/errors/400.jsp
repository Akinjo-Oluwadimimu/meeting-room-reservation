<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="400 Bad Request" />
<c:set var="errorContent">
    <div class="text-center">
        <i class="fas fa-exclamation-triangle text-yellow-500 text-5xl mb-4"></i>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">400 - Bad Request</h1>
        <p class="text-gray-600">${errorContent}</p>
        <c:if test="${not empty requestScope['javax.servlet.error.message']}">
            <div class="mt-4 p-3 bg-gray-100 rounded-md">
                <p class="text-sm text-gray-700">${requestScope['javax.servlet.error.message']}</p>
            </div>
        </c:if>
    </div>
</c:set>
<%@ include file="error-base.jsp" %>