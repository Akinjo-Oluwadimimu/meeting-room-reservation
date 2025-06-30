// Add this script to your JSP or separate JS file
document.addEventListener('DOMContentLoaded', function() {
    // Event listeners for filter buttons
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const filter = this.dataset.filter;
            loadApprovalRequests(filter);
            
            // Update active button styling
            document.querySelectorAll('.filter-btn').forEach(b => {
                b.classList.remove('bg-blue-600', 'text-white', 'border-transparent');
                b.classList.add('bg-gray-100', 'text-gray-700', 'border-gray-300');
            });
            this.classList.remove('bg-gray-100', 'text-gray-700', 'border-gray-300');
            this.classList.add('bg-blue-600', 'text-white', 'border-transparent');
        });
    });
    
    // Initial load
    loadApprovalRequests('all');
    
    attachScheduleEventListeners();
    
    // Keyboard shortcut for refresh (Ctrl+R or Cmd+R)
    document.addEventListener('keydown', function(e) {
        if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
            e.preventDefault();
            refreshSchedule();
        }
    });
});

function loadApprovalRequests(filter) {
    fetch(`approval-requests?filter=${filter}`)
        .then(response => response.json())
        .then(resp => {
            const data = resp.data; // Actual records
            const totalCount = resp.totalCount; // Total matching records
            
            const tbody = document.querySelector('tbody');
            tbody.innerHTML = ''; // Clear existing rows
            
            data.forEach(reservation => {
                const startDate = new Date(reservation.startDate);
                const formattedstartDate = startDate.toLocaleDateString('en-US', {
                    month: 'short',
                    day: 'numeric'
                });
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 h-10 w-10">
                                <img class="h-10 w-10 rounded-full" 
                                     src="https://ui-avatars.com/api/?name=${reservation.user.firstName}+${reservation.user.lastName}" 
                                     alt="${reservation.user.username}">
                            </div>
                            <div class="ml-4">
                                <div class="text-sm font-medium text-gray-900">${reservation.user.firstName} ${reservation.user.lastName}</div>
                                <a href="mailto:${reservation.user.email}"><div class="text-sm text-gray-500">${reservation.user.email}</div></a>
                            </div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${reservation.room.name}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <div>${formatDate(reservation.startDate, 'EEEE, MMMM d, yyyy')}</div>
                        <div class="text-gray-500">
                            ${formatDate(reservation.startDate, 'h:mm a')} - 
                            ${formatDate(reservation.endDate, 'h:mm a')}
                            (${calculateDuration(reservation.startDate, reservation.endDate)} hours)
                        </div>
                    </td>
                    <td class="px-6 py-4">
                        <div class="font-medium">${reservation.title}</div>
                        <div class="text-sm text-gray-500 truncate max-w-xs">${reservation.purpose}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <a href="manager/reservations?action=view&id=${reservation.id}" 
                            class="text-blue-600 hover:text-blue-900 mr-1"
                            title="View">
                            <i class="fas fa-info-circle"></i>
                        </a>
                        <a href="#" onclick="showApproveModal(${reservation.id})" 
                           class="text-green-600 hover:text-green-900 mr-1"
                           title="Approve">
                            <i class="fas fa-check-circle"></i>
                        </a>
                        <a href="#" onclick="showRejectModal(${reservation.id})" 
                           class="text-red-600 hover:text-red-900 mr-1"
                           title="Reject">
                            <i class="fas fa-times-circle"></i>
                        </a>
                    </td>
                `;
                tbody.appendChild(row);
            });
            
            // Update "View all" count
            const viewAllLink = document.querySelector('.view-all-link');
            viewAllLink.textContent = `View all ${totalCount} pending requests`;
            
            // Build the appropriate query string based on filter
            let queryString = '';
            const today = new Date().toISOString().split('T')[0];
            
            switch(filter) {
                case 'today':
                    queryString = `?searchType=date&query=${today}&status=pending`;
                    break;
                case 'week':
                    const weekStart = new Date();
                    weekStart.setDate(weekStart.getDate() - weekStart.getDay()); // Start of week (Sunday)
                    const weekEnd = new Date(weekStart);
                    weekEnd.setDate(weekStart.getDate() + 6); // End of week (Saturday)
                    
                    const formatDate = (date) => date.toISOString().split('T')[0];
                    queryString = `?searchType=date&query=${formatDate(weekStart)}%20to%20${formatDate(weekEnd)}&status=pending`;
                    break;
                default: // 'all'
                    queryString = '?status=pending';
            }
            
            viewAllLink.href = `${viewAllLink.dataset.baseUrl}${queryString}`;
        })
        .catch(error => console.error('Error:', error));
}

// Helper functions
function formatDate(dateString, format) {
    const date = new Date(dateString);
    
    // Return empty string for invalid dates
    if (isNaN(date.getTime())) return '';
    
    // Define format replacements
    const options = {
        weekday: { EEEE: 'long', EEE: 'short' },
        month: { MMMM: 'long', MMM: 'short', MM: '2-digit', M: 'numeric' },
        day: { dd: '2-digit', d: 'numeric' },
        year: { yyyy: 'numeric', yy: '2-digit' },
        hour: { HH: '2-digit', H: 'numeric', hh: '2-digit', h: 'numeric' },
        minute: { mm: '2-digit', m: 'numeric' },
        second: { ss: '2-digit', s: 'numeric' },
        meridiem: { a: 'lowercase', A: 'uppercase' }
    };
    
    // Create format-to-Intl mapping
    const formatMap = {
        'EEEE': { weekday: 'long' },
        'EEE': { weekday: 'short' },
        'MMMM': { month: 'long' },
        'MMM': { month: 'short' },
        'MM': { month: '2-digit' },
        'M': { month: 'numeric' },
        'dd': { day: '2-digit' },
        'd': { day: 'numeric' },
        'yyyy': { year: 'numeric' },
        'yy': { year: '2-digit' },
        'HH': { hour: '2-digit', hour12: false },
        'H': { hour: 'numeric', hour12: false },
        'hh': { hour: '2-digit', hour12: true },
        'h': { hour: 'numeric', hour12: true },
        'mm': { minute: '2-digit' },
        'm': { minute: 'numeric' },
        'ss': { second: '2-digit' },
        's': { second: 'numeric' },
        'a': { hour: 'numeric', hour12: true }
    };
    
    // Handle common format patterns
    if (formatMap[format]) {
        return date.toLocaleString(undefined, formatMap[format]);
    }
    
    // Replace format patterns with actual values
    return format.replace(/(EEEE|EEE|MMMM|MMM|MM|M|dd|d|yyyy|yy|HH|H|hh|h|mm|m|ss|s|a|A)/g, (match) => {
        switch (match) {
            case 'EEEE': return date.toLocaleDateString(undefined, { weekday: 'long' });
            case 'EEE': return date.toLocaleDateString(undefined, { weekday: 'short' });
            case 'MMMM': return date.toLocaleDateString(undefined, { month: 'long' });
            case 'MMM': return date.toLocaleDateString(undefined, { month: 'short' });
            case 'MM': return String(date.getMonth() + 1).padStart(2, '0');
            case 'M': return String(date.getMonth() + 1);
            case 'dd': return String(date.getDate()).padStart(2, '0');
            case 'd': return String(date.getDate());
            case 'yyyy': return String(date.getFullYear());
            case 'yy': return String(date.getFullYear()).slice(-2);
            case 'HH': return String(date.getHours()).padStart(2, '0');
            case 'H': return String(date.getHours());
            case 'hh': 
                const hours12 = date.getHours() % 12 || 12;
                return String(hours12).padStart(2, '0');
            case 'h':
                return String(date.getHours() % 12 || 12);
            case 'mm': return String(date.getMinutes()).padStart(2, '0');
            case 'm': return String(date.getMinutes());
            case 'ss': return String(date.getSeconds()).padStart(2, '0');
            case 's': return String(date.getSeconds());
            case 'a': return date.getHours() < 12 ? 'am' : 'pm';
            case 'A': return date.getHours() < 12 ? 'AM' : 'PM';
            default: return match;
        }
    });
}

function calculateDuration(startDate, endDate) {
    const diff = new Date(endDate) - new Date(startDate);
    return (diff / (1000 * 60 * 60)).toFixed(1);
}

// Print the schedule table
function printSchedule() {
    // Clone the table to avoid affecting the main page
    const printWindow = window.open('', '_blank');
    const table = document.querySelector('.room-schedule').cloneNode(true);
    
    // Create print-friendly styles
    const styles = `
        <style>
            body { font-family: Arial, sans-serif; margin: 1cm; }
            table { width: 100%; border-collapse: collapse; }
            th, td { padding: 8px 12px; border: 1px solid #ddd; text-align: left; }
            th { background-color: #f5f5f5; font-weight: bold; }
            .approved { background-color: #d4edda; color: #155724; }
            .pending { background-color: #fff3cd; color: #856404; }
            .cancelled { background-color: #f8d7da; color: #721c24; }
            h1 { text-align: center; margin-bottom: 20px; }
            .print-date { text-align: right; margin-bottom: 10px; }
        </style>
    `;
    
    // Add title and print date
    const title = `<h1>Today's Room Schedule</h1>
                  <div class="print-date">Printed: ${new Date().toLocaleString()}</div>`;
    
    // Write to the print window
    printWindow.document.write(`
        <html>
            <head>
                <title>Today's Room Schedule</title>
                ${styles}
            </head>
            <body>
                ${title}
                ${table.outerHTML}
                <script>
                    window.onload = function() {
                        setTimeout(function() {
                            window.print();
                            window.close();
                        }, 200);
                    };
                </script>
            </body>
        </html>
    `);
    printWindow.document.close();
}

// Refresh the schedule data
function refreshSchedule() {
    const refreshBtn = document.querySelector('.refresh-schedule-btn');
    
    // Show loading state
    refreshBtn.disabled = true;
    refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i> Refreshing';
    
    // Fetch updated data
    fetch(`manager?refresh=true`, {
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) throw new Error('Network response was not ok');
        return response.text();
    })
    .then(html => {
        // Parse the response and replace the schedule section
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const newSchedule = doc.querySelector('.bg-white.p-6.rounded-lg.shadow-sm.mb-6');
        
        if (newSchedule) {
            document.querySelector('.bg-white.p-6.rounded-lg.shadow-sm.mb-6')
                .replaceWith(newSchedule);
            
            // Show success feedback
            showToast('Schedule refreshed successfully', 'success');
        }
    })
    .catch(error => {
        console.error('Error refreshing schedule:', error);
        showToast('Failed to refresh schedule', 'error');
    })
    .finally(() => {
        // Reset button state
        setTimeout(() => {
            refreshBtn.disabled = false;
            refreshBtn.innerHTML = '<i class="fas fa-sync-alt mr-1"></i> Refresh';
        }, 1000);
        attachScheduleEventListeners();
    });
}

// Helper function to show toast notifications
function showToast(message, type = 'info') {
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

function attachScheduleEventListeners() {
    // Re-attach event listeners to the new elements
    document.querySelector('.print-schedule-btn')?.addEventListener('click', printSchedule);
    document.querySelector('.refresh-schedule-btn')?.addEventListener('click', refreshSchedule);
}