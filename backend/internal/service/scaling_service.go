package service

import (
	"recipe-book-mc/internal/domain"
	"recipe-book-mc/internal/dto"
	"recipe-book-mc/internal/pkg/utils"
)

type ScalingService struct{}

func NewScalingService() *ScalingService {
	return &ScalingService{}
}

func (s *ScalingService) ScaleRecipe(recipe *domain.Recipe, targetServings int) *dto.ScaleResponse {
	if recipe.Servings == 0 || targetServings <= 0 {
		return nil
	}

	factor := float64(targetServings) / float64(recipe.Servings)

	scaledIngredients := make([]dto.ScaledIngredientResponse, len(recipe.Ingredients))
	for i, ing := range recipe.Ingredients {
		scaledQty := utils.RoundQuantity(ing.Quantity * factor)
		scaledIngredients[i] = dto.ScaledIngredientResponse{
			Name:             ing.Ingredient.Name,
			OriginalQuantity: ing.Quantity,
			ScaledQuantity:   scaledQty,
			Unit:             ing.Unit,
			IconURL:          ing.Ingredient.IconURL,
		}
	}

	return &dto.ScaleResponse{
		OriginalServings: recipe.Servings,
		TargetServings:   targetServings,
		ScaleFactor:      utils.RoundQuantity(factor),
		Ingredients:      scaledIngredients,
	}
}
