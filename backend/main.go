package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {

	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Minecraft Recipe API is running!",
			"status":  "working",
		})
	})

	r.Run(":8080")
}
