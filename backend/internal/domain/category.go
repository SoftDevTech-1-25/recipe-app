package domain

type Category struct {
	ID       uint   `gorm:"primaryKey" json:"id"`
	Name     string `gorm:"size:50;not null;uniqueIndex" json:"name"`
	IconURL  string `gorm:"size:500" json:"icon_url,omitempty"`
	Color    string `gorm:"size:7;default:'#FFFFFF'" json:"color,omitempty"`
	Recipes  []Recipe `gorm:"foreignKey:CategoryID" json:"-"`
}
