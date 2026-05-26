package dto

import (
	"recipe-book-mc/internal/domain"
)

// Auth Responses
type AuthResponse struct {
	Token     string `json:"token"`
	ExpiresIn int64  `json:"expires_in"`
	User      UserResponse `json:"user"`
}

type UserResponse struct {
	ID        uint   `json:"id"`
	Username  string `json:"username"`
	Email     string `json:"email"`
	AvatarURL string `json:"avatar_url"`
	Theme     string `json:"theme"`
	Units     string `json:"units"`
}

// Recipe Responses
type RecipeListResponse struct {
	Data       []domain.Recipe `json:"data"`
	Total      int64           `json:"total"`
	Page       int             `json:"page"`
	Limit      int             `json:"limit"`
	TotalPages int             `json:"total_pages"`
}

type ScaleResponse struct {
	OriginalServings int                      `json:"original_servings"`
	TargetServings   int                      `json:"target_servings"`
	ScaleFactor      float64                  `json:"scale_factor"`
	Ingredients      []ScaledIngredientResponse `json:"ingredients"`
}

type ScaledIngredientResponse struct {
	Name             string  `json:"name"`
	OriginalQuantity float64 `json:"original_quantity"`
	ScaledQuantity   float64 `json:"scaled_quantity"`
	Unit             string  `json:"unit"`
	IconURL          string  `json:"icon_url,omitempty"`
}

// Error Response
type ErrorResponse struct {
	Error   string `json:"error"`
	Code    int    `json:"code"`
	Details string `json:"details,omitempty"`
}

// Success Response
type SuccessResponse struct {
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}

func ToUserResponse(user *domain.User) UserResponse {
	return UserResponse{
		ID:        user.ID,
		Username:  user.Username,
		Email:     user.Email,
		AvatarURL: user.AvatarURL,
		Theme:     user.Theme,
		Units:     user.Units,
	}
}

func ToUserResponseFromProfile(profile *domain.UserProfile) UserResponse {
	return UserResponse{
		ID:        profile.ID,
		Username:  profile.Username,
		Email:     profile.Email,
		AvatarURL: profile.AvatarURL,
		Theme:     profile.Theme,
		Units:     profile.Units,
	}
}
