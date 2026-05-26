package domain

import "time"

type MealPlan struct {
	ID       uint      `gorm:"primaryKey" json:"id"`
	UserID   uint      `gorm:"not null;index" json:"user_id"`
	RecipeID uint      `gorm:"not null;index" json:"recipe_id"`
	PlanDate time.Time `gorm:"type:date;not null" json:"plan_date"`
	MealType string    `gorm:"size:20;not null;check:meal_type in ('breakfast','lunch','dinner','snack')" json:"meal_type"`
	Servings int       `gorm:"not null" json:"servings"`
	CreatedAt time.Time `json:"created_at"`

	User   User   `gorm:"foreignKey:UserID" json:"-"`
	Recipe Recipe `gorm:"foreignKey:RecipeID" json:"recipe,omitempty"`
}
