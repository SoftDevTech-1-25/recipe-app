package service

import (
	"errors"
	"time"

	"recipe-book-mc/internal/domain"
	"recipe-book-mc/internal/dto"
	"recipe-book-mc/internal/pkg/utils"
	"recipe-book-mc/internal/repository/postgres"
)

type ShoppingListService struct {
	shoppingRepo *postgres.ShoppingListRepository
	mealPlanRepo *postgres.MealPlanRepository
	recipeRepo   *postgres.RecipeRepository
}

func NewShoppingListService(shoppingRepo *postgres.ShoppingListRepository, mealPlanRepo *postgres.MealPlanRepository, recipeRepo *postgres.RecipeRepository) *ShoppingListService {
	return &ShoppingListService{
		shoppingRepo: shoppingRepo,
		mealPlanRepo: mealPlanRepo,
		recipeRepo:   recipeRepo,
	}
}

func (s *ShoppingListService) GetList(userID uint) (*domain.ShoppingListSummary, error) {
	return s.shoppingRepo.GetSummary(userID)
}

func (s *ShoppingListService) UpdateItem(userID, itemID uint, req dto.UpdateShoppingItemRequest) error {
	items, err := s.shoppingRepo.GetByUser(userID)
	if err != nil {
		return err
	}

	var targetItem *domain.ShoppingListItem
	for i := range items {
		if items[i].ID == itemID {
			targetItem = &items[i]
			break
		}
	}

	if targetItem == nil {
		return errors.New("item not found")
	}

	targetItem.IsChecked = req.IsChecked
	return s.shoppingRepo.Update(targetItem)
}

func (s *ShoppingListService) DeleteItem(userID, itemID uint) error {
	items, err := s.shoppingRepo.GetByUser(userID)
	if err != nil {
		return err
	}

	found := false
	for _, item := range items {
		if item.ID == itemID {
			found = true
			break
		}
	}

	if !found {
		return errors.New("item not found")
	}

	return s.shoppingRepo.Delete(itemID)
}

func (s *ShoppingListService) ClearList(userID uint) error {
	return s.shoppingRepo.ClearByUser(userID)
}

func (s *ShoppingListService) GenerateFromMealPlan(userID uint, filter dto.MealPlanFilterRequest) (*domain.ShoppingListSummary, error) {
	from, _ := time.Parse("2006-01-02", filter.From)
	to, _ := time.Parse("2006-01-02", filter.To)

	plans, err := s.mealPlanRepo.ListByUserAndDateRange(userID, from, to)
	if err != nil {
		return nil, err
	}

	if len(plans) == 0 {
		return nil, errors.New("no meal plans found for the selected period")
	}

	if err := s.shoppingRepo.ClearByUser(userID); err != nil {
		return nil, err
	}

	ingredientMap := make(map[uint]*domain.ShoppingListItem)

	for _, plan := range plans {
		recipe, err := s.recipeRepo.GetByID(plan.RecipeID)
		if err != nil {
			continue
		}

		scaleFactor := float64(plan.Servings) / float64(recipe.Servings)
		if scaleFactor <= 0 {
			scaleFactor = 1
		}

		for _, ing := range recipe.Ingredients {
			scaledQty := utils.RoundQuantity(ing.Quantity * scaleFactor)

			if existing, ok := ingredientMap[ing.IngredientID]; ok {
				existing.Quantity = utils.RoundQuantity(existing.Quantity + scaledQty)
				existing.SourcePlanIDs = append(existing.SourcePlanIDs, int(plan.ID))
			} else {
				ingredientMap[ing.IngredientID] = &domain.ShoppingListItem{
					UserID:        userID,
					IngredientID:  ing.IngredientID,
					Quantity:      scaledQty,
					Unit:          ing.Unit,
					IsChecked:     false,
					SourcePlanIDs: []int{int(plan.ID)},
				}
			}
		}
	}

	var items []domain.ShoppingListItem
	for _, item := range ingredientMap {
		items = append(items, *item)
	}

	if len(items) > 0 {
		if err := s.shoppingRepo.Create(items); err != nil {
			return nil, err
		}
	}

	return s.shoppingRepo.GetSummary(userID)
}
