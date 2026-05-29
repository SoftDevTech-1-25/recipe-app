-- Очистка старых данных (опционально)
DELETE FROM recipe_tags;
DELETE FROM recipe_ingredients;
DELETE FROM recipe_steps;
DELETE FROM recipes;
DELETE FROM ingredients;

-- Ингредиенты
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (1, 'Спагетти', 'spaghetti_16x16.png', 'Макароны', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (2, 'Фарш говяжий', 'beef_16x16.png', 'Мясо', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (3, 'Помидор', 'tomato_16x16.png', 'Овощи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (4, 'Лук', 'onion_16x16.png', 'Овощи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (5, 'Чеснок', 'garlic_16x16.png', 'Овощи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (6, 'Морковь', 'carrot_16x16.png', 'Овощи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (7, 'Картофель', 'potato_16x16.png', 'Овощи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (8, 'Молоко', 'milk_16x16.png', 'Молочка', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (9, 'Яйцо', 'egg_16x16.png', 'Молочка', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (10, 'Мука', 'flour_16x16.png', 'Бакалея', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (11, 'Сахар', 'sugar_16x16.png', 'Бакалея', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (12, 'Соль', 'salt_16x16.png', 'Специи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (13, 'Перец', 'pepper_16x16.png', 'Специи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (14, 'Подсолнечное масло', 'oil_16x16.png', 'Бакалея', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (15, 'Сыр', 'cheese_16x16.png', 'Молочка', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (16, 'Грибы', 'mushroom_16x16.png', 'Овощи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (17, 'Курица', 'chicken_16x16.png', 'Мясо', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (18, 'Рис', 'rice_16x16.png', 'Бакалея', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (19, 'Лосось', 'salmon_16x16.png', 'Рыба', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (20, 'Креветки', 'shrimp_16x16.png', 'Морепродукты', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (21, 'Авокадо', 'avocado_16x16.png', 'Овощи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (22, 'Бекон', 'bacon_16x16.png', 'Мясо', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (23, 'Сметана', 'sourcream_16x16.png', 'Молочка', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (24, 'Капуста', 'cabbage_16x16.png', 'Овощи', '2024-01-01 00:00:00');
INSERT OR IGNORE INTO ingredients (id, name, icon_url, category, created_at) VALUES (25, 'Свёкла', 'beet_16x16.png', 'Овощи', '2024-01-01 00:00:00');

-- Рецепты
INSERT INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, image_url, is_public) VALUES (1, 'Пицца Маргарита', 'Классическая итальянская пицца с моцареллой и помидорами', 1, 40, 2, 2, '🍕', 'pizza.jpg', 1);
INSERT INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, image_url, is_public) VALUES (1, 'Спагетти Болоньезе', 'Итальянская паста с мясным соусом', 1, 45, 3, 2, '🍝', 'pasta.jpg', 1);
INSERT INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, image_url, is_public) VALUES (1, 'Куриный плов', 'Восточное блюдо с курицей и рисом', 2, 50, 2, 4, '🍚', 'pilaf.jpg', 1);
INSERT INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, image_url, is_public) VALUES (1, 'Борщ', 'Традиционный украинский борщ', 2, 55, 2, 4, '🥘', 'borscht.jpg', 1);
INSERT INTO recipes (user_id, title, description, category_id, prep_time, difficulty, servings, emoji, image_url, is_public) VALUES (1, 'Салат Цезарь', 'Салат с курицей, сыром и сухариками', 1, 20, 1, 2, '🥗', 'caesar.jpg', 1);

-- Связи рецепт-ингредиент для Пицца Маргарита
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 10, 500, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 15, 200, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 3, 3, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 4, 1, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 14, 3, 'ст.л');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 12, 1, 'щепотка');

-- Связи рецепт-ингредиент для Спагетти Болоньезе
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 1, 400, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 2, 300, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 3, 4, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 4, 2, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 5, 3, 'зубчик');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 14, 2, 'ст.л');

-- Связи рецепт-ингредиент для Куриного плова
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 18, 400, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 17, 500, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 6, 2, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 4, 2, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 14, 4, 'ст.л');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 5, 4, 'зубчик');

-- Связи рецепт-ингредиент для Борща
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 25, 3, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 24, 400, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 3, 3, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 4, 2, 'шт');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 6, 2, 'шт');

-- Связи рецепт-ингредиент для Салата Цезарь
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (5, 17, 300, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (5, 15, 100, 'г');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (5, 14, 2, 'ст.л');

-- ==================== ШАГИ ПРИГОТОВЛЕНИЯ ====================

-- Пицца Маргарита - шаги (ID: 1)
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (1, 1, 'Замесите тесто из муки, воды и масла', 20);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (1, 2, 'Дайте тесту подняться в течение часа', 60);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (1, 3, 'Раскатайте тесто и положите на противень', 10);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (1, 4, 'Смажьте тесто томатным соусом', 5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (1, 5, 'Добавьте сыр и помидоры', 5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (1, 6, 'Запекайте при 200°С в течение 20 минут', 20);

-- Спагетти Болоньезе - шаги (ID: 2)
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (2, 1, 'Поставьте кастрюлю с подсоленной водой на огонь', 5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (2, 2, 'На сковороде обжарьте лук с чесноком', 5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (2, 3, 'Добавьте фарш и жарьте до готовности', 10);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (2, 4, 'Добавьте помидоры и томатный соус', 15);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (2, 5, 'Варите спагетти и перемешайте с соусом', 10);

-- Куриный плов - шаги (ID: 3)
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (3, 1, 'Нарежьте курицу небольшими кусками', 10);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (3, 2, 'Обжарьте курицу на масле до золотистого цвета', 15);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (3, 3, 'Добавьте морковь и лук', 10);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (3, 4, 'Добавьте рис и перемешайте', 5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (3, 5, 'Залейте кипящей водой и варите под крышкой', 30);

-- Борщ - шаги (ID: 4)
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (4, 1, 'Нарежьте свеклу соломкой', 10);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (4, 2, 'Варите свеклу в подсоленной воде 20 минут', 20);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (4, 3, 'Добавьте нарезанную капусту', 10);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (4, 4, 'Добавьте помидоры и другие овощи', 5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (4, 5, 'Варите еще 20 минут и приправьте', 20);

-- Салат Цезарь - шаги (ID: 5)
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (5, 1, 'Нарежьте салат небольшими кусками', 5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (5, 2, 'Приготовьте куриное филе', 10);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (5, 3, 'Сделайте соус из майонеза, сыра и специй', 5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (5, 4, 'Смешайте ингредиенты и подавайте', 3);
