<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="404 Not Found" />
<c:set var="errorContent">
    <div class="text-center">
        <i class="fas fa-map-marker-alt text-blue-500 text-5xl mb-4"></i>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">404 - Page Not Found</h1>
        <p class="text-gray-600">The requested resource could not be found.</p>
        <div class="mt-4 p-3 bg-gray-100 rounded-md">
            <p class="text-sm text-gray-700">
                Requested URL: ${requestScope['javax.servlet.error.request_uri']}
            </p>
        </div>
    </div>
</c:set>
<%@ include file="error-base.jsp" %>