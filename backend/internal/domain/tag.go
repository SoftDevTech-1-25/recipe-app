package domain

import "time"

// Tag represents a recipe tag (e.g. "острая", "быстрая")
type Tag struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Name      string    `gorm:"size:50;not null;uniqueIndex" json:"name"`
	Color     string    `gorm:"size:7;default:'#5a8a3c'" json:"color"`
	CreatedAt time.Time `json:"created_at"`

	Recipes []Recipe `gorm:"many2many:recipe_tags;" json:"-"`
}

// RecipeTag — junction table
type RecipeTag struct {
	RecipeID uint `gorm:"primaryKey"`
	TagID    uint `gorm:"primaryKey"`
}
