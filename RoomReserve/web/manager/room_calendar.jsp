<jsp:include page="../layout.jsp">
    <jsp:param name="title" value="${not empty selectedRoom ? selectedRoom.name : 'Room'} Calendar" />
    <jsp:param name="content" value="manager/contents/room-calendar-content.jsp" />
</jsp:include>
