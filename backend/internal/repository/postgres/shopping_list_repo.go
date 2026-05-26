package postgres

import (
	"errors"
	"recipe-book-mc/internal/domain"
	"sync"
	"time"
)

type ShoppingListRepository struct {
	mu     sync.RWMutex
	items  []domain.ShoppingListItem
	nextID uint
}

func NewShoppingListRepository(db interface{}) *ShoppingListRepository {
	return &ShoppingListRepository{
		items:  make([]domain.ShoppingListItem, 0),
		nextID: 1,
	}
}

func (r *ShoppingListRepository) GetByUser(userID uint) ([]domain.ShoppingListItem, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []domain.ShoppingListItem
	for _, item := range r.items {
		if item.UserID == userID {
			result = append(result, item)
		}
	}
	return result, nil
}

func (r *ShoppingListRepository) Create(items []domain.ShoppingListItem) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range items {
		items[i].ID = r.nextID
		items[i].CreatedAt = time.Now()
		r.nextID++
		r.items = append(r.items, items[i])
	}
	return nil
}

func (r *ShoppingListRepository) Update(item *domain.ShoppingListItem) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.items {
		if r.items[i].ID == item.ID {
			r.items[i] = *item
			return nil
		}
	}
	return errors.New("item not found")
}

func (r *ShoppingListRepository) Delete(id uint) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.items {
		if r.items[i].ID == id {
			r.items = append(r.items[:i], r.items[i+1:]...)
			return nil
		}
	}
	return errors.New("item not found")
}

func (r *ShoppingListRepository) ClearByUser(userID uint) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	var filtered []domain.ShoppingListItem
	for _, item := range r.items {
		if item.UserID != userID {
			filtered = append(filtered, item)
		}
	}
	r.items = filtered
	return nil
}

func (r *ShoppingListRepository) GetSummary(userID uint) (*domain.ShoppingListSummary, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var items []domain.ShoppingListItem
	var checked int
	for _, item := range r.items {
		if item.UserID == userID {
			items = append(items, item)
			if item.IsChecked {
				checked++
			}
		}
	}
	return &domain.ShoppingListSummary{
		Items:        items,
		TotalItems:   len(items),
		CheckedItems: checked,
	}, nil
}
