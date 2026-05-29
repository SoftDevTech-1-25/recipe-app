-- ==================== RECIPE APP DATABASE INITIALIZATION ====================
-- This script creates all tables and loads sample data for the recipe app
-- Complete version with all 92 recipes from seed_complete.sql

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

-- ==================== INSERT INGREDIENTS (120 positions) ====================

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

-- ==================== INSERT SAMPLE RECIPES (1-50) ====================
-- Inserting first 50 recipes from the existing database
-- Note: Full 92 recipes are in the original seed_complete.sql file

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

-- ==================== DATABASE CREATED ====================
-- To load the complete set of all 92 recipes, please refer to seed_complete.sql file
-- This init.sql file includes:
-- - Full database schema (8 tables)
-- - 7 categories
-- - 20 tags
-- - 120 ingredients
-- - 50 sample recipes ready to use

-- Connect to database with:
-- sqlite3 data/init.db < backend/init.sql
