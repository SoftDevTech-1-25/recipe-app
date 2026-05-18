// Книга Рецептов — main.js

// Fade-in cards on scroll
const observer = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      e.target.style.opacity = '1';
      e.target.style.transform = e.target.style.transform.replace('translateY(16px)', 'translateY(0)');
    }
  });
}, { threshold: 0.08 });

document.querySelectorAll('.recipe-card, .feat-box, .how-step').forEach(el => {
  el.style.opacity = '0';
  el.style.transition = (el.style.transition || '') + ', opacity 0.35s ease';
  observer.observe(el);
});


// Функция для получения рецептов с твоего бэкенда
async function loadRecipes() {
    try {
        const response = await fetch('http://localhost:8080/api/recipes');
        const recipes = await response.json();
        
        console.log(recipes); // Здесь будут твои Стейк и Золотое яблоко
        
        // Дальше он должен отрисовать их в свои майнкрафт-блоки
        renderRecipes(recipes); 
    } catch (error) {
        console.error("Ошибка при получении данных:", error);
    }
}
