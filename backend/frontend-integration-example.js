// Пример интеграции с recipes.html
// Вставь в <script> или подключи как модуль

import { fetchRecipes, fetchTags, addFavorite, removeFavorite } from './js/api.js';

// Замени статичные карточки на динамические
async function loadRecipes() {
  try {
    const { data: recipes } = await fetchRecipes({ limit: 50 });
    const container = document.getElementById("recipeList");
    container.innerHTML = "";

    recipes.forEach(recipe => {
      const tagsStr = (recipe.tags || []).map(t => t.name).join(",");
      const difficultyText = ["", "лёгкий", "простой", "средний", "сложный", "эксперт"][recipe.difficulty] || "";

      const card = document.createElement("div");
      card.className = "feed-card";
      card.dataset.tags = tagsStr;
      card.onclick = () => location.href = `recipe-detail.html?id=${recipe.id}`;

      card.innerHTML = `
        <div class="feed-img">${recipe.emoji || "🍽"}</div>
        <div class="feed-body">
          <h3 class="feed-title">${recipe.title.toUpperCase()}</h3>
          <div class="feed-tags">
            ${(recipe.tags || []).map(t => `<span class="tag g">${t.name}</span>`).join("")}
            <span class="tag y">${recipe.prep_time} мин</span>
            <span class="tag ${recipe.difficulty <= 2 ? 'g' : recipe.difficulty >= 4 ? 'rd' : 'y'}">${difficultyText}</span>
          </div>
        </div>
        <button class="fav-btn" data-id="${recipe.id}">⭐</button>
      `;

      // Favorite handler
      const favBtn = card.querySelector(".fav-btn");
      favBtn.onclick = async (e) => {
        e.stopPropagation();
        const isActive = favBtn.classList.toggle("active");
        try {
          if (isActive) await addFavorite(recipe.id);
          else await removeFavorite(recipe.id);
        } catch (err) {
          console.error("Favorite error:", err);
          favBtn.classList.toggle("active"); // revert
        }
      };

      container.appendChild(card);
    });
  } catch (err) {
    console.error("Failed to load recipes:", err);
    document.getElementById("recipeList").innerHTML = `
      <div style="padding:1rem; color:#b03030;">
        ⚠ Сервер недоступен. Убедись, что бэкенд запущен на localhost:8080
      </div>
    `;
  }
}

// Загрузить теги в боковую панель
async function loadTags() {
  try {
    const tags = await fetchTags();
    const catList = document.getElementById("catList");
    // Очистить старые статичные теги
    catList.innerHTML = tags.map(t =>
      `<li class="cat-item" onclick="filterByTag('${t.name}')">□ ${t.name}</li>`
    ).join("");
  } catch (err) {
    console.log("Using static tags (server unavailable)");
  }
}

// Инициализация
document.addEventListener("DOMContentLoaded", () => {
  loadRecipes();
  loadTags();
});
