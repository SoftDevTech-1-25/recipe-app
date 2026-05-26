package config

import (
	"os"
	"time"

	"github.com/joho/godotenv"
)

type Config struct {
	JWTSecret     string
	JWTExpiration time.Duration
	Port          string
	Env           string
}

func Load() *Config {
	godotenv.Load()

	jwtExp, _ := time.ParseDuration(getEnv("JWT_EXPIRATION", "24h"))

	return &Config{
		JWTSecret:     getEnv("JWT_SECRET", "minecraft-secret-key"),
		JWTExpiration: jwtExp,
		Port:          getEnv("PORT", "8080"),
		Env:           getEnv("ENV", "development"),
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
