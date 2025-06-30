<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${param.minimalFooter != null || requestScope['javax.servlet.forward.request_uri'].endsWith('login.jsp') || requestScope['javax.servlet.forward.request_uri'].endsWith('register.jsp')}">
        <jsp:include page="footer-minimal.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="footer.jsp" />
    </c:otherwise>
</c:choose>