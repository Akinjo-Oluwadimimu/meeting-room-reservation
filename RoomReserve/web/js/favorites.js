document.querySelectorAll('.favorite-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const roomId = this.dataset.roomId;
        const action = this.dataset.action;
        
        fetch(`${BASE_PATH}/user/favorites`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=${action}&room_id=${roomId}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                this.closest('.fav-container').remove();
                showToast('Room updated in favorites');
            }
        });
    });
});

document.querySelectorAll('.rooms-favorite-btn').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.preventDefault();
        const roomId = this.dataset.roomId;
        const action = this.dataset.action;
        const icon = this.querySelector('i');
        const button = this;
        
        fetch(`${BASE_PATH}/user/favorites`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=${action}&room_id=${roomId}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Update button state without reload
                const newAction = action === 'add' ? 'remove' : 'add';
                button.dataset.action = newAction;
                
                // Toggle heart icon color
                icon.classList.toggle('text-red-500');
                icon.classList.toggle('text-gray-400');
                
                // Update tooltip if you have one
                if (button.title) {
                    button.title = newAction === 'add' ? 'Add to favorites' : 'Remove from favorites';
                }
                
                showToast(action === 'add' ? 'Added to favorites' : 'Removed from favorites');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('Failed to update favorites', 'error');
        });
    });
});

// Toast Notification Function
function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `fixed bottom-4 right-4 px-4 py-2 rounded-md shadow-md text-white ${
        type === 'success' ? 'bg-green-500' : 
        type === 'error' ? 'bg-red-500' : 'bg-blue-500'
    }`;
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.remove();
    }, 3000);
}