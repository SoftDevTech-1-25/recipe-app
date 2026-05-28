package main

import (
	"log"
	"os"
	"time"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

// ==================== МОДЕЛИ ====================

type User struct {
	ID           uint      `json:"id" gorm:"primaryKey"`
	Username     string    `json:"username" gorm:"uniqueIndex;not null"`
	Email        string    `json:"email" gorm:"uniqueIndex;not null"`
	PasswordHash string    `json:"-" gorm:"not null"`
	AvatarURL    string    `json:"avatar_url"`
	Theme        string    `json:"theme" gorm:"default:overworld"`
	Units        string    `json:"units" gorm:"default:metric"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type Category struct {
	ID      uint   `json:"id" gorm:"primaryKey"`
	Name    string `json:"name" gorm:"uniqueIndex;not null"`
	IconURL string `json:"icon_url"`
	Color   string `json:"color" gorm:"default:#FFFFFF"`
}

type Tag struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Name      string    `json:"name" gorm:"uniqueIndex;not null"`
	Color     string    `json:"color" gorm:"default:#5a8a3c"`
	CreatedAt time.Time `json:"created_at"`
}

type Ingredient struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Name      string    `json:"name" gorm:"uniqueIndex;not null"`
	IconURL   string    `json:"icon_url"`
	Category  string    `json:"category"`
	CreatedAt time.Time `json:"created_at"`
}

type Recipe struct {
	ID          uint               `json:"id" gorm:"primaryKey"`
	UserID      uint               `json:"user_id" gorm:"not null"`
	Title       string             `json:"title" gorm:"not null"`
	Description string             `json:"description"`
	CategoryID  *uint              `json:"category_id"`
	Category    Category           `json:"category,omitempty" gorm:"foreignKey:CategoryID"`
	PrepTime    int                `json:"prep_time" gorm:"not null"`
	Difficulty  int                `json:"difficulty"`
	Servings    int                `json:"servings" gorm:"default:2"`
	ImageURL    string             `json:"image_url"`
	Emoji       string             `json:"emoji" gorm:"default:🍽"`
	IsPublic    bool               `json:"is_public" gorm:"default:true"`
	Tags        []Tag              `json:"tags" gorm:"many2many:recipe_tags;"`
	Ingredients []RecipeIngredient `json:"ingredients,omitempty" gorm:"foreignKey:RecipeID"`
	Steps       []RecipeStep       `json:"steps,omitempty" gorm:"foreignKey:RecipeID"`
	CreatedAt   time.Time          `json:"created_at"`
	UpdatedAt   time.Time          `json:"updated_at"`
}

type RecipeIngredient struct {
	ID           uint       `json:"id" gorm:"primaryKey"`
	RecipeID     uint       `json:"recipe_id" gorm:"not null"`
	IngredientID uint       `json:"ingredient_id" gorm:"not null"`
	Ingredient   Ingredient `json:"ingredient,omitempty" gorm:"foreignKey:IngredientID"`
	Quantity     float64    `json:"quantity" gorm:"not null"`
	Unit         string     `json:"unit" gorm:"not null"`
	SlotPosition *int       `json:"slot_position"`
}

type RecipeStep struct {
	ID          uint   `json:"id" gorm:"primaryKey"`
	RecipeID    uint   `json:"recipe_id" gorm:"not null"`
	StepOrder   int    `json:"step_order" gorm:"not null"`
	Description string `json:"description" gorm:"not null"`
	Duration    *int   `json:"duration"`
	ImageURL    string `json:"image_url"`
}

type Favorite struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	UserID    uint      `json:"user_id" gorm:"not null"`
	RecipeID  uint      `json:"recipe_id" gorm:"not null"`
	CreatedAt time.Time `json:"created_at"`
}

// ==================== DTO для фронта ====================

type RecipeResponse struct {
	ID          uint                `json:"id"`
	Name        string              `json:"name"`
	Title       string              `json:"title"`
	Description string              `json:"description"`
	Tags        []string            `json:"tags"`
	Emoji       string              `json:"emoji"`
	Time        int                 `json:"time"`
	Difficulty  string              `json:"difficulty"`
	Servings    int                 `json:"servings"`
	ImageURL    string              `json:"image_url"`
	Category    string              `json:"category"`
	Ingredients []RecipeIngredient  `json:"ingredients,omitempty"`
	Steps       []RecipeStep        `json:"steps,omitempty"`
}

func recipeToResponse(r Recipe) RecipeResponse {
	tags := make([]string, len(r.Tags))
	for i, t := range r.Tags {
		tags[i] = t.Name
	}

	diff := "лёгкий"
	if r.Difficulty >= 4 {
		diff = "сложный"
	} else if r.Difficulty == 3 {
		diff = "средний"
	}

	catName := ""
	if r.Category.ID != 0 {
		catName = r.Category.Name
	}

	return RecipeResponse{
		ID:          r.ID,
		Name:        r.Title,
		Title:       r.Title,
		Description: r.Description,
		Tags:        tags,
		Emoji:       r.Emoji,
		Time:        r.PrepTime,
		Difficulty:  diff,
		Servings:    r.Servings,
		ImageURL:    r.ImageURL,
		Category:    catName,
		Ingredients: r.Ingredients,
		Steps:       r.Steps,
	}
}

// ==================== ПОДКЛЮЧЕНИЕ ====================

func InitDB() {
	var err error
	DB, err = gorm.Open(sqlite.Open("data/init.db"), &gorm.Config{})
	if err != nil {
		log.Fatal("❌ Не удалось подключиться к БД:", err)
	}

	DB.AutoMigrate(
		&User{}, &Category{}, &Tag{}, &Ingredient{},
		&Recipe{}, &RecipeIngredient{}, &RecipeStep{},
		&Favorite{},
	)

	log.Println("✅ БД подключена")

	// Авто-импорт если таблица пустая
	var count int64
	DB.Model(&Recipe{}).Count(&count)
	if count == 0 {
		if data, err := os.ReadFile("import.sql"); err == nil {
			DB.Exec(string(data))
			log.Println("✅ Авто-импорт выполнен")
		} else {
			log.Println("ℹ import.sql не найден, используем SeedData")
			SeedData()
		}
		// Авто-создание тегов
		RunSeedTags()
		// Авто-привязка тегов
		RunFixTags()
	} else {
		log.Printf("ℹ БД уже содержит %d рецептов", count)
	}
}

// ==================== SEED ====================

func SeedData() {
	cats := []Category{
		{Name: "Веган", IconURL: "vegan_16x16.png", Color: "#567D46"},
		{Name: "Мясо", IconURL: "meat_16x16.png", Color: "#8B4513"},
		{Name: "Десерты", IconURL: "cake_16x16.png", Color: "#FF69B4"},
		{Name: "Итальянская", IconURL: "pasta_16x16.png", Color: "#FFD700"},
		{Name: "Быстрое", IconURL: "fast_16x16.png", Color: "#00CED1"},
		{Name: "Напитки", IconURL: "potion_16x16.png", Color: "#4169E1"},
		{Name: "Супы", IconURL: "soup_16x16.png", Color: "#FF6347"},
	}
	for _, c := range cats {
		DB.FirstOrCreate(&c, Category{Name: c.Name})
	}

	tagList := []struct{ Name, Color string }{
		{"острая", "#b03030"}, {"сладкая", "#c04080"}, {"солёная", "#6a6a5a"},
		{"кислая", "#c8a020"}, {"веганская", "#5a8a3c"}, {"вегетарианская", "#7ab84a"},
		{"мясная", "#8B4513"}, {"рыбная", "#3a6a9a"}, {"диетическая", "#7a4a9a"},
		{"полезная", "#5a8a3c"}, {"жареная", "#b03030"}, {"запечённая", "#c8a020"},
		{"домашняя", "#c8a020"}, {"быстрая", "#00CED1"}, {"праздничная", "#c04080"},
		{"с сыром", "#FFD700"}, {"с курицей", "#c8a020"}, {"с овощами", "#5a8a3c"},
		{"с морепродуктами", "#3a6a9a"}, {"японское", "#3a6a9a"}, {"салат", "#5a8a3c"},
	}
	for _, t := range tagList {
		DB.FirstOrCreate(&Tag{Name: t.Name, Color: t.Color}, Tag{Name: t.Name})
	}

	ings := []Ingredient{
		{Name: "Спагетти", IconURL: "spaghetti_16x16.png", Category: "Макароны"},
		{Name: "Фарш говяжий", IconURL: "beef_16x16.png", Category: "Мясо"},
		{Name: "Помидор", IconURL: "tomato_16x16.png", Category: "Овощи"},
		{Name: "Лук", IconURL: "onion_16x16.png", Category: "Овощи"},
		{Name: "Чеснок", IconURL: "garlic_16x16.png", Category: "Овощи"},
		{Name: "Морковь", IconURL: "carrot_16x16.png", Category: "Овощи"},
		{Name: "Картофель", IconURL: "potato_16x16.png", Category: "Овощи"},
		{Name: "Молоко", IconURL: "milk_16x16.png", Category: "Молочка"},
		{Name: "Яйцо", IconURL: "egg_16x16.png", Category: "Молочка"},
		{Name: "Мука", IconURL: "flour_16x16.png", Category: "Бакалея"},
		{Name: "Сахар", IconURL: "sugar_16x16.png", Category: "Бакалея"},
		{Name: "Соль", IconURL: "salt_16x16.png", Category: "Специи"},
		{Name: "Перец", IconURL: "pepper_16x16.png", Category: "Специи"},
		{Name: "Подсолнечное масло", IconURL: "oil_16x16.png", Category: "Бакалея"},
		{Name: "Сыр", IconURL: "cheese_16x16.png", Category: "Молочка"},
		{Name: "Грибы", IconURL: "mushroom_16x16.png", Category: "Овощи"},
		{Name: "Курица", IconURL: "chicken_16x16.png", Category: "Мясо"},
		{Name: "Рис", IconURL: "rice_16x16.png", Category: "Бакалея"},
	}
	for _, ing := range ings {
		DB.FirstOrCreate(&ing, Ingredient{Name: ing.Name})
	}

	var guest User
	DB.FirstOrCreate(&guest, User{Username: "guest", Email: "guest@local"})
	if guest.ID == 0 {
		guest.Username = "guest"
		guest.Email = "guest@local"
		guest.PasswordHash = "-"
		DB.Create(&guest)
	}

	var count int64
	DB.Model(&Recipe{}).Count(&count)
	if count > 0 {
		return
	}

	tagID := func(name string) uint {
		var t Tag
		DB.Where("name = ?", name).First(&t)
		return t.ID
	}
	catID := func(name string) uint {
		var c Category
		DB.Where("name = ?", name).First(&c)
		return c.ID
	}

	catPizza := catID("Итальянская")
	pizza := Recipe{
		UserID:      guest.ID,
		Title:       "Пицца с сыром",
		Description: "Классическая итальянская пицца с томатным соусом и сыром моцарелла",
		CategoryID:  &catPizza,
		PrepTime:    40,
		Difficulty:  3,
		Servings:    2,
		Emoji:       "🍕",
	}
	DB.Create(&pizza)
	DB.Model(&pizza).Association("Tags").Append(
		&Tag{ID: tagID("острая")},
		&Tag{ID: tagID("вегетарианская")},
	)

	catFast := catID("Быстрое")
	sushi := Recipe{
		UserID:      guest.ID,
		Title:       "Сет суши",
		Description: "Ассорти из роллов с лососем, тунцом и авокадо",
		CategoryID:  &catFast,
		PrepTime:    60,
		Difficulty:  4,
		Servings:    2,
		Emoji:       "🍣",
	}
	DB.Create(&sushi)
	DB.Model(&sushi).Association("Tags").Append(
		&Tag{ID: tagID("японское")},
		&Tag{ID: tagID("с морепродуктами")},
	)

	catSoup := catID("Супы")
	soup := Recipe{
		UserID:      guest.ID,
		Title:       "Чечевичный суп",
		Description: "Сытный суп из красной чечевицы с овощами",
		CategoryID:  &catSoup,
		PrepTime:    35,
		Difficulty:  2,
		Servings:    4,
		Emoji:       "🥣",
	}
	DB.Create(&soup)
	DB.Model(&soup).Association("Tags").Append(
		&Tag{ID: tagID("вегетарианская")},
		&Tag{ID: tagID("с овощами")},
	)

	salad := Recipe{
		UserID:      guest.ID,
		Title:       "Салат Цезарь",
		Description: "Классический салат с курицей, сыром пармезан и соусом Цезарь",
		PrepTime:    20,
		Difficulty:  1,
		Servings:    2,
		Emoji:       "🥗",
	}
	DB.Create(&salad)
	DB.Model(&salad).Association("Tags").Append(
		&Tag{ID: tagID("салат")},
		&Tag{ID: tagID("с курицей")},
	)

	spag := Recipe{
		UserID:      guest.ID,
		Title:       "Спагетти Болоньезе",
		Description: "Итальянская паста с мясным соусом болоньезе",
		CategoryID:  &catPizza,
		PrepTime:    45,
		Difficulty:  3,
		Servings:    3,
		Emoji:       "🍝",
	}
	DB.Create(&spag)
	DB.Model(&spag).Association("Tags").Append(
		&Tag{ID: tagID("мясная")},
		&Tag{ID: tagID("домашняя")},
	)

	chicken := Recipe{
		UserID:      guest.ID,
		Title:       "Куриные крылышки",
		Description: "Острые куриные крылышки в медово-соевом соусе",
		PrepTime:    30,
		Difficulty:  2,
		Servings:    2,
		Emoji:       "🍗",
	}
	DB.Create(&chicken)
	DB.Model(&chicken).Association("Tags").Append(
		&Tag{ID: tagID("быстрая")},
		&Tag{ID: tagID("с курицей")},
	)

	log.Println("🌱 Seed завершён: 6 рецептов")
}
func RunSeedTags() {
	tagList := []struct{ Name, Color string }{
		{"острая", "#b03030"}, {"сладкая", "#c04080"}, {"солёная", "#6a6a5a"},
		{"кислая", "#c8a020"}, {"веганская", "#5a8a3c"}, {"вегетарианская", "#7ab84a"},
		{"мясная", "#8B4513"}, {"рыбная", "#3a6a9a"}, {"диетическая", "#7a4a9a"},
		{"полезная", "#5a8a3c"}, {"жареная", "#b03030"}, {"запечённая", "#c8a020"},
		{"домашняя", "#c8a020"}, {"быстрая", "#00CED1"}, {"праздничная", "#c04080"},
		{"с сыром", "#FFD700"}, {"с курицей", "#c8a020"}, {"с овощами", "#5a8a3c"},
		{"с морепродуктами", "#3a6a9a"}, {"японское", "#3a6a9a"}, {"салат", "#5a8a3c"},
	}

	for _, t := range tagList {
		var existing Tag
		DB.Where("name = ?", t.Name).First(&existing)
		if existing.ID == 0 {
			DB.Create(&Tag{Name: t.Name, Color: t.Color})
		}
	}
	log.Println("✅ Теги созданы")
}

func RunFixTags() {
	fixes := map[string][]string{
		"Пицца":      {"вегетарианская", "с сыром"},
		"Роллы":      {"японское", "с морепродуктами"},
		"Борщ":       {"с овощами", "домашняя"},
		"Цезарь":     {"салат", "с курицей"},
		"Карбонара":  {"итальянская", "быстрая"},
		"Тирамису":   {"сладкая", "десерт"},
		"Уха":        {"рыбная", "суп"},
		"Стейк":      {"мясная", "жареная"},
		"Пельмени":   {"домашняя", "мясная"},
		"Шашлык":     {"жареная", "мясная"},
		"Блины":      {"быстрая", "десерт"},
		"Рамен":      {"японское", "суп"},
		"Том Ям":     {"острая", "суп"},
		"Фалафель":   {"веганская", "жареная"},
		"Лазанья":    {"итальянская", "запечённая"},
		"Пад Тай":    {"азиатская", "острая"},
		"Чизкейк":    {"сладкая", "десерт"},
		"Минестроне": {"суп", "вегетарианская"},
		"Плов":       {"домашняя", "мясная"},
		"Манты":      {"домашняя", "мясная"},
		"Фо Бо":      {"острая", "суп"},
		"Рататуй":    {"вегетарианская", "запечённая"},
		"Чуррос":     {"сладкая", "жареная"},
		"Гаспачо":    {"с овощами", "холодная"},
		"Нисуаз":     {"салат", "рыбная"},
		"Вареники":   {"домашняя", "вегетарианская"},
		"Мисо":       {"японское", "суп"},
		"Тако":       {"быстрая", "мясная"},
		"Паэлья":     {"морепродукты", "испанская"},
		"Крем-брюле": {"сладкая", "десерт"},
		"Солянка":    {"суп", "мясная"},
		"Табуле":     {"салат", "веганская"},
		"Кебаб":      {"мясная", "жареная"},
		"Хачапури":   {"с сыром", "запечённая"},
		"Фондю":      {"с сыром", "быстрая"},
		"Гуляш":      {"мясная", "домашняя"},
		"Мусака":     {"запечённая", "домашняя"},
		"Каннеллони": {"итальянская", "запечённая"},
		"Самоса":     {"острая", "жареная"},
		"Эклеры":     {"сладкая", "десерт"},
		"Харчо":      {"острая", "суп"},
		"Баклава":    {"сладкая", "десерт"},
	}

	fixed := 0
	for keyword, tagNames := range fixes {
		var recipes []Recipe
		DB.Where("title LIKE ?", "%"+keyword+"%").Find(&recipes)

		for _, recipe := range recipes {
			for _, tagName := range tagNames {
				var tag Tag
				DB.Where("name = ?", tagName).First(&tag)
				if tag.ID == 0 {
					continue
				}

				var exists int64
				DB.Raw("SELECT COUNT(*) FROM recipe_tags WHERE recipe_id = ? AND tag_id = ?", recipe.ID, tag.ID).Scan(&exists)
				if exists == 0 {
					DB.Exec("INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (?, ?)", recipe.ID, tag.ID)
					fixed++
				}
			}
		}
	}
	log.Printf("✅ Теги привязаны: %d связей", fixed)
}
