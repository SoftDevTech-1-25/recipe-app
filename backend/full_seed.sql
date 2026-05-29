-- full_seed.sql — Главный файл базы данных Recipe App
-- Включает полную схему, базовые данные и все рецепты (1–92)
-- Сгенерирован автоматически из init.sql + seed_complete.sql

PRAGMA foreign_keys = ON;

-- ==========================================
-- 1. СОЗДАНИЕ ТАБЛИЦ
-- ==========================================


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



CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  icon_url TEXT,
  color TEXT DEFAULT '#FFFFFF'
);



CREATE TABLE IF NOT EXISTS tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  color TEXT DEFAULT '#5a8a3c',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE IF NOT EXISTS ingredients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  icon_url TEXT,
  category TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);



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



CREATE TABLE IF NOT EXISTS recipe_steps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recipe_id INTEGER NOT NULL,
  step_order INTEGER NOT NULL,
  description TEXT NOT NULL,
  duration INTEGER,
  image_url TEXT,
  FOREIGN KEY (recipe_id) REFERENCES recipes(id)
);



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



CREATE TABLE IF NOT EXISTS recipe_tags (
  recipe_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  PRIMARY KEY (recipe_id, tag_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id)
);



CREATE TABLE IF NOT EXISTS favorites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  recipe_id INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(id)
);



-- ==========================================
-- 2. ОЧИСТКА ДАННЫХ (для возможности перезапуска)
-- ==========================================

DELETE FROM recipe_tags;
DELETE FROM recipe_ingredients;
DELETE FROM recipe_steps;
DELETE FROM favorites;
DELETE FROM recipes;
DELETE FROM ingredients;
DELETE FROM categories;
DELETE FROM tags;
DELETE FROM users;

-- Сброс автоинкремента (чтобы ID начинались с 1 при чистой загрузке)
DELETE FROM sqlite_sequence WHERE name IN (
    'users', 'categories', 'tags', 'ingredients', 
    'recipes', 'recipe_steps', 'recipe_ingredients', 'favorites'
);

-- ==========================================
-- 3. БАЗОВЫЕ ДАННЫЕ
-- ==========================================

-- Категории

INSERT OR IGNORE INTO categories (id, name, icon_url, color) VALUES
(1, 'Веган', 'vegan_16x16.png', '#567D46'),
(2, 'Мясо', 'meat_16x16.png', '#8B4513'),
(3, 'Десерты', 'cake_16x16.png', '#FF69B4'),
(4, 'Итальянская', 'pasta_16x16.png', '#FFD700'),
(5, 'Быстрое', 'fast_16x16.png', '#00CED1'),
(6, 'Напитки', 'potion_16x16.png', '#4169E1'),
(7, 'Супы', 'soup_16x16.png', '#FF6347');


-- Теги

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


-- Ингредиенты (1–120)

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
(115, 'Фарш', 'minced_meat_16x16.png', 'Мясо'),
(116, 'Нори для суши', 'nori_wrap_16x16.png', 'Макароны'),
(117, 'Тайская паста', 'thai_paste_16x16.png', 'Приправы'),
(118, 'Кокосовое масло', 'coconut_oil_16x16.png', 'Бакалея'),
(119, 'Соевые бобы', 'soybeans_16x16.png', 'Бобовые'),
(120, 'Семена кунжута', 'sesame_seeds_16x16.png', 'Специи');


-- Пользователь guest

INSERT OR IGNORE INTO users (id, username, email, password_hash, avatar_url, theme, units) VALUES
(1, 'guest', 'guest@local', '-', NULL, 'overworld', 'metric');


-- ==========================================
-- 4. РЕЦЕПТЫ 1–50 (основные данные)
-- ==========================================
-- Примечание: для рецептов 1–50 в исходном файле были доступны только 
-- базовые поля (таблица recipes). Ингредиенты, шаги и теги можно 
-- дополнить отдельно при необходимости.


INSERT OR IGNORE INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public) VALUES
(1, 1, 'Спагетти болоньезе', 'Классическая итальянская паста с мясным соусом', 45, 2, 3, '🍝', 1),
(2, 1, 'Куриные крылышки', 'Острые куриные крылышки в соусе', 30, 2, 2, '🍗', 1),
(3, 1, 'Салат Цезарь', 'Классический салат с курицей и пармезаном', 20, 1, 2, '🥗', 1),
(4, 1, 'Суши роллы', 'Классические роллы с лососем', 40, 3, 2, '🍣', 1),
(5, 1, 'Борщ красный', 'Традиционный русский борщ', 90, 2, 4, '🥘', 1),
(6, 1, 'Рис с курицей', 'Простой и вкусный рис с курицей', 30, 1, 2, '🍚', 1),
(7, 1, 'Тесто для пиццы', 'Домашнее тесто для пиццы', 120, 2, 1, '🍕', 1),
(8, 1, 'Блины', 'Тонкие русские блины', 30, 1, 2, '🥞', 1),
(9, 1, 'Чебуреки', 'Жареные чебуреки с мясом', 45, 2, 4, '🥟', 1),
(10, 1, 'Омлет', 'Простой омлет из яиц и молока', 10, 1, 1, '🍳', 1),
(11, 1, 'Котлеты мясные', 'Сочные котлеты из фарша', 30, 2, 4, '🍔', 1),
(12, 1, 'Уха рыбная', 'Традиционная рыбная похлебка', 45, 2, 4, '🍲', 1),
(13, 1, 'Овощное рагу', 'Ароматное рагу из овощей', 45, 1, 3, '🍆', 1),
(14, 1, 'Рассольник', 'Суп с перловкой и огурцами', 60, 2, 4, '🥣', 1),
(15, 1, 'Куриный суп', 'Домашний суп из курицы', 40, 1, 4, '🍗', 1),
(16, 1, 'Щи из капусты', 'Традиционные щи из свежей капусты', 50, 1, 4, '🥬', 1),
(17, 1, 'Отбивная из курицы', 'Нежная куриная отбивная', 20, 1, 2, '🍖', 1),
(18, 1, 'Картофельное пюре', 'Гладкое картофельное пюре', 25, 1, 3, '🥔', 1),
(19, 1, 'Гарнир из риса', 'Рассыпчатый рис с маслом', 20, 1, 2, '🍚', 1),
(20, 1, 'Фрикадельки', 'Мясные фрикадельки в подливке', 40, 2, 4, '🍡', 1),
(21, 1, 'Макаронная запеканка', 'Сытная запеканка из макарон', 40, 2, 4, '🍝', 1),
(22, 1, 'Голубцы', 'Голубцы с говядиной и рисом', 60, 2, 4, '🥬', 1),
(23, 1, 'Крем-суп из грибов', 'Нежный крем-суп из грибов', 35, 2, 3, '🍄', 1),
(24, 1, 'Салат Оливье', 'Классический новогодний салат', 30, 1, 6, '🥗', 1),
(25, 1, 'Оселедец под шубой', 'Салат с селедкой и овощами', 25, 1, 4, '🐟', 1),
(26, 1, 'Картофель жареный', 'Хрустящий жареный картофель', 25, 1, 2, '🥔', 1),
(27, 1, 'Завтрак чемпиона', 'Омлет с беконом и сыром', 15, 1, 1, '🍳', 1),
(28, 1, 'Гамбургер домашний', 'Самодельный гамбургер', 20, 1, 1, '🍔', 1),
(29, 1, 'Греческий салат', 'Свежий салат с фетой и оливками', 15, 1, 2, '🥗', 1),
(30, 1, 'Торт Медовик', 'Классический медовый торт', 90, 3, 8, '🍰', 1),
(31, 1, 'Печенье Овсяное', 'Хрустящее овсяное печенье', 25, 1, 20, '🍪', 1),
(32, 1, 'Пончики', 'Мягкие пончики с сахаром', 40, 2, 12, '🍩', 1),
(33, 1, 'Булка сладкая', 'Сладкая булка с корицей', 60, 2, 1, '🥐', 1),
(34, 1, 'Варенье из клубники', 'Клубничное варенье', 120, 2, 1, '🍓', 1),
(35, 1, 'Компот фруктовый', 'Освежающий фруктовый компот', 45, 1, 1, '🧋', 1),
(36, 1, 'Морс клубничный', 'Кисель из клубники', 30, 1, 1, '🧃', 1),
(37, 1, 'Чай с печеньем', 'Чай с домашним печеньем', 10, 1, 1, '🫖', 1),
(38, 1, 'Какао горячее', 'Горячее какао с молоком', 10, 1, 1, '☕', 1),
(39, 1, 'Йогурт домашний', 'Свежий йогурт', 480, 1, 1, '🥛', 1),
(40, 1, 'Творог со сметаной', 'Творог с ягодами', 10, 1, 1, '🍮', 1),
(41, 1, 'Кефир с печеньем', 'Кефир с сухим печеньем', 5, 1, 1, '🥛', 1),
(42, 1, 'Сыр плавленый', 'Домашний плавленый сыр', 30, 2, 1, '🧀', 1),
(43, 1, 'Масло сливочное', 'Свежее сливочное масло', 20, 1, 1, '🧈', 1),
(44, 1, 'Сметана жирная', 'Домашняя жирная сметана', 15, 1, 1, '🥄', 1),
(45, 1, 'Смесь специй', 'Универсальная приправа', 5, 1, 1, '🌶️', 1),
(46, 1, 'Паста для бутербродов', 'Паста из печени', 45, 2, 1, '🍽️', 1),
(47, 1, 'Консервированные помидоры', 'Консервированные томаты', 60, 1, 1, '🍅', 1),
(48, 1, 'Квашеная капуста', 'Традиционная квашеная капуста', 300, 1, 1, '🥬', 1),
(49, 1, 'Маринованные огурцы', 'Маринованные огурцы на зиму', 45, 1, 1, '🥒', 1),
(50, 1, 'Морс ягодный', 'Ягодный морс', 60, 1, 1, '🧃', 1);


-- ==========================================
-- 5. РЕЦЕПТЫ 51–92 (полные данные)
-- ==========================================
-- Каждый рецепт включает: recipes, recipe_ingredients, recipe_steps, recipe_tags


-- 51. Пицца
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(51, 1, 'Пицца', 'Классическая пицца с томатным соусом и моцареллой', 90, 2, 2, '🍕', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(51, 10, 300, 'г'), (51, 51, 180, 'мл'), (51, 52, 5, 'г'), (51, 53, 100, 'г'), (51, 54, 200, 'г'), (51, 42, 1, 'ст.л.');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(51, 1, 'Замесить тесто и оставить на 1 час', 60), (51, 2, 'Раскатать основу', 10), (51, 3, 'Смазать соусом', 5), (51, 4, 'Посыпать сыром', 5), (51, 5, 'Выпекать 12-15 минут при 220°C', 15);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (51, 6), (51, 16), (51, 13);

-- 52. Роллы
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(52, 1, 'Роллы', 'Классические роллы с лососем и огурцом', 40, 3, 2, '🍣', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(52, 26, 200, 'г'), (52, 27, 5, 'лист'), (52, 25, 150, 'г'), (52, 55, 1, 'шт'), (52, 56, 100, 'г');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(52, 1, 'Сварить рис', 20), (52, 2, 'Разложить нори на коврике', 5), (52, 3, 'Выложить рис и начинку', 10), (52, 4, 'Свернуть ролл', 5), (52, 5, 'Нарезать на кусочки', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (52, 20), (52, 19), (52, 8);

-- 53. Борщ
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(53, 1, 'Борщ', 'Традиционный красный борщ со свеклой', 90, 2, 4, '🥘', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(53, 23, 500, 'г'), (53, 21, 2, 'шт'), (53, 7, 4, 'шт'), (53, 6, 1, 'шт'), (53, 4, 1, 'шт'), (53, 22, 300, 'г'), (53, 34, 2, 'ст.л.');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(53, 1, 'Сварить бульон', 60), (53, 2, 'Нарезать овощи', 15), (53, 3, 'Обжарить свеклу с томатной пастой', 10), (53, 4, 'Добавить овощи в бульон', 5), (53, 5, 'Варить 30-40 минут', 40);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (53, 7), (53, 13), (53, 18);

-- 54. Цезарь
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(54, 1, 'Салат Цезарь', 'Классический салат с курицей и соусом Цезарь', 20, 1, 2, '🥗', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(54, 17, 200, 'г'), (54, 115, 1, 'пучок'), (54, 116, 100, 'г'), (54, 117, 50, 'г'), (54, 118, 50, 'мл');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(54, 1, 'Обжарить курицу', 15), (54, 2, 'Нарезать салат', 5), (54, 3, 'Добавить сухарики', 2), (54, 4, 'Посыпать сыром', 2), (54, 5, 'Полить соусом', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (54, 17), (54, 14), (54, 10);

-- 55. Карбонара
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(55, 1, 'Паста Карбонара', 'Итальянская паста с беконом и яичным соусом', 25, 2, 2, '🍝', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(55, 1, 250, 'г'), (55, 119, 150, 'г'), (55, 9, 2, 'шт'), (55, 117, 50, 'г'), (55, 13, 1, 'по вкусу');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(55, 1, 'Отварить спагетти', 12), (55, 2, 'Обжарить бекон', 5), (55, 3, 'Смешать яйца и сыр', 5), (55, 4, 'Соединить с пастой', 3), (55, 5, 'Добавить перец', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (55, 14), (55, 16), (55, 7);

-- 56. Тирамису
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(56, 1, 'Тирамису', 'Итальянский десерт с маскарпоне и кофе', 35, 2, 4, '🍰', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(56, 57, 200, 'г'), (56, 58, 250, 'г'), (56, 9, 3, 'шт'), (56, 11, 100, 'г'), (56, 59, 200, 'мл'), (56, 38, 1, 'ст.л.');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(56, 1, 'Приготовить крем', 10), (56, 2, 'Обмакнуть печенье в кофе', 10), (56, 3, 'Выложить слоями', 5), (56, 4, 'Повторить слои', 5), (56, 5, 'Посыпать какао и охладить', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (56, 2), (56, 15), (56, 13);

-- 57. Уха
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(57, 1, 'Уха', 'Традиционная рыбная похлебка', 40, 1, 4, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(57, 60, 500, 'г'), (57, 7, 3, 'шт'), (57, 6, 1, 'шт'), (57, 4, 1, 'шт'), (57, 61, 2, 'шт');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(57, 1, 'Сварить рыбный бульон', 20), (57, 2, 'Добавить овощи', 5), (57, 3, 'Варить 20 минут', 20), (57, 4, 'Добавить специи', 2), (57, 5, 'Подать горячим', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (57, 8), (57, 13), (57, 18);

-- 58. Стейк
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(58, 1, 'Стейк', 'Сочный говяжий стейк', 25, 2, 2, '🥩', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(58, 23, 300, 'г'), (58, 12, 1, 'по вкусу'), (58, 13, 1, 'по вкусу'), (58, 14, 2, 'ст.л.');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(58, 1, 'Довести мясо до комнатной температуры', 30), (58, 2, 'Посолить и поперчить', 2), (58, 3, 'Обжарить по 3-5 минут с каждой стороны', 10), (58, 4, 'Дать отдохнуть 5 минут', 5), (58, 5, 'Подать', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (58, 7), (58, 11), (58, 15);

-- 59. Пельмени
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(59, 1, 'Пельмени', 'Домашние пельмени с мясной начинкой', 90, 3, 4, '🥟', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(59, 10, 400, 'г'), (59, 51, 200, 'мл'), (59, 120, 300, 'г'), (59, 4, 1, 'шт'), (59, 12, 1, 'по вкусу');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(59, 1, 'Замесить тесто', 15), (59, 2, 'Приготовить начинку', 10), (59, 3, 'Слепить пельмени', 30), (59, 4, 'Варить 7-10 минут', 10), (59, 5, 'Подать со сметаной', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (59, 7), (59, 13), (59, 18);

-- 60. Шашлык
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(60, 1, 'Шашлык', 'Маринованный шашлык из свинины', 300, 2, 4, '🍖', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(60, 63, 1000, 'г'), (60, 4, 3, 'шт'), (60, 12, 1, 'по вкусу'), (60, 13, 1, 'по вкусу'), (60, 64, 100, 'мл');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(60, 1, 'Нарезать мясо', 15), (60, 2, 'Замариновать с луком', 10), (60, 3, 'Оставить на 4-6 часов', 300), (60, 4, 'Нанизать на шампуры', 10), (60, 5, 'Жарить на углях до готовности', 20);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (60, 7), (60, 11), (60, 13);

-- 61. Блины
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(61, 1, 'Блины', 'Тонкие русские блины', 30, 1, 2, '🥞', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(61, 10, 250, 'г'), (61, 8, 500, 'мл'), (61, 9, 2, 'шт'), (61, 11, 1, 'ст.л'), (61, 12, 1, 'щепотка'), (61, 14, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(61, 1, 'Смешать яйца, сахар и соль', 5), (61, 2, 'Добавить молоко', 2), (61, 3, 'Постепенно всыпать муку', 5), (61, 4, 'Добавить масло', 2), (61, 5, 'Жарить тонкие блины на сковороде', 20);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (61, 2), (61, 14), (61, 6);

-- 62. Рамен
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(62, 1, 'Рамен', 'Японский суп с лапшой и яйцом', 50, 3, 2, '🍜', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(62, 66, 200, 'г'), (62, 35, 1, 'л'), (62, 9, 2, 'шт'), (62, 63, 200, 'г'), (62, 67, 2, 'стебля'), (62, 30, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(62, 1, 'Сварить бульон', 30), (62, 2, 'Отварить лапшу', 5), (62, 3, 'Приготовить мясо', 10), (62, 4, 'Собрать ингредиенты в миске', 5), (62, 5, 'Залить горячим бульоном', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (62, 20), (62, 7), (62, 18);

-- 63. Том Ям
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(63, 1, 'Том Ям', 'Острый тайский суп с креветками', 30, 2, 2, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(63, 68, 300, 'г'), (63, 39, 200, 'мл'), (63, 16, 150, 'г'), (63, 69, 1, 'шт'), (63, 70, 1, 'по вкусу'), (63, 40, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(63, 1, 'Довести воду до кипения', 5), (63, 2, 'Добавить пасту том ям', 2), (63, 3, 'Положить грибы и креветки', 5), (63, 4, 'Влить кокосовое молоко', 2), (63, 5, 'Добавить сок лайма и подать', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (63, 1), (63, 19), (63, 14);

-- 64. Фалафель
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(64, 1, 'Фалафель', 'Жареные шарики из нута с восточными специями', 270, 2, 2, '🧆', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(64, 31, 300, 'г'), (64, 4, 1, 'шт'), (64, 5, 2, 'зубч'), (64, 71, 1, 'пучок'), (64, 72, 1, 'ч.л'), (64, 14, 500, 'мл');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(64, 1, 'Замочить нут на ночь', 480), (64, 2, 'Измельчить с остальными ингредиентами', 10), (64, 3, 'Сформировать шарики', 5), (64, 4, 'Обжарить во фритюре', 15), (64, 5, 'Подать с соусом', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (64, 5), (64, 11), (64, 18);

-- 65. Лазанья
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(65, 1, 'Лазанья', 'Итальянская лазанья с мясным соусом', 70, 3, 4, '🧀', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(65, 73, 12, 'шт'), (65, 120, 500, 'г'), (65, 53, 300, 'мл'), (65, 15, 250, 'г'), (65, 4, 1, 'шт');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(65, 1, 'Обжарить фарш с луком', 10), (65, 2, 'Добавить томатный соус', 5), (65, 3, 'Выложить слоями листы, мясо и сыр', 15), (65, 4, 'Повторить слои', 10), (65, 5, 'Запекать 40 минут', 40);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (65, 7), (65, 16), (65, 12);

-- 66. Пад Тай
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(66, 1, 'Пад Тай', 'Тайская жареная рисовая лапша', 30, 2, 2, '🍜', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(66, 74, 200, 'г'), (66, 68, 200, 'г'), (66, 9, 2, 'шт'), (66, 75, 100, 'г'), (66, 76, 3, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(66, 1, 'Замочить лапшу', 15), (66, 2, 'Обжарить креветки', 5), (66, 3, 'Добавить яйца', 3), (66, 4, 'Смешать с лапшой и соусом', 5), (66, 5, 'Добавить ростки фасоли', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (66, 19), (66, 14), (66, 18);

-- 67. Чизкейк
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(67, 1, 'Чизкейк', 'Классический чизкейк с печеньем', 90, 2, 8, '🍰', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(67, 77, 200, 'г'), (67, 19, 100, 'г'), (67, 56, 500, 'г'), (67, 9, 3, 'шт'), (67, 11, 150, 'г');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(67, 1, 'Измельчить печенье', 5), (67, 2, 'Смешать с маслом и сделать основу', 5), (67, 3, 'Приготовить сырную начинку', 10), (67, 4, 'Вылить на основу', 5), (67, 5, 'Выпекать около часа', 60);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (67, 2), (67, 15), (67, 16);

-- 68. Минестроне
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(68, 1, 'Минестроне', 'Итальянский овощной суп', 40, 1, 4, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(68, 7, 2, 'шт'), (68, 6, 1, 'шт'), (68, 78, 150, 'г'), (68, 3, 2, 'шт'), (68, 79, 100, 'г'), (68, 4, 1, 'шт');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(68, 1, 'Нарезать овощи', 10), (68, 2, 'Обжарить лук и морковь', 5), (68, 3, 'Добавить остальные овощи', 5), (68, 4, 'Варить до готовности', 20), (68, 5, 'Добавить макароны', 10);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (68, 6), (68, 18), (68, 10);

-- 69. Плов
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(69, 1, 'Плов', 'Восточный плов с говядиной', 90, 2, 4, '🍚', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(69, 18, 500, 'г'), (69, 23, 500, 'г'), (69, 6, 2, 'шт'), (69, 4, 2, 'шт'), (69, 5, 1, 'головка'), (69, 51, 1, 'л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(69, 1, 'Обжарить мясо', 15), (69, 2, 'Добавить лук и морковь', 10), (69, 3, 'Засыпать рис', 2), (69, 4, 'Влить воду', 2), (69, 5, 'Томить до готовности', 40);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (69, 7), (69, 13), (69, 18);

-- 70. Манты
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(70, 1, 'Манты', 'Восточные манты на пару', 90, 3, 4, '🥟', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(70, 10, 500, 'г'), (70, 51, 250, 'мл'), (70, 120, 500, 'г'), (70, 4, 3, 'шт'), (70, 12, 1, 'по вкусу'), (70, 13, 1, 'по вкусу');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(70, 1, 'Замесить тесто', 15), (70, 2, 'Подготовить начинку', 10), (70, 3, 'Сформировать манты', 30), (70, 4, 'Готовить на пару 40-45 минут', 45), (70, 5, 'Подать со сметаной', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (70, 7), (70, 13), (70, 18);

-- 71. Фо Бо
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(71, 1, 'Фо Бо', 'Вьетнамский суп с рисовой лапшой', 120, 3, 2, '🍜', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(71, 23, 300, 'г'), (71, 74, 200, 'г'), (71, 80, 1, 'л'), (71, 29, 20, 'г'), (71, 67, 1, 'пучок'), (71, 81, 1, 'пучок');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(71, 1, 'Приготовить ароматный бульон', 90), (71, 2, 'Отварить рисовую лапшу', 5), (71, 3, 'Тонко нарезать говядину', 5), (71, 4, 'Выложить лапшу и мясо в миску', 3), (71, 5, 'Залить горячим бульоном', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (71, 7), (71, 18), (71, 10);

-- 72. Рататуй
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(72, 1, 'Рататуй', 'Французское овощное рагу', 60, 2, 3, '🍆', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(72, 82, 1, 'шт'), (72, 83, 1, 'шт'), (72, 3, 3, 'шт'), (72, 84, 1, 'шт'), (72, 4, 1, 'шт'), (72, 5, 2, 'зубч'), (72, 53, 100, 'г');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(72, 1, 'Нарезать овощи кружочками', 10), (72, 2, 'Приготовить томатный соус', 10), (72, 3, 'Выложить овощи слоями', 10), (72, 4, 'Накрыть фольгой', 2), (72, 5, 'Запекать 40-50 минут', 50);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (72, 6), (72, 18), (72, 12);

-- 73. Чуррос
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(73, 1, 'Чуррос', 'Испанские жареные палочки с корицей', 30, 2, 2, '🥨', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(73, 51, 250, 'мл'), (73, 10, 150, 'г'), (73, 19, 50, 'г'), (73, 11, 50, 'г'), (73, 85, 1, 'ч.л'), (73, 14, 500, 'мл');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(73, 1, 'Вскипятить воду с маслом', 5), (73, 2, 'Добавить муку и перемешать', 5), (73, 3, 'Остудить тесто', 10), (73, 4, 'Выдавить полоски в горячее масло', 10), (73, 5, 'Посыпать сахаром и корицей', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (73, 2), (73, 11), (73, 6);

-- 74. Гаспачо
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(74, 1, 'Гаспачо', 'Испанский холодный томатный суп', 15, 1, 2, '🥣', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(74, 3, 600, 'г'), (74, 55, 1, 'шт'), (74, 84, 1, 'шт'), (74, 5, 1, 'зубч'), (74, 42, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(74, 1, 'Очистить помидоры', 5), (74, 2, 'Нарезать овощи', 5), (74, 3, 'Измельчить в блендере', 3), (74, 4, 'Добавить масло и специи', 2), (74, 5, 'Охладить перед подачей', 30);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (74, 6), (74, 18), (74, 10);

-- 75. Нисуаз
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(75, 1, 'Нисуаз', 'Французский салат с тунцом', 20, 1, 2, '🥗', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(75, 86, 150, 'г'), (75, 9, 2, 'шт'), (75, 3, 2, 'шт'), (75, 87, 100, 'г'), (75, 33, 50, 'г'), (75, 42, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(75, 1, 'Отварить яйца', 10), (75, 2, 'Нарезать овощи', 5), (75, 3, 'Разложить салат на тарелке', 3), (75, 4, 'Добавить тунец и яйца', 2), (75, 5, 'Заправить оливковым маслом', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (75, 8), (75, 14), (75, 10);

-- 76. Вареники
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(76, 1, 'Вареники', 'Домашние вареники с картошкой', 60, 2, 4, '🥟', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(76, 10, 400, 'г'), (76, 51, 200, 'мл'), (76, 7, 500, 'г'), (76, 4, 1, 'шт'), (76, 12, 1, 'по вкусу');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(76, 1, 'Замесить тесто', 15), (76, 2, 'Приготовить картофельную начинку', 20), (76, 3, 'Слепить вареники', 20), (76, 4, 'Отварить 5-7 минут', 7), (76, 5, 'Подать с жареным луком', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (76, 6), (76, 13), (76, 18);

-- 77. Мисо
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(77, 1, 'Мисо', 'Японский суп с мисо и тофу', 15, 1, 2, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(77, 88, 2, 'ст.л'), (77, 51, 1, 'л'), (77, 89, 150, 'г'), (77, 90, 10, 'г'), (77, 67, 2, 'стебля');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(77, 1, 'Нагреть воду', 5), (77, 2, 'Растворить мисо-пасту', 3), (77, 3, 'Добавить тофу', 2), (77, 4, 'Положить водоросли', 2), (77, 5, 'Посыпать луком перед подачей', 1);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (77, 20), (77, 5), (77, 10);

-- 78. Тако
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(78, 1, 'Тако', 'Мексиканские тако с говяжьим фаршем', 25, 1, 2, '🌮', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(78, 91, 6, 'шт'), (78, 2, 300, 'г'), (78, 3, 2, 'шт'), (78, 4, 1, 'шт'), (78, 15, 100, 'г');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(78, 1, 'Обжарить фарш', 10), (78, 2, 'Подготовить овощи', 5), (78, 3, 'Разогреть тортильи', 3), (78, 4, 'Наполнить начинкой', 5), (78, 5, 'Посыпать сыром и подать', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (78, 7), (78, 14), (78, 18);

-- 79. Паэлья
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(79, 1, 'Паэлья', 'Испанская паэлья с морепродуктами', 60, 3, 4, '🍚', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(79, 18, 300, 'г'), (79, 68, 200, 'г'), (79, 17, 200, 'г'), (79, 84, 1, 'шт'), (79, 92, 100, 'г'), (79, 93, 1, 'щепотка'), (79, 35, 1, 'л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(79, 1, 'Обжарить мясо и овощи', 15), (79, 2, 'Добавить рис', 2), (79, 3, 'Влить бульон', 2), (79, 4, 'Добавить морепродукты', 5), (79, 5, 'Готовить до впитывания жидкости', 30);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (79, 19), (79, 15), (79, 18);

-- 80. Крем-брюле
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(80, 1, 'Крем-брюле', 'Французский кремовый десерт', 50, 3, 2, '🍮', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(80, 20, 500, 'мл'), (80, 94, 5, 'шт'), (80, 11, 100, 'г'), (80, 95, 1, 'по вкусу');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(80, 1, 'Подогреть сливки с ванилью', 5), (80, 2, 'Смешать желтки и сахар', 5), (80, 3, 'Соединить смеси', 3), (80, 4, 'Запечь на водяной бане', 25), (80, 5, 'Посыпать сахаром и карамелизовать', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (80, 2), (80, 15), (80, 12);

-- 81. Солянка
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(81, 1, 'Солянка', 'Сборная мясная солянка', 60, 2, 4, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(81, 23, 300, 'г'), (81, 96, 150, 'г'), (81, 97, 150, 'г'), (81, 98, 3, 'шт'), (81, 34, 2, 'ст.л'), (81, 33, 100, 'г'), (81, 32, 1, 'шт');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(81, 1, 'Сварить мясной бульон', 30), (81, 2, 'Нарезать мясные продукты', 10), (81, 3, 'Обжарить огурцы с томатной пастой', 10), (81, 4, 'Добавить всё в бульон', 5), (81, 5, 'Подавать с лимоном и маслинами', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (81, 7), (81, 13), (81, 3);

-- 82. Табуле
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(82, 1, 'Табуле', 'Ближневосточный салат с булгуром', 20, 1, 2, '🥗', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(82, 99, 150, 'г'), (82, 71, 1, 'пучок'), (82, 3, 2, 'шт'), (82, 55, 1, 'шт'), (82, 32, 2, 'ст.л'), (82, 42, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(82, 1, 'Залить булгур горячей водой', 10), (82, 2, 'Мелко нарезать зелень и овощи', 10), (82, 3, 'Смешать ингредиенты', 3), (82, 4, 'Заправить маслом и лимонным соком', 2), (82, 5, 'Охладить перед подачей', 10);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (82, 5), (82, 10), (82, 18);

-- 83. Кебаб
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(83, 1, 'Кебаб', 'Восточный кебаб из баранины', 40, 2, 3, '🍢', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(83, 100, 500, 'г'), (83, 4, 2, 'шт'), (83, 5, 2, 'зубч'), (83, 72, 1, 'ч.л'), (83, 12, 1, 'по вкусу'), (83, 13, 1, 'по вкусу');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(83, 1, 'Измельчить мясо и лук', 10), (83, 2, 'Добавить специи', 2), (83, 3, 'Хорошо вымесить фарш', 5), (83, 4, 'Сформировать колбаски', 5), (83, 5, 'Жарить на гриле или мангале', 15);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (83, 7), (83, 11), (83, 13);

-- 84. Хачапури
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(84, 1, 'Хачапури', 'Грузинский хачапури по-аджарски', 80, 3, 2, '🥖', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(84, 10, 400, 'г'), (84, 8, 200, 'мл'), (84, 52, 7, 'г'), (84, 101, 300, 'г'), (84, 9, 1, 'шт');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(84, 1, 'Замесить дрожжевое тесто', 20), (84, 2, 'Приготовить сырную начинку', 5), (84, 3, 'Сформировать лодочку', 10), (84, 4, 'Запечь до золотистой корочки', 20), (84, 5, 'Добавить яйцо и допечь', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (84, 6), (84, 16), (84, 12);

-- 85. Фондю
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(85, 1, 'Фондю', 'Швейцарское сырное фондю', 20, 2, 2, '🫕', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(85, 102, 200, 'г'), (85, 103, 200, 'г'), (85, 104, 250, 'мл'), (85, 5, 1, 'зубч'), (85, 105, 1, 'багет');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(85, 1, 'Натереть сыр', 5), (85, 2, 'Нагреть вино', 5), (85, 3, 'Постепенно расплавить сыр', 10), (85, 4, 'Перемешать до однородности', 3), (85, 5, 'Подавать с кусочками хлеба', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (85, 16), (85, 15), (85, 6);

-- 86. Гуляш
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(86, 1, 'Гуляш', 'Венгерский гуляш с паприкой', 120, 2, 4, '🥘', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(86, 23, 600, 'г'), (86, 4, 2, 'шт'), (86, 106, 2, 'ст.л'), (86, 7, 3, 'шт'), (86, 6, 1, 'шт'), (86, 51, 500, 'мл');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(86, 1, 'Обжарить лук', 5), (86, 2, 'Добавить мясо', 10), (86, 3, 'Всыпать паприку', 2), (86, 4, 'Добавить овощи и воду', 5), (86, 5, 'Тушить 1,5-2 часа', 120);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (86, 7), (86, 13), (86, 18);

-- 87. Мусака
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(87, 1, 'Мусака', 'Греческая мусака с баклажанами', 70, 3, 4, '🍆', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(87, 83, 2, 'шт'), (87, 120, 400, 'г'), (87, 3, 3, 'шт'), (87, 15, 150, 'г'), (87, 107, 300, 'мл');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(87, 1, 'Нарезать и обжарить баклажаны', 15), (87, 2, 'Приготовить мясную начинку', 15), (87, 3, 'Выложить слоями', 10), (87, 4, 'Залить бешамелем', 5), (87, 5, 'Запекать 40 минут', 40);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (87, 7), (87, 16), (87, 12);

-- 88. Каннеллони
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(88, 1, 'Каннеллони', 'Итальянские каннеллони с фаршем', 60, 2, 4, '🍝', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(88, 108, 250, 'г'), (88, 120, 400, 'г'), (88, 53, 300, 'мл'), (88, 15, 150, 'г');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(88, 1, 'Приготовить начинку', 15), (88, 2, 'Наполнить каннеллони', 15), (88, 3, 'Выложить в форму', 5), (88, 4, 'Полить соусом', 3), (88, 5, 'Посыпать сыром и запечь', 25);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (88, 7), (88, 16), (88, 12);

-- 89. Самоса
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(89, 1, 'Самоса', 'Индийские пирожки с картошкой', 50, 2, 4, '🥟', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(89, 10, 300, 'г'), (89, 7, 3, 'шт'), (89, 92, 100, 'г'), (89, 109, 1, 'ч.л'), (89, 14, 500, 'мл');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(89, 1, 'Замесить тесто', 10), (89, 2, 'Приготовить начинку', 15), (89, 3, 'Сформировать треугольники', 10), (89, 4, 'Обжарить во фритюре', 15), (89, 5, 'Подать с соусом', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (89, 5), (89, 11), (89, 18);

-- 90. Эклеры
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(90, 1, 'Эклеры', 'Французские эклеры с заварным кремом', 60, 3, 8, '🥮', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(90, 51, 250, 'мл'), (90, 19, 100, 'г'), (90, 10, 150, 'г'), (90, 9, 4, 'шт'), (90, 110, 300, 'г');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(90, 1, 'Приготовить заварное тесто', 10), (90, 2, 'Отсадить полоски на противень', 10), (90, 3, 'Выпекать до золотистого цвета', 20), (90, 4, 'Остудить', 10), (90, 5, 'Наполнить кремом', 10);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (90, 2), (90, 15), (90, 13);

-- 91. Харчо
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(91, 1, 'Харчо', 'Грузинский суп харчо с говядиной', 90, 2, 4, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(91, 23, 500, 'г'), (91, 18, 100, 'г'), (91, 4, 2, 'шт'), (91, 34, 2, 'ст.л'), (91, 111, 50, 'г'), (91, 5, 3, 'зубч'), (91, 81, 1, 'пучок'), (91, 112, 1, 'ч.л'), (91, 61, 2, 'шт'), (91, 12, 1, 'по вкусу'), (91, 13, 1, 'по вкусу');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(91, 1, 'Сварить говяжий бульон', 60), (91, 2, 'Нарезать мясо и вернуть его в кастрюлю', 10), (91, 3, 'Добавить промытый рис', 3), (91, 4, 'Обжарить лук с томатной пастой', 10), (91, 5, 'Добавить зажарку в суп', 2), (91, 6, 'Положить измельчённые орехи, чеснок и специи', 5), (91, 7, 'Варить до готовности риса', 20), (91, 8, 'Перед подачей посыпать кинзой', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (91, 7), (91, 1), (91, 13);

-- 92. Баклава
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(92, 1, 'Баклава', 'Восточная баклава с орехами и мёдом', 120, 4, 8, '🍯', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(92, 113, 400, 'г'), (92, 111, 300, 'г'), (92, 19, 200, 'г'), (92, 11, 200, 'г'), (92, 51, 200, 'мл'), (92, 114, 100, 'г'), (92, 32, 1, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(92, 1, 'Измельчить орехи', 5), (92, 2, 'Смазать форму маслом', 2), (92, 3, 'Выложить несколько слоёв теста фило', 5), (92, 4, 'Посыпать орехами', 3), (92, 5, 'Повторять слои до окончания ингредиентов', 10), (92, 6, 'Нарезать ромбами до выпечки', 3), (92, 7, 'Выпекать 40-50 минут при 180°C', 50), (92, 8, 'Сварить сироп из воды, сахара и мёда', 15), (92, 9, 'Полить горячую баклаву сиропом', 2), (92, 10, 'Дать настояться несколько часов', 180);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (92, 2), (92, 15), (92, 6);


-- ==========================================
-- КОНЕЦ ФАЙЛА
-- ==========================================
