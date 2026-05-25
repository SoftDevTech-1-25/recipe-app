// api.js — готовый клиент для бэкенда "Книга Рецептов: Minecraft Edition"
// Вставь этот файл в папку js/ проекта

const BASE_URL = "http://localhost:8080/api";

// ─── УТИЛИТЫ ───

function getToken() {
  return localStorage.getItem("token");
}

function authHeaders() {
  const token = getToken();
  return token ? { "Authorization": `Bearer ${token}` } : {};
}

async function apiFetch(path, options = {}) {
  const url = `${BASE_URL}${path}`;
  const res = await fetch(url, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...authHeaders(),
      ...options.headers,
    },
  });

  if (!res.ok) {
    const err = await res.json().catch(() => ({ error: "Unknown error" }));
    throw new Error(err.error || `HTTP ${res.status}`);
  }

  // DELETE/204 — без тела
  if (res.status === 204) return null;
  return res.json();
}

// ─── AUTH ───

export async function register(username, email, password) {
  const data = await apiFetch("/auth/register", {
    method: "POST",
    body: JSON.stringify({ username, email, password }),
  });
  localStorage.setItem("token", data.token);
  localStorage.setItem("user", JSON.stringify(data.user));
  return data;
}

export async function login(email, password) {
  const data = await apiFetch("/auth/login", {
    method: "POST",
    body: JSON.stringify({ email, password }),
  });
  localStorage.setItem("token", data.token);
  localStorage.setItem("user", JSON.stringify(data.user));
  return data;
}

export function logout() {
  localStorage.removeItem("token");
  localStorage.removeItem("user");
}

export function getUser() {
  const raw = localStorage.getItem("user");
  return raw ? JSON.parse(raw) : null;
}

export function isLoggedIn() {
  return !!getToken();
}

// ─── RECIPES ───

export async function fetchRecipes(params = {}) {
  // params: { search, category, tag, time_max, page, limit, sort, order }
  const qs = new URLSearchParams();
  Object.entries(params).forEach(([k, v]) => { if (v) qs.append(k, v); });
  return apiFetch(`/recipes?${qs}`);
}

export async function fetchRecipe(id) {
  return apiFetch(`/recipes/${id}`);
}

export async function createRecipe(recipe) {
  // recipe: { title, description, prep_time, difficulty, servings, emoji, tags, ingredients, steps, ... }
  return apiFetch("/recipes", { method: "POST", body: JSON.stringify(recipe) });
}

export async function updateRecipe(id, recipe) {
  return apiFetch(`/recipes/${id}`, { method: "PUT", body: JSON.stringify(recipe) });
}

export async function deleteRecipe(id) {
  return apiFetch(`/recipes/${id}`, { method: "DELETE" });
}

export async function scaleRecipe(id, servings) {
  return apiFetch(`/recipes/${id}/scale?servings=${servings}`);
}

// ─── FAVORITES ───

export async function addFavorite(recipeId) {
  return apiFetch(`/recipes/${recipeId}/favorite`, { method: "POST" });
}

export async function removeFavorite(recipeId) {
  return apiFetch(`/recipes/${recipeId}/favorite`, { method: "DELETE" });
}

export async function fetchFavorites() {
  return apiFetch("/favorites");
}

// ─── CATEGORIES & TAGS ───

export async function fetchCategories() {
  return apiFetch("/categories");
}

export async function fetchTags() {
  return apiFetch("/tags");
}

// ─── MEAL PLANS ───

export async function fetchMealPlans(from, to) {
  return apiFetch(`/meal-plans?from=${from}&to=${to}`);
}

export async function createMealPlan({ recipe_id, date, meal_type, servings }) {
  return apiFetch("/meal-plans", {
    method: "POST",
    body: JSON.stringify({ recipe_id, date, meal_type, servings }),
  });
}

export async function updateMealPlan(id, data) {
  return apiFetch(`/meal-plans/${id}`, { method: "PUT", body: JSON.stringify(data) });
}

export async function deleteMealPlan(id) {
  return apiFetch(`/meal-plans/${id}`, { method: "DELETE" });
}

export async function generateShoppingList(from, to) {
  return apiFetch(`/meal-plans/generate-shopping?from=${from}&to=${to}`, { method: "POST" });
}

// ─── SHOPPING LIST ───

export async function fetchShoppingList() {
  return apiFetch("/shopping-list");
}

export async function checkShoppingItem(id, isChecked) {
  return apiFetch(`/shopping-list/${id}`, {
    method: "PUT",
    body: JSON.stringify({ is_checked: isChecked }),
  });
}

export async function deleteShoppingItem(id) {
  return apiFetch(`/shopping-list/${id}`, { method: "DELETE" });
}

export async function clearShoppingList() {
  return apiFetch("/shopping-list/clear", { method: "DELETE" });
}

// ─── USER ───

export async function fetchProfile() {
  return apiFetch("/users/me");
}

export async function updateProfile(data) {
  return apiFetch("/users/me", { method: "PUT", body: JSON.stringify(data) });
}
