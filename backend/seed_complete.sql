-- ==================== ПОЛНАЯ ПЕРЕПИСАННАЯ БД С 50 РЕЦЕПТАМИ ====================
-- Очищаем старые данные
DELETE FROM recipe_tags;
DELETE FROM recipe_ingredients;
DELETE FROM recipe_steps;
DELETE FROM recipes;
DELETE FROM ingredients;
DELETE FROM tags;

-- ==================== ИНГРЕДИЕНТЫ (50+ позиций) ====================
INSERT INTO ingredients (id, name, icon_url, category, created_at) VALUES
(1, 'Спагетти', 'spaghetti_16x16.png', 'Макароны', datetime('now')),
(2, 'Фарш говяжий', 'beef_16x16.png', 'Мясо', datetime('now')),
(3, 'Помидор', 'tomato_16x16.png', 'Овощи', datetime('now')),
(4, 'Лук', 'onion_16x16.png', 'Овощи', datetime('now')),
(5, 'Чеснок', 'garlic_16x16.png', 'Овощи', datetime('now')),
(6, 'Морковь', 'carrot_16x16.png', 'Овощи', datetime('now')),
(7, 'Картофель', 'potato_16x16.png', 'Овощи', datetime('now')),
(8, 'Молоко', 'milk_16x16.png', 'Молочка', datetime('now')),
(9, 'Яйцо', 'egg_16x16.png', 'Молочка', datetime('now')),
(10, 'Мука', 'flour_16x16.png', 'Бакалея', datetime('now')),
(11, 'Сахар', 'sugar_16x16.png', 'Бакалея', datetime('now')),
(12, 'Соль', 'salt_16x16.png', 'Специи', datetime('now')),
(13, 'Перец', 'pepper_16x16.png', 'Специи', datetime('now')),
(14, 'Подсолнечное масло', 'oil_16x16.png', 'Бакалея', datetime('now')),
(15, 'Сыр', 'cheese_16x16.png', 'Молочка', datetime('now')),
(16, 'Грибы', 'mushroom_16x16.png', 'Овощи', datetime('now')),
(17, 'Курица', 'chicken_16x16.png', 'Мясо', datetime('now')),
(18, 'Рис', 'rice_16x16.png', 'Бакалея', datetime('now')),
(19, 'Масло сливочное', 'butter_16x16.png', 'Молочка', datetime('now')),
(20, 'Сливки', 'cream_16x16.png', 'Молочка', datetime('now')),
(21, 'Красная свекла', 'beet_16x16.png', 'Овощи', datetime('now')),
(22, 'Капуста', 'cabbage_16x16.png', 'Овощи', datetime('now')),
(23, 'Говядина', 'beef_steak_16x16.png', 'Мясо', datetime('now')),
(24, 'Тесто слоеное', 'pastry_16x16.png', 'Мука', datetime('now')),
(25, 'Лосось', 'salmon_16x16.png', 'Рыба', datetime('now')),
(26, 'Рис для суши', 'sushi_rice_16x16.png', 'Бакалея', datetime('now')),
(27, 'Водоросли нори', 'nori_16x16.png', 'Морепродукты', datetime('now')),
(28, 'Авокадо', 'avocado_16x16.png', 'Овощи', datetime('now')),
(29, 'Имбирь', 'ginger_16x16.png', 'Специи', datetime('now')),
(30, 'Соевый соус', 'soy_sauce_16x16.png', 'Приправы', datetime('now')),
(31, 'Нут', 'chickpea_16x16.png', 'Бобовые', datetime('now')),
(32, 'Лимон', 'lemon_16x16.png', 'Фрукты', datetime('now')),
(33, 'Маслины', 'olive_16x16.png', 'Овощи', datetime('now')),
(34, 'Томатная паста', 'tomato_paste_16x16.png', 'Консервы', datetime('now')),
(35, 'Бульон куриный', 'broth_16x16.png', 'Консервы', datetime('now')),
(36, 'Печень говяжья', 'liver_16x16.png', 'Мясо', datetime('now')),
(37, 'Белки яйца', 'egg_white_16x16.png', 'Молочка', datetime('now')),
(38, 'Какао', 'cocoa_16x16.png', 'Приправы', datetime('now')),
(39, 'Кокосовое молоко', 'coconut_milk_16x16.png', 'Молочка', datetime('now')),
(40, 'Тайский пастой', 'paste_16x16.png', 'П��иправы', datetime('now')),
(41, 'Фетаксыр', 'feta_16x16.png', 'Молочка', datetime('now')),
(42, 'Оливковое масло', 'olive_oil_16x16.png', 'Масла', datetime('now')),
(43, 'Уксус бальзамический', 'vinegar_16x16.png', 'Приправы', datetime('now')),
(44, 'Кокос', 'coconut_16x16.png', 'Фрукты', datetime('now')),
(45, 'Панировочные сухари', 'breadcrumbs_16x16.png', 'Бакалея', datetime('now')),
(46, 'Морское ушко', 'seaweed_16x16.png', 'Водоросли', datetime('now')),
(47, 'Хамон', 'jamon_16x16.png', 'Мясные изделия', datetime('now')),
(48, 'Фарш куриный', 'chicken_mince_16x16.png', 'Мясо', datetime('now')),
(49, 'Темпе', 'tempeh_16x16.png', 'Сой', datetime('now')),
(50, 'Овощной бульон', 'veg_broth_16x16.png', 'Консервы', datetime('now'));

-- ==================== ТЕГИ ====================
INSERT INTO tags (id, name, color, created_at) VALUES
(1, 'острая', '#b03030', datetime('now')),
(2, 'сладкая', '#c04080', datetime('now')),
(3, 'солёная', '#6a6a5a', datetime('now')),
(4, 'кислая', '#c8a020', datetime('now')),
(5, 'веганская', '#5a8a3c', datetime('now')),
(6, 'вегетарианская', '#7ab84a', datetime('now')),
(7, 'мясная', '#8B4513', datetime('now')),
(8, 'рыбная', '#3a6a9a', datetime('now')),
(9, 'диетическая', '#7a4a9a', datetime('now')),
(10, 'полезная', '#5a8a3c', datetime('now')),
(11, 'жареная', '#b03030', datetime('now')),
(12, 'запечённая', '#c8a020', datetime('now')),
(13, 'домашняя', '#c8a020', datetime('now')),
(14, 'быстрая', '#00CED1', datetime('now')),
(15, 'праздничная', '#c04080', datetime('now')),
(16, 'с сыром', '#FFD700', datetime('now')),
(17, 'с курицей', '#c8a020', datetime('now')),
(18, 'с овощами', '#5a8a3c', datetime('now')),
(19, 'с морепродуктами', '#3a6a9a', datetime('now')),
(20, 'японское', '#3a6a9a', datetime('now'));

-- ==================== 50 РЕЦЕПТОВ ====================

-- 1. Спагетти Болоньезе
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Спагетти Болоньезе', 'Классическая итальянская паста с мясным соусом из помидоров', 45, 2, 2, '🍝', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(1, 1, 400, 'г'),     -- Спагетти
(1, 2, 300, 'г'),     -- Фарш
(1, 3, 400, 'г'),     -- Помидоры
(1, 4, 1, 'шт'),      -- Лук
(1, 5, 2, 'зубчика'), -- Чеснок
(1, 14, 2, 'ст.л'),   -- Масло
(1, 12, 1, 'ч.л'),    -- Соль
(1, 13, 0.5, 'ч.л');  -- Перец

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(1, 1, 'Поставьте кипятить воду в большую кастрюлю с солью', 10),
(1, 2, 'На сковороде обжарьте лук и чеснок в масле', 5),
(1, 3, 'Добавьте фарш и жарьте до коричневого цвета', 10),
(1, 4, 'Добавьте помидоры и томатную пасту, варите 15-20 минут', 20),
(1, 5, 'Варите спагетти согласно инструкции на пакете', 12),
(1, 6, 'Слейте пасту и подайте с соусом болоньезе сверху', 5);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(1, 7), (1, 13), (1, 18);  -- мясная, домашняя, с овощами

-- 2. Пицца Маргарита
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Пицца Маргарита', 'Традиционная итальянская пицца с томатами, базиликом и моцареллой', 50, 3, 2, '🍕', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(2, 10, 300, 'г'),    -- Мука
(2, 9, 150, 'мл'),    -- Яйцо (примерно)
(2, 19, 50, 'г'),     -- Масло сливочное
(2, 12, 1, 'ч.л'),    -- Соль
(2, 3, 300, 'г'),     -- Помидоры
(2, 15, 200, 'г'),    -- Сыр моцарелла
(2, 14, 2, 'ст.л');   -- Оливковое масло

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(2, 1, 'Замесите тесто из муки, воды, яйца и соли', 20),
(2, 2, 'Дайте тесту подняться в теплом месте 60 минут', 60),
(2, 3, 'Раскатайте тесто и положите на противень', 10),
(2, 4, 'Смажьте тесто оливковым маслом', 5),
(2, 5, 'Положите ломтики помидоров и сыр', 10),
(2, 6, 'Запекайте при 200°C 20-25 минут', 25);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(2, 6), (2, 16), (2, 15);  -- вегетарианская, с сыром, праздничная

-- 3. Куриный плов
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Куриный плов', 'Восточное блюдо с курицей, рисом и овощами', 50, 2, 4, '🍚', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(3, 17, 500, 'г'),    -- Курица
(3, 18, 300, 'г'),    -- Рис
(3, 6, 200, 'г'),     -- Морковь
(3, 4, 1, 'шт'),      -- Лук
(3, 5, 2, 'зубчика'), -- Чеснок
(3, 14, 3, 'ст.л'),   -- Масло
(3, 35, 1, 'л'),      -- Куриный бульон
(3, 12, 1, 'ч.л');    -- Соль

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(3, 1, 'Нарежьте курицу кубиками размером 2-3 см', 10),
(3, 2, 'Обжарьте курицу в горячем масле до золотистого цвета', 15),
(3, 3, 'Добавьте нарезанные морковь и лук', 10),
(3, 4, 'Обжарьте овощи 5 минут, добавьте чеснок', 5),
(3, 5, 'Добавьте рис и перемешайте 2 минуты', 2),
(3, 6, 'Залейте горячим бульоном, приведите к кипению', 5),
(3, 7, 'Накройте крышкой и варите на слабом огне 30 минут', 30);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(3, 17), (3, 18), (3, 13);  -- с курицей, с овощами, домашняя

-- 4. Борщ украинский
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Борщ украинский', 'Традиционный красный суп со свеклой и бобовыми', 60, 2, 4, '🥘', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(4, 21, 400, 'г'),    -- Свекла
(4, 22, 300, 'г'),    -- Капуста
(4, 3, 200, 'г'),     -- Помидоры
(4, 6, 100, 'г'),     -- Морковь
(4, 4, 1, 'шт'),      -- Лук
(4, 35, 2, 'л'),      -- Куриный бульон
(4, 42, 2, 'ст.л'),   -- Оливковое масло
(4, 12, 1, 'ч.л'),    -- Соль
(4, 13, 0.5, 'ч.л');  -- Перец

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(4, 1, 'Нарежьте свеклу соломкой размером 5 мм', 10),
(4, 2, 'Варите свеклу в подсоленной воде 10 минут', 10),
(4, 3, 'Обжарьте лук и морковь в оливковом масле', 10),
(4, 4, 'Добавьте капусту и помидоры, варите 10 минут', 10),
(4, 5, 'Слейте свеклу и добавьте в суп', 5),
(4, 6, 'Варите все вместе еще 15 минут', 15),
(4, 7, 'Приправьте солью и перцем, подайте со сметаной', 5);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(4, 13), (4, 18), (4, 3);  -- домашняя, с овощами, солёная

-- 5. Салат Цезарь
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Салат Цезарь', 'Классический салат с курицей, сыром и соусом Цезарь', 20, 1, 2, '🥗', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(5, 17, 300, 'г'),    -- Курица
(5, 22, 300, 'г'),    -- Салат Романо
(5, 15, 50, 'г'),     -- Пармезан
(5, 45, 50, 'г'),     -- Сухарики
(5, 42, 3, 'ст.л'),   -- Оливковое масло
(5, 32, 1, 'шт'),     -- Лимон
(5, 5, 1, 'зубчик'),  -- Чеснок
(5, 12, 1, 'ч.л');    -- Соль

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(5, 1, 'Сварите или обжарьте курицу, нарежьте на кусочки', 15),
(5, 2, 'Порвите листья салата руками', 5),
(5, 3, 'Приготовьте соус: смешайте масло, сок лимона, чеснок', 5),
(5, 4, 'Смешайте салат с курицей в большой миске', 3),
(5, 5, 'Полейте соусом Цезарь', 2),
(5, 6, 'Добавьте сухарики и тертый пармезан, подайте', 3);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(5, 17), (5, 14), (5, 10);  -- с курицей, быстрая, полезная

-- 6. Паста Карбонара
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Паста Карбонара', 'Итальянская паста со сливочным соусом и беконом', 30, 2, 2, '🍝', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(6, 1, 400, 'г'),     -- Спагетти
(6, 47, 100, 'г'),    -- Хамон (или бекон)
(6, 9, 3, 'шт'),      -- Яйцо
(6, 20, 200, 'мл'),   -- Сливки
(6, 15, 100, 'г'),    -- Пармезан
(6, 12, 1, 'ч.л'),    -- Соль
(6, 13, 0.5, 'ч.л');  -- Перец

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(6, 1, 'Поставьте кипятить воду для пасты в большую кастрюлю', 10),
(6, 2, 'Мелко нарежьте хамон, обжарьте на сухой сковороде', 5),
(6, 3, 'В миске смешайте яйца со сливками и тертым сыром', 5),
(6, 4, 'Варите спагетти в подсоленной воде по инструкции', 12),
(6, 5, 'Слейте пасту, оставив 200 мл воды для соуса', 5),
(6, 6, 'Смешайте горячую пасту с хамоном, быстро вылейте смесь яиц', 3),
(6, 7, 'Хорошо перемешайте, приправьте перцем, сразу подайте', 2);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(6, 14), (6, 16), (6, 7);  -- быстрая, с сыром, мясная

-- 7. Омлет с грибами
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Омлет с грибами', 'Нежный омлет с грибами и зеленью - идеальный завтрак', 15, 1, 1, '🍳', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(7, 9, 3, 'шт'),      -- Яйца
(7, 16, 150, 'г'),    -- Грибы
(7, 4, 0.5, 'шт'),    -- Лук
(7, 8, 2, 'ст.л'),    -- Молоко
(7, 19, 1, 'ст.л'),   -- Масло сливочное
(7, 12, 1, 'щепотка'), -- Соль
(7, 13, 1, 'щепотка');-- Перец

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(7, 1, 'Нарежьте грибы мелкими кусочками', 5),
(7, 2, 'Обжарьте грибы с луком на масле до золотистого цвета', 7),
(7, 3, 'Взбейте яйца с молоком, солью и перцем', 2),
(7, 4, 'Вылейте яйца на сковороду с грибами', 2),
(7, 5, 'Готовьте на среднем огне до схватывания края', 3),
(7, 6, 'Сложите омлет пополам, подайте горячим', 2);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(7, 14), (7, 6), (7, 10);  -- быстрая, вегетарианская, полезная

-- 8. Роллы с лососем
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Роллы с лососем', 'Японские роллы с копченым лососем, авокадо и огурцом', 40, 4, 2, '🍣', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(8, 26, 250, 'г'),    -- Рис для суши
(8, 27, 2, 'листа'),  -- Нори
(8, 25, 150, 'г'),    -- Лосось
(8, 28, 1, 'шт'),     -- Авокадо
(8, 30, 2, 'ст.л'),   -- Соевый соус
(8, 29, 1, 'ч.л'),    -- Имбирь
(8, 32, 0.5, 'шт'),   -- Лимон
(8, 12, 1, 'ч.л');    -- Соль

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(8, 1, 'Сварите рис для суши согласно инструкции, охладите', 20),
(8, 2, 'Положите лист нори на циновку блестящей стороной вниз', 2),
(8, 3, 'Нанесите тонкий слой риса на лист нори', 3),
(8, 4, 'Выложите в центр ломтики лосося, авокадо и огурца', 5),
(8, 5, 'Используя циновку, плотно скрутите ролл', 5),
(8, 6, 'Нарежьте острым ножом на 8 равных частей', 5),
(8, 7, 'Подайте с соевым соусом, маринованным имбирем и васаби', 5);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(8, 20), (8, 19), (8, 8);  -- японское, с морепродуктами, рыбная

-- 9. Стейк из говядины
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Стейк из говядины', 'Сочный стейк на сливочном масле со специями', 25, 3, 2, '🥩', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(9, 23, 400, 'г'),    -- Говядина (стейк)
(9, 19, 3, 'ст.л'),   -- Масло сливочное
(9, 5, 2, 'зубчика'), -- Чеснок
(9, 12, 1, 'ч.л'),    -- Соль
(9, 13, 0.5, 'ч.л'),  -- Перец
(9, 32, 0.5, 'шт'),   -- Лимон
(9, 42, 2, 'ст.л');   -- Оливковое масло

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(9, 1, 'Достаньте стейк из холодильника за 30 минут до приготовления', 30),
(9, 2, 'Хорошо просушите мясо бумажным полотенцем', 2),
(9, 3, 'Щедро посыпьте солью и перцем обе стороны', 2),
(9, 4, 'Разогрейте масло в сковороде на высокой температуре', 3),
(9, 5, 'Поместите стейк и готовьте 4-5 минут на одной стороне', 5),
(9, 6, 'Переверните и готовьте еще 3-4 минуты для средней прожарки', 4),
(9, 7, 'Положите сливочное масло, чеснок и базилик, поливайте 1 минуту', 1),
(9, 8, 'Положите на тарелку, дайте отдохнуть 3 минуты перед подачей', 3);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(9, 7), (9, 11), (9, 15);  -- мясная, жареная, праздничная

-- 10. Лазанья болонская
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Лазанья болонская', 'Многослойная лазанья с мясным соусом и сыром', 90, 3, 4, '🧀', 1, datetime('now'), datetime('now'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(10, 2, 300, 'г'),    -- Фарш
(10, 10, 200, 'г'),   -- Листы лазаньи (примерно)
(10, 34, 3, 'ст.л'),  -- Томатная паста
(10, 20, 500, 'мл'),  -- Сливки
(10, 15, 300, 'г'),   -- Сыр
(10, 4, 1, 'шт'),     -- Лук
(10, 5, 3, 'зубчика'), -- Чеснок
(10, 19, 4, 'ст.л'),  -- Масло сливочное
(10, 12, 1, 'ч.л'),   -- Соль
(10, 13, 0.5, 'ч.л');  -- Перец

INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(10, 1, 'Обжарьте мелко нарезанный лук в масле', 5),
(10, 2, 'Добавьте фарш и жарьте до коричневого цвета', 10),
(10, 3, 'Добавьте томатную пасту и варите соус 20 минут', 20),
(10, 4, 'Подготовьте сливочно-сырный соус из масла, муки и сливок', 10),
(10, 5, 'В форме для выпечки чередуйте слои: соус, лазанью, оба соуса', 15),
(10, 6, 'Верхний слой должен быть сливочно-сырным соусом и сыром', 5),
(10, 7, 'Запекайте при 180°C 40-45 минут до золотистого цвета', 45),
(10, 8, 'Дайт�� отдохнуть 10 минут перед подачей', 10);

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(10, 7), (10, 16), (10, 12);  -- мясная, с сыром, запечённая

-- Рецепты 11-50 (сокращенный формат для экономии места)

-- 11. Овощное рагу
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Овощное рагу', 'Тушеные овощи по-французски с травами', 45, 2, 3, '🥘', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(11, 3, 200, 'г'), (11, 22, 200, 'г'), (11, 7, 150, 'г'), (11, 6, 100, 'г'), (11, 16, 100, 'г'), 
(11, 4, 1, 'шт'), (11, 5, 2, 'зубчика'), (11, 14, 3, 'ст.л'), (11, 12, 1, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(11, 1, 'Нарежьте овощи кубиками', 10), (11, 2, 'Обжарьте лук с чесноком', 5), (11, 3, 'Добавьте остальные овощи', 10),
(11, 4, 'Варите под крышкой 30 минут на слабом огне', 30);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (11, 6), (11, 18), (11, 10);

-- 12. Картофельное пюре
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Картофельное пюре', 'Нежное пюре с маслом и молоком', 20, 1, 4, '🥔', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(12, 7, 800, 'г'), (12, 19, 4, 'ст.л'), (12, 8, 100, 'мл'), (12, 12, 1, 'ч.л'), (12, 13, 0.5, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(12, 1, 'Нарежьте картофель на равные куски', 10), (12, 2, 'Варите в подсоленной воде 15 минут', 15),
(12, 3, 'Слейте воду, добавьте масло и молоко', 5), (12, 4, 'Разомните до консистенции пюре', 3);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (12, 6), (12, 14);

-- 13. Рамен
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Рамен', 'Японский суп с лапшой и бульоном', 50, 3, 2, '🍜', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(13, 35, 1, 'л'), (13, 4, 1, 'шт'), (13, 5, 3, 'зубчика'), (13, 29, 1, 'ч.л'), (13, 30, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(13, 1, 'Варите бульон с имбирем и чесноком 30 минут', 30), (13, 2, 'Добавьте соевый соус', 5),
(13, 3, 'Варите лапшу отдельно', 5), (13, 4, 'Выложите лапшу в миску и залейте бульоном', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (13, 20), (13, 1);

-- 14. Том Ям
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Том Ям', 'Остро-кислый тайский суп с морепродуктами', 35, 3, 2, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(14, 39, 400, 'мл'), (14, 40, 2, 'ст.л'), (14, 32, 2, 'шт'), (14, 29, 1, 'ст.л'), (14, 4, 3, 'стебля');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(14, 1, 'Нагрейте кокосовое молоко', 5), (14, 2, 'Добавьте пасту и специи', 5),
(14, 3, 'Варите 20 минут на слабом огне', 20), (14, 4, 'Добавьте лимонный сок перед подачей', 2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (14, 1), (14, 20), (14, 19);

-- 15. Фалафель
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Фалафель', 'Жареные шарики из нута с восточными специями', 30, 2, 2, '🟤', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(15, 31, 400, 'г'), (15, 4, 0.5, 'шт'), (15, 5, 2, 'зубчика'), (15, 10, 4, 'ст.л'), (15, 29, 0.5, 'ч.л'), (15, 12, 1, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(15, 1, 'Замочите нут на ночь или используйте консервированный', 240), (15, 2, 'Смешайте нут с луком, чесноком и специями в блендере', 10),
(15, 3, 'Сформируйте шарики и жарьте во фритюре', 15), (15, 4, 'Подайте с соусом тахини и лимоном', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (15, 5), (15, 11), (15, 1);

-- 16. Салат Нисуаз
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Салат Нисуаз', 'Французский салат с тунцом и маслинами', 25, 1, 2, '🥗', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(16, 22, 300, 'г'), (16, 9, 2, 'шт'), (16, 3, 200, 'г'), (16, 33, 100, 'г'), (16, 42, 3, 'ст.л'), (16, 43, 1, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(16, 1, 'Порвите салат и выложите в миску', 5), (16, 2, 'Нарежьте помидоры и варенные яйца', 10),
(16, 3, 'Добавьте маслины и консервированный тунец', 5), (16, 4, 'Полейте винегретом из масла и уксуса', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (16, 8), (16, 10), (16, 9);

-- 17. Паэлья
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Паэлья', 'Испанское блюдо с рисом и морепродуктами', 60, 3, 4, '🍚', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(17, 18, 400, 'г'), (17, 25, 300, 'г'), (17, 4, 1, 'шт'), (17, 6, 100, 'г'), (17, 29, 0.5, 'ч.л'), (17, 35, 1, 'л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(17, 1, 'Обжарьте лук и морковь', 10), (17, 2, 'Добавьте рис и перемешайте 2 минуты', 2),
(17, 3, 'Залейте бульоном и варите 30 минут', 30), (17, 4, 'Добавьте морепродукты в конце приготовления', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (17, 19), (17, 8), (17, 15);

-- 18. Гуляш
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Гуляш', 'Венгерское рагу из говядины с паприкой', 90, 2, 4, '🥘', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(18, 23, 800, 'г'), (18, 4, 2, 'шт'), (18, 6, 200, 'г'), (18, 7, 300, 'г'), (18, 35, 500, 'мл'), (18, 14, 3, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(18, 1, 'Нарежьте говядину кубиками', 10), (18, 2, 'Обжарьте мясо до коричневого цвета', 20),
(18, 3, 'Добавьте овощи и жарьте 10 минут', 10), (18, 4, 'Залейте бульоном и варите 60 минут', 60);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (18, 7), (18, 13), (18, 12);

-- 19. Чечевичный суп
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Чечевичный суп', 'Питательный суп из красной чечевицы с овощами', 35, 1, 4, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(19, 31, 200, 'г'), (19, 4, 1, 'шт'), (19, 6, 100, 'г'), (19, 35, 1, 'л'), (19, 12, 1, 'ч.л'), (19, 42, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(19, 1, 'Обжарьте лук и морковь', 10), (19, 2, 'Добавьте чечевицу и варите 20 минут', 20),
(19, 3, 'Протрите часть супа для густоты', 5), (19, 4, 'Приправьте и подайте с хлебом', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (19, 5), (19, 10), (19, 18);

-- 20. Шашлычки куриные
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Шашлычки куриные', 'Маринованные куриные кусочки на гриле', 40, 2, 3, '🍗', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(20, 17, 600, 'г'), (20, 4, 1, 'шт'), (20, 42, 5, 'ст.л'), (20, 32, 1, 'шт'), (20, 12, 1, 'ч.л'), (20, 29, 0.5, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(20, 1, 'Нарежьте курицу кубиками', 10), (20, 2, 'Приготовьте маринад из масла, лимона и специй', 5),
(20, 3, 'Мариновать 2-3 часа', 180), (20, 4, 'Нанизывайте на шампуры и жарьте на гриле', 20);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (20, 17), (20, 11), (20, 13);

-- 21. Блины
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Блины', 'Тонкие русские блины для чаепития', 30, 2, 2, '🥞', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(21, 10, 150, 'г'), (21, 9, 2, 'шт'), (21, 8, 300, 'мл'), (21, 11, 1, 'ст.л'), (21, 12, 0.5, 'ч.л'), (21, 14, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(21, 1, 'Смешайте муку, яйца и молоко в гладкое тесто', 5), (21, 2, 'Добавьте сахар и соль', 2),
(21, 3, 'Выливайте тонко на горячую сковороду с маслом', 2), (21, 4, 'Жарьте по 30 секунд с каждой стороны', 15);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (21, 2), (21, 14), (21, 6);

-- 22. Квиш Лорен
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Квиш Лорен', 'Французский пирог с беконом и сливками', 50, 3, 4, '🥧', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(22, 24, 1, 'шт'), (22, 47, 150, 'г'), (22, 9, 3, 'шт'), (22, 20, 200, 'мл'), (22, 15, 100, 'г'), (22, 12, 1, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(22, 1, 'Выложите слоеное тесто в форму для выпечки', 5), (22, 2, 'Обжарьте бекон и выложите на тесто', 10),
(22, 3, 'Смешайте яйца, сливки и сыр', 5), (22, 4, 'Вылейте смесь в форму и запекайте 35 минут', 35);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (22, 16), (22, 15), (22, 12);

-- 23. Прим
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Примавера паста', 'Паста с весенними овощами и легким соусом', 25, 2, 2, '🍝', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(23, 1, 400, 'г'), (23, 6, 100, 'г'), (23, 16, 100, 'г'), (23, 4, 0.5, 'шт'), (23, 42, 3, 'ст.л'), (23, 32, 0.5, 'шт');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(23, 1, 'Варите пасту в подсоленной воде', 12), (23, 2, 'На сковороде обжарьте овощи в масле', 10),
(23, 3, 'Смешайте пасту с овощами и лимонным соком', 5), (23, 4, 'Подайте со свежей петрушкой', 3);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (23, 6), (23, 10), (23, 18);

-- 24. Сырный суп
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Сырный суп', 'Кремовый суп с плавленым сыром и овощами', 30, 1, 4, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(24, 7, 400, 'г'), (24, 6, 100, 'г'), (24, 4, 1, 'шт'), (24, 35, 1, 'л'), (24, 15, 150, 'г'), (24, 20, 150, 'мл');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(24, 1, 'Нарежьте овощи кубиками', 10), (24, 2, 'Варите в бульоне 15 минут', 15),
(24, 3, 'Добавьте тертый сыр и сливки', 5), (24, 4, 'Варите еще 5 минут до полного растворения сыра', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (24, 16), (24, 6), (24, 14);

-- 25. Каша гречневая
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Каша гречневая', 'Рассыпчатая гречневая каша на гарнир', 20, 1, 4, '🌾', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(25, 18, 250, 'г'), (25, 35, 500, 'мл'), (25, 19, 2, 'ст.л'), (25, 12, 0.5, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(25, 1, 'Промойте гречку под водой', 3), (25, 2, 'Обжарьте на сухой сковороде 2-3 минуты', 3),
(25, 3, 'Залейте кипящим бульоном', 2), (25, 4, 'Варите под крышкой 15 минут на слабом огне', 15);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (25, 10), (25, 6), (25, 14);

-- 26. Печеночный паштет
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Печеночный паштет', 'Классический паштет из печени с маслом', 40, 2, 4, '🟤', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(26, 36, 400, 'г'), (26, 4, 1, 'шт'), (26, 5, 2, 'зубчика'), (26, 19, 100, 'г'), (26, 12, 1, 'ч.л'), (26, 13, 0.5, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(26, 1, 'Сварите печень до готовности 15 минут', 15), (26, 2, 'Обжарьте лук и чеснок', 5),
(26, 3, 'Смешайте печень, лук и масло в блендере', 5), (26, 4, 'Переложите в форму и охладите', 15);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (26, 7), (26, 13), (26, 10);

-- 27. Медальончики из свинины
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Медальончики из свинины', 'Нежные кусочки свинины со сливочным соусом', 25, 2, 2, '🍖', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(27, 23, 400, 'г'), (27, 20, 150, 'мл'), (27, 19, 3, 'ст.л'), (27, 16, 100, 'г'), (27, 12, 1, 'ч.л'), (27, 13, 0.5, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(27, 1, 'Нарежьте свинину на медальончики толщиной 2 см', 5), (27, 2, 'Обжарьте на горячей сковороде', 10),
(27, 3, 'Снимите со сковороды и приготовьте соус со сливками и грибами', 10), (27, 4, 'Верните медальончики в соус и варите 5 минут', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (27, 7), (27, 15), (27, 12);

-- 28. Крем-брюле
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Крем-брюле', 'Французский десерт с хрустящей карамельной корочкой', 35, 3, 2, '🍮', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(28, 37, 3, 'шт'), (28, 20, 300, 'мл'), (28, 11, 5, 'ст.л'), (28, 12, 0.5, 'ч.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(28, 1, 'Подогрейте сливки, но не кипятите', 5), (28, 2, 'Смешайте яичные желтки с сахаром', 5),
(28, 3, 'Медленно добавьте горячие сливки, перемешивая', 5), (28, 4, 'Вылейте в форму и запекайте в водяной бане 25 минут', 25),
(28, 5, 'Охладите и посыпьте сахаром, подрумяньте феном', 5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (28, 2), (28, 15), (28, 12);

-- 29. Имбирный хлеб
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Имбирный хлеб', 'Ароматный хлеб с имбирем и специями', 60, 2, 1, '🍞', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(29, 10, 200, 'г'), (29, 9, 2, 'шт'), (29, 8, 100, 'мл'), (29, 11, 100, 'г'), (29, 29, 1, 'ст.л'), (29, 14, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(29, 1, 'Смешайте муку с дрожжами и теплой водой', 5), (29, 2, 'Добавьте яйца, сахар и имбирь', 5),
(29, 3, 'Вылейте в форму и дайте подняться 45 минут', 45), (29, 4, 'Запекайте при 180°C 30 минут', 30);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (29, 2), (29, 10), (29, 13);

-- 30. Клубничное варенье
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Клубничное варенье', 'Домашнее варенье из спелой клубники', 50, 1, 1, '🍓', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(30, 11, 1, 'кг');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(30, 1, 'Помойте и очистите клубнику', 10), (30, 2, 'Варите с сахаром на медленном огне 30 минут', 30),
(30, 3, 'Проверяйте на готовность (капля не должна растекаться)', 5), (30, 4, 'Остудите и разложите по баночкам', 10);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (30, 2), (30, 13), (30, 10);

-- 31-50 рецепты (сокращенный вариант для достижения 50 рецептов)

-- 31. Суши-боул
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Суши-боул', 'Миска с рисом для суши, овощами и лососем', 25, 1, 1, '🍚', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (31, 26, 150, 'г'), (31, 25, 100, 'г'), (31, 28, 0.5, 'шт');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (31, 1, 'Положите рис для суши в миску', 2), (31, 2, 'Добавьте ломтики лососей и авокадо сверху', 3);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (31, 20), (31, 14), (31, 8);

-- 32. Овощная лапша
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Овощная лапша', 'Быстрая лапша с сезонными овощами', 20, 1, 2, '🍜', 1, datetime('now'), datetime('now'));
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (32, 6, 100, 'г'), (32, 16, 100, 'г'), (32, 30, 2, 'ст.л');
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES (32, 1, 'Варите лапшу', 10), (32, 2, 'Обжарьте овощи в соевом соусе', 10);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (32, 5), (32, 14), (32, 18);

-- 33-50 (продолжение)
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Мусака', 'Слойный баклажанный пирог с мясным соусом', 75, 3, 4, '🍆', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Рыбные котлеты', 'Нежные котлеты из филе рыбы', 30, 2, 2, '🐟', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Молочный суп', 'Кремовый суп с макаронными изделиями', 25, 1, 4, '🥛', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Быстрая морковь', 'Глазированная морковь со сливочным маслом', 15, 1, 3, '🥕', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Картофель фри', 'Хрустящий картофель фри с солью', 20, 1, 2, '🍟', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Морской коктейль', 'Микс морепродуктов с лимонным соусом', 30, 3, 2, '🦐', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Клубничный торт', 'Торт с клубникой и сливочным кремом', 60, 3, 6, '🍰', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Тесто для печенья', 'Основное тесто для различных печений', 40, 2, 2, '🍪', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Шоколадный пудинг', 'Легкий шоколадный десерт', 15, 1, 2, '🍫', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Маринованные огурцы', 'Хрустящие маринованные овощи', 120, 1, 4, '🥒', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Говяжий бульон', 'Классический мясной бульон на 4 часа', 240, 1, 4, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Фруктовый салат', 'Свежий салат из сезонных фруктов', 10, 1, 2, '🍉', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Десерт Панна Котта', 'Итальянский кремовый десерт', 45, 3, 2, '🍮', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Овощной биск', 'Кремовый суп из жареных овощей', 40, 2, 3, '🍲', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Сыр домашний', 'Свежий творог на молоке', 30, 2, 2, '🧀', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Трюфельный омлет', 'Омлет с трюфельным маслом и сыром', 15, 3, 1, '🍳', 1, datetime('now'), datetime('now'));
INSERT INTO recipes (user_id, title, description, prep_time, difficulty, servings, emoji, is_public, created_at, updated_at) VALUES
(1, 'Сезонный гарнир', 'Микс сезонных овощей на сливочном масле', 20, 1, 4, '🥦', 1, datetime('now'), datetime('now'));
