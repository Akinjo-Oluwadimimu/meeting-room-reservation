function toggleUserStatus(userId, button) {
    const isCurrentlyActive = button.classList.contains('bg-green-100');
    const newStatus = isCurrentlyActive ? 'inactive' : 'active';
    
    Swal.fire({
        title: `Mark user as ${newStatus}?`,
        text: `This will ${isCurrentlyActive ? 'deactivate' : 'activate'} the user\'s account`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: `Yes, mark as ${newStatus}`,
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('UserController', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `userId=${userId}&action=toggleStatus`
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
                        `User account status updated to ${newStatus}`,
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

function changeUserRole(userId, selectElement) {
    const newRole = selectElement.value;
    const currentRole = selectElement.querySelector('option[selected]').value;
    
    // Don't proceed if role didn't actually change or if admin (disabled)
    if (newRole === currentRole || currentRole === 'admin') {
        return;
    }

    Swal.fire({
        title: 'Change User Role?',
        html: `Change role from <strong>${currentRole}</strong> to <strong>${newRole}</strong>?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, change role',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            // Show loading state
            selectElement.disabled = true;
            
            fetch('user_management.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `userId=${userId}&action=changeRole&newRole=${newRole}`
            }).then(response => {
                if (response.ok) {
                    // Update UI
                    selectElement.querySelectorAll('option').forEach(option => {
                        option.removeAttribute('selected');
                    });
                    selectElement.querySelector(`option[value="${newRole}"]`).setAttribute('selected', 'selected');
                    
                    // If new role is admin, disable the dropdown
                    if (newRole === 'admin') {
                        selectElement.disabled = true;
                        selectElement.classList.add('bg-gray-100');
                    } else {
                        selectElement.classList.remove('bg-gray-100');
                    }
                    
                    Swal.fire(
                        'Success!',
                        `User role updated to ${newRole}`,
                        'success'
                    );
                } else {
                    // Revert to original value on error
                    selectElement.value = currentRole;
                    Swal.fire(
                        'Error!',
                        'Failed to update user role',
                        'error'
                    );
                }
            }).catch(error => {
                selectElement.value = currentRole;
                Swal.fire(
                    'Error!',
                    'An error occurred while updating role',
                    'error'
                );
            }).finally(() => {
                selectElement.disabled = (newRole === 'admin');
            });
        } else {
            // Revert to original value if cancelled
            selectElement.value = currentRole;
        }
    });
}