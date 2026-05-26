package postgres

import (
	"errors"
	"recipe-book-mc/internal/domain"
	"sync"
)

type UserRepository struct {
	mu    sync.RWMutex
	users []domain.User
	nextID uint
}

func NewUserRepository(db interface{}) *UserRepository {
	return &UserRepository{
		users:  make([]domain.User, 0),
		nextID: 1,
	}
}

func (r *UserRepository) Create(user *domain.User) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	user.ID = r.nextID
	r.nextID++
	r.users = append(r.users, *user)
	return nil
}

func (r *UserRepository) GetByID(id uint) (*domain.User, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := range r.users {
		if r.users[i].ID == id {
			return &r.users[i], nil
		}
	}
	return nil, errors.New("user not found")
}

func (r *UserRepository) GetByEmail(email string) (*domain.User, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := range r.users {
		if r.users[i].Email == email {
			return &r.users[i], nil
		}
	}
	return nil, errors.New("user not found")
}

func (r *UserRepository) GetByUsername(username string) (*domain.User, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := range r.users {
		if r.users[i].Username == username {
			return &r.users[i], nil
		}
	}
	return nil, errors.New("user not found")
}

func (r *UserRepository) Update(user *domain.User) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.users {
		if r.users[i].ID == user.ID {
			r.users[i] = *user
			return nil
		}
	}
	return errors.New("user not found")
}

func (r *UserRepository) Delete(id uint) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.users {
		if r.users[i].ID == id {
			r.users = append(r.users[:i], r.users[i+1:]...)
			return nil
		}
	}
	return errors.New("user not found")
}
