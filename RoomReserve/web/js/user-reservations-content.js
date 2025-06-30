const startDate = document.getElementById('startDate');
// Initialize flatpickr for date input
datePicker = flatpickr(startDate, {
    dateFormat: 'Y-m-d',
    mode: "range",
    //allowInput: true,
    placeholder: 'Select a date'
});

function openCancelModal(reservationId) {
    document.getElementById('cancel-reservation-id').value = reservationId;
    document.getElementById('cancel-modal').classList.remove('hidden');
}

function closeCancelModal() {
    document.getElementById('cancel-form').reset();
    document.getElementById('cancel-modal').classList.add('hidden');
}

// Close modals when clicking outside
window.onclick = function(event) {
    if (event.target == document.getElementById('cancel-modal')) {
        closeCancelModal();
    }
}

async function handleCheckIn(reservationId) {
    const response = await fetch(`${BASE_PATH}/user/checkin`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `reservationId=`+ reservationId
    });

    const result = await response.json();

    if (result.success) {
        Swal.fire({
            icon: 'success',
            title: 'Success',
            text: result.message
        });
        updateUIAfterCheckIn(reservationId);
    } else {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: result.message
            }); 
    }
}


function updateUIAfterCheckIn(reservationId) {
    const row = document.querySelector('tr[data-reservation-id="'+reservationId+'"]');
    if (row) {
        row.classList.add('bg-blue-50');
        setTimeout(() => {
            // Rest of your update logic
            const statusCell = row.querySelector('td:nth-child(5)');
            if (statusCell) {
                statusCell.innerHTML = `
                    <span class="px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">
                        Completed
                    </span>
                `;
            }

            // 3. Update the actions cell - remove check-in button
            const actionsCell = row.querySelector('td:nth-child(6)');
            if (actionsCell) {
                // Clone existing links except the check-in button
                const links = actionsCell.querySelectorAll('a:not([onclick])');
                console.log(links);
                actionsCell.innerHTML = '';

                links.forEach(link => {
                    actionsCell.appendChild(link.cloneNode(true));
                });
            }
            row.classList.remove('bg-blue-50');
        }, 1000);
    }
}
