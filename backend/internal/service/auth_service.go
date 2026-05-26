package service

import (
	"errors"
	"time"

	"recipe-book-mc/internal/domain"
	"recipe-book-mc/internal/dto"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo  domain.UserRepository
	jwtSecret string
	jwtExp    time.Duration
}

func NewAuthService(userRepo domain.UserRepository, jwtSecret string, jwtExp time.Duration) *AuthService {
	return &AuthService{
		userRepo:  userRepo,
		jwtSecret: jwtSecret,
		jwtExp:    jwtExp,
	}
}

func (s *AuthService) Register(req dto.RegisterRequest) (*dto.AuthResponse, error) {
	_, err := s.userRepo.GetByEmail(req.Email)
	if err == nil {
		return nil, errors.New("user with this email already exists")
	}

	_, err = s.userRepo.GetByUsername(req.Username)
	if err == nil {
		return nil, errors.New("username already taken")
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	user := &domain.User{
		Username:     req.Username,
		Email:        req.Email,
		PasswordHash: string(hash),
	}

	if err := s.userRepo.Create(user); err != nil {
		return nil, err
	}

	token, expiresIn, err := s.generateToken(user)
	if err != nil {
		return nil, err
	}

	return &dto.AuthResponse{
		Token:     token,
		ExpiresIn: expiresIn,
		User:      dto.ToUserResponse(user),
	}, nil
}

func (s *AuthService) Login(req dto.LoginRequest) (*dto.AuthResponse, error) {
	user, err := s.userRepo.GetByEmail(req.Email)
	if err != nil {
		return nil, errors.New("invalid email or password")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)); err != nil {
		return nil, errors.New("invalid email or password")
	}

	token, expiresIn, err := s.generateToken(user)
	if err != nil {
		return nil, err
	}

	return &dto.AuthResponse{
		Token:     token,
		ExpiresIn: expiresIn,
		User:      dto.ToUserResponse(user),
	}, nil
}

func (s *AuthService) generateToken(user *domain.User) (string, int64, error) {
	now := time.Now()
	expiresAt := now.Add(s.jwtExp)

	claims := jwt.MapClaims{
		"user_id":  user.ID,
		"username": user.Username,
		"exp":      expiresAt.Unix(),
		"iat":      now.Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString([]byte(s.jwtSecret))
	if err != nil {
		return "", 0, err
	}

	return tokenString, expiresAt.Unix(), nil
}

func (s *AuthService) GetProfile(userID uint) (*dto.UserResponse, error) {
	user, err := s.userRepo.GetByID(userID)
	if err != nil {
		return nil, err
	}
	resp := dto.ToUserResponse(user)
	return &resp, nil
}

func (s *AuthService) UpdateProfile(userID uint, req dto.UpdateUserRequest) (*dto.UserResponse, error) {
	user, err := s.userRepo.GetByID(userID)
	if err != nil {
		return nil, err
	}

	if req.Username != "" {
		user.Username = req.Username
	}
	if req.Email != "" {
		user.Email = req.Email
	}
	if req.AvatarURL != "" {
		user.AvatarURL = req.AvatarURL
	}
	if req.Theme != "" {
		user.Theme = req.Theme
	}
	if req.Units != "" {
		user.Units = req.Units
	}

	if err := s.userRepo.Update(user); err != nil {
		return nil, err
	}

	resp := dto.ToUserResponse(user)
	return &resp, nil
}
