// Load more notifications on button click
document.getElementById('loadMoreBtn')?.addEventListener('click', function() {
    const notificationList = document.querySelector('.notification-list');
    const lastNotification = notificationList.lastElementChild;
    console.log(notificationList);
    const lastId = lastNotification.getAttribute('data-notification-id');

    fetch(`notifications?action=loadMore&lastId=` + lastId)
        .then(response => response.json())
        .then(data => {
            if (data.length === 0) {
                this.style.display = 'none';
                return;
            }

            data.forEach(notification => {
                const notificationElement = document.createElement('div');
                notificationElement.className = `border border-gray-200 rounded-lg p-4 mb-4 
                    ${notification.read ? 'bg-gray-50' : 'bg-blue-50'}`;
                notificationElement.setAttribute('data-notification-id', notification.notificationId);

                // Format date in JavaScript
                const notificationDate = new Date(notification.createdAtTimestamp);
                const formattedDate = notificationDate.toLocaleDateString('en-US', {
                    month: 'short',
                    day: 'numeric'
                });
                
                var notificationElementContent = `
                    <div class="flex justify-between items-start">
                        <div>
                            <h3 class="font-bold">`+notification.title+`</h3>
                            <p class="text-gray-700 mt-1">`+notification.message+`</p>
                            <p class="text-sm text-gray-500 mt-2">`+
                                formattedDate + `
                            </p>
                        </div>
                        <div class="flex space-x-2">`;
                if (!notification.read){
                    notificationElementContent += `<form action="notifications" method="post">
                        <input type="hidden" name="action" value="markAsRead">
                        <input type="hidden" name="notificationId" value="${notification.notificationId}">
                        <button type="submit" class="text-blue-600 hover:text-blue-800 text-sm" title="Mark as Read">
                            <i class="fas fa-eye"></i>
                        </button>
                    </form>`;
                } else {
                    notificationElementContent += `<form action="notifications" method="post">
                        <input type="hidden" name="action" value="markAsUnread">
                        <input type="hidden" name="notificationId" value="${notification.notificationId}">
                        <button type="submit" class="text-blue-600 hover:text-blue-800 text-sm" title="Mark as Unread">
                            <i class="fas fa-eye-slash"></i>
                        </button>
                    </form>`;
                }
                
                notificationElementContent += `<form action="notifications" method="post">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="notificationId" value="${notification.notificationId}">
                                <button type="submit" class="text-red-600 hover:text-red-800 text-sm" title="Delete">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                `;

                notificationElement.innerHTML = notificationElementContent;

                notificationList.appendChild(notificationElement);
            });

            // Check if there are more to load
            if (data.length < 10) { // Assuming page size is 10
                this.style.display = 'none';
            }
        })
        .catch(error => {
            console.error('Error loading more notifications:', error);
        });
});
