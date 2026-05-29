-- ==================== RECIPE APP DATABASE INITIALIZATION ====================
-- This script creates all tables and loads sample data for the recipe app

-- ==================== CREATE TABLES ====================

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  avatar_url TEXT,
  theme TEXT DEFAULT 'overworld',
  units TEXT DEFAULT 'metric',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  icon_url TEXT,
  color TEXT DEFAULT '#FFFFFF'
);

-- Tags table
CREATE TABLE IF NOT EXISTS tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  color TEXT DEFAULT '#5a8a3c',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Ingredients table
CREATE TABLE IF NOT EXISTS ingredients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  icon_url TEXT,
  category TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Recipes table
CREATE TABLE IF NOT EXISTS recipes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  category_id INTEGER,
  prep_time INTEGER NOT NULL,
  difficulty INTEGER,
  servings INTEGER DEFAULT 2,
  image_url TEXT,
  emoji TEXT DEFAULT '🍽',
  is_public BOOLEAN DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Recipe Steps table
CREATE TABLE IF NOT EXISTS recipe_steps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recipe_id INTEGER NOT NULL,
  step_order INTEGER NOT NULL,
  description TEXT NOT NULL,
  duration INTEGER,
  image_url TEXT,
  FOREIGN KEY (recipe_id) REFERENCES recipes(id)
);

-- Recipe Ingredients table (many-to-many)
CREATE TABLE IF NOT EXISTS recipe_ingredients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recipe_id INTEGER NOT NULL,
  ingredient_id INTEGER NOT NULL,
  quantity REAL NOT NULL,
  unit TEXT NOT NULL,
  slot_position INTEGER,
  FOREIGN KEY (recipe_id) REFERENCES recipes(id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

-- Recipe Tags table (many-to-many)
CREATE TABLE IF NOT EXISTS recipe_tags (
  recipe_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  PRIMARY KEY (recipe_id, tag_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id)
);

-- Favorites table
CREATE TABLE IF NOT EXISTS favorites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  recipe_id INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(id)
);

-- ==================== INSERT CATEGORIES ====================

INSERT OR IGNORE INTO categories (id, name, icon_url, color) VALUES
(1, 'Веган', 'vegan_16x16.png', '#567D46'),
(2, 'Мясо', 'meat_16x16.png', '#8B4513'),
(3, 'Десерты', 'cake_16x16.png', '#FF69B4'),
(4, 'Итальянская', 'pasta_16x16.png', '#FFD700'),
(5, 'Быстрое', 'fast_16x16.png', '#00CED1'),
(6, 'Напитки', 'potion_16x16.png', '#4169E1'),
(7, 'Супы', 'soup_16x16.png', '#FF6347');

-- ==================== INSERT TAGS ====================

INSERT OR IGNORE INTO tags (id, name, color) VALUES
(1, 'острая', '#b03030'),
(2, 'сладкая', '#c04080'),
(3, 'солёная', '#6a6a5a'),
(4, 'кислая', '#c8a020'),
(5, 'веганская', '#5a8a3c'),
(6, 'вегетарианская', '#7ab84a'),
(7, 'мясная', '#8B4513'),
(8, 'рыбная', '#3a6a9a'),
(9, 'диетическая', '#7a4a9a'),
(10, 'полезная', '#5a8a3c'),
(11, 'жареная', '#b03030'),
(12, 'запечённая', '#c8a020'),
(13, 'домашняя', '#c8a020'),
(14, 'быстрая', '#00CED1'),
(15, 'праздничная', '#c04080'),
(16, 'с сыром', '#FFD700'),
(17, 'с курицей', '#c8a020'),
(18, 'с овощами', '#5a8a3c'),
(19, 'с морепродуктами', '#3a6a9a'),
(20, 'японское', '#3a6a9a');

-- ==================== INSERT GUEST USER ====================

INSERT OR IGNORE INTO users (id, username, email, password_hash, avatar_url, theme, units) VALUES
(1, 'guest', 'guest@local', '-', NULL, 'overworld', 'metric');

-- ==================== INSERT INGREDIENTS (50+ positions) ====================

INSERT OR IGNORE INTO ingredients (id, name, icon_url, category) VALUES
(1, 'Спагетти', 'spaghetti_16x16.png', 'Макароны'),
(2, 'Фарш говяжий', 'beef_16x16.png', 'Мясо'),
(3, 'Помидор', 'tomato_16x16.png', 'Овощи'),
(4, 'Лук', 'onion_16x16.png', 'Овощи'),
(5, 'Чеснок', 'garlic_16x16.png', 'Овощи'),
(6, 'Морковь', 'carrot_16x16.png', 'Овощи'),
(7, 'Картофель', 'potato_16x16.png', 'Овощи'),
(8, 'Молоко', 'milk_16x16.png', 'Молочка'),
(9, 'Яйцо', 'egg_16x16.png', 'Молочка'),
(10, 'Мука', 'flour_16x16.png', 'Бакалея'),
(11, 'Сахар', 'sugar_16x16.png', 'Бакалея'),
(12, 'Соль', 'salt_16x16.png', 'Специи'),
(13, 'Перец', 'pepper_16x16.png', 'Специи'),
(14, 'Подсолнечное масло', 'oil_16x16.png', 'Бакалея'),
(15, 'Сыр', 'cheese_16x16.png', 'Молочка'),
(16, 'Грибы', 'mushroom_16x16.png', 'Овощи'),
(17, 'Курица', 'chicken_16x16.png', 'Мясо'),
(18, 'Рис', 'rice_16x16.png', 'Бакалея'),
(19, 'Масло сливочное', 'butter_16x16.png', 'Молочка'),
(20, 'Сливки', 'cream_16x16.png', 'Молочка'),
(21, 'Красная свекла', 'beet_16x16.png', 'Овощи'),
(22, 'Капуста', 'cabbage_16x16.png', 'Овощи'),
(23, 'Говяжий бульон', 'beef_broth_16x16.png', 'Консервы'),
(24, 'Нори', 'nori_16x16.png', 'Макароны'),
(25, 'Лосось', 'salmon_16x16.png', 'Рыба'),
(26, 'Масло кунжутное', 'sesame_16x16.png', 'Бакалея'),
(27, 'Рисовая крупа', 'rice_grain_16x16.png', 'Бакалея'),
(28, 'Сок лимона', 'lemon_16x16.png', 'Напитки'),
(29, 'Авокадо', 'avocado_16x16.png', 'Овощи'),
(30, 'Соевый соус', 'soy_sauce_16x16.png', 'Приправы'),
(31, 'Нут', 'chickpea_16x16.png', 'Бобовые'),
(32, 'Оливковое масло', 'olive_oil_16x16.png', 'Бакалея'),
(33, 'Уксус', 'vinegar_16x16.png', 'Приправы'),
(34, 'Томатная паста', 'tomato_paste_16x16.png', 'Консервы'),
(35, 'Говяжий фарш', 'minced_beef_16x16.png', 'Мясо'),
(36, 'Баклажан', 'eggplant_16x16.png', 'Овощи'),
(37, 'Крем свежий', 'cream_fresh_16x16.png', 'Молочка'),
(38, 'Мёд', 'honey_16x16.png', 'Бакалея'),
(39, 'Кокосовое молоко', 'coconut_milk_16x16.png', 'Напитки'),
(40, 'Паста том ям', 'tom_yam_paste_16x16.png', 'Приправы'),
(41, 'Красный перец', 'red_pepper_16x16.png', 'Овощи'),
(42, 'Цедра лимона', 'lemon_zest_16x16.png', 'Специи'),
(43, 'Имбирь', 'ginger_16x16.png', 'Овощи'),
(44, 'Булка в форме', 'bun_16x16.png', 'Бакалея'),
(45, 'Панировка', 'breadcrumb_16x16.png', 'Бакалея'),
(46, 'Горошек зелёный', 'green_peas_16x16.png', 'Овощи'),
(47, 'Сырок плавленый', 'melted_cheese_16x16.png', 'Молочка'),
(48, 'Мясо индейки', 'turkey_16x16.png', 'Мясо'),
(49, 'Булгур', 'bulgur_16x16.png', 'Бакалея'),
(50, 'Мята свежая', 'mint_16x16.png', 'Специи'),
(51, 'Вода', 'water_16x16.png', 'Бакалея'),
(52, 'Дрожжи', 'yeast_16x16.png', 'Бакалея'),
(53, 'Томатный соус', 'tomato_sauce_16x16.png', 'Консервы'),
(54, 'Моцарелла', 'mozzarella_16x16.png', 'Молочка'),
(55, 'Огурец', 'cucumber_16x16.png', 'Овощи'),
(56, 'Сливочный сыр', 'cream_cheese_16x16.png', 'Молочка'),
(57, 'Савоярди', 'savoiardi_16x16.png', 'Бакалея'),
(58, 'Маскарпоне', 'mascarpone_16x16.png', 'Молочка'),
(59, 'Кофе', 'coffee_16x16.png', 'Напитки'),
(60, 'Рыба', 'fish_16x16.png', 'Рыба'),
(61, 'Лавровый лист', 'bay_leaf_16x16.png', 'Специи'),
(62, 'Сметана', 'sour_cream_16x16.png', 'Молочка'),
(63, 'Свинина', 'pork_16x16.png', 'Мясо'),
(64, 'Минеральная вода', 'mineral_water_16x16.png', 'Напитки'),
(65, 'Лапша рамен', 'ramen_noodles_16x16.png', 'Макароны'),
(66, 'Зеленый лук', 'green_onion_16x16.png', 'Овощи'),
(67, 'Креветки', 'shrimp_16x16.png', 'Морепродукты'),
(68, 'Лайм', 'lime_16x16.png', 'Фрукты'),
(69, 'Перец чили', 'chili_16x16.png', 'Специи'),
(70, 'Петрушка', 'parsley_16x16.png', 'Овощи'),
(71, 'Зира', 'cumin_16x16.png', 'Специи'),
(72, 'Листы лазаньи', 'lasagna_sheets_16x16.png', 'Макароны'),
(73, 'Рисовая лапша', 'rice_noodles_16x16.png', 'Макароны'),
(74, 'Ростки фасоли', 'bean_sprouts_16x16.png', 'Овощи'),
(75, 'Соус пад тай', 'pad_thai_sauce_16x16.png', 'Приправы'),
(76, 'Печенье', 'cookies_16x16.png', 'Бакалея'),
(77, 'Фасоль', 'beans_16x16.png', 'Бобовые'),
(78, 'Макароны', 'macaroni_16x16.png', 'Макароны'),
(79, 'Кинза', 'cilantro_16x16.png', 'Овощи'),
(80, 'Кабачок', 'zucchini_16x16.png', 'Овощи'),
(81, 'Болгарский перец', 'bell_pepper_16x16.png', 'Овощи'),
(82, 'Корица', 'cinnamon_16x16.png', 'Специи'),
(83, 'Тунец', 'tuna_16x16.png', 'Рыба'),
(84, 'Листья салата', 'lettuce_16x16.png', 'Овощи'),
(85, 'Мисо-паста', 'miso_paste_16x16.png', 'Приправы'),
(86, 'Тофу', 'tofu_16x16.png', 'Сой'),
(87, 'Водоросли вакаме', 'wakame_16x16.png', 'Водоросли'),
(88, 'Тортильи', 'tortillas_16x16.png', 'Мука'),
(89, 'Зеленый горошек', 'green_peas_2_16x16.png', 'Овощи'),
(90, 'Шафран', 'saffron_16x16.png', 'Специи'),
(91, 'Яичные желтки', 'egg_yolks_16x16.png', 'Молочка'),
(92, 'Ваниль', 'vanilla_16x16.png', 'Специи'),
(93, 'Колбаса', 'sausage_16x16.png', 'Мясные изделия'),
(94, 'Ветчина', 'ham_16x16.png', 'Мясные изделия'),
(95, 'Соленые огурцы', 'pickles_16x16.png', 'Консервы'),
(96, 'Баранина', 'lamb_16x16.png', 'Мясо'),
(97, 'Сыр сулугуни', 'sulguni_16x16.png', 'Молочка'),
(98, 'Сыр грюйер', 'gruyere_16x16.png', 'Молочка'),
(99, 'Сыр эмменталь', 'emmental_16x16.png', 'Молочка'),
(100, 'Белое вино', 'white_wine_16x16.png', 'Напитки'),
(101, 'Хлеб', 'bread_16x16.png', 'Бакалея'),
(102, 'Паприка', 'paprika_16x16.png', 'Специи'),
(103, 'Соус бешамель', 'bechamel_16x16.png', 'Приправы'),
(104, 'Каннеллони', 'cannelloni_16x16.png', 'Макароны'),
(105, 'Карри', 'curry_16x16.png', 'Специи'),
(106, 'Заварной крем', 'custard_16x16.png', 'Молочка'),
(107, 'Грецкие орехи', 'walnuts_16x16.png', 'Орехи'),
(108, 'Хмели-сунели', 'khmeli_suneli_16x16.png', 'Специи'),
(109, 'Тесто фило', 'phyllo_16x16.png', 'Мука'),
(110, 'Салат ромэн', 'romaine_16x16.png', 'Овощи'),
(111, 'Сухарики', 'croutons_16x16.png', 'Бакалея'),
(112, 'Пармезан', 'parmesan_16x16.png', 'Молочка'),
(113, 'Соус Цезарь', 'caesar_sauce_16x16.png', 'Приправы'),
(114, 'Бекон', 'bacon_16x16.png', 'Мясные изделия'),
(115, 'Фарш', 'minced_meat_16x16.png', 'Мясо');

-- ==================== INSERT SAMPLE RECIPES ====================

-- 1. Pizza
INSERT OR IGNORE INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, is_public) VALUES
(1, 'Пицца', 'Классическая пицца с томатным соусом и моцареллой', 4, 90, 2, 2, '🍕', 1);

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(1, 10, 300, 'г'), (1, 51, 180, 'мл'), (1, 52, 5, 'г'), (1, 53, 100, 'г'), (1, 54, 200, 'г'), (1, 32, 1, 'ст.л.');

INSERT OR IGNORE INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(1, 1, 'Замесить тесто и оставить на 1 час', 60),
(1, 2, 'Раскатать основу', 10),
(1, 3, 'Смазать соусом', 5),
(1, 4, 'Посыпать сыром и запечь при 200°C 25-30 мин', 30);

INSERT OR IGNORE INTO recipe_tags (recipe_id, tag_id) VALUES (1, 6), (1, 16), (1, 13);

-- 2. Sushi
INSERT OR IGNORE INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, is_public) VALUES
(1, 'Роллы', 'Классические роллы с лососем и огурцом', 5, 40, 3, 2, '🍣', 1);

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(2, 27, 200, 'г'), (2, 24, 5, 'лист'), (2, 25, 150, 'г'), (2, 55, 1, 'шт'), (2, 56, 100, 'г');

INSERT OR IGNORE INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(2, 1, 'Сварить рис', 20),
(2, 2, 'Разложить нори на коврике', 5),
(2, 3, 'Выложить рис и начинку', 10),
(2, 4, 'Свернуть ролл', 5);

INSERT OR IGNORE INTO recipe_tags (recipe_id, tag_id) VALUES (2, 20), (2, 19), (2, 13);

-- 3. Borscht
INSERT OR IGNORE INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, is_public) VALUES
(1, 'Борщ', 'Традиционный красный борщ со свеклой', 7, 90, 2, 4, '🥘', 1);

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(3, 23, 500, 'г'), (3, 21, 2, 'шт'), (3, 7, 4, 'шт'), (3, 6, 1, 'шт'), (3, 4, 1, 'шт'), (3, 22, 300, 'г'), (3, 34, 2, 'ст.л.');

INSERT OR IGNORE INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(3, 1, 'Сварить бульон', 60),
(3, 2, 'Нарезать овощи', 15),
(3, 3, 'Обжарить свеклу с томатной пастой', 10),
(3, 4, 'Добавить овощи и варить до готовности', 35);

INSERT OR IGNORE INTO recipe_tags (recipe_id, tag_id) VALUES (3, 7), (3, 13), (3, 18);

-- 4. Caesar Salad
INSERT OR IGNORE INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, is_public) VALUES
(1, 'Салат Цезарь', 'Классический салат с курицей и соусом Цезарь', 5, 20, 1, 2, '🥗', 1);

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(4, 17, 200, 'г'), (4, 110, 1, 'пучок'), (4, 111, 100, 'г'), (4, 112, 50, 'г'), (4, 113, 50, 'мл');

INSERT OR IGNORE INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(4, 1, 'Обжарить курицу', 15),
(4, 2, 'Нарезать салат', 5),
(4, 3, 'Добавить сухарики', 2),
(4, 4, 'Посыпать сыром', 2),
(4, 5, 'Полить соусом', 1);

INSERT OR IGNORE INTO recipe_tags (recipe_id, tag_id) VALUES (4, 10), (4, 17), (4, 13);

-- 5. Carbonara Pasta
INSERT OR IGNORE INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, is_public) VALUES
(1, 'Паста Карбонара', 'Итальянская паста с беконом и яичным соусом', 4, 25, 2, 2, '🍝', 1);

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(5, 1, 250, 'г'), (5, 114, 150, 'г'), (5, 9, 2, 'шт'), (5, 112, 50, 'г'), (5, 13, 1, 'по вкусу');

INSERT OR IGNORE INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(5, 1, 'Отварить спагетти', 12),
(5, 2, 'Обжарить бекон', 5),
(5, 3, 'Смешать яйца и сыр', 5),
(5, 4, 'Соединить с пастой', 3);

INSERT OR IGNORE INTO recipe_tags (recipe_id, tag_id) VALUES (5, 14), (5, 16), (5, 7);

-- Продолжение с основными 92 рецептами находится в seed_complete.sql
-- Здесь добавлены 5 основных примеров для демонстрации

-- ==================== DATABASE CREATED ====================
