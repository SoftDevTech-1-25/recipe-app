package service

import (
	"errors"
	"recipe-book-mc/internal/domain"
	"recipe-book-mc/internal/dto"
	"recipe-book-mc/internal/repository/postgres"
)

type RecipeService struct {
	recipeRepo     *postgres.RecipeRepository
	ingredientRepo *postgres.IngredientRepository
}

func NewRecipeService(recipeRepo *postgres.RecipeRepository, ingredientRepo *postgres.IngredientRepository) *RecipeService {
	return &RecipeService{
		recipeRepo:     recipeRepo,
		ingredientRepo: ingredientRepo,
	}
}

func (s *RecipeService) Create(userID uint, req dto.CreateRecipeRequest) (*domain.Recipe, error) {
	recipe := &domain.Recipe{
		UserID:      userID,
		Title:       req.Title,
		Description: req.Description,
		CategoryID:  req.CategoryID,
		PrepTime:    req.PrepTime,
		Difficulty:  req.Difficulty,
		Servings:    req.Servings,
		ImageURL:    req.ImageURL,
		Emoji:       req.Emoji,
		IsPublic:    req.IsPublic,
	}

	// Default emoji if not provided
	if recipe.Emoji == "" {
		recipe.Emoji = "🍽"
	}

	// Build ingredients
	for _, ing := range req.Ingredients {
		ri := domain.RecipeIngredient{
			IngredientID: ing.IngredientID,
			Quantity:     ing.Quantity,
			Unit:         ing.Unit,
		}
		if ing.SlotPosition != nil {
			ri.SlotPosition = ing.SlotPosition
		}
		recipe.Ingredients = append(recipe.Ingredients, ri)
	}

	// Build steps
	for i, step := range req.Steps {
		recipe.Steps = append(recipe.Steps, domain.RecipeStep{
			StepOrder:   i + 1,
			Description: step.Description,
			Duration:    step.Duration,
			ImageURL:    step.ImageURL,
		})
	}

	// Handle tags
	for _, tagName := range req.Tags {
		tag, err := s.recipeRepo.FindOrCreateTag(tagName, "")
		if err != nil {
			continue
		}
		recipe.Tags = append(recipe.Tags, *tag)
	}

	if err := s.recipeRepo.Create(recipe); err != nil {
		return nil, err
	}

	return s.recipeRepo.GetByID(recipe.ID)
}

func (s *RecipeService) GetByID(id uint, userID *uint) (*domain.Recipe, error) {
	recipe, err := s.recipeRepo.GetByID(id)
	if err != nil {
		return nil, err
	}
	return recipe, nil
}

func (s *RecipeService) List(filter dto.RecipeFilterRequest, userID *uint) (*dto.RecipeListResponse, error) {
	return s.recipeRepo.List(filter, userID)
}

func (s *RecipeService) Update(recipeID, userID uint, req dto.UpdateRecipeRequest) (*domain.Recipe, error) {
	isOwner, err := s.recipeRepo.IsOwner(recipeID, userID)
	if err != nil || !isOwner {
		return nil, errors.New("recipe not found or access denied")
	}

	recipe, err := s.recipeRepo.GetByID(recipeID)
	if err != nil {
		return nil, err
	}

	if req.Title != "" {
		recipe.Title = req.Title
	}
	if req.Description != "" {
		recipe.Description = req.Description
	}
	if req.CategoryID != nil {
		recipe.CategoryID = req.CategoryID
	}
	if req.PrepTime > 0 {
		recipe.PrepTime = req.PrepTime
	}
	if req.Difficulty > 0 {
		recipe.Difficulty = req.Difficulty
	}
	if req.Servings > 0 {
		recipe.Servings = req.Servings
	}
	if req.ImageURL != "" {
		recipe.ImageURL = req.ImageURL
	}
	if req.Emoji != "" {
		recipe.Emoji = req.Emoji
	}
	recipe.IsPublic = req.IsPublic

	// Rebuild ingredients if provided
	if len(req.Ingredients) > 0 {
		recipe.Ingredients = nil
		for _, ing := range req.Ingredients {
			ri := domain.RecipeIngredient{
				IngredientID: ing.IngredientID,
				Quantity:     ing.Quantity,
				Unit:         ing.Unit,
			}
			if ing.SlotPosition != nil {
				ri.SlotPosition = ing.SlotPosition
			}
			recipe.Ingredients = append(recipe.Ingredients, ri)
		}
	}

	// Rebuild steps if provided
	if len(req.Steps) > 0 {
		recipe.Steps = nil
		for i, step := range req.Steps {
			recipe.Steps = append(recipe.Steps, domain.RecipeStep{
				StepOrder:   i + 1,
				Description: step.Description,
				Duration:    step.Duration,
				ImageURL:    step.ImageURL,
			})
		}
	}

	// Rebuild tags if provided
	if len(req.Tags) > 0 {
		recipe.Tags = nil
		for _, tagName := range req.Tags {
			tag, err := s.recipeRepo.FindOrCreateTag(tagName, "")
			if err != nil {
				continue
			}
			recipe.Tags = append(recipe.Tags, *tag)
		}
	}

	if err := s.recipeRepo.Update(recipe); err != nil {
		return nil, err
	}

	return s.recipeRepo.GetByID(recipeID)
}

func (s *RecipeService) Delete(recipeID, userID uint) error {
	isOwner, err := s.recipeRepo.IsOwner(recipeID, userID)
	if err != nil || !isOwner {
		return errors.New("recipe not found or access denied")
	}
	return s.recipeRepo.Delete(recipeID)
}

func (s *RecipeService) AddFavorite(userID, recipeID uint) error {
	return s.recipeRepo.AddFavorite(userID, recipeID)
}

func (s *RecipeService) RemoveFavorite(userID, recipeID uint) error {
	return s.recipeRepo.RemoveFavorite(userID, recipeID)
}

func (s *RecipeService) ListFavorites(userID uint) ([]domain.Recipe, error) {
	return s.recipeRepo.ListFavorites(userID)
}

func (s *RecipeService) ListCategories() ([]domain.Category, error) {
	return s.recipeRepo.ListCategories()
}

func (s *RecipeService) ListTags() ([]domain.Tag, error) {
	return s.recipeRepo.ListTags()
}
