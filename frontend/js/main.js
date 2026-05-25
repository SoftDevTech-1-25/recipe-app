// Книга Рецептов — main.js

const BASE_URL = "http://localhost:8080"; // ← если на одном ПК
//const BASE_URL = "http://192.168.1.XX:8080"; // ← если на разных ПК

// Загрузить и отрисовать рецепты с бэкенда
async function loadRecipes() {
  try {
    const response = await fetch(`${BASE_URL}/api/recipes`);
    if (!response.ok) throw new Error(`Ошибка: ${response.status}`);

    const recipes = await response.json();
    renderRecipes(recipes);

  } catch (error) {
    console.error("Не удалось загрузить рецепты:", error);
    // Показываем ошибку в списке
    document.getElementById("recipeList").innerHTML = `
      <div style="padding:1rem; color:red;">⚠ Сервер недоступен. Запусти go run main.go</div>
    `;
  }
}

// Отрисовать рецепты в стиле feed-card (под HTML напарника)
function renderRecipes(recipes) {
  const list = document.getElementById("recipeList");
  list.innerHTML = ""; // очищаем старые карточки

  recipes.forEach(recipe => {
    const card = document.createElement("div");
    card.className = "feed-card";
    card.dataset.tags = (recipe.tags || []).join(",");
    card.onclick = () => location.href = "recipe-detail.html";

    card.innerHTML = `
      <div class="feed-img">${recipe.emoji || "🍽"}</div>
      <div class="feed-body">
        <h3 class="feed-title">${recipe.name.toUpperCase()}</h3>
        <div class="feed-tags">
          <span class="tag g">${recipe.difficulty}</span>
        </div>
      </div>
      <button class="fav-btn" onclick="event.stopPropagation(); this.classList.toggle('active')">⭐</button>
    `;

    list.appendChild(card);
  });
}

// Запуск
loadRecipes();

// Fade-in cards on scroll
const observer = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      e.target.style.opacity = "1";
      e.target.style.transform = "translateY(0)";
    }
  });
}, { threshold: 0.08 });

document.querySelectorAll(".recipe-card, .feat-box, .how-step").forEach(el => {
  el.style.opacity = "0";
  el.style.transition = "opacity 0.35s ease, transform 0.35s ease";
  el.style.transform = "translateY(16px)";
  observer.observe(el);
});

// Фильтрация по тегам и поиск (существующие функции)
let activeTag = null;

function filterByTag(tag) {
  const items = document.querySelectorAll(".cat-item");
  items.forEach(i => { i.textContent = i.textContent.replace("■", "□"); i.classList.remove("active"); });

  if (activeTag === tag) { activeTag = null; showAllRecipes(); return; }

  activeTag = tag;
  const clicked = [...items].find(i => i.textContent.includes(tag));
  if (clicked) { clicked.textContent = "■ " + tag; clicked.classList.add("active"); }

  document.querySelectorAll(".feed-card").forEach(card => {
    const tags = card.dataset.tags || "";
    card.style.display = tags.includes(tag) ? "flex" : "none";
  });
}

function clearFilter() {
  activeTag = null;
  document.querySelectorAll(".cat-item").forEach(i => {
    i.textContent = "□ " + i.textContent.replace("■ ", "").replace("□ ", "");
    i.classList.remove("active");
  });
  showAllRecipes();
}

function showAllRecipes() {
  document.querySelectorAll(".feed-card").forEach(c => c.style.display = "flex");
}

function filterRecipes() {
  const q = document.getElementById("searchInput").value.toLowerCase();
  document.querySelectorAll(".feed-card").forEach(card => {
    const title = card.querySelector(".feed-title").textContent.toLowerCase();
    card.style.display = title.includes(q) ? "flex" : "none";
  });
}

function setSort(el) {
  document.querySelectorAll(".cat-item").forEach(i => {
    if (["По популярности","По сложности","По скорости готовки","Случайно"].some(s => i.textContent.includes(s))) {
      i.textContent = "□ " + i.textContent.replace("■ ","").replace("□ ","");
      i.classList.remove("active");
    }
  });
  el.textContent = "■ " + el.textContent.replace("□ ","").replace("■ ","");
  el.classList.add("active");
}

