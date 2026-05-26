package postgres

import (
	"errors"
	"recipe-book-mc/internal/domain"
	"sync"
)

type IngredientRepository struct {
	mu          sync.RWMutex
	ingredients []domain.Ingredient
	nextID      uint
}

func NewIngredientRepository(db interface{}) *IngredientRepository {
	r := &IngredientRepository{
		ingredients: make([]domain.Ingredient, 0),
		nextID:      1,
	}
	// Demo ingredients
	r.ingredients = []domain.Ingredient{
		{ID: 1, Name: "Спагетти", IconURL: "spaghetti_16x16.png", Category: "Макароны"},
		{ID: 2, Name: "Фарш говяжий", IconURL: "beef_16x16.png", Category: "Мясо"},
		{ID: 3, Name: "Помидор", IconURL: "tomato_16x16.png", Category: "Овощи"},
		{ID: 4, Name: "Лук", IconURL: "onion_16x16.png", Category: "Овощи"},
		{ID: 5, Name: "Сыр", IconURL: "cheese_16x16.png", Category: "Молочка"},
		{ID: 6, Name: "Курица", IconURL: "chicken_16x16.png", Category: "Мясо"},
	}
	r.nextID = 7
	return r
}

func (r *IngredientRepository) Create(ingredient *domain.Ingredient) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	ingredient.ID = r.nextID
	r.nextID++
	r.ingredients = append(r.ingredients, *ingredient)
	return nil
}

func (r *IngredientRepository) GetByID(id uint) (*domain.Ingredient, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := range r.ingredients {
		if r.ingredients[i].ID == id {
			return &r.ingredients[i], nil
		}
	}
	return nil, errors.New("ingredient not found")
}

func (r *IngredientRepository) GetByName(name string) (*domain.Ingredient, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := range r.ingredients {
		if r.ingredients[i].Name == name {
			return &r.ingredients[i], nil
		}
	}
	return nil, errors.New("ingredient not found")
}

func (r *IngredientRepository) List() ([]domain.Ingredient, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	result := make([]domain.Ingredient, len(r.ingredients))
	copy(result, r.ingredients)
	return result, nil
}

func (r *IngredientRepository) FindOrCreate(name string) (*domain.Ingredient, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.ingredients {
		if r.ingredients[i].Name == name {
			return &r.ingredients[i], nil
		}
	}
	ing := domain.Ingredient{ID: r.nextID, Name: name}
	r.nextID++
	r.ingredients = append(r.ingredients, ing)
	return &ing, nil
}
