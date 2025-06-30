<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="bg-gradient-to-r from-blue-600 to-blue-800 text-white py-20">
    <div class="container mx-auto px-4 ${param.center != null ? 'text-center' : 'flex flex-col md:flex-row items-center'}">
        <c:choose>
            <%-- Homepage Hero --%>
            <c:when test="${param.variant == 'home'}">
                <div class="md:w-1/2 mb-10 md:mb-0">
                    <h1 class="text-4xl md:text-5xl font-bold mb-6">Efficient Meeting Room Management</h1>
                    <p class="text-xl mb-8">Streamline your college's meeting room reservations with our easy-to-use system.</p>
                    <div class="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
                        <a href="${pageContext.request.contextPath}/login.jsp" class="bg-white text-blue-700 px-6 py-3 rounded-md font-bold text-center hover:bg-blue-100 transition">Get Started</a>
                        <a href="${pageContext.request.contextPath}/user/rooms.jsp" class="border-2 border-white px-6 py-3 rounded-md font-bold text-center hover:bg-white hover:text-blue-700 transition">Browse Rooms</a>
                    </div>
                </div>
                <div class="md:w-1/2 flex justify-center">
                    <img src="https://images.unsplash.com/photo-1573164713988-8665fc963095?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1469&q=80" 
                        alt="Modern meeting room" 
                        class="rounded-lg shadow-2xl max-w-md w-full h-auto border-4 border-white">
                </div>
            </c:when>
            
            <%-- Standard Centered Header --%>
            <c:when test="${param.variant == 'centered'}">
                <div class="${param.narrow != null ? 'max-w-3xl' : 'max-w-4xl'} mx-auto">
                    <h1 class="text-4xl md:text-5xl font-bold mb-6">${param.title}</h1>
                    <c:if test="${not empty param.subtitle}">
                        <p class="text-xl mb-8">${param.subtitle}</p>
                    </c:if>
                    <c:if test="${param.cta == 'true'}">
                        <div class="mt-6">
                            <a href="${param.ctaLink}" class="inline-block bg-white text-blue-700 px-6 py-3 rounded-md font-bold hover:bg-blue-100 transition">
                                ${param.ctaText}
                            </a>
                        </div>
                    </c:if>
                </div>
            </c:when>
            
            <%-- Default if no variant specified --%>
            <c:otherwise>
                <h1 class="text-4xl md:text-5xl font-bold mb-6">${param.title}</h1>
                <c:if test="${not empty param.subtitle}">
                    <p class="text-xl">${param.subtitle}</p>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</section>