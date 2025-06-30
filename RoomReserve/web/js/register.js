// Password strength validation
document.getElementById('password').addEventListener('input', function () {
    const password = this.value;
    const strengthBar = document.getElementById('strength-bar');
    const strengthText = document.getElementById('strength-text');
    const strengthIcon = document.getElementById('strength-icon');

    let strength = 0;

    if (password.length >= 8) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[a-z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^A-Za-z0-9]/.test(password)) strength++;

    const levels = [
      { label: 'Very Weak', color: 'bg-red-500'},
      { label: 'Weak', color: 'bg-orange-500'},
      { label: 'Fair', color: 'bg-yellow-500'},
      { label: 'Strong', color: 'bg-lime-500'},
      { label: 'Very Strong', color: 'bg-green-600'}
    ];

    const level = levels[Math.max(0, strength - 1)];

    strengthBar.className = `h-2 rounded transition-all duration-300 ease-in-out ` + level.color;
    strengthBar.style.width = `${(strength / 5) * 100}%`;

    strengthText.textContent = level.label;
});

function checkAvailability(type, value, callback) {
    fetch(`${BASE_PATH}/check-user`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({type, value })
    })
    .then(res => res.json())
    .then(data => callback(data.exists))
    .catch(err => {
        console.error("Check failed:", err);
        callback(false); // fail safe
    });
}

document.getElementById('username').addEventListener('blur', function() {
    const usernameInput = document.getElementById('username');
    const username = this.value;
    checkAvailability('username', username, function(exists) {
        if (exists) {
            usernameInput.value = '';
            Swal.fire({
                title: 'Username Taken',
                text: 'Please choose another username.',
                icon: 'warning'
            });
        }
    });
});

document.getElementById('email').addEventListener('blur', function() {
    const emailInput = document.getElementById('email');
    const email = this.value;
    checkAvailability('email', email, function(exists) {
        if (exists) {
            emailInput.value = '';
            Swal.fire({
                title: 'Email Already Registered',
                text: 'Try logging in or use another email.',
                icon: 'error'
            });
        }
    });
});

// Form validation
document.querySelector('form').addEventListener('submit', function(e) {
    e.preventDefault();

    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirm-password').value;

    if (password !== confirmPassword) {
        Swal.fire({
            title: 'Error',
            text: 'Passwords do not match!',
            icon: 'error'
        });
        return;
    }

    // Additional password strength check
    let strength = 0;
    if (password.length >= 8) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[a-z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^A-Za-z0-9]/.test(password)) strength++;

    if (strength < 3) {
        Swal.fire({
            title: 'Weak Password',
            text: 'Please choose a stronger password.',
            icon: 'warning'
        });
        return;
    }

    this.submit(); 
});