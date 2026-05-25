package postgres

import (
	"errors"
	"recipe-book-mc/internal/domain"
	"sync"
	"time"
)

type MealPlanRepository struct {
	mu      sync.RWMutex
	plans   []domain.MealPlan
	nextID  uint
}

func NewMealPlanRepository(db interface{}) *MealPlanRepository {
	return &MealPlanRepository{
		plans:  make([]domain.MealPlan, 0),
		nextID: 1,
	}
}

func (r *MealPlanRepository) Create(plan *domain.MealPlan) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	plan.ID = r.nextID
	r.nextID++
	plan.CreatedAt = time.Now()
	r.plans = append(r.plans, *plan)
	return nil
}

func (r *MealPlanRepository) GetByID(id uint) (*domain.MealPlan, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := range r.plans {
		if r.plans[i].ID == id {
			return &r.plans[i], nil
		}
	}
	return nil, errors.New("meal plan not found")
}

func (r *MealPlanRepository) ListByUserAndDateRange(userID uint, from, to time.Time) ([]domain.MealPlan, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []domain.MealPlan
	for _, plan := range r.plans {
		if plan.UserID == userID && !plan.PlanDate.Before(from) && !plan.PlanDate.After(to) {
			result = append(result, plan)
		}
	}
	return result, nil
}

func (r *MealPlanRepository) Update(plan *domain.MealPlan) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.plans {
		if r.plans[i].ID == plan.ID {
			r.plans[i] = *plan
			return nil
		}
	}
	return errors.New("meal plan not found")
}

func (r *MealPlanRepository) Delete(id uint) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.plans {
		if r.plans[i].ID == id {
			r.plans = append(r.plans[:i], r.plans[i+1:]...)
			return nil
		}
	}
	return errors.New("meal plan not found")
}

func (r *MealPlanRepository) IsOwner(planID, userID uint) (bool, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for _, plan := range r.plans {
		if plan.ID == planID {
			return plan.UserID == userID, nil
		}
	}
	return false, errors.New("meal plan not found")
}
