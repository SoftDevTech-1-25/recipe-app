package domain

import (
	"time"
)

type User struct {
	ID           uint      `gorm:"primaryKey" json:"id"`
	Username     string    `gorm:"size:50;not null;uniqueIndex" json:"username"`
	Email        string    `gorm:"size:255;not null;uniqueIndex" json:"email"`
	PasswordHash string    `gorm:"size:255;not null" json:"-"`
	AvatarURL    string    `gorm:"size:500" json:"avatar_url,omitempty"`
	Theme        string    `gorm:"size:20;default:'overworld'" json:"theme"`
	Units        string    `gorm:"size:10;default:'metric'" json:"units"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`

	Recipes    []Recipe    `gorm:"foreignKey:UserID" json:"recipes,omitempty"`
	Favorites  []Favorite  `gorm:"foreignKey:UserID" json:"-"`
	MealPlans  []MealPlan  `gorm:"foreignKey:UserID" json:"-"`
	ShoppingItems []ShoppingListItem `gorm:"foreignKey:UserID" json:"-"`
}

type UserProfile struct {
	ID        uint   `json:"id"`
	Username  string `json:"username"`
	Email     string `json:"email"`
	AvatarURL string `json:"avatar_url"`
	Theme     string `json:"theme"`
	Units     string `json:"units"`
}
