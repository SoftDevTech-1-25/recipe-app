package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"recipe-book-mc/internal/dto"
	"recipe-book-mc/internal/service"
)

type ShoppingListHandler struct {
	shoppingService *service.ShoppingListService
}

func NewShoppingListHandler(shoppingService *service.ShoppingListService) *ShoppingListHandler {
	return &ShoppingListHandler{shoppingService: shoppingService}
}

// GetList godoc
// @Summary Get shopping list
// @Tags shopping-list
// @Security BearerAuth
// @Produce json
// @Success 200 {object} domain.ShoppingListSummary
// @Router /shopping-list [get]
func (h *ShoppingListHandler) GetList(c *gin.Context) {
	userID, _ := c.Get("userID")

	summary, err := h.shoppingService.GetList(userID.(uint))
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error(), Code: 500})
		return
	}

	c.JSON(http.StatusOK, summary)
}

// UpdateItem godoc
// @Summary Update shopping item status
// @Tags shopping-list
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param id path int true "Item ID"
// @Param request body dto.UpdateShoppingItemRequest true "Update data"
// @Success 200 {object} dto.SuccessResponse
// @Router /shopping-list/{id} [put]
func (h *ShoppingListHandler) UpdateItem(c *gin.Context) {
	userID, _ := c.Get("userID")
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid item id", Code: 400})
		return
	}

	var req dto.UpdateShoppingItemRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	if err := h.shoppingService.UpdateItem(userID.(uint), uint(id), req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Message: "item updated"})
}

// DeleteItem godoc
// @Summary Delete shopping item
// @Tags shopping-list
// @Security BearerAuth
// @Param id path int true "Item ID"
// @Success 204
// @Router /shopping-list/{id} [delete]
func (h *ShoppingListHandler) DeleteItem(c *gin.Context) {
	userID, _ := c.Get("userID")
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "invalid item id", Code: 400})
		return
	}

	if err := h.shoppingService.DeleteItem(userID.(uint), uint(id)); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error(), Code: 400})
		return
	}

	c.Status(http.StatusNoContent)
}

// ClearList godoc
// @Summary Clear entire shopping list
// @Tags shopping-list
// @Security BearerAuth
// @Success 204
// @Router /shopping-list/clear [delete]
func (h *ShoppingListHandler) ClearList(c *gin.Context) {
	userID, _ := c.Get("userID")

	if err := h.shoppingService.ClearList(userID.(uint)); err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error(), Code: 500})
		return
	}

	c.Status(http.StatusNoContent)
}
