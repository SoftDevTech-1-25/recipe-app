package main

import (
	"log"
	"os"

	"github.com/gin-gonic/gin"

	"recipe-book-mc/internal/config"
	"recipe-book-mc/internal/handler"
	"recipe-book-mc/internal/middleware"
	"recipe-book-mc/internal/repository/postgres"
	"recipe-book-mc/internal/service"
)

// @title Recipe Book: Minecraft Edition API
// @version 1.0
// @description Digital recipe library with Minecraft-style crafting mechanics
// @termsOfService http://swagger.io/terms/

// @contact.name API Support
// @contact.email support@recipebook.mc

// @license.name MIT
// @license.url https://opensource.org/licenses/MIT

// @host localhost:8080
// @BasePath /api
// @schemes http https

// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
// @description Type "Bearer" followed by a space and JWT token.
func main() {
	cfg := config.Load()

	if cfg.Env == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	// Repositories (in-memory for demo)
	userRepo := postgres.NewUserRepository(nil)
	recipeRepo := postgres.NewRecipeRepository(nil)
	ingredientRepo := postgres.NewIngredientRepository(nil)
	mealPlanRepo := postgres.NewMealPlanRepository(nil)
	shoppingRepo := postgres.NewShoppingListRepository(nil)

	// Services
	authService := service.NewAuthService(userRepo, cfg.JWTSecret, cfg.JWTExpiration)
	recipeService := service.NewRecipeService(recipeRepo, ingredientRepo)
	scalingService := service.NewScalingService()
	mealPlanService := service.NewMealPlanService(mealPlanRepo, recipeRepo)
	shoppingService := service.NewShoppingListService(shoppingRepo, mealPlanRepo, recipeRepo)

	// Handlers
	authHandler := handler.NewAuthHandler(authService)
	recipeHandler := handler.NewRecipeHandler(recipeService, scalingService)
	mealPlanHandler := handler.NewMealPlanHandler(mealPlanService, shoppingService)
	shoppingHandler := handler.NewShoppingListHandler(shoppingService)

	// Router
	r := gin.Default()
	r.Use(middleware.CORS())

	// Health check
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "version": "1.1.0-mc", "mode": "in-memory"})
	})

	// Public routes
	r.POST("/api/auth/register", authHandler.Register)
	r.POST("/api/auth/login", authHandler.Login)
	r.GET("/api/recipes", recipeHandler.List)
	r.GET("/api/recipes/:id", recipeHandler.GetByID)
	r.GET("/api/recipes/:id/scale", recipeHandler.Scale)
	r.GET("/api/categories", recipeHandler.ListCategories)
	r.GET("/api/tags", recipeHandler.ListTags)

	// Protected routes
	api := r.Group("/api")
	api.Use(middleware.Auth(cfg.JWTSecret))
	{
		api.GET("/users/me", authHandler.GetProfile)
		api.PUT("/users/me", authHandler.UpdateProfile)

		api.POST("/recipes", recipeHandler.Create)
		api.PUT("/recipes/:id", recipeHandler.Update)
		api.DELETE("/recipes/:id", recipeHandler.Delete)
		api.POST("/recipes/:id/favorite", recipeHandler.AddFavorite)
		api.DELETE("/recipes/:id/favorite", recipeHandler.RemoveFavorite)
		api.GET("/favorites", recipeHandler.ListFavorites)

		api.GET("/meal-plans", mealPlanHandler.List)
		api.POST("/meal-plans", mealPlanHandler.Create)
		api.PUT("/meal-plans/:id", mealPlanHandler.Update)
		api.DELETE("/meal-plans/:id", mealPlanHandler.Delete)
		api.POST("/meal-plans/generate-shopping", mealPlanHandler.GenerateShoppingList)

		api.GET("/shopping-list", shoppingHandler.GetList)
		api.PUT("/shopping-list/:id", shoppingHandler.UpdateItem)
		api.DELETE("/shopping-list/:id", shoppingHandler.DeleteItem)
		api.DELETE("/shopping-list/clear", shoppingHandler.ClearList)
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🎮 Recipe Book: Minecraft Edition API (IN-MEMORY MODE)")
	log.Printf("📖 API: http://localhost:%s/api", port)
	log.Printf("💚 Health: http://localhost:%s/health", port)
	r.Run(":" + port)
}
