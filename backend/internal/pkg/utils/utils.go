package utils

import (
	"math"
)

func RoundQuantity(qty float64) float64 {
	return math.Round(qty*100) / 100
}

func ClampInt(value, min, max int) int {
	if value < min {
		return min
	}
	if value > max {
		return max
	}
	return value
}
