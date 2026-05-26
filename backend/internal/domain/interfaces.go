package domain

// Repository interfaces
type UserRepository interface {
	Create(user *User) error
	GetByID(id uint) (*User, error)
	GetByEmail(email string) (*User, error)
	GetByUsername(username string) (*User, error)
	Update(user *User) error
	Delete(id uint) error
}

type RecipeRepositoryInterface interface {
	Create(recipe *Recipe) error
	GetByID(id uint) (*Recipe, error)
	List(filter interface{}, userID *uint) (interface{}, error)
	Update(recipe *Recipe) error
	Delete(id uint) error
	IsOwner(recipeID, userID uint) (bool, error)
	AddFavorite(userID, recipeID uint) error
	RemoveFavorite(userID, recipeID uint) error
	IsFavorite(userID, recipeID uint) (bool, error)
	ListFavorites(userID uint) ([]Recipe, error)
	ListCategories() ([]Category, error)
}

type MealPlanRepositoryInterface interface {
	Create(plan *MealPlan) error
	GetByID(id uint) (*MealPlan, error)
	ListByUserAndDateRange(userID uint, from, to interface{}) ([]MealPlan, error)
	Update(plan *MealPlan) error
	Delete(id uint) error
	IsOwner(planID, userID uint) (bool, error)
}

type ShoppingListRepositoryInterface interface {
	GetByUser(userID uint) ([]ShoppingListItem, error)
	Create(items []ShoppingListItem) error
	Update(item *ShoppingListItem) error
	Delete(id uint) error
	ClearByUser(userID uint) error
	GetSummary(userID uint) (*ShoppingListSummary, error)
}
