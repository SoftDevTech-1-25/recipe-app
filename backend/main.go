package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	InitDB()

	r := gin.Default()

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
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	api := r.Group("/api")
	{
		api.GET("/recipes", getRecipes)
		api.GET("/recipes/:id", getRecipeByID)
		api.POST("/recipes", createRecipe)
		api.DELETE("/recipes/:id", deleteRecipe)
		api.GET("/tags", getTags)
		api.GET("/categories", getCategories)
	}

	r.Run(":8080")
}

func getRecipes(c *gin.Context) {
	tag := c.Query("tag")
	search := c.Query("search")

	query := DB.Preload("Tags").Preload("Category")

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
	if err := DB.Preload("Tags").Preload("Category").Preload("Ingredients.Ingredient").Preload("Steps").First(&recipe, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Рецепт не найден"})
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
