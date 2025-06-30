async function checkRoomAvailability(event) {
    event.preventDefault();
    
    const validation = validateReservation();
    if (validation && validation.isValid) {
    
        const roomId = document.getElementById('roomId').value;
        const reservationDate = document.getElementById('reservationDate').value;
        const startTime = document.getElementById('startTime').value;
        const endTime = document.getElementById('endTime').value;
        
        const startDateTime = `${reservationDate}T${startTime}:00`;
        const endDateTime = `${reservationDate}T${endTime}:00`;

        const submitBtn = document.querySelector('#reservationForm button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.innerHTML = 'Checking availability...';

        try {
            const response = await fetch(`${BASE_PATH}/user/checkAvailability`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    roomId,
                    startDateTime,
                    endDateTime
                })
            });

            // First check if response is OK
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            // Then try to parse JSON
            const data = await response.json();

            if (data.available) {
                document.getElementById('reservationForm').submit();
            } else {
                showError(data.message || 'Room is not available at the selected time');
            }
        } catch (error) {
            console.error('Error:', error);
            showError('An error occurred while checking availability. Please try again.');
        } finally {
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Submit Reservation';
        }
    }
}

async function checkRoomAvailabilityForUpdate(event) {
    event.preventDefault();
    
    const validation = validateReservation();
    if (validation && validation.isValid) {
    
        const reservationId = document.getElementById('reservationId').value;
        const roomId = document.getElementById('roomId').value;
        const reservationDate = document.getElementById('reservationDate').value;
        const startTime = document.getElementById('startTime').value;
        const endTime = document.getElementById('endTime').value;
        
        const startDateTime = `${reservationDate}T${startTime}:00`;
        const endDateTime = `${reservationDate}T${endTime}:00`;

        const submitBtn = document.querySelector('#reservationForm button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.innerHTML = 'Checking availability...';

        try {
            const response = await fetch(`${BASE_PATH}/user/checkAvailabilityForUpdate`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    reservationId,
                    roomId,
                    startDateTime,
                    endDateTime
                })
            });

            // First check if response is OK
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            // Then try to parse JSON
            const data = await response.json();

            if (data.available) {
                document.getElementById('reservationForm').submit();
            } else {
                showError(data.message || 'Room is not available at the selected time');
            }
        } catch (error) {
            console.error('Error:', error);
            showError('An error occurred while checking availability. Please try again.');
        } finally {
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Update Reservation';
        }
    }
}

function showError(message) {
    // Replace with your preferred error display method
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: message
    });
} 

function validateReservation() {
    const startTimeInput = document.getElementById('startTime');
    const endTimeInput = document.getElementById('endTime');
    const dateInput = document.getElementById('reservationDate');
    const errorElement = document.getElementById('bookingError');

    // Get system settings from earlier configuration
    const minHours = bookingConfig.minBookingHours;
    const maxDays = bookingConfig.maxBookingDays;
    const allowWeekends = bookingConfig.allowWeekends;
    const minDuration = bookingConfig.minBookingDuration;
    const maxDuration = bookingConfig.maxBookingDuration;
    const allowBusinessHours = bookingConfig.allowBusinessHours;

    // Clear previous errors
    errorElement.textContent = '';
    errorElement.classList.add('hidden');


    // Validate date selection
    if (!dateInput.value) {
        showErrorMessage('Please select a date');
        return false;
    }

    const selectedDate = new Date(dateInput.value);
    const now = new Date();

    // Check if date is in the past
    if (selectedDate.setHours(0,0,0,0) < now.setHours(0,0,0,0)) {
        showErrorMessage('Cannot select a date in the past');
        dateInput.value = '';
        return false;
    }

    // Check max booking days
    const maxBookingDate = new Date();
    maxBookingDate.setDate(maxBookingDate.getDate() + maxDays);

    if (selectedDate > maxBookingDate) {
        showErrorMessage(`Reservations can only be made up to ${maxDays} days in advance`);
        dateInput.value = '';
        return false;
    }

    // Check weekend bookings if not allowed
    if (!allowWeekends && (selectedDate.getDay() === 0 || selectedDate.getDay() === 6)) {
        showErrorMessage('Weekend bookings are not allowed');
        dateInput.value = '';
        return false;
    }

    if (!startTimeInput.value || !endTimeInput.value) {
        showErrorMessage('Please select both start and end times');
        return false;
    }

    // Create full datetime objects
    const [startHours, startMinutes] = startTimeInput.value.split(':').map(Number);
    const [endHours, endMinutes] = endTimeInput.value.split(':').map(Number);

    const startDateTime = new Date(selectedDate);
    startDateTime.setHours(startHours, startMinutes);

    const endDateTime = new Date(selectedDate);
    endDateTime.setHours(endHours, endMinutes);

    // 6. Check if end time is after start time
    if (endDateTime <= startDateTime) {
        showErrorMessage('End time must be after start time');
        endTimeInput.value = '';
        return false;
    }
    
    // 7. Check minimum booking duration (optional)
    const durationMinutes = (endDateTime - startDateTime) / (1000 * 60);
    
    if (durationMinutes < minDuration) { 
        showErrorMessage(`Minimum booking duration is ${minDuration} minutes`);
        return false;
    }
    
    // 8. Check maximum booking duration (optional)
    if (durationMinutes > maxDuration) { 
        showErrorMessage(`Maximum booking duration is ${maxDuration} minutes`);
        return false;
    }


    const minBookingTime = new Date();
    minBookingTime.setHours(minBookingTime.getHours() + minHours);

    if (startDateTime < minBookingTime) {
        showErrorMessage(`Reservations must be made at least ${minHours} hours in advance`);
        return false;
    }
    
    if (allowBusinessHours) {
        if (startHours < 8 || endHours > 18) {
            showErrorMessage(`Bookings are only available between 8:00 AM and 6:00 PM`);
            return false;
        }
    }

    // If all validations pass
    return {
        isValid: true,
        start: startDateTime.toISOString(),
        end: endDateTime.toISOString()
    };

}


flatpickr("#reservationDate", {
    altInput: true,
    altFormat: "F j, Y",
    minDate: "today",
    maxDate: new Date().fp_incr(bookingConfig.maxBookingDays),
    dateFormat: "Y-m-d",
    disable: bookingConfig.allowWeekends ? [] : [
        function(date) {
            // Disable weekends (0 = Sunday, 6 = Saturday)
            return (date.getDay() === 0 || date.getDay() === 6);
        }
    ]
});

// Initialize datetime pickers
const startPicker = flatpickr("#startTime", {
    enableTime: true,
    noCalendar: true,
    dateFormat: "H:i",
    onChange: function(selectedTimes, timeStr, instance) {
        endPicker.set("minTime", timeStr);
    }
});

const endPicker = flatpickr("#endTime", {
    enableTime: true,
    noCalendar: true,
    dateFormat: "H:i"
});

function showErrorMessage(message) {
    const errorElement = document.getElementById('bookingError');
    errorElement.textContent = message;
    errorElement.classList.remove('hidden');

    // Scroll to error for better UX
    errorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
}