package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/nigusmamo/Cinema-Booking-Platform/routes"
	"github.com/nigusmamo/Cinema-Booking-Platform/utils"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Fatal("Error loading .env file")
	}

	r := gin.Default()
	routes.AuthRoutes(r)
	routes.PaymentRoutes(r)
	routes.UploadRoutes(r)

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "Server is running"}) 
	})

	port := utils.GetEnv("PORT", "8000")
	log.Printf("Server starting on port %s", port)
	r.Run(":" + port)
}