-- Привязываем теги к рецептам по названию
INSERT OR IGNORE INTO recipe_tags (recipe_id, tag_id) 
SELECT r.id, t.id 
FROM recipes r
JOIN tags t ON (
    (r.title LIKE '%Пицца%' AND t.name = 'вегетарианская') OR
    (r.title LIKE '%Роллы%' AND t.name = 'японское') OR
    (r.title LIKE '%Борщ%' AND t.name = 'с овощами') OR
    (r.title LIKE '%Цезарь%' AND t.name = 'салат') OR
    (r.title LIKE '%Карбонара%' AND t.name = 'итальянская') OR
    (r.title LIKE '%Тирамису%' AND t.name = 'сладкая') OR
    (r.title LIKE '%Уха%' AND t.name = 'рыбная') OR
    (r.title LIKE '%Стейк%' AND t.name = 'мясная') OR
    (r.title LIKE '%Пельмени%' AND t.name = 'домашняя') OR
    (r.title LIKE '%Шашлык%' AND t.name = 'жареная') OR
    (r.title LIKE '%Блины%' AND t.name = 'быстрая') OR
    (r.title LIKE '%Рамен%' AND t.name = 'японское') OR
    (r.title LIKE '%Том Ям%' AND t.name = 'острая') OR
    (r.title LIKE '%Фалафель%' AND t.name = 'веганская') OR
    (r.title LIKE '%Лазанья%' AND t.name = 'итальянская') OR
    (r.title LIKE '%Пад Тай%' AND t.name = 'азиатская') OR
    (r.title LIKE '%Чизкейк%' AND t.name = 'десерт') OR
    (r.title LIKE '%Минестроне%' AND t.name = 'суп') OR
    (r.title LIKE '%Плов%' AND t.name = 'домашняя') OR
    (r.title LIKE '%Манты%' AND t.name = 'домашняя') OR
    (r.title LIKE '%Фо Бо%' AND t.name = 'острая') OR
    (r.title LIKE '%Рататуй%' AND t.name = 'вегетарианская') OR
    (r.title LIKE '%Чуррос%' AND t.name = 'сладкая') OR
    (r.title LIKE '%Гаспачо%' AND t.name = 'с овощами') OR
    (r.title LIKE '%Нисуаз%' AND t.name = 'салат') OR
    (r.title LIKE '%Вареники%' AND t.name = 'домашняя') OR
    (r.title LIKE '%Мисо%' AND t.name = 'японское') OR
    (r.title LIKE '%Тако%' AND t.name = 'быстрая') OR
    (r.title LIKE '%Паэлья%' AND t.name = 'морепродукты') OR
    (r.title LIKE '%Крем-брюле%' AND t.name = 'десерт') OR
    (r.title LIKE '%Солянка%' AND t.name = 'суп') OR
    (r.title LIKE '%Табуле%' AND t.name = 'салат') OR
    (r.title LIKE '%Кебаб%' AND t.name = 'мясная') OR
    (r.title LIKE '%Хачапури%' AND t.name = 'с сыром') OR
    (r.title LIKE '%Фондю%' AND t.name = 'с сыром') OR
    (r.title LIKE '%Гуляш%' AND t.name = 'мясная') OR
    (r.title LIKE '%Мусака%' AND t.name = 'запечённая') OR
    (r.title LIKE '%Каннеллони%' AND t.name = 'итальянская') OR
    (r.title LIKE '%Самоса%' AND t.name = 'острая') OR
    (r.title LIKE '%Эклеры%' AND t.name = 'сладкая') OR
    (r.title LIKE '%Харчо%' AND t.name = 'острая') OR
    (r.title LIKE '%Баклава%' AND t.name = 'сладкая')
);