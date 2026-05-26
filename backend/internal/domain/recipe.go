package domain

import (
	"time"
)

// Difficulty levels for frontend mapping
type DifficultyLevel struct {
	Level int    `json:"level"`
	Name  string `json:"name"`
	Color string `json:"color"`
}

var DifficultyLevels = []DifficultyLevel{
	{1, "лёгкий", "#5a8a3c"},
	{2, "простой", "#7ab84a"},
	{3, "средний", "#c8a020"},
	{4, "сложный", "#b03030"},
	{5, "эксперт", "#7a0000"},
}

// Recipe represents a cooking recipe
type Recipe struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	UserID      uint      `gorm:"not null;index" json:"user_id"`
	Title       string    `gorm:"size:200;not null" json:"title"`
	Description string    `gorm:"type:text" json:"description,omitempty"`
	CategoryID  *uint     `gorm:"index" json:"category_id,omitempty"`
	PrepTime    int       `gorm:"not null" json:"prep_time"`
	Difficulty  int       `gorm:"check:difficulty >= 1 and difficulty <= 5" json:"difficulty"`
	Servings    int       `gorm:"not null;default:2" json:"servings"`
	ImageURL    string    `gorm:"size:500" json:"image_url,omitempty"`
	Emoji       string    `gorm:"size:10;default:'🍽'" json:"emoji"`
	IsPublic    bool      `gorm:"default:true" json:"is_public"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`

	User        User               `gorm:"foreignKey:UserID" json:"author,omitempty"`
	Category    *Category          `gorm:"foreignKey:CategoryID" json:"category,omitempty"`
	Ingredients []RecipeIngredient `gorm:"foreignKey:RecipeID" json:"ingredients,omitempty"`
	Steps       []RecipeStep       `gorm:"foreignKey:RecipeID" json:"steps,omitempty"`
	Tags        []Tag              `gorm:"many2many:recipe_tags;" json:"tags,omitempty"`
	Favorites   []Favorite         `gorm:"foreignKey:RecipeID" json:"-"`
	MealPlans   []MealPlan         `gorm:"foreignKey:RecipeID" json:"-"`
}

// RecipeIngredient — slot_position теперь опциональный (для совместимости)
type RecipeIngredient struct {
	ID           uint       `gorm:"primaryKey" json:"id"`
	RecipeID     uint       `gorm:"not null;index" json:"recipe_id"`
	IngredientID uint       `gorm:"not null;index" json:"ingredient_id"`
	Quantity     float64    `gorm:"not null" json:"quantity"`
	Unit         string     `gorm:"size:20;not null" json:"unit"`
	SlotPosition *int       `json:"slot_position,omitempty"`

	Ingredient Ingredient `gorm:"foreignKey:IngredientID" json:"ingredient,omitempty"`
}

type RecipeStep struct {
	ID          uint   `gorm:"primaryKey" json:"id"`
	RecipeID    uint   `gorm:"not null;index" json:"recipe_id"`
	StepOrder   int    `gorm:"not null" json:"order"`
	Description string `gorm:"type:text;not null" json:"description"`
	Duration    *int   `json:"duration,omitempty"`
	ImageURL    string `gorm:"size:500" json:"image_url,omitempty"`
}

type ScaledRecipe struct {
	OriginalServings int                `json:"original_servings"`
	TargetServings   int                `json:"target_servings"`
	ScaleFactor      float64            `json:"scale_factor"`
	Ingredients      []ScaledIngredient `json:"ingredients"`
}

type ScaledIngredient struct {
	Name             string  `json:"name"`
	OriginalQuantity float64 `json:"original_quantity"`
	ScaledQuantity   float64 `json:"scaled_quantity"`
	Unit             string  `json:"unit"`
	IconURL          string  `json:"icon_url,omitempty"`
}
