<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../components/navigation.jsp" />
<jsp:include page="../components/hero.jsp">
    <jsp:param name="variant" value="centered" />
    <jsp:param name="center" value="centered" />
    <jsp:param name="title" value="About RoomReserve" />
    <jsp:param name="subtitle" value="Streamlining academic collaboration through efficient meeting room management" />
</jsp:include>

<!-- Mission Section -->
<section class="py-16 bg-white">
    <div class="container mx-auto px-4">
        <div class="flex flex-col md:flex-row items-center">
            <div class="md:w-1/2 mb-10 md:mb-0 md:pr-10">
                <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80" 
                     alt="Team meeting" 
                     class="rounded-lg shadow-xl w-full">
            </div>
            <div class="md:w-1/2">
                <h2 class="text-3xl font-bold mb-6 text-gray-800">Our Mission</h2>
                <p class="text-lg text-gray-600 mb-6">RoomReserve was created to solve the challenges academic institutions face in managing their meeting spaces. We recognized that valuable time was being lost in scheduling conflicts, inefficient room utilization, and manual booking processes.</p>
                <p class="text-lg text-gray-600">Our mission is to provide a seamless, intuitive platform that enhances collaboration by removing the administrative barriers to room reservations, allowing faculty and staff to focus on what matters most - their academic work.</p>
            </div>
        </div>
    </div>
</section>

<!-- Features Highlight -->
<section class="py-16 bg-gray-50">
    <div class="container mx-auto px-4">
        <h2 class="text-3xl font-bold text-center mb-12 text-gray-800">Why Choose RoomReserve?</h2>

        <div class="grid md:grid-cols-3 gap-8">
            <!-- Feature 1 -->
            <jsp:include page="../components/features-card.jsp">
                <jsp:param name="icon" value="fas fa-clock" />
                <jsp:param name="title" value="Time-Saving" />
                <jsp:param name="subtitle" value="Reduce time spent on room scheduling by up to 80% with our intuitive interface and real-time availability views." />
            </jsp:include>

            <!-- Feature 2 -->
            <jsp:include page="../components/features-card.jsp">
                <jsp:param name="icon" value="fas fa-chart-line" />
                <jsp:param name="title" value="Optimized Utilization" />
                <jsp:param name="subtitle" value="Our analytics help institutions improve room usage rates by identifying underutilized spaces and peak demand periods." />
            </jsp:include>

            <!-- Feature 3 -->
            <jsp:include page="../components/features-card.jsp">
                <jsp:param name="icon" value="fas fa-shield-alt" />
                <jsp:param name="title" value="Secure Access" />
                <jsp:param name="subtitle" value="Role-based permissions ensure only authorized users can book or approve reservations for specific rooms." />
            </jsp:include>
        </div>
    </div>
</section>

<c:choose>
    <c:when test="${param.minimalFooter != null || fn:endsWith(pageContext.request.requestURI, 'login.jsp') || fn:endsWith(pageContext.request.requestURI, 'register.jsp')}">
        <jsp:include page="components/footer-minimal.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="../components/footer.jsp" />
    </c:otherwise>
</c:choose>
