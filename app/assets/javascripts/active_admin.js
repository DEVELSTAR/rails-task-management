//= require active_admin/base

document.addEventListener('DOMContentLoaded', function() {
  // Select flash messages container (Active Admin uses #flash for notices)
  const flashContainer = document.querySelector('.flashes');
  if (flashContainer) {
    // Hide flash messages after 5 seconds with fade-out effect
    setTimeout(() => {
      flashContainer.style.transition = 'opacity 0.5s ease';
      flashContainer.style.opacity = '0';
      // Remove from DOM after fade-out to prevent interaction
      setTimeout(() => {
        flashContainer.remove();
      }, 200); // Match transition duration
    }, 2000); // 5 seconds delay
  }
});
