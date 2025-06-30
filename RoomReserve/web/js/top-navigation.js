const userMenuButton = document.getElementById('user-menu-button');
const userMenu = document.getElementById('user-menu');

userMenuButton.addEventListener('click', () => {
    const isExpanded = userMenuButton.getAttribute('aria-expanded') === 'true';
    userMenuButton.setAttribute('aria-expanded', !isExpanded);
    userMenu.classList.toggle('hidden');
});

// Close the dropdown when clicking outside
document.addEventListener('click', (event) => {
    if (!userMenuButton.contains(event.target) && !userMenu.contains(event.target)) {
        userMenuButton.setAttribute('aria-expanded', 'false');
        userMenu.classList.add('hidden');
    }
});

// Toggle notification dropdown
document.getElementById('notificationDropdown').addEventListener('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    document.getElementById('notificationDropdownContent').classList.toggle('hidden');
});

// Close dropdown when clicking outside
document.addEventListener('click', function(e) {
    const dropdown = document.getElementById('notificationDropdownContent');
    if (!dropdown.contains(e.target)) {
        dropdown.classList.add('hidden');
    }
});

// Load more notifications via AJAX
let isLoading = false;
const notificationItems = document.getElementById('notificationItems');
const notificationDropdown = document.getElementById('notificationDropdownContent');
const notificationLoader = document.getElementById('notificationLoader');

document.getElementById('loadMoreBtn')?.addEventListener('click', function() {
    if (isLoading) return;

    notificationLoader.classList.remove('hidden');
    isLoading = true;
    const lastNotification = notificationItems.lastElementChild;
    const lastNotificationId = lastNotification ? lastNotification.getAttribute('data-notification-id') : 0;

    fetch(`notifications?action=loadMore&lastId=` + lastNotificationId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.length === 0) {
                this.style.display = 'none';
                notificationLoader.classList.add('hidden');
                return;
            }
            notificationLoader.classList.add('hidden');
            data.forEach(notification => {
                const notificationElement = document.createElement('a');
                notificationElement.href = `notifications?${notification.read ? 'markAsUnread' : 'markAsRead'}=`+notification.notificationId;
                notificationElement.className = `block px-4 py-3 hover:bg-gray-100 border-b border-gray-100 ${notification.read ? '' : 'bg-blue-50'}`;
                notificationElement.setAttribute('data-notification-id', notification.notificationId);

                // Format date in JavaScript
                const notificationDate = new Date(notification.createdAtTimestamp);
                const formattedDate = notificationDate.toLocaleDateString('en-US', {
                    month: 'short',
                    day: 'numeric'
                });

                notificationElement.innerHTML = `
                    <div class="flex justify-between">
                        <h4 class="font-medium text-gray-800">` + notification.title + `</h4>
                        <span class="text-xs text-gray-500">
                            ` + formattedDate + `
                        </span>
                    </div>
                    <p class="text-sm text-gray-600 mt-1 truncate">` + notification.message + `</p>
                `;

                notificationItems.appendChild(notificationElement);
            });

            if (data.length < 5) { // Assuming page size is 10
                this.style.display = 'none';
            }
        })
        .catch(error => {
            console.error('Error loading notifications:', error);
        })
        .finally(() => {
            isLoading = false;
            notificationLoader.classList.add('hidden');
        });
});
