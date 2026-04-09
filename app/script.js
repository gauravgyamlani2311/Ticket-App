document.addEventListener('DOMContentLoaded', () => {
    console.log("TicketApp Frontend Loaded");
    // Simple logic to highlight the active link
    const links = document.querySelectorAll('nav a');
    links.forEach(link => {
        if (link.href === window.location.href) {
            link.style.color = '#ff9900';
        }
    });
});