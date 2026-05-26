package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"recipe-book-mc/internal/dto"
	"recipe-book-mc/internal/service"
)

type MealPlanHandler struct {
	mealPlanService    *service.MealPlanService
	shoppingListService *service.ShoppingListService
}

func NewMealPlanHandler(mealPlanService *service.MealPlanService, shoppingListService *service.ShoppingListService) *MealPlanHandler {
	return &MealPlanHandler{
		mealPlanService:     mealPlanService,
		shoppingListService: shoppingListService,
	}
}

// Create godoc
// @Summary Add recipe to meal plan
// @Tags meal-plans
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param request body dto.CreateMealPlanRequest true "Meal plan data"
// @Success 201 {object} domain.MealPlan
// @Failure 400 {object} dto.ErrorResponse
// @Router /meal-plans [post]
func (h *MealPlanHandler) Create(c *gin.Context) {
	userID, _ := c.Get("userID")

	var req dto.CreateMealPlanRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	plan, err := h.mealPlanService.Create(userID.(uint), req)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	c.JSON(http.StatusCreated, plan)
}

// List godoc
// @Summary Get meal plans for date range
// @Tags meal-plans
// @Security BearerAuth
// @Produce json
// @Param from query string true "From date (YYYY-MM-DD)"
// @Param to query string true "To date (YYYY-MM-DD)"
// @Success 200 {array} domain.MealPlan
// @Router /meal-plans [get]
func (h *MealPlanHandler) List(c *gin.Context) {
	userID, _ := c.Get("userID")

	var filter dto.MealPlanFilterRequest
	if err := c.ShouldBindQuery(&filter); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	plans, err := h.mealPlanService.List(userID.(uint), filter)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	c.JSON(http.StatusOK, plans)
}

// Update godoc
// @Summary Update meal plan entry
// @Tags meal-plans
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param id path int true "Plan ID"
// @Param request body dto.UpdateMealPlanRequest true "Update data"
// @Success 200 {object} domain.MealPlan
// @Router /meal-plans/{id} [put]
func (h *MealPlanHandler) Update(c *gin.Context) {
	userID, _ := c.Get("userID")
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid plan id", Code: 400})
		return
	}

	var req dto.UpdateMealPlanRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	plan, err := h.mealPlanService.Update(uint(id), userID.(uint), req)
	if err != nil {
		c.JSON(http.StatusForbidden, dto.ErrorResponse{Error: err.Error(), Code: 403})
		return
	}

	c.JSON(http.StatusOK, plan)
}

// Delete godoc
// @Summary Delete meal plan entry
// @Tags meal-plans
// @Security BearerAuth
// @Param id path int true "Plan ID"
// @Success 204
// @Router /meal-plans/{id} [delete]
func (h *MealPlanHandler) Delete(c *gin.Context) {
	userID, _ := c.Get("userID")
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid plan id", Code: 400})
		return
	}

	if err := h.mealPlanService.Delete(uint(id), userID.(uint)); err != nil {
		c.JSON(http.StatusForbidden, dto.ErrorResponse{Error: err.Error(), Code: 403})
		return
	}

	c.Status(http.StatusNoContent)
}

// GenerateShoppingList godoc
// @Summary Generate shopping list from meal plans
// @Tags meal-plans
// @Security BearerAuth
// @Produce json
// @Param from query string true "From date (YYYY-MM-DD)"
// @Param to query string true "To date (YYYY-MM-DD)"
// @Success 200 {object} domain.ShoppingListSummary
// @Router /meal-plans/generate-shopping [post]
func (h *MealPlanHandler) GenerateShoppingList(c *gin.Context) {
	userID, _ := c.Get("userID")

	var filter dto.MealPlanFilterRequest
	if err := c.ShouldBindQuery(&filter); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	summary, err := h.shoppingListService.GenerateFromMealPlan(userID.(uint), filter)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	c.JSON(http.StatusOK, summary)
}
