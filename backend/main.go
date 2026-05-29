package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func main() {
	InitDB()

	// === АВТОМАТИЧЕСКИЙ СБРОС И ЗАПОЛНЕНИЕ БАЗЫ ===
	if os.Getenv("RESET_DB") == "true" {
		fmt.Println("🗑️  Полный сброс и заполнение базы данных...")

		// Очищаем таблицы
		DB.Exec("DELETE FROM recipe_tags")
		DB.Exec("DELETE FROM recipe_ingredients")
		DB.Exec("DELETE FROM recipe_steps")
		DB.Exec("DELETE FROM recipes")
		DB.Exec("DELETE FROM ingredients")
		DB.Exec("DELETE FROM categories")
		DB.Exec("DELETE FROM tags")
		DB.Exec("DELETE FROM users")

		fmt.Println("✅ База очищена")

		// Запускаем полное заполнение
		seedDatabase()
	}

	r := gin.Default()

	// CORS middleware
	r.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Health check
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	// API Routes
	api := r.Group("/api")
	{
		api.GET("/recipes", getRecipes)
		api.GET("/recipes/:id", getRecipeByID)
		api.POST("/recipes", createRecipe)
		api.DELETE("/recipes/:id", deleteRecipe)
		api.GET("/tags", getTags)
		api.GET("/categories", getCategories)

		// Эндпоинты для детальной страницы
		api.GET("/recipes/:id/ingredients", getRecipeIngredients)
		api.GET("/recipes/:id/steps", getRecipeSteps)

		// Админ
		api.GET("/admin/seed-tags", seedTagsHandler)
		api.GET("/admin/fix-all", fixAllTagsHandler)
	}

	r.Run(":8080")
}

// ====================== АВТОМАТИЧЕСКОЕ ЗАПОЛНЕНИЕ ======================

func seedDatabase() {
	fmt.Println("🌱 Запуск полного заполнения базы из full_seed.sql...")

	// Читаем и выполняем новый единый файл
	data, err := os.ReadFile("full_seed.sql")
	if err != nil {
		fmt.Println("❌ Ошибка чтения full_seed.sql:", err)
		return
	}

	if err := DB.Exec(string(data)).Error; err != nil {
		fmt.Println("⚠️ Ошибка выполнения full_seed.sql:", err)
	} else {
		fmt.Println("✅ full_seed.sql успешно выполнен (92 рецепта загружены)")
	}
}

// ====================== НОВЫЕ ФУНКЦИИ ======================

func getRecipeIngredients(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный ID рецепта"})
		return
	}

	var ingredients []RecipeIngredient
	DB.Preload("Ingredient").
		Where("recipe_id = ?", id).
		Order("slot_position ASC, id ASC").
		Find(&ingredients)

	c.JSON(http.StatusOK, ingredients)
}

func getRecipeSteps(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный ID рецепта"})
		return
	}

	var steps []RecipeStep
	DB.Where("recipe_id = ?", id).
		Order("step_order ASC").
		Find(&steps)

	c.JSON(http.StatusOK, steps)
}

// ====================== АДМИН ФУНКЦИИ ======================

func seedTagsHandler(c *gin.Context) {
	tagList := []struct{ Name, Color string }{
		{"острая", "#b03030"}, {"сладкая", "#c04080"}, {"солёная", "#6a6a5a"},
		{"кислая", "#c8a020"}, {"веганская", "#5a8a3c"}, {"вегетарианская", "#7ab84a"},
		{"мясная", "#8B4513"}, {"рыбная", "#3a6a9a"}, {"диетическая", "#7a4a9a"},
		{"полезная", "#5a8a3c"}, {"жареная", "#b03030"}, {"запечённая", "#c8a020"},
		{"домашняя", "#c8a020"}, {"быстрая", "#00CED1"}, {"праздничная", "#c04080"},
		{"с сыром", "#FFD700"}, {"с курицей", "#c8a020"}, {"с овощами", "#5a8a3c"},
	}

	created := 0
	for _, t := range tagList {
		var existing Tag
		DB.Where("name = ?", t.Name).First(&existing)
		if existing.ID == 0 {
			DB.Create(&Tag{Name: t.Name, Color: t.Color})
			created++
		}
	}
	c.JSON(200, gin.H{"created_tags": created})
}

func fixAllTagsHandler(c *gin.Context) {
	// Можно оставить пустым или добавить позже
	c.JSON(200, gin.H{"message": "Функция fix-all отключена в автоматическом режиме"})
}

func getRecipes(c *gin.Context) {
	tag := c.Query("tag")
	search := c.Query("search")

	query := DB.Preload("Tags").
		Preload("Category").
		Preload("Ingredients", func(db *gorm.DB) *gorm.DB {
			return db.Order("id ASC")
		}).
		Preload("Ingredients.Ingredient").
		Preload("Steps", func(db *gorm.DB) *gorm.DB {
			return db.Order("step_order ASC")
		})

	if tag != "" {
		query = query.Joins("JOIN recipe_tags ON recipe_tags.recipe_id = recipes.id").
			Joins("JOIN tags ON tags.id = recipe_tags.tag_id").
			Where("tags.name = ?", tag)
	}
	if search != "" {
		query = query.Where("recipes.title LIKE ? OR recipes.description LIKE ?", "%"+search+"%", "%"+search+"%")
	}

	var recipes []Recipe
	if err := query.Find(&recipes).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	resp := make([]RecipeResponse, len(recipes))
	for i, r := range recipes {
		resp[i] = recipeToResponse(r)
	}
	c.JSON(http.StatusOK, resp)
}

func getRecipeByID(c *gin.Context) {
	id := c.Param("id")
	var recipe Recipe

	// Загружаем рецепт со всеми связанными данными
	// ВАЖНО: используем Preload для загрузки связанных данных
	if err := DB.
		Preload("Tags").
		Preload("Category").
		Preload("Ingredients", func(db *gorm.DB) *gorm.DB {
			// Сортируем ингредиенты по ID для консистентности
			return db.Order("id ASC")
		}).
		Preload("Ingredients.Ingredient").
		Preload("Steps", func(db *gorm.DB) *gorm.DB {
			// Сортируем шаги по порядку - ЭТО КРИТИЧНО!
			return db.Order("step_order ASC")
		}).
		First(&recipe, id).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Рецепт не найден"})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}

	c.JSON(http.StatusOK, recipeToResponse(recipe))
}

func createRecipe(c *gin.Context) {
	var req struct {
		Title       string   `json:"title" binding:"required"`
		Description string   `json:"description"`
		CategoryID  *uint    `json:"category_id"`
		PrepTime    int      `json:"prep_time"`
		Difficulty  int      `json:"difficulty"`
		Servings    int      `json:"servings"`
		ImageURL    string   `json:"image_url"`
		Emoji       string   `json:"emoji"`
		TagNames    []string `json:"tags"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var guest User
	DB.Where("username = ?", "guest").First(&guest)

	recipe := Recipe{
		UserID:      guest.ID,
		Title:       req.Title,
		Description: req.Description,
		CategoryID:  req.CategoryID,
		PrepTime:    req.PrepTime,
		Difficulty:  req.Difficulty,
		Servings:    req.Servings,
		ImageURL:    req.ImageURL,
		Emoji:       req.Emoji,
		IsPublic:    true,
	}
	DB.Create(&recipe)

	for _, tagName := range req.TagNames {
		var tag Tag
		DB.Where("name = ?", tagName).First(&tag)
		if tag.ID != 0 {
			DB.Exec("INSERT OR IGNORE INTO recipe_tags (recipe_id, tag_id) VALUES (?, ?)", recipe.ID, tag.ID)
		}
	}

	c.JSON(http.StatusCreated, recipeToResponse(recipe))
}

func deleteRecipe(c *gin.Context) {
	id := c.Param("id")
	DB.Delete(&Recipe{}, id)
	c.JSON(http.StatusOK, gin.H{"deleted": id})
}

func getTags(c *gin.Context) {
	var tags []Tag
	DB.Find(&tags)
	c.JSON(http.StatusOK, tags)
}

func getCategories(c *gin.Context) {
	var cats []Category
	DB.Find(&cats)
	c.JSON(http.StatusOK, cats)
}
