package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"recipe-book-mc/internal/dto"
	"recipe-book-mc/internal/service"
)

type RecipeHandler struct {
	recipeService  *service.RecipeService
	scalingService *service.ScalingService
}

func NewRecipeHandler(recipeService *service.RecipeService, scalingService *service.ScalingService) *RecipeHandler {
	return &RecipeHandler{
		recipeService:  recipeService,
		scalingService: scalingService,
	}
}

// Create godoc
// @Summary Create new recipe
// @Tags recipes
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param request body dto.CreateRecipeRequest true "Recipe data"
// @Success 201 {object} domain.Recipe
// @Failure 400 {object} dto.ErrorResponse
// @Router /recipes [post]
func (h *RecipeHandler) Create(c *gin.Context) {
	userID, _ := c.Get("userID")

	var req dto.CreateRecipeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	recipe, err := h.recipeService.Create(userID.(uint), req)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	c.JSON(http.StatusCreated, recipe)
}

// GetByID godoc
// @Summary Get recipe by ID
// @Tags recipes
// @Produce json
// @Param id path int true "Recipe ID"
// @Success 200 {object} domain.Recipe
// @Failure 404 {object} dto.ErrorResponse
// @Router /recipes/{id} [get]
func (h *RecipeHandler) GetByID(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid recipe id", Code: 400})
		return
	}

	var userID *uint
	if uid, exists := c.Get("userID"); exists {
		uidVal := uid.(uint)
		userID = &uidVal
	}

	recipe, err := h.recipeService.GetByID(uint(id), userID)
	if err != nil {
		c.JSON(http.StatusNotFound, dto.ErrorResponse{Error: err.Error(), Code: 404})
		return
	}

	c.JSON(http.StatusOK, recipe)
}

// List godoc
// @Summary List recipes with filters
// @Tags recipes
// @Produce json
// @Param search query string false "Search query"
// @Param category query string false "Category filter"
// @Param tag query string false "Tag filter (e.g. острая)"
// @Param time_max query int false "Max prep time"
// @Param page query int false "Page number" default(1)
// @Param limit query int false "Items per page" default(20)
// @Param sort query string false "Sort field" default(created_at)
// @Param order query string false "Sort order" default(desc)
// @Success 200 {object} dto.RecipeListResponse
// @Router /recipes [get]
func (h *RecipeHandler) List(c *gin.Context) {
	var filter dto.RecipeFilterRequest
	if err := c.ShouldBindQuery(&filter); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	if filter.Page < 1 {
		filter.Page = 1
	}
	if filter.Limit < 1 || filter.Limit > 100 {
		filter.Limit = 20
	}

	var userID *uint
	if uid, exists := c.Get("userID"); exists {
		uidVal := uid.(uint)
		userID = &uidVal
	}

	resp, err := h.recipeService.List(filter, userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error(), Code: 500})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// Update godoc
// @Summary Update recipe
// @Tags recipes
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param id path int true "Recipe ID"
// @Param request body dto.UpdateRecipeRequest true "Update data"
// @Success 200 {object} domain.Recipe
// @Failure 403 {object} dto.ErrorResponse
// @Router /recipes/{id} [put]
func (h *RecipeHandler) Update(c *gin.Context) {
	userID, _ := c.Get("userID")
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid recipe id", Code: 400})
		return
	}

	var req dto.UpdateRecipeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	recipe, err := h.recipeService.Update(uint(id), userID.(uint), req)
	if err != nil {
		c.JSON(http.StatusForbidden, dto.ErrorResponse{Error: err.Error(), Code: 403})
		return
	}

	c.JSON(http.StatusOK, recipe)
}

// Delete godoc
// @Summary Delete recipe
// @Tags recipes
// @Security BearerAuth
// @Param id path int true "Recipe ID"
// @Success 204
// @Failure 403 {object} dto.ErrorResponse
// @Router /recipes/{id} [delete]
func (h *RecipeHandler) Delete(c *gin.Context) {
	userID, _ := c.Get("userID")
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid recipe id", Code: 400})
		return
	}

	if err := h.recipeService.Delete(uint(id), userID.(uint)); err != nil {
		c.JSON(http.StatusForbidden, dto.ErrorResponse{Error: err.Error(), Code: 403})
		return
	}

	c.Status(http.StatusNoContent)
}

// Scale godoc
// @Summary Scale recipe servings
// @Tags recipes
// @Produce json
// @Param id path int true "Recipe ID"
// @Param servings query int true "Target servings"
// @Success 200 {object} dto.ScaleResponse
// @Failure 404 {object} dto.ErrorResponse
// @Router /recipes/{id}/scale [get]
func (h *RecipeHandler) Scale(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid recipe id", Code: 400})
		return
	}

	servings, err := strconv.Atoi(c.Query("servings"))
	if err != nil || servings < 1 {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid servings parameter", Code: 400})
		return
	}

	recipe, err := h.recipeService.GetByID(uint(id), nil)
	if err != nil {
		c.JSON(http.StatusNotFound, dto.ErrorResponse{Error: err.Error(), Code: 404})
		return
	}

	scaled := h.scalingService.ScaleRecipe(recipe, servings)
	c.JSON(http.StatusOK, scaled)
}

// AddFavorite godoc
// @Summary Add recipe to favorites
// @Tags favorites
// @Security BearerAuth
// @Param id path int true "Recipe ID"
// @Success 201 {object} dto.SuccessResponse
// @Router /recipes/{id}/favorite [post]
func (h *RecipeHandler) AddFavorite(c *gin.Context) {
	userID, _ := c.Get("userID")
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid recipe id", Code: 400})
		return
	}

	if err := h.recipeService.AddFavorite(userID.(uint), uint(id)); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	c.JSON(http.StatusCreated, dto.SuccessResponse{Message: "added to favorites"})
}

// RemoveFavorite godoc
// @Summary Remove recipe from favorites
// @Tags favorites
// @Security BearerAuth
// @Param id path int true "Recipe ID"
// @Success 204
// @Router /recipes/{id}/favorite [delete]
func (h *RecipeHandler) RemoveFavorite(c *gin.Context) {
	userID, _ := c.Get("userID")
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid recipe id", Code: 400})
		return
	}

	if err := h.recipeService.RemoveFavorite(userID.(uint), uint(id)); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	c.Status(http.StatusNoContent)
}

// ListFavorites godoc
// @Summary List favorite recipes
// @Tags favorites
// @Security BearerAuth
// @Produce json
// @Success 200 {array} domain.Recipe
// @Router /favorites [get]
func (h *RecipeHandler) ListFavorites(c *gin.Context) {
	userID, _ := c.Get("userID")

	recipes, err := h.recipeService.ListFavorites(userID.(uint))
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error(), Code: 500})
		return
	}

	c.JSON(http.StatusOK, recipes)
}

// ListCategories godoc
// @Summary List all categories
// @Tags categories
// @Produce json
// @Success 200 {array} domain.Category
// @Router /categories [get]
func (h *RecipeHandler) ListCategories(c *gin.Context) {
	categories, err := h.recipeService.ListCategories()
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error(), Code: 500})
		return
	}

	c.JSON(http.StatusOK, categories)
}

// ListTags godoc
// @Summary List all tags
// @Tags tags
// @Produce json
// @Success 200 {array} domain.Tag
// @Router /tags [get]
func (h *RecipeHandler) ListTags(c *gin.Context) {
	tags, err := h.recipeService.ListTags()
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error(), Code: 500})
		return
	}

	c.JSON(http.StatusOK, tags)
}
