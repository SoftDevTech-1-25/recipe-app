-- ==========================================
-- full_seed.sql — ЧИСТАЯ КАЧЕСТВЕННАЯ БАЗА (32 рецепта)
-- ==========================================

PRAGMA foreign_keys = ON;

-- 1. Создание таблиц
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  avatar_url TEXT,
  theme TEXT DEFAULT 'overworld',
  units TEXT DEFAULT 'metric',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  icon_url TEXT,
  color TEXT
);

CREATE TABLE IF NOT EXISTS tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  color TEXT
);

CREATE TABLE IF NOT EXISTS ingredients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  icon_url TEXT,
  category TEXT
);

CREATE TABLE IF NOT EXISTS recipes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  category_id INTEGER,
  prep_time INTEGER,
  difficulty INTEGER,
  servings INTEGER DEFAULT 2,
  image_url TEXT,
  emoji TEXT,
  is_public BOOLEAN DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS recipe_steps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recipe_id INTEGER NOT NULL,
  step_order INTEGER NOT NULL,
  description TEXT NOT NULL,
  duration INTEGER,
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
  PRIMARY KEY (recipe_id, tag_id)
);

-- 2. Очистка старых данных
DELETE FROM recipe_tags;
DELETE FROM recipe_ingredients;
DELETE FROM recipe_steps;
DELETE FROM recipes;
DELETE FROM ingredients;
DELETE FROM categories;
DELETE FROM tags;
DELETE FROM users;

DELETE FROM sqlite_sequence WHERE name IN (
    'users','categories','tags','ingredients',
    'recipes','recipe_steps','recipe_ingredients'
);

-- 3. Базовые данные
INSERT INTO categories (id, name, color) VALUES
(1, 'Итальянская', '#FFD700'),
(2, 'Русская', '#FF6347'),
(3, 'Азиатская', '#FF4500'),
(4, 'Мясные блюда', '#8B4513'),
(5, 'Супы', '#FF6347'),
(6, 'Десерты', '#FF69B4'),
(7, 'Салаты', '#90EE90');

INSERT INTO tags (id, name, color) VALUES
(1, 'острая', '#b03030'), (2, 'веганская', '#5a8a3c'), (3, 'мясная', '#8B4513'),
(4, 'с сыром', '#FFD700'), (5, 'домашняя', '#c8a020'), (6, 'быстрая', '#00CED1'),
(7, 'вегетарианская', '#7ab84a'), (8, 'сладкая', '#c04080'), (9, 'рыбная', '#3a6a9a');

INSERT INTO users (id, username, email, password_hash) VALUES
(1, 'guest', 'guest@local', '-');

-- ==================== ИНГРЕДИЕНТЫ (62 шт) ====================
INSERT INTO ingredients (id, name, category) VALUES
(1,'Спагетти','Макароны'),(2,'Фарш говяжий','Мясо'),(3,'Помидор','Овощи'),
(4,'Лук','Овощи'),(5,'Чеснок','Овощи'),(6,'Морковь','Овощи'),
(7,'Моцарелла','Молочка'),(8,'Курица','Мясо'),(9,'Рис','Крупы'),
(10,'Картофель','Овощи'),(11,'Сметана','Молочка'),(12,'Яйцо','Молочка'),
(13,'Мука','Бакалея'),(14,'Сыр','Молочка'),(15,'Бекон','Мясо'),
(16,'Лосось','Рыба'),(17,'Нори','Морепродукты'),(18,'Капуста','Овощи'),
(19,'Свекла','Овощи'),(20,'Томатная паста','Соусы'),(21,'Сливки','Молочка'),
(22,'Грибы','Овощи'),(23,'Лапша яичная','Макароны'),(24,'Креветки','Морепродукты'),
(25,'Кокосовое молоко','Напитки'),(26,'Паста Том Ям','Приправы'),(27,'Рисовая лапша','Макароны'),
(28,'Соевый соус','Приправы'),(29,'Имбирь','Овощи'),(30,'Огурец','Овощи'),
(31,'Авокадо','Овощи'),(32,'Говядина','Мясо'),(33,'Свинина','Мясо'),
(34,'Баранина','Мясо'),(35,'Перец болгарский','Овощи'),(36,'Баклажан','Овощи'),
(37,'Кабачок','Овощи'),(38,'Яблоко','Фрукты'),(39,'Масло сливочное','Молочка'),
(40,'Мёд','Бакалея'),(41,'Ванилин','Специи'),(42,'Разрыхлитель','Бакалея'),
(43,'Молоко','Молочка'),(44,'Масло растительное','Бакалея'),(45,'Зелень','Овощи'),
(46,'Лимон','Фрукты'),(47,'Майонез','Приправы'),(48,'Горошек зелёный','Консервы'),
(49,'Соль','Специи'),(50,'Перец чёрный','Специи'),(51,'Вода','Напитки'),
(52,'Дрожжи','Бакалея'),(53,'Томатный соус','Соусы'),(54,'Масло оливковое','Бакалея'),
(55,'Маскарпоне','Молочка'),(56,'Печенье Савоярди','Бакалея'),(57,'Кофе','Напитки'),
(58,'Рыба белая','Рыба'),(59,'Соус Терияки','Приправы'),(60,'Кунжут','Специи'),
(61,'Сахар','Бакалея'),(62,'Сливочный сыр','Молочка');

-- ==================== РЕЦЕПТЫ (32 шт) ====================

-- 1. Спагетти Болоньезе
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(1,1,'Спагетти Болоньезе','Классическая итальянская паста с мясным соусом из говяжьего фарша и томатов',45,2,3,'🍝',1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(1,1,300,'г',1),(1,2,400,'г',2),(1,3,3,'шт',3),(1,4,1,'шт',4),(1,5,2,'зубч',5),(1,20,2,'ст.л',6),(1,14,50,'г',7),(1,49,1,'щепотка',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(1,1,'Обжарить фарш с луком и чесноком до румяной корочки',10),
(1,2,'Добавить помидоры и томатную пасту, тушить 20 минут',20),
(1,3,'Отварить спагетти в подсоленной воде до аль денте',10),
(1,4,'Смешать горячую пасту с соусом',3),
(1,5,'Посыпать тёртым сыром и подать горячим',2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (1,3),(1,5);

-- 2. Паста Карбонара
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(2,1,'Паста Карбонара','Нежная паста с беконом, яйцом и сыром в сливочном соусе',25,2,2,'🍝',1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(2,1,200,'г',1),(2,15,150,'г',2),(2,12,3,'шт',3),(2,14,80,'г',4),(2,21,100,'мл',5),(2,5,1,'зубч',6),(2,49,1,'щепотка',7),(2,50,1,'щепотка',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(2,1,'Обжарить нарезанный бекон с чесноком до хрустящей корочки',5),
(2,2,'Взбить яйца со сливками и тёртым сыром',5),
(2,3,'Отварить спагетти, сохранить немного воды',10),
(2,4,'Смешать горячую пасту с беконом и яичной смесью',3),
(2,5,'Посыпать перцем и подать немедленно',2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (2,3),(2,4);

-- 3. Пицца Маргарита
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(3,1,'Пицца Маргарита','Классическая пицца на тонком тесте с моцареллой и томатным соусом',90,2,2,'🍕',1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(3,13,250,'г',1),(3,51,150,'мл',2),(3,52,5,'г',3),(3,3,2,'шт',4),(3,7,200,'г',5),(3,54,2,'ст.л',6),(3,49,1,'щепотка',7),(3,53,3,'ст.л',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(3,1,'Замесить тесто из муки, воды, дрожжей и соли, оставить на 1 час',60),
(3,2,'Раскатать тесто в тонкую лепёшку',10),
(3,3,'Смазать оливковым маслом, выложить томатный соус',5),
(3,4,'Разложить кружочки помидоров и нарезанную моцареллу',5),
(3,5,'Выпекать 12–15 минут при 220°C до золотистой корочки',15);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (3,4),(3,7);

-- 4. Паста с грибами и сливками
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(4,1,'Паста с грибами','Феттучине в нежном сливочном соусе с шампиньонами и сыром',30,1,2,'🍝',1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(4,1,250,'г',1),(4,22,300,'г',2),(4,21,200,'мл',3),(4,14,60,'г',4),(4,5,2,'зубч',5),(4,39,1,'ст.л',6),(4,49,1,'щепотка',7),(4,50,1,'щепотка',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(4,1,'Отварить пасту до состояния аль денте',10),
(4,2,'Обжарить грибы со сливочным маслом и чесноком',8),
(4,3,'Влить сливки, добавить сыр, прогреть до растворения',5),
(4,4,'Смешать с пастой и тушить 2 минуты',2),
(4,5,'Посыпать зеленью и подать',5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (4,4),(4,7);

-- 5. Ризотто с курицей
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(5,1,'Ризотто с курицей','Кремовое итальянское ризотто с кусочками курицы и грибами',40,2,3,'🍚',1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(5,9,250,'г',1),(5,8,300,'г',2),(5,22,200,'г',3),(5,21,150,'мл',4),(5,14,50,'г',5),(5,4,1,'шт',6),(5,39,1,'ст.л',7),(5,49,1,'щепотка',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(5,1,'Обжарить нарезанную курицу до готовности, отложить',8),
(5,2,'Обжарить лук и грибы, добавить рис и прогреть',5),
(5,3,'Влить сливки и немного воды, тушить помешивая',20),
(5,4,'Вернуть курицу, добавить сыр и масло',5),
(5,5,'Накрыть крышкой и дать настояться 2 минуты',2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (5,3),(5,4);

-- 6. Том Ям
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(6,1,'Том Ям с креветками','Острый тайский суп с креветками, кокосовым молоком и лемонграссом',30,2,2,'🍲',3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(6,24,250,'г',1),(6,25,200,'мл',2),(6,26,2,'ст.л',3),(6,51,500,'мл',4),(6,29,20,'г',5),(6,46,0.5,'шт',6),(6,49,1,'щепотка',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(6,1,'Довести воду до кипения, растворить пасту Том Ям',3),
(6,2,'Добавить имбирь и креветки, варить 5 минут',5),
(6,3,'Влить кокосовое молоко и довести до кипения',5),
(6,4,'Выжать сок лимона, посолить',2),
(6,5,'Разлить по мискам и подать горячим',5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (6,1),(6,5);

-- 7. Азиатская лапша с курицей
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(7,1,'Лапша с курицей по-азиатски','Жареная яичная лапша с курицей, овощами и соевым соусом',25,1,2,'🍜',3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(7,23,200,'г',1),(7,8,250,'г',2),(7,4,1,'шт',3),(7,5,2,'зубч',4),(7,29,15,'г',5),(7,28,2,'ст.л',6),(7,44,2,'ст.л',7),(7,45,1,'пучок',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(7,1,'Отварить лапшу, промыть холодной водой',8),
(7,2,'Обжарить нарезанную курицу до готовности',7),
(7,3,'Добавить лук, чеснок и имбирь, обжарить',3),
(7,4,'Выложить лапшу, полить соевым соусом, перемешать',5),
(7,5,'Посыпать зеленью и подать',2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (7,6);

-- 8. Пад Тай
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(8,1,'Пад Тай','Тайская жареная рисовая лапша с креветками, яйцом и арахисом',25,2,2,'🍜',3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(8,27,200,'г',1),(8,24,200,'г',2),(8,12,2,'шт',3),(8,4,1,'шт',4),(8,28,2,'ст.л',5),(8,44,2,'ст.л',6),(8,61,1,'ст.л',7),(8,46,0.5,'шт',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(8,1,'Замочить рисовую лапшу в тёплой воде на 10 минут',10),
(8,2,'Обжарить креветки до розового цвета',4),
(8,3,'Добавить яйцо, быстро перемешать',2),
(8,4,'Выложить лапшу с соевым соусом и сахаром, жарить 5 минут',5),
(8,5,'Полить лимонным соком и подать',4);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (8,1),(8,6);

-- 9. Роллы Филадельфия
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(9,1,'Роллы Филадельфия','Классические роллы с лососем, сливочным сыром и авокадо',40,3,2,'🍣',3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(9,17,3,'листа',1),(9,9,150,'г',2),(9,16,100,'г',3),(9,30,0.5,'шт',4),(9,31,1,'шт',5),(9,62,100,'г',6),(9,28,1,'ч.л',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(9,1,'Сварить рис, заправить смесью уксуса и сахара, остудить',20),
(9,2,'Выложить нори на коврик, равномерно распределить рис',5),
(9,3,'Положить лосось, авокадо, огурец и сливочный сыр в ряд',5),
(9,4,'Завернуть плотным рулетом при помощи коврика',5),
(9,5,'Нарезать на 8 равных кусочков и подать',5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (9,6),(9,9);

-- 10. Курица Терияки
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(10,1,'Курица Терияки','Куриное филе в карамельном соусе Терияки с кунжутом',20,1,2,'🍗',3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(10,8,400,'г',1),(10,59,3,'ст.л',2),(10,28,1,'ст.л',3),(10,5,2,'зубч',4),(10,44,1,'ст.л',5),(10,49,1,'щепотка',6),(10,50,1,'щепотка',7),(10,60,1,'ст.л',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(10,1,'Нарезать курицу полосками, обжарить на сильном огне',6),
(10,2,'Добавить измельчённый чеснок',1),
(10,3,'Влить соус Терияки и соевый соус',2),
(10,4,'Тушить до загустения соуса 5 минут',5),
(10,5,'Посыпать кунжутом и подать с отварным рисом',6);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (10,6);

-- 11. Борщ
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(11,1,'Борщ украинский','Настоящий красный борщ со свёклой, говядиной и сметаной',90,2,4,'🥘',2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(11,32,300,'г',1),(11,19,2,'шт',2),(11,18,200,'г',3),(11,3,2,'шт',4),(11,4,1,'шт',5),(11,6,1,'шт',6),(11,10,3,'шт',7),(11,20,3,'ст.л',8),(11,44,2,'ст.л',9),(11,49,1,'щепотка',10);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(11,1,'Сварить говядину до готовности, получить бульон',40),
(11,2,'Нарезать свёклу соломкой, обжарить с томатной пастой',10),
(11,3,'Нарезать остальные овощи кубиками',10),
(11,4,'Добавить овощи в бульон, варить 20 минут',20),
(11,5,'Добавить зажарку из свёклы, посолить, варить ещё 10 минут',10);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (11,3),(11,5);

-- 12. Грибной крем-суп
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(12,1,'Грибной крем-суп','Нежный суп-пюре из шампиньонов со сливками и гренками',35,1,3,'🍄',5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(12,22,400,'г',1),(12,10,2,'шт',2),(12,4,1,'шт',3),(12,21,150,'мл',4),(12,43,200,'мл',5),(12,39,1,'ст.л',6),(12,49,1,'щепотка',7),(12,45,1,'пучок',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(12,1,'Нарезать грибы, картофель и лук',5),
(12,2,'Обжарить грибы с луком до золотистого цвета',7),
(12,3,'Добавить картофель, залить водой или бульоном, варить 15 минут',15),
(12,4,'Измельчить блендером до однородности',3),
(12,5,'Влить сливки и молоко, довести до кипения, посыпать зеленью',5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (12,5),(12,7);

-- 13. Куриный суп с лапшой
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(13,1,'Куриный суп с лапшой','Лёгкий домашний суп с курицей, овощами и яичной лапшой',35,1,4,'🍗',5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(13,8,300,'г',1),(13,23,100,'г',2),(13,4,1,'шт',3),(13,6,1,'шт',4),(13,10,2,'шт',5),(13,45,1,'пучок',6),(13,49,1,'щепотка',7),(13,50,1,'щепотка',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(13,1,'Залить курицу водой, варить бульон 20 минут',20),
(13,2,'Достать курицу, разобрать на волокна',5),
(13,3,'Нарезать овощи, добавить в бульон',5),
(13,4,'Вернуть курицу, добавить лапшу, варить 7 минут',7),
(13,5,'Посыпать зеленью и подать',3);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (13,6),(13,5);

-- 14. Уха по-русски
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(14,1,'Уха по-русски','Душистая рыбная похлёбка с овощами и зеленью',40,1,4,'🐟',5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(14,58,600,'г',1),(14,10,2,'шт',2),(14,4,1,'шт',3),(14,6,1,'шт',4),(14,45,1,'пучок',5),(14,49,1,'щепотка',6),(14,50,1,'щепотка',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(14,1,'Почистить рыбу, залить водой, варить бульон 20 минут',20),
(14,2,'Достать рыбу, отделить филе от костей',5),
(14,3,'Нарезать картофель и морковь, добавить в бульон',5),
(14,4,'Варить до готовности овощей 10 минут',10),
(14,5,'Вернуть рыбу, посыпать зеленью',5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (14,9),(14,5);

-- 15. Стейк из говядины
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(15,1,'Стейк из говядины','Сочный стейк средней прожарки с чёрным перцем',20,2,2,'🥩',4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(15,32,400,'г',1),(15,49,1,'щепотка',2),(15,50,1,'щепотка',3),(15,44,1,'ст.л',4),(15,39,20,'г',5);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(15,1,'Достать мясо из холодильника за 30 минут до готовки',1),
(15,2,'Обсушить бумажным полотенцем, посолить и поперчить',2),
(15,3,'Разогреть сковороду до дыма, обжарить по 4 минуты с каждой стороны',8),
(15,4,'Добавить сливочное масло, полить стейк',2),
(15,5,'Дать отдохнуть под фольгой 5 минут, затем нарезать',5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (15,3);

-- 16. Бефстроганов
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(16,1,'Бефстроганов','Классический русский обед: говядина в сметанном соусе с луком',35,2,3,'🥘',4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(16,32,400,'г',1),(16,4,2,'шт',2),(16,11,200,'г',3),(16,44,2,'ст.л',4),(16,49,1,'щепотка',5),(16,50,1,'щепотка',6),(16,45,1,'пучок',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(16,1,'Нарезать говядину тонкими брусочками',5),
(16,2,'Обжарить мясо на сильном огне до румяной корочки',7),
(16,3,'Добавить лук, обжарить до мягкости',5),
(16,4,'Влить сметану, добавить специи, тушить 10 минут',10),
(16,5,'Посыпать зеленью, подать с картофельным пюре',8);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (16,3),(16,5);

-- 17. Шашлык из свинины
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(17,1,'Шашлык из свинины','Сочный маринованный шашлык с луком и лимоном',180,2,4,'🍖',4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(17,33,1000,'г',1),(17,4,3,'шт',2),(17,46,1,'шт',3),(17,49,1,'ст.л',4),(17,50,1,'ч.л',5),(17,44,2,'ст.л',6);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(17,1,'Нарезать свинину крупными кусками',10),
(17,2,'Нарезать лук кольцами, выжать лимонный сок',5),
(17,3,'Замариновать мясо с луком, солью и перцем на 3 часа',180),
(17,4,'Нанизать мясо на шампуры',10),
(17,5,'Жарить на углях 15–20 минут, периодически переворачивая',20);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (17,3),(17,5);

-- 18. Плов узбекский
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(18,1,'Плов узбекский','Ароматный плов с бараниной, морковью и специями',90,2,4,'🍚',4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(18,9,400,'г',1),(18,34,500,'г',2),(18,4,2,'шт',3),(18,6,2,'шт',4),(18,44,100,'мл',5),(18,49,1,'щепотка',6),(18,50,1,'щепотка',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(18,1,'Обжарить нарезанную баранину до румяной корочки',10),
(18,2,'Добавить нарезанный лук, обжарить до золотистого',5),
(18,3,'Добавить морковь соломкой, обжарить',7),
(18,4,'Засыпать промытый рис, залить водой на 2 см выше',2),
(18,5,'Томить на медленном огне до впитывания воды 40 минут',40);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (18,3),(18,5);

-- 19. Домашние котлеты
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(19,1,'Домашние котлеты','Сочные жареные котлеты из говяжьего фарша с луком',35,1,4,'🍔',4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(19,2,600,'г',1),(19,12,1,'шт',2),(19,13,3,'ст.л',3),(19,4,1,'шт',4),(19,43,100,'мл',5),(19,44,2,'ст.л',6),(19,49,1,'щепотка',7),(19,50,1,'щепотка',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(19,1,'Измельчить лук, смешать с фаршем, яйцом и мукой',10),
(19,2,'Добавить молоко, соль, перец, вымесить фарш',5),
(19,3,'Сформировать котлеты, обвалять в муке',5),
(19,4,'Обжарить на растительном масле по 5 минут с каждой стороны',10),
(19,5,'Держать под крышкой 5 минут перед подачей',5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (19,3),(19,5);

-- 20. Тёплый салат с курицей
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(20,1,'Тёплый салат с курицей','Сытный салат с обжаренной курицей, свежими овощами и сыром',15,1,2,'🥗',7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(20,8,200,'г',1),(20,3,2,'шт',2),(20,30,1,'шт',3),(20,14,50,'г',4),(20,47,2,'ст.л',5),(20,49,1,'щепотка',6),(20,50,1,'щепотка',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(20,1,'Обжарить куриное филе до готовности, нарезать полосками',8),
(20,2,'Нарезать помидоры и огурец кубиками',3),
(20,3,'Натереть сыр',2),
(20,4,'Смешать овощи, курицу и сыр',1),
(20,5,'Заправить майонезом, посолить и поперчить',1);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (20,6);

-- 21. Овощной салат летний
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(21,1,'Овощной салат летний','Лёгкий витаминный салат из свежих овощей с оливковым маслом',10,1,2,'🥗',7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(21,3,2,'шт',1),(21,30,2,'шт',2),(21,35,1,'шт',3),(21,4,0.5,'шт',4),(21,54,2,'ст.л',5),(21,46,0.5,'шт',6),(21,49,1,'щепотка',7),(21,50,1,'щепотка',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(21,1,'Нарезать помидоры дольками',2),
(21,2,'Нарезать огурец полукольцами',2),
(21,3,'Нарезать перец соломкой',2),
(21,4,'Мелко нарезать лук',1),
(21,5,'Смешать всё, заправить маслом и лимонным соком, посолить',3);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (21,2),(21,7);

-- 22. Салат Оливье
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(22,1,'Салат Оливье','Новогодний классический салат с курицей, овощами и майонезом',30,1,6,'🥗',7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(22,10,4,'шт',1),(22,6,2,'шт',2),(22,48,1,'банка',3),(22,30,3,'шт',4),(22,12,4,'шт',5),(22,8,200,'г',6),(22,47,3,'ст.л',7),(22,49,1,'щепотка',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(22,1,'Отварить картофель, морковь и яйца до готовности',20),
(22,2,'Нарезать все ингредиенты кубиками одинакового размера',5),
(22,3,'Добавить горошек и майонез',2),
(22,4,'Аккуратно перемешать',2),
(22,5,'Украсить зеленью и охладить перед подачей',1);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (22,5),(22,9);

-- 23. Винегрет
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(23,1,'Винегрет','Постный овощной салат со свёклой и квашеной капустой',25,1,4,'🥗',7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(23,19,2,'шт',1),(23,10,3,'шт',2),(23,6,2,'шт',3),(23,48,1,'банка',4),(23,54,2,'ст.л',5),(23,49,1,'щепотка',6),(23,50,1,'щепотка',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(23,1,'Отварить свёклу, картофель и морковь до готовности',20),
(23,2,'Нарезать овощи кубиками',3),
(23,3,'Добавить горошек',1),
(23,4,'Заправить оливковым маслом, солью и перцем',1),
(23,5,'Перемешать и подать',0);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (23,2),(23,7);

-- 24. Блины тонкие
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(24,1,'Блины тонкие','Классические русские блины на молоке — идеальны с мёдом или икрой',30,1,4,'🥞',6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(24,12,3,'шт',1),(24,43,500,'мл',2),(24,13,200,'г',3),(24,61,1,'ст.л',4),(24,49,1,'щепотка',5),(24,44,2,'ст.л',6),(24,39,30,'г',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(24,1,'Взбить яйца с сахаром и солью',3),
(24,2,'Влить молоко, постепенно добавить муку, замесить тесто',5),
(24,3,'Добавить растительное масло, дать постоять 10 минут',10),
(24,4,'Жарить тонкие блины на сковороде с двух сторон',15),
(24,5,'Смазать сливочным маслом и подать',2);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (24,8),(24,5);

-- 25. Тирамису
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(25,1,'Тирамису','Итальянский десерт с маскарпоне, кофе и печеньем савоярди',30,2,4,'🍰',6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(25,55,250,'г',1),(25,12,3,'шт',2),(25,61,100,'г',3),(25,56,200,'г',4),(25,57,200,'мл',5),(25,41,1,'щепотка',6);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(25,1,'Взбить яичные желтки с сахаром до пышности',5),
(25,2,'Добавить маскарпоне, взбить до однородности',5),
(25,3,'Приготовить кофе, остудить',5),
(25,4,'Обмакнуть печенье в кофе и выложить слоем',5),
(25,5,'Покрыть кремом, повторить слои и убрать в холодильник на 2 часа',120);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (25,8),(25,9);

-- 26. Сметанная запеканка
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(26,1,'Сметанная запеканка','Нежная творожно-сметанная запеканка с изюмом или без',50,1,4,'🍮',6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(26,11,500,'г',1),(26,12,3,'шт',2),(26,61,100,'г',3),(26,13,2,'ст.л',4),(26,39,50,'г',5),(26,42,1,'ч.л',6),(26,49,1,'щепотка',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(26,1,'Смешать сметану с яйцами и сахаром',5),
(26,2,'Добавить муку, разрыхлитель и соль',3),
(26,3,'Вылить в форму, смазанную маслом',2),
(26,4,'Выпекать при 180°C 35–40 минут',40),
(26,5,'Остудить и нарезать порции',5);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (26,8),(26,5);

-- 27. Шарлотка с яблоками
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(27,1,'Шарлотка с яблоками','Пышная домашняя шарлотка с хрустящей корочкой и мягкими яблоками',45,1,6,'🍎',6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(27,12,4,'шт',1),(27,61,150,'г',2),(27,13,150,'г',3),(27,38,4,'шт',4),(27,42,0.5,'ч.л',5),(27,49,1,'щепотка',6),(27,39,30,'г',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(27,1,'Взбить яйца с сахаром до пышной светлой массы',5),
(27,2,'Просеять муку с разрыхлителем, аккуратно вмешать',3),
(27,3,'Нарезать яблоки дольками, добавить в тесто',3),
(27,4,'Вылить в форму, смазанную маслом',2),
(27,5,'Выпекать при 180°C 30–35 минут до золотистой корочки',35);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (27,8),(27,5);

-- 28. Панкейки
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(28,1,'Панкейки','Американские пышные блинчики на завтрак с мёдом или ягодами',20,1,2,'🥞',6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(28,13,150,'г',1),(28,61,2,'ст.л',2),(28,12,1,'шт',3),(28,43,200,'мл',4),(28,42,1,'ч.л',5),(28,39,30,'г',6),(28,49,1,'щепотка',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(28,1,'Смешать муку, сахар, разрыхлитель и соль',2),
(28,2,'Взбить яйцо с молоком и растопленным маслом',3),
(28,3,'Соединить жидкие и сухие ингредиенты',2),
(28,4,'Жарить на сухой сковороде до появления пузырьков',10),
(28,5,'Перевернуть, обжарить ещё 1 минуту и подать',3);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (28,8),(28,6);

-- 29. Омлет с сыром
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(29,1,'Омлет с сыром','Пышный завтрачный омлет с тёртым сыром и зеленью',10,1,1,'🍳',6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(29,12,3,'шт',1),(29,43,50,'мл',2),(29,14,40,'г',3),(29,49,1,'щепотка',4),(29,50,1,'щепотка',5),(29,44,1,'ст.л',6),(29,45,1,'пучок',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(29,1,'Взбить яйца с молоком, солью и перцем',2),
(29,2,'Разогреть сковороду с маслом',1),
(29,3,'Вылить яичную смесь, готовить на среднем огне',4),
(29,4,'Посыпать сыром, накрыть крышкой до расплавления',2),
(29,5,'Свернуть омлет и подать с зеленью',1);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (29,4),(29,6);

-- 30. Жареные кабачки
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(30,1,'Жареные кабачки','Хрустящие кольца кабачков в яичном кляре — идеальная закуска',20,1,2,'🥒',7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(30,37,2,'шт',1),(30,13,3,'ст.л',2),(30,12,1,'шт',3),(30,49,1,'щепотка',4),(30,50,1,'щепотка',5),(30,44,3,'ст.л',6);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(30,1,'Нарезать кабачки кольцами толщиной 1 см',3),
(30,2,'Приготовить кляр из муки, яйца, соли и перца',3),
(30,3,'Обмакнуть каждое кольцо в кляр',3),
(30,4,'Обжарить на растительном масле до золотистой корочки',10),
(30,5,'Выложить на бумажное полотенце и подать',1);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (30,2),(30,7);

-- 31. Рататуй
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(31,1,'Рататуй','Французское овощное рагу из баклажанов, кабачков и помидоров',50,2,3,'🍆',7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(31,36,1,'шт',1),(31,37,1,'шт',2),(31,3,3,'шт',3),(31,35,1,'шт',4),(31,4,1,'шт',5),(31,5,3,'зубч',6),(31,54,3,'ст.л',7),(31,45,1,'пучок',8);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(31,1,'Нарезать все овощи кружочками одинаковой толщины',8),
(31,2,'Обжарить лук и чеснок в оливковом масле',3),
(31,3,'Выложить овощи в форму чередуя цвета',5),
(31,4,'Запекать при 180°C под фольгой 30 минут',30),
(31,5,'Снять фольгу, запечь ещё 10 минут, посыпать зеленью',10);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (31,2),(31,7);

-- 32. Хачапури по-аджарски
INSERT INTO recipes (id, user_id, title, description, prep_time, difficulty, servings, emoji, category_id) VALUES
(32,1,'Хачапури по-аджарски','Грузинская лодочка из дрожжевого теста с расплавленным сыром и яйцом',70,3,2,'🥖',1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, slot_position) VALUES
(32,13,300,'г',1),(32,51,150,'мл',2),(32,52,5,'г',3),(32,12,1,'шт',4),(32,14,250,'г',5),(32,39,50,'г',6),(32,49,1,'щепотка',7);
INSERT INTO recipe_steps (recipe_id, step_order, description, duration) VALUES
(32,1,'Замесить тесто из муки, воды, дрожжей и соли, оставить на 40 минут',40),
(32,2,'Приготовить начинку из тёртого сыра',5),
(32,3,'Разделить тесто, сформировать лодочки, выложить сыр',10),
(32,4,'Выпекать при 220°C 15 минут до золотистой корочки',15),
(32,5,'Выложить яйцо в центр, допечь 3 минуты',3);
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (32,4),(32,5);

-- ==========================================
-- КОНЕЦ ФАЙЛА
-- ==========================================