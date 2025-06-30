<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="403 Forbidden" />
<c:set var="errorContent">
    <div class="text-center">
        <i class="fas fa-ban text-red-500 text-5xl mb-4"></i>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">403 - Access Denied</h1>
        <p class="text-gray-600">You don't have permission to access this resource.</p>
        <c:if test="${not empty pageContext.request.userPrincipal}">
            <div class="mt-4">
                <p class="text-sm text-gray-700">Logged in as: ${pageContext.request.userPrincipal.name}</p>
            </div>
        </c:if>
    </div>
</c:set>
<%@ include file="error-base.jsp" %>