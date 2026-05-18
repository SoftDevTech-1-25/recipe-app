package main

import (
	"fmt"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

// Структура одного рецепта
type Recipe struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	Difficulty string `json:"difficulty"`
	ImageSlug  string `json:"image_slug"`
}

// Временные данные (потом заменишь на базу данных)
var recipes = []Recipe{
	{ID: 1, Name: "Стейк", Difficulty: "Лёгкий", ImageSlug: "cooked_beef.png"},
	{ID: 2, Name: "Золотое яблоко", Difficulty: "Средний", ImageSlug: "golden_apple.png"},
	{ID: 3, Name: "Зелье силы", Difficulty: "Сложный", ImageSlug: "potion.png"},
}

func main() {
	r := gin.Default()

	// ✅ CORS — разрешаем фронтенду делать запросы
	r.Use(cors.Default())

	// Проверка что сервер жив
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Minecraft Recipe API is running!",
			"status":  "working",
		})
	})

	// ✅ Новый эндпоинт — все рецепты
	r.GET("/api/recipes", func(c *gin.Context) {
		c.JSON(http.StatusOK, recipes)
	})

	// ✅ Один рецепт по ID — /api/recipes/1
	r.GET("/api/recipes/:id", func(c *gin.Context) {
		id := c.Param("id")
		for _, recipe := range recipes {
			if fmt.Sprintf("%d", recipe.ID) == id {
				c.JSON(http.StatusOK, recipe)
				return
			}
		}
		c.JSON(http.StatusNotFound, gin.H{"error": "Рецепт не найден"})
	})

	r.Run(":8080")
}
