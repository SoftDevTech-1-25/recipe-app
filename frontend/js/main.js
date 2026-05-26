// ============================================
// Recipe Book: Minecraft Edition — Frontend JS
// ============================================

const BASE_URL = "http://10.211.171.246:8080/api";
// const BASE_URL = "http://192.168.1.XX:8080/api";

// ============================================
// 1. Анимация появления карточек (IntersectionObserver)
// ============================================
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.08 });

function observeElement(el, index = 0) {
  el.style.opacity = '0';
  el.style.transform = 'translateY(16px)';
  el.style.transition = `opacity 0.35s ease ${index * 0.06}s, transform 0.35s ease ${index * 0.06}s, box-shadow 0.15s`;
  observer.observe(el);
}

function initStaticAnimations() {
  document.querySelectorAll('.step-card, .recipe-card, .feed-card').forEach((el, i) => {
    observeElement(el, i);
  });
}

// ============================================
// 2. API Layer
// ============================================
async function apiGet(endpoint) {
  try {
    const res = await fetch(`${BASE_URL}${endpoint}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return await res.json();
  } catch (err) {
    console.error('API GET error:', err);
    showToast('⚠️ Ошибка загрузки данных', 'error');
    throw err;
  }
}

async function apiPost(endpoint, body) {
  try {
    const res = await fetch(`${BASE_URL}${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return await res.json();
  } catch (err) {
    console.error('API POST error:', err);
    showToast('⚠️ Ошибка сохранения', 'error');
    throw err;
  }
}

async function apiDelete(endpoint) {
  try {
    const res = await fetch(`${BASE_URL}${endpoint}`, { method: 'DELETE' });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return await res.json();
  } catch (err) {
    console.error('API DELETE error:', err);
    showToast('⚠️ Ошибка удаления', 'error');
    throw err;
  }
}

// ============================================
// 3. State
// ============================================
const state = {
  recipes: [],
  filtered: [],
  loading: false,
  activeCategory: 'all',
  activeRecipe: null
};

// ============================================
// 4. Render
// ============================================
function createRecipeCard(recipe, index) {
  const div = document.createElement('div');
  div.className = 'recipe-card';
  div.dataset.id = recipe.id;
  div.innerHTML = `
    <div class="recipe-image-wrapper">
      <img src="${recipe.image || '/img/placeholder.png'}" alt="${recipe.title}" loading="lazy">
      <span class="recipe-category">${recipe.category || 'Разное'}</span>
    </div>
    <div class="recipe-body">
      <h3>${recipe.title}</h3>
      <div class="recipe-meta">
        <span>⏱ ${recipe.time || '?'} мин</span>
        <span>📊 ${recipe.difficulty || 'Легко'}</span>
      </div>
      <p class="recipe-desc">${recipe.description || ''}</p>
    </div>
  `;
  div.addEventListener('click', () => openRecipeDetail(recipe.id));
  observeElement(div, index);
  return div;
}

function renderList(recipes) {
  const container = document.getElementById('recipes-container');
  if (!container) return;

  container.innerHTML = '';

  if (recipes.length === 0) {
    container.innerHTML = `
      <div class="empty-state">
        <div class="empty-icon">🔍</div>
        <p>Ничего не найдено</p>
        <span>Попробуй изменить запрос или добавь новый рецепт</span>
      </div>`;
    return;
  }

  recipes.forEach((r, i) => {
    container.appendChild(createRecipeCard(r, i));
  });
}

function renderCraftingGrid(ingredients) {
  // ingredients — массив из 9 элементов (null для пустых слотов)
  const grid = document.createElement('div');
  grid.className = 'crafting-grid';
  (ingredients || Array(9).fill(null)).forEach(item => {
    const slot = document.createElement('div');
    slot.className = 'crafting-slot' + (item ? ' filled' : '');
    if (item) {
      slot.innerHTML = `<img src="${item.image}" alt="${item.name}" title="${item.name}">`;
    }
    grid.appendChild(slot);
  });
  return grid;
}

function openRecipeDetail(id) {
  const recipe = state.recipes.find(r => r.id == id);
  if (!recipe) return;
  state.activeRecipe = recipe;

  const modal = document.getElementById('recipe-modal');
  const title = document.getElementById('modal-title');
  const content = document.getElementById('modal-content');
  if (!modal || !content) return;

  title.textContent = recipe.title;
  content.innerHTML = `
    <div class="modal-image">
      <img src="${recipe.image || '/img/placeholder.png'}" alt="${recipe.title}">
    </div>
    <div class="modal-info">
      <p><strong>Категория:</strong> ${recipe.category || 'Разное'}</p>
      <p><strong>Время:</strong> ${recipe.time || '?'} мин</p>
      <p><strong>Сложность:</strong> ${recipe.difficulty || 'Легко'}</p>
      <p>${recipe.description || ''}</p>
    </div>
    <div class="modal-crafting">
      <h4>Сетка крафта 3×3</h4>
    </div>
    <div class="modal-result">
      <h4>Результат</h4>
      <div class="result-slot">
        <img src="${recipe.resultImage || recipe.image || '/img/placeholder.png'}" alt="${recipe.title}">
        <span>${recipe.resultCount || 1} шт.</span>
      </div>
    </div>
  `;

  const craftingContainer = content.querySelector('.modal-crafting');
  craftingContainer.appendChild(renderCraftingGrid(recipe.ingredients));

  modal.classList.add('open');
}

function closeModal() {
  document.getElementById('recipe-modal')?.classList.remove('open');
  state.activeRecipe = null;
}

// ============================================
// 5. Toast уведомления
// ============================================
function showToast(message, type = 'info') {
  const container = document.getElementById('toast-container') || createToastContainer();
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.textContent = message;
  container.appendChild(toast);

  requestAnimationFrame(() => toast.classList.add('show'));
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}

function createToastContainer() {
  const div = document.createElement('div');
  div.id = 'toast-container';
  div.style.cssText = 'position:fixed;top:20px;right:20px;z-index:9999;display:flex;flex-direction:column;gap:8px;';
  document.body.appendChild(div);
  return div;
}

// ============================================
// 6. Events & Search
// ============================================
let searchTimeout;
function handleSearch(query) {
  const q = query.toLowerCase().trim();
  state.filtered = q
    ? state.recipes.filter(r =>
        r.title.toLowerCase().includes(q) ||
        (r.description && r.description.toLowerCase().includes(q)) ||
        (r.category && r.category.toLowerCase().includes(q))
      )
    : [...state.recipes];
  renderList(state.filtered);
}

function setupEventListeners() {
  // Поиск
  const searchInput = document.getElementById('search-input');
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      clearTimeout(searchTimeout);
      searchTimeout = setTimeout(() => handleSearch(e.target.value), 250);
    });
  }

  // Фильтр по категориям
  document.querySelectorAll('.category-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const cat = btn.dataset.category || 'all';
      state.activeCategory = cat;
      state.filtered = cat === 'all'
        ? [...state.recipes]
        : state.recipes.filter(r => r.category === cat);
      renderList(state.filtered);
    });
  });

  // Модалка — закрытие
  document.getElementById('modal-close')?.addEventListener('click', closeModal);
  document.getElementById('recipe-modal')?.addEventListener('click', (e) => {
    if (e.target.id === 'recipe-modal') closeModal();
  });
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeModal();
  });

  // Форма добавления рецепта
  const form = document.getElementById('add-recipe-form');
  if (form) {
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const formData = new FormData(form);
      const recipe = {
        title: formData.get('title'),
        category: formData.get('category'),
        time: parseInt(formData.get('time')) || 0,
        difficulty: formData.get('difficulty'),
        description: formData.get('description'),
        image: formData.get('image') || '/img/placeholder.png',
        ingredients: [] // TODO: собрать из формы если есть
      };
      try {
        const saved = await apiPost('/recipes', recipe);
        state.recipes.unshift(saved);
        state.filtered = [...state.recipes];
        renderList(state.filtered);
        form.reset();
        showToast('✅ Рецепт добавлен!');
      } catch (err) {
        // ошибка уже обработана в apiPost
      }
    });
  }
}

// ============================================
// 7. Main Loader
// ============================================
async function loadRecipes() {
  state.loading = true;
  document.getElementById('recipes-container')?.classList.add('loading');
  try {
    const data = await apiGet('/recipes');
    state.recipes = data || [];
    state.filtered = [...state.recipes];
    renderList(state.filtered);
  } catch (err) {
    renderList([]);
  } finally {
    state.loading = false;
    document.getElementById('recipes-container')?.classList.remove('loading');
  }
}

// ============================================
// 8. Init
// ============================================
function init() {
  initStaticAnimations();
  setupEventListeners();
  loadRecipes();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}