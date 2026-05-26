package domain

import "time"

type ShoppingListItem struct {
	ID            uint      `gorm:"primaryKey" json:"id"`
	UserID        uint      `gorm:"not null;index" json:"user_id"`
	IngredientID  uint      `gorm:"not null;index" json:"ingredient_id"`
	Quantity      float64   `gorm:"not null" json:"quantity"`
	Unit          string    `gorm:"size:20;not null" json:"unit"`
	IsChecked     bool      `gorm:"default:false" json:"is_checked"`
	SourcePlanIDs []int     `gorm:"type:integer[]" json:"source_plan_ids,omitempty"`
	CreatedAt     time.Time `json:"created_at"`

	User       User       `gorm:"foreignKey:UserID" json:"-"`
	Ingredient Ingredient `gorm:"foreignKey:IngredientID" json:"ingredient,omitempty"`
}

type ShoppingListSummary struct {
	Items        []ShoppingListItem `json:"items"`
	TotalItems   int                `json:"total_items"`
	CheckedItems int                `json:"checked_items"`
}
