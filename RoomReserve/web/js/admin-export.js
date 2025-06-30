document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('form[action*="/admin/export"]').forEach(form => {
        form.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const form = this;
            const formAction = this.getAttribute('action');
            const submitButton = form.querySelector('button[type="submit"]');
            const originalButtonText = submitButton.textContent;
            
            try {
                // Show loading state
                submitButton.disabled = true;
                submitButton.innerHTML = `
                    <span class="inline-flex items-center">
                        <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        Processing...
                    </span>
                `;
                
                // Create URLSearchParams instead of FormData for better compatibility
                const formData = new URLSearchParams();
                
                // Manually add all form elements
                Array.from(form.elements).forEach(element => {
                    if (element.name && !element.disabled && element.type !== 'file') {
                        formData.append(element.name, element.value);
                    }
                });
                
                // Debug: Log what's being sent
                console.log('Submitting:', Array.from(formData.entries()));
                
                // Submit with proper headers
                const response = await fetch(formAction, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                });
                
                if (response.ok) {
                    // Show success notification
                    await Swal.fire({
                        title: 'Export Successful!',
                        text: 'Your download should start shortly.',
                        icon: 'success',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#3b82f6',
                        timer: 3000,
                        timerProgressBar: true
                    });
                    
                    // Refresh the export history table
                    await refreshExportHistory();
                } else {
                    const errorText = await response.text();
                    throw new Error(errorText || 'Export failed with status: ' + response.status);
                }
            } catch (error) {
                console.error('Export error:', error);
                await Swal.fire({
                    title: 'Export Failed',
                    text: error.message,
                    icon: 'error',
                    confirmButtonText: 'Try Again',
                    confirmButtonColor: '#ef4444'
                });
            } finally {
                // Reset button state
                submitButton.disabled = false;
                submitButton.textContent = originalButtonText;
            }
        });
    });
    
    // refreshExportHistory function remains the same
    async function refreshExportHistory() {
        try {
            const response = await fetch(`${contextPath}/admin/export/history?page=${currentPage}&limit=${recordsPerPage}`);
            if (!response.ok) throw new Error('Failed to refresh history');
            
            const html = await response.text();
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;
            const newTable = tempDiv.querySelector('.overflow-x-auto');
            
            if (newTable) {
                document.querySelector('.overflow-x-auto').replaceWith(newTable);
                
                const Toast = Swal.mixin({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 2000,
                    timerProgressBar: true
                });
                
                Toast.fire({
                    icon: 'success',
                    title: 'Export history updated'
                });
            }
        } catch (error) {
            console.error('Refresh error:', error);
            Swal.fire({
                title: 'Refresh Failed',
                text: 'Could not update export history',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    }
});
