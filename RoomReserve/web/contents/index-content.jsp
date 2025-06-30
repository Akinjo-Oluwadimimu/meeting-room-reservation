<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../components/navigation.jsp" />
<jsp:include page="../components/hero.jsp">
    <jsp:param name="variant" value="home" />
</jsp:include>
<jsp:include page="../components/features.jsp" />
<jsp:include page="../components/how-it-works.jsp" />
<c:choose>
    <c:when test="${param.minimalFooter != null || fn:endsWith(pageContext.request.requestURI, 'login.jsp') || fn:endsWith(pageContext.request.requestURI, 'register.jsp')}">
        <jsp:include page="components/footer-minimal.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="../components/footer.jsp" />
    </c:otherwise>
</c:choose>