<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<%
String message = (String) request.getAttribute("message");
String success = (String) request.getParameter("success");
String error = (String) request.getAttribute("error");
%>

<script>
// Handle messages from server
<c:if test="${not empty success}">
    Swal.fire({
        icon: 'success',
        title: 'Success',
        text: '${success}'
    });
    <c:remove var="success" scope="session"/>
</c:if>
<c:if test="${not empty message}">
    Swal.fire({
        icon: 'success',
        title: 'Success',
        text: '${message}'
    });
    <c:remove var="message" scope="session"/>
</c:if>
<c:if test="${not empty error}">
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: '${error}'
    });
    <c:remove var="error" scope="session"/>
</c:if>

<% if (success != null) { %>
Swal.fire({
    icon: 'success',
    title: 'Success',
    text: '<%= success %>'
});
<% } %>

<% if (error != null) { %>
Swal.fire({
    icon: 'error',
    title: 'Error',
    text: '<%= error %>'
});
<% } %>
</script>

