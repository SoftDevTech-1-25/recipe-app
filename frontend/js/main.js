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

const BASE_URL = "http://192.168.X.X:8080"; // твой реальный IP // или IP твоего друга если на другом ПК

// Загрузить все рецепты
async function loadRecipes() {
    try {
        const response = await fetch(`${BASE_URL}/api/recipes`);

        if (!response.ok) throw new Error(`Ошибка: ${response.status}`);

        const recipes = await response.json();
        renderRecipes(recipes);

    } catch (error) {
        console.error("Не удалось загрузить рецепты:", error);
    }
}

// Отрисовать рецепты в майнкрафт-блоки
function renderRecipes(recipes) {
    const container = document.getElementById("recipes-container");
    container.innerHTML = "";

    recipes.forEach(recipe => {
        const card = document.createElement("div");
        card.className = "recipe-card";
        card.innerHTML = `
            <img src="/assets/icons/${recipe.image_slug}" alt="${recipe.name}" />
            <h3>${recipe.name}</h3>
            <p>Сложность: ${recipe.difficulty}</p>
        `;
        container.appendChild(card);
    });
}

// Запускаем сразу при загрузке страницы
loadRecipes();