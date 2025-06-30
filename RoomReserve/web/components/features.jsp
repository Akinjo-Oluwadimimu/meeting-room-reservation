<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Features Section -->
<section class="py-16 bg-white">
    <div class="container mx-auto px-4">
        <h2 class="text-3xl font-bold text-center mb-12 text-gray-800">Key Features</h2>

        <div class="grid md:grid-cols-3 gap-8">
            <!-- Feature 1 -->
            <jsp:include page="features-card.jsp">
                <jsp:param name="icon" value="fas fa-calendar-check" />
                <jsp:param name="title" value="Easy Reservations" />
                <jsp:param name="subtitle" value="Quickly book meeting rooms with our intuitive interface. View availability in real-time and get instant confirmations." />
            </jsp:include>

            <!-- Feature 2 -->
            <jsp:include page="../components/features-card.jsp">
                <jsp:param name="icon" value="fas fa-chart-bar" />
                <jsp:param name="title" value="Usage Analytics" />
                <jsp:param name="subtitle" value="Track room utilization with detailed reports. Identify peak times and optimize your meeting room resources." />
            </jsp:include>

            <!-- Feature 3 -->
            <jsp:include page="../components/features-card.jsp">
                <jsp:param name="icon" value="fas fa-user-shield" />
                <jsp:param name="title" value="Role-Based Access" />
                <jsp:param name="subtitle" value="Different access levels for faculty, staff, and administrators with appropriate permissions for each role." />
            </jsp:include>
        </div>
    </div>
</section>
