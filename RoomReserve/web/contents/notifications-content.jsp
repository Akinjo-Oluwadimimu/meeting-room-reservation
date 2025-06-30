<jsp:include page="../components/navigation.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<main class="bg-gray-50">
    <div  class="flex h-screen">
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Main Content Area -->
        <main class="flex-1 overflow-y-auto p-2 bg-gray-100">
            <div class="mx-4">
                <!-- Success/Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                        ${successMessage}
                        <c:remove var="successMessage" scope="session" />
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                        ${errorMessage}
                        <c:remove var="errorMessage" scope="session" />
                    </div>
                </c:if>
            </div>
            <div class="container mx-auto px-4 py-8">
                <div class="bg-white rounded-lg shadow-md p-6">
                    <h1 class="text-2xl font-bold mb-6">Your Notifications</h1>

                    <c:choose>
                        <c:when test="${not empty notifications}">
                            <div class="space-y-4">
                                <div class="notification-list">
                                    <c:forEach items="${notifications}" var="notification">
                                        <div class="border border-gray-200 rounded-lg p-4 mb-3
                                            ${notification.read ? 'bg-gray-50' : 'bg-blue-50'}" data-notification-id="${notification.notificationId}">
                                            <div class="flex justify-between items-start">
                                                <div>
                                                    <h3 class="font-bold">${notification.title}</h3>
                                                    <p class="text-gray-700 mt-1">${notification.message}</p>
                                                    <p class="text-sm text-gray-500 mt-2">
                                                        <fmt:formatDate value="${notification.dateCreated}" pattern="MMM dd, yyyy hh:mm a" />
                                                    </p>
                                                </div>
                                                <div class="flex space-x-2">
                                                    <c:if test="${!notification.read}">
                                                        <form action="notifications" method="post">
                                                            <input type="hidden" name="action" value="markAsRead">
                                                            <input type="hidden" name="notificationId" value="${notification.notificationId}">
                                                            <button type="submit" class="text-blue-600 hover:text-blue-800 text-sm" title="Mark as Read">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${notification.read}">
                                                        <form action="notifications" method="post">
                                                            <input type="hidden" name="action" value="markAsUnread">
                                                            <input type="hidden" name="notificationId" value="${notification.notificationId}">
                                                            <button type="submit" class="text-blue-600 hover:text-blue-800 text-sm" title="Mark as Unread">
                                                                <i class="fas fa-eye-slash"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <form action="notifications" method="post">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="notificationId" value="${notification.notificationId}">
                                                        <button type="submit" class="text-red-600 hover:text-red-800 text-sm" title="Delete">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Add this at the bottom of your notifications list -->
                                <c:if test="${hasMore}">
                                    <div class="mt-4 text-center">
                                        <button id="loadMoreBtn" 
                                                class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                                            Load More Notifications
                                        </button>
                                    </div>
                                </c:if>

                                <script src="${pageContext.request.contextPath}/js/notifications.js">
                                   
                                </script>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-gray-600">You don't have any notifications yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
        </div>
    </div>
</main>
<%@include file="../components/mobile-menu-toggle-script.jsp"%>