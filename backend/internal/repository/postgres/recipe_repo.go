package postgres

import (
	"errors"
	"recipe-book-mc/internal/domain"
	"recipe-book-mc/internal/dto"
	"sync"
	"time"
)

type RecipeRepository struct {
	mu        sync.RWMutex
	recipes   []domain.Recipe
	favorites []domain.Favorite
	categories []domain.Category
	tags      []domain.Tag
	nextRecipeID uint
	nextFavID    uint
	nextCatID    uint
	nextTagID    uint
}

func NewRecipeRepository(db interface{}) *RecipeRepository {
	r := &RecipeRepository{
		recipes:      make([]domain.Recipe, 0),
		favorites:    make([]domain.Favorite, 0),
		categories:   make([]domain.Category, 0),
		tags:         make([]domain.Tag, 0),
		nextRecipeID: 1,
		nextFavID:    1,
		nextCatID:    1,
		nextTagID:    1,
	}
	r.initDemoData()
	return r
}

func (r *RecipeRepository) initDemoData() {
	// Categories
	r.categories = []domain.Category{
		{ID: 1, Name: "Веган", Color: "#567D46"},
		{ID: 2, Name: "Мясо", Color: "#8B4513"},
		{ID: 3, Name: "Десерты", Color: "#FF69B4"},
		{ID: 4, Name: "Итальянская", Color: "#FFD700"},
		{ID: 5, Name: "Быстрое", Color: "#00CED1"},
		{ID: 6, Name: "Напитки", Color: "#4169E1"},
		{ID: 7, Name: "Супы", Color: "#FF6347"},
	}
	r.nextCatID = 8

	// Tags
	r.tags = []domain.Tag{
		{ID: 1, Name: "острая", Color: "#b03030"},
		{ID: 2, Name: "вегетарианская", Color: "#7ab84a"},
		{ID: 3, Name: "мясная", Color: "#8B4513"},
		{ID: 4, Name: "быстрая", Color: "#00CED1"},
		{ID: 5, Name: "домашняя", Color: "#c8a020"},
		{ID: 6, Name: "с овощами", Color: "#5a8a3c"},
		{ID: 7, Name: "с курицей", Color: "#c8a020"},
		{ID: 8, Name: "японское", Color: "#3a6a9a"},
		{ID: 9, Name: "морепродукты", Color: "#3a6a9a"},
		{ID: 10, Name: "салат", Color: "#5a8a3c"},
		{ID: 11, Name: "праздничная", Color: "#c04080"},
		{ID: 12, Name: "с сыром", Color: "#FFD700"},
	}
	r.nextTagID = 13

	now := time.Now()

	// Demo recipes
	r.recipes = []domain.Recipe{
		{
			ID: 1, UserID: 1, Title: "Пицца с сыром",
			Description: "Классическая пицца Маргарита",
			CategoryID: func() *uint { u := uint(4); return &u }(),
			PrepTime: 40, Difficulty: 3, Servings: 2,
			Emoji: "🍕", IsPublic: true,
			CreatedAt: now, UpdatedAt: now,
			Tags: []domain.Tag{
				{ID: 1, Name: "острая"},
				{ID: 2, Name: "вегетарианская"},
			},
		},
		{
			ID: 2, UserID: 1, Title: "Сет суши",
			Description: "Ассорти из свежих суши и роллов",
			CategoryID: func() *uint { u := uint(5); return &u }(),
			PrepTime: 60, Difficulty: 4, Servings: 2,
			Emoji: "🍣", IsPublic: true,
			CreatedAt: now, UpdatedAt: now,
			Tags: []domain.Tag{
				{ID: 8, Name: "японское"},
				{ID: 9, Name: "морепродукты"},
			},
		},
		{
			ID: 3, UserID: 1, Title: "Чечевичный суп",
			Description: "Сытный суп из красной чечевицы",
			CategoryID: func() *uint { u := uint(7); return &u }(),
			PrepTime: 35, Difficulty: 2, Servings: 4,
			Emoji: "🥣", IsPublic: true,
			CreatedAt: now, UpdatedAt: now,
			Tags: []domain.Tag{
				{ID: 2, Name: "вегетарианская"},
				{ID: 6, Name: "с овощами"},
			},
		},
		{
			ID: 4, UserID: 1, Title: "Салат Цезарь",
			Description: "Классический салат с курицей",
			CategoryID: func() *uint { u := uint(5); return &u }(),
			PrepTime: 20, Difficulty: 1, Servings: 2,
			Emoji: "🥗", IsPublic: true,
			CreatedAt: now, UpdatedAt: now,
			Tags: []domain.Tag{
				{ID: 10, Name: "салат"},
				{ID: 6, Name: "с овощами"},
			},
		},
		{
			ID: 5, UserID: 1, Title: "Спагетти Болоньезе",
			Description: "Итальянская паста с мясным соусом",
			CategoryID: func() *uint { u := uint(4); return &u }(),
			PrepTime: 45, Difficulty: 3, Servings: 2,
			Emoji: "🍝", IsPublic: true,
			CreatedAt: now, UpdatedAt: now,
			Tags: []domain.Tag{
				{ID: 3, Name: "мясная"},
				{ID: 5, Name: "домашняя"},
			},
		},
		{
			ID: 6, UserID: 1, Title: "Куриные крылышки",
			Description: "Хрустящие крылышки в соусе",
			CategoryID: func() *uint { u := uint(2); return &u }(),
			PrepTime: 30, Difficulty: 2, Servings: 3,
			Emoji: "🍗", IsPublic: true,
			CreatedAt: now, UpdatedAt: now,
			Tags: []domain.Tag{
				{ID: 4, Name: "быстрая"},
				{ID: 7, Name: "с курицей"},
			},
		},
	}
	r.nextRecipeID = 7
}

func (r *RecipeRepository) Create(recipe *domain.Recipe) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	recipe.ID = r.nextRecipeID
	r.nextRecipeID++
	recipe.CreatedAt = time.Now()
	recipe.UpdatedAt = time.Now()
	r.recipes = append(r.recipes, *recipe)
	return nil
}

func (r *RecipeRepository) GetByID(id uint) (*domain.Recipe, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := range r.recipes {
		if r.recipes[i].ID == id {
			// Return copy with relations
			recipe := r.recipes[i]
			return &recipe, nil
		}
	}
	return nil, errors.New("recipe not found")
}

func (r *RecipeRepository) List(filter dto.RecipeFilterRequest, userID *uint) (*dto.RecipeListResponse, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	var result []domain.Recipe
	for _, recipe := range r.recipes {
		// Search filter
		if filter.Search != "" {
			if !containsIgnoreCase(recipe.Title, filter.Search) && !containsIgnoreCase(recipe.Description, filter.Search) {
				continue
			}
		}
		// Category filter
		if filter.Category != "" && recipe.Category != nil {
			if !containsIgnoreCase(recipe.Category.Name, filter.Category) {
				continue
			}
		}
		// Tag filter
		if filter.Tag != "" {
			found := false
			for _, t := range recipe.Tags {
				if t.Name == filter.Tag {
					found = true
					break
				}
			}
			if !found {
				continue
			}
		}
		// Time filter
		if filter.TimeMax > 0 && recipe.PrepTime > filter.TimeMax {
			continue
		}
		result = append(result, recipe)
	}

	total := int64(len(result))

	// Pagination
	start := (filter.Page - 1) * filter.Limit
	if start > len(result) {
		start = len(result)
	}
	end := start + filter.Limit
	if end > len(result) {
		end = len(result)
	}
	pageData := result[start:end]

	totalPages := int(total) / filter.Limit
	if int(total)%filter.Limit > 0 {
		totalPages++
	}

	return &dto.RecipeListResponse{
		Data:       pageData,
		Total:      total,
		Page:       filter.Page,
		Limit:      filter.Limit,
		TotalPages: totalPages,
	}, nil
}

func (r *RecipeRepository) Update(recipe *domain.Recipe) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.recipes {
		if r.recipes[i].ID == recipe.ID {
			recipe.UpdatedAt = time.Now()
			r.recipes[i] = *recipe
			return nil
		}
	}
	return errors.New("recipe not found")
}

func (r *RecipeRepository) Delete(id uint) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.recipes {
		if r.recipes[i].ID == id {
			r.recipes = append(r.recipes[:i], r.recipes[i+1:]...)
			return nil
		}
	}
	return errors.New("recipe not found")
}

func (r *RecipeRepository) IsOwner(recipeID, userID uint) (bool, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for _, recipe := range r.recipes {
		if recipe.ID == recipeID {
			return recipe.UserID == userID, nil
		}
	}
	return false, errors.New("recipe not found")
}

func (r *RecipeRepository) AddFavorite(userID, recipeID uint) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for _, f := range r.favorites {
		if f.UserID == userID && f.RecipeID == recipeID {
			return errors.New("already favorite")
		}
	}
	r.favorites = append(r.favorites, domain.Favorite{
		ID:       r.nextFavID,
		UserID:   userID,
		RecipeID: recipeID,
		CreatedAt: time.Now(),
	})
	r.nextFavID++
	return nil
}

func (r *RecipeRepository) RemoveFavorite(userID, recipeID uint) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i, f := range r.favorites {
		if f.UserID == userID && f.RecipeID == recipeID {
			r.favorites = append(r.favorites[:i], r.favorites[i+1:]...)
			return nil
		}
	}
	return errors.New("not found")
}

func (r *RecipeRepository) IsFavorite(userID, recipeID uint) (bool, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for _, f := range r.favorites {
		if f.UserID == userID && f.RecipeID == recipeID {
			return true, nil
		}
	}
	return false, nil
}

func (r *RecipeRepository) ListFavorites(userID uint) ([]domain.Recipe, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []domain.Recipe
	for _, f := range r.favorites {
		if f.UserID == userID {
			for _, recipe := range r.recipes {
				if recipe.ID == f.RecipeID {
					result = append(result, recipe)
					break
				}
			}
		}
	}
	return result, nil
}

func (r *RecipeRepository) ListCategories() ([]domain.Category, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	result := make([]domain.Category, len(r.categories))
	copy(result, r.categories)
	return result, nil
}

func (r *RecipeRepository) CreateTag(tag *domain.Tag) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	tag.ID = r.nextTagID
	r.nextTagID++
	r.tags = append(r.tags, *tag)
	return nil
}

func (r *RecipeRepository) GetTagByName(name string) (*domain.Tag, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := range r.tags {
		if r.tags[i].Name == name {
			return &r.tags[i], nil
		}
	}
	return nil, errors.New("tag not found")
}

func (r *RecipeRepository) FindOrCreateTag(name string, color string) (*domain.Tag, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := range r.tags {
		if r.tags[i].Name == name {
			return &r.tags[i], nil
		}
	}
	tag := domain.Tag{ID: r.nextTagID, Name: name, Color: color}
	r.nextTagID++
	r.tags = append(r.tags, tag)
	return &tag, nil
}

func (r *RecipeRepository) ListTags() ([]domain.Tag, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	result := make([]domain.Tag, len(r.tags))
	copy(result, r.tags)
	return result, nil
}

func containsIgnoreCase(s, substr string) bool {
	return len(s) >= len(substr) && (s == substr || 
		len(s) > 0 && len(substr) > 0 && 
		containsSubstr(s, substr))
}

func containsSubstr(s, substr string) bool {
	for i := 0; i <= len(s)-len(substr); i++ {
		if s[i:i+len(substr)] == substr {
			return true
		}
	}
	return false
}
