package dto

// Auth DTOs
type RegisterRequest struct {
	Username string `json:"username" binding:"required,min=3,max=50"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

// Recipe DTOs
type CreateRecipeRequest struct {
	Title       string                      `json:"title" binding:"required,max=200"`
	Description string                      `json:"description"`
	CategoryID  *uint                       `json:"category_id"`
	PrepTime    int                         `json:"prep_time" binding:"required,min=1"`
	Difficulty  int                         `json:"difficulty" binding:"required,min=1,max=5"`
	Servings    int                         `json:"servings" binding:"required,min=1"`
	ImageURL    string                      `json:"image_url"`
	Emoji       string                      `json:"emoji"`
	IsPublic    bool                        `json:"is_public"`
	Tags        []string                    `json:"tags"` // ["острая", "быстрая"]
	Ingredients []CreateIngredientRequest   `json:"ingredients" binding:"required,min=1"`
	Steps       []CreateStepRequest         `json:"steps" binding:"required,min=1"`
}

type CreateIngredientRequest struct {
	IngredientID uint    `json:"ingredient_id" binding:"required"`
	Quantity     float64 `json:"quantity" binding:"required,gt=0"`
	Unit         string  `json:"unit" binding:"required"`
	SlotPosition *int    `json:"slot_position"` // Опционально!
}

type CreateStepRequest struct {
	Description string `json:"description" binding:"required"`
	Duration    *int   `json:"duration"`
	ImageURL    string `json:"image_url"`
}

type UpdateRecipeRequest struct {
	Title       string                      `json:"title" binding:"max=200"`
	Description string                      `json:"description"`
	CategoryID  *uint                       `json:"category_id"`
	PrepTime    int                         `json:"prep_time" binding:"min=1"`
	Difficulty  int                         `json:"difficulty" binding:"min=1,max=5"`
	Servings    int                         `json:"servings" binding:"min=1"`
	ImageURL    string                      `json:"image_url"`
	Emoji       string                      `json:"emoji"`
	IsPublic    bool                        `json:"is_public"`
	Tags        []string                    `json:"tags"`
	Ingredients []CreateIngredientRequest   `json:"ingredients"`
	Steps       []CreateStepRequest         `json:"steps"`
}

type RecipeFilterRequest struct {
	Search    string `form:"search"`
	Category  string `form:"category"`
	Tag       string `form:"tag"`      // Новый фильтр по тегу!
	TimeMax   int    `form:"time_max"`
	Page      int    `form:"page,default=1"`
	Limit     int    `form:"limit,default=20"`
	Sort      string `form:"sort,default=created_at"`
	Order     string `form:"order,default=desc"`
}

// Meal Plan DTOs
type CreateMealPlanRequest struct {
	RecipeID uint   `json:"recipe_id" binding:"required"`
	Date     string `json:"date" binding:"required,datetime=2006-01-02"`
	MealType string `json:"meal_type" binding:"required,oneof=breakfast lunch dinner snack"`
	Servings int    `json:"servings" binding:"required,min=1"`
}

type UpdateMealPlanRequest struct {
	RecipeID uint   `json:"recipe_id"`
	Date     string `json:"date" binding:"datetime=2006-01-02"`
	MealType string `json:"meal_type" binding:"oneof=breakfast lunch dinner snack"`
	Servings int    `json:"servings" binding:"min=1"`
}

type MealPlanFilterRequest struct {
	From string `form:"from" binding:"required,datetime=2006-01-02"`
	To   string `form:"to" binding:"required,datetime=2006-01-02"`
}

// Shopping List DTOs
type UpdateShoppingItemRequest struct {
	IsChecked bool `json:"is_checked"`
}

// User DTOs
type UpdateUserRequest struct {
	Username  string `json:"username" binding:"omitempty,min=3,max=50"`
	Email     string `json:"email" binding:"omitempty,email"`
	AvatarURL string `json:"avatar_url"`
	Theme     string `json:"theme" binding:"omitempty,oneof=overworld nether end"`
	Units     string `json:"units" binding:"omitempty,oneof=metric imperial"`
}

// Tag DTOs
type CreateTagRequest struct {
	Name  string `json:"name" binding:"required,max=50"`
	Color string `json:"color" binding:"omitempty,max=7"`
}
