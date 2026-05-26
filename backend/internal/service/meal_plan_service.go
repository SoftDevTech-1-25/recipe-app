package service

import (
	"errors"
	"time"

	"recipe-book-mc/internal/domain"
	"recipe-book-mc/internal/dto"
	"recipe-book-mc/internal/repository/postgres"
)

type MealPlanService struct {
	mealPlanRepo *postgres.MealPlanRepository
	recipeRepo   *postgres.RecipeRepository
}

func NewMealPlanService(mealPlanRepo *postgres.MealPlanRepository, recipeRepo *postgres.RecipeRepository) *MealPlanService {
	return &MealPlanService{
		mealPlanRepo: mealPlanRepo,
		recipeRepo:   recipeRepo,
	}
}

func (s *MealPlanService) Create(userID uint, req dto.CreateMealPlanRequest) (*domain.MealPlan, error) {
	_, err := s.recipeRepo.GetByID(req.RecipeID)
	if err != nil {
		return nil, errors.New("recipe not found")
	}

	date, err := time.Parse("2006-01-02", req.Date)
	if err != nil {
		return nil, errors.New("invalid date format")
	}

	plan := &domain.MealPlan{
		UserID:   userID,
		RecipeID: req.RecipeID,
		PlanDate: date,
		MealType: req.MealType,
		Servings: req.Servings,
	}

	if err := s.mealPlanRepo.Create(plan); err != nil {
		return nil, err
	}

	return s.mealPlanRepo.GetByID(plan.ID)
}

func (s *MealPlanService) List(userID uint, filter dto.MealPlanFilterRequest) ([]domain.MealPlan, error) {
	from, err := time.Parse("2006-01-02", filter.From)
	if err != nil {
		return nil, errors.New("invalid from date")
	}

	to, err := time.Parse("2006-01-02", filter.To)
	if err != nil {
		return nil, errors.New("invalid to date")
	}

	return s.mealPlanRepo.ListByUserAndDateRange(userID, from, to)
}

func (s *MealPlanService) Update(planID, userID uint, req dto.UpdateMealPlanRequest) (*domain.MealPlan, error) {
	isOwner, err := s.mealPlanRepo.IsOwner(planID, userID)
	if err != nil || !isOwner {
		return nil, errors.New("meal plan not found or access denied")
	}

	plan, err := s.mealPlanRepo.GetByID(planID)
	if err != nil {
		return nil, err
	}

	if req.RecipeID > 0 {
		plan.RecipeID = req.RecipeID
	}
	if req.Date != "" {
		date, err := time.Parse("2006-01-02", req.Date)
		if err != nil {
			return nil, errors.New("invalid date format")
		}
		plan.PlanDate = date
	}
	if req.MealType != "" {
		plan.MealType = req.MealType
	}
	if req.Servings > 0 {
		plan.Servings = req.Servings
	}

	if err := s.mealPlanRepo.Update(plan); err != nil {
		return nil, err
	}

	return s.mealPlanRepo.GetByID(planID)
}

func (s *MealPlanService) Delete(planID, userID uint) error {
	isOwner, err := s.mealPlanRepo.IsOwner(planID, userID)
	if err != nil || !isOwner {
		return errors.New("meal plan not found or access denied")
	}
	return s.mealPlanRepo.Delete(planID)
}
