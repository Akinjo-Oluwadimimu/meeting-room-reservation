// Toggle amenities filter
document.getElementById('amenitiesToggle').addEventListener('click', function() {
    const filter = document.getElementById('amenitiesFilter');
    const icon = this.querySelector('i');

    filter.classList.toggle('hidden');
    icon.classList.toggle('fa-chevron-down');
    icon.classList.toggle('fa-chevron-up');
});
        
// Image preview functionality
function previewImages(input) {
    const previewContainer = document.getElementById('imagePreviews');
    previewContainer.innerHTML = '';

    if (input.files && input.files.length > 0) {
        previewContainer.classList.remove('hidden');

        for (let i = 0; i < input.files.length; i++) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const previewDiv = document.createElement('div');
                previewDiv.className = 'relative border rounded-md overflow-hidden';

                const img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'w-full h-32 object-cover';
                previewDiv.appendChild(img);

                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'absolute top-2 right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center';
                removeBtn.innerHTML = '<i class="fas fa-times text-xs"></i>';
                removeBtn.onclick = function() {
                    previewDiv.remove();
                    if (previewContainer.children.length === 0) {
                        previewContainer.classList.add('hidden');
                    }
                };
                previewDiv.appendChild(removeBtn);

                previewContainer.appendChild(previewDiv);
            };
            reader.readAsDataURL(input.files[i]);
        }
    } else {
        previewContainer.classList.add('hidden');
    }
}

// Set primary image
function setPrimaryImage(imageId, roomId, clickedButton) {
    Swal.fire({
        title: 'Set as primary image?',
        text: 'This will make the selected image the main display for the room',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, set as primary',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('RoomImageController', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=set-primary&imageId=${imageId}&roomId=${roomId}`
            }).then(response => {
                if (response.ok) {
                    // Get the container of the clicked image
                    const imageContainer = clickedButton.closest('.image-container');
                    
                    // Remove all existing "Primary" badges
                    document.querySelectorAll('.image-container [class*="bg-green-500"].absolute').forEach(badge => {
                        badge.remove();
                    });
                    
                    // Reset all star buttons to default state
                    document.querySelectorAll('.image-container .fa-star').forEach(star => {
                        star.parentElement.classList.remove('bg-green-500', 'text-white');
                        star.parentElement.classList.add('bg-white', 'text-gray-700');
                    });
                    
                    // Update the clicked button's appearance
                    clickedButton.classList.remove('bg-white', 'text-gray-700');
                    clickedButton.classList.add('bg-green-500', 'text-white');
                    clickedButton.title = "Primary Image";
                    
                    // Add "Primary" badge to this image
                    const primaryBadge = document.createElement('div');
                    primaryBadge.className = 'absolute top-2 left-2 bg-green-500 text-white text-xs px-2 py-1 rounded';
                    primaryBadge.textContent = 'Primary';
                    imageContainer.appendChild(primaryBadge);
                    
                    Swal.fire(
                        'Success!',
                        'Primary image has been updated.',
                        'success'
                    );
                } else {
                    Swal.fire(
                        'Error!',
                        'Failed to update primary image.',
                        'error'
                    );
                }
            }).catch(error => {
                Swal.fire(
                    'Error!',
                    'An error occurred while updating the primary image.',
                    'error'
                );
            });
        }
    });
}

function confirmDeleteImage(imageId, imageElement) {
    Swal.fire({
        title: 'Are you sure?',
        text: 'You won\'t be able to revert this!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('RoomImageController', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=delete&imageId=${imageId}`
            }).then(response => {
                if (response.ok) {
                    // Remove the image element from DOM without reloading
                    imageElement.closest('.image-container').remove();
                    
                    Swal.fire(
                        'Deleted!',
                        'Your image has been deleted.',
                        'success'
                    );
                    
                } else {
                    Swal.fire(
                        'Error!',
                        'Failed to delete the image.',
                        'error'
                    );
                }
            }).catch(error => {
                Swal.fire(
                    'Error!',
                    'An error occurred while deleting the image.',
                    'error'
                );
            });
        }
    });
}

function toggleRoomStatus(roomId, button) {
    const isCurrentlyActive = button.classList.contains('bg-green-100');
    const newStatus = isCurrentlyActive ? 'inactive' : 'active';
    
    Swal.fire({
        title: `Mark room as ${newStatus}?`,
        text: `This will ${isCurrentlyActive ? 'deactivate' : 'activate'} the room`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: `Yes, mark as ${newStatus}`,
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('RoomController', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `roomId=${roomId}&action=toggleStatus`
            }).then(response => {
                if (response.ok) {
                    // Toggle the button appearance
                    button.classList.toggle('bg-green-100', !isCurrentlyActive);
                    button.classList.toggle('text-green-800', !isCurrentlyActive);
                    button.classList.toggle('bg-red-100', isCurrentlyActive);
                    button.classList.toggle('text-red-800', isCurrentlyActive);
                    button.textContent = isCurrentlyActive ? 'Inactive' : 'Active';
                    
                    Swal.fire(
                        'Success!',
                        `Room status updated to ${newStatus}`,
                        'success'
                    );
                } else {
                    Swal.fire(
                        'Error!',
                        'Failed to update room status',
                        'error'
                    );
                }
            }).catch(error => {
                Swal.fire(
                    'Error!',
                    'An error occurred while updating room status',
                    'error'
                );
            });
        }
    });
}

// Drag and drop functionality
const dropArea = document.querySelector('.border-dashed');
['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
    dropArea.addEventListener(eventName, preventDefaults, false);
});

function preventDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
}

['dragenter', 'dragover'].forEach(eventName => {
    dropArea.addEventListener(eventName, highlight, false);
});

['dragleave', 'drop'].forEach(eventName => {
    dropArea.addEventListener(eventName, unhighlight, false);
});

function highlight() {
    dropArea.classList.add('border-blue-500', 'bg-blue-50');
}

function unhighlight() {
    dropArea.classList.remove('border-blue-500', 'bg-blue-50');
}

dropArea.addEventListener('drop', handleDrop, false);

function handleDrop(e) {
    const dt = e.dataTransfer;
    const files = dt.files;
    document.getElementById('images').files = files;
    previewImages(document.getElementById('images'));
}