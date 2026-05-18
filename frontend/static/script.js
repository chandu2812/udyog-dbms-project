// =============================================
// 🌐 ONLINE JOB PORTAL - JAVASCRIPT
// =============================================

// Auto-hide alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function () {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s ease';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });
});

// Confirm before dangerous actions
function confirmAction(message) {
    return confirm(message || 'Are you sure you want to proceed?');
}

// Format salary in Indian Rupees
function formatSalary(amount) {
    return '₹' + new Intl.NumberFormat('en-IN').format(amount);
}

// Toggle company field on register page
document.addEventListener('DOMContentLoaded', function () {
    const userTypeRadios = document.querySelectorAll('input[name="user_type"]');
    const companyField = document.getElementById('company_field');

    if (userTypeRadios.length > 0 && companyField) {
        userTypeRadios.forEach(radio => {
            radio.addEventListener('change', function () {
                if (this.value === 'employer') {
                    companyField.style.display = 'block';
                } else {
                    companyField.style.display = 'none';
                }
            });
        });
    }
});

// Search with debounce
let searchTimeout;
const searchInput = document.querySelector('.search-bar input');
if (searchInput) {
    searchInput.addEventListener('input', function () {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            console.log('Searching for:', this.value);
        }, 500);
    });
}

// Smooth scroll to top
function scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
}