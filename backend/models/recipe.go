package models

type Recipe struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	Difficulty int    `json:"difficulty"`
	ImageSlug  string `json:"image_slug"`
}

type Ingredient struct {
	Name   string  `json:"name"`
	Amount float64 `json:"amount"`
	Unit   string  `json:"unit"`
}

type RecipeFull struct {
	Recipe
	Ingredients []Ingredient `json:"ingredients"`
}
