// CraftCook — main.js

// Анимация появления карточек при скролле
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.08 });

document.querySelectorAll('.step-card, .recipe-card, .feed-card').forEach((el, i) => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(16px)';
  el.style.transition = `opacity 0.35s ease ${i * 0.06}s, transform 0.35s ease ${i * 0.06}s, box-shadow 0.15s`;
  observer.observe(el);
});