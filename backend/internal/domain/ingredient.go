package domain

import "time"

type Ingredient struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Name      string    `gorm:"size:100;not null;uniqueIndex" json:"name"`
	IconURL   string    `gorm:"size:500" json:"icon_url,omitempty"`
	Category  string    `gorm:"size:50" json:"category,omitempty"`
	CreatedAt time.Time `json:"created_at"`

	RecipeIngredients []RecipeIngredient `gorm:"foreignKey:IngredientID" json:"-"`
	ShoppingItems     []ShoppingListItem `gorm:"foreignKey:IngredientID" json:"-"`
}
